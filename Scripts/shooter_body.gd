extends Node2D

#VARIABLES
var can_shoot;
var ball_ready;
var remaining_balls:int;

#SHOTS
var cur_shot;
var next_shot;
var special_shot;

#SHOTS PRELOAD
var possible_shots=preload("res://Scenes/bubbles/my_shot.tscn")
var rainbow_shots=preload("res://Scenes/bubbles/rainbow_shot.tscn")
var lightning_shots=preload("res://Scenes/bubbles/lightning_shot.tscn")

var possible_bubbles=[
	"blue",
	"green",
	"purple",
	"red",
	"thin",
	"yellow",];

#button and label
onready var swap=$swap;
onready var balls_label=$remain_balls;

var laser=preload("res://Scenes/laser/laser.tscn").instance()

signal out_of_shots
signal add_bubble

func init(number:int):
	special_shot=null;
	update_remain_balls(number);
	
func reload():
	cur_shot=next_shot
	cur_shot.position=Vector2(0,0)
	next_shot=make_next_ball();
	
func swap():
	var pivot=cur_shot
	cur_shot=next_shot
	next_shot=pivot
	next_shot.position=cur_shot.position
	cur_shot.position=Vector2(0,0)
	move_child(next_shot,cur_shot.get_index())
	
func make_cur_ball():
	var random_int=floor(rand_range(0,possible_bubbles.size()))
	var bubble_type=possible_bubbles[random_int];
	var random_bubble=possible_shots.instance();
	random_bubble._init2(bubble_type,Vector2(0,0));
	random_bubble.name="shot"

	add_child(random_bubble)
	return random_bubble;
	
func make_next_ball():
	var random_int=floor(rand_range(0,possible_bubbles.size()))
	var bubble_type=possible_bubbles[random_int];
	var random_bubble=possible_shots.instance();
	random_bubble._init2(bubble_type,Vector2(100,50));
	random_bubble.name="shot"
	add_child(random_bubble)
	return random_bubble;

func _ready():
		cur_shot=make_cur_ball()
		next_shot=make_next_ball()
		self.connect("out_of_shots", self.get_parent(), "no_more_shots")
		self.connect("add_bubble", self.get_parent(), "add_bubble")
		yield(get_tree().create_timer(0.5), "timeout")
		
		can_shoot=true;
		ball_ready=true
		
func update_remain_balls(new_number:int):
	remaining_balls=new_number
	balls_label.set_text(remaining_balls as String)
	
func _input(event):
	can_shoot=not get_parent().get_parent().on_mnu    #if player on menu cant shoot
	if(can_shoot and ball_ready)and((event is InputEventMouseButton)or(event is InputEventScreenTouch)):
		if(event.is_pressed()):
			var t;
			#LAZER
			#print("lazer")
		else:
			var touch_position=event.get_position()
			if((touch_position.y>96)and(touch_position.y<768)): #we want to shoot!
				ball_ready=false;
				var point1=$shooter_position.global_position;
				var point2=touch_position;
				var direction = ( point2 - point1 ).normalized()
				shoot(direction);
				
func shoot(direction):
	if(special_shot !=null):
		special_shot.shoot(direction);
		special_shot=null;
		yield(get_tree().create_timer(0.2), "timeout")
		add_child(cur_shot)
		add_child(next_shot)
		ball_ready=true;
	else:
		cur_shot.shoot(direction);
		emit_signal("add_bubble")
		yield(get_tree().create_timer(0.2), "timeout")
		update_remain_balls(remaining_balls-1)
		if(remaining_balls==0):
			emit_signal("out_of_shots")
		ball_ready=true;
		reload()
		
	get_parent().add_bubble()
	
func make_rainbow(): #for case the player uses rainbow bubble
	if(special_shot==null):
		remove_child(cur_shot)
		remove_child(next_shot)
		special_shot=rainbow_shots.instance();
		special_shot._init2("rainbow",Vector2(0,0));
		add_child(special_shot)
	else:
		remove_child(special_shot)
		special_shot=rainbow_shots.instance();
		special_shot._init2("rainbow",Vector2(0,0));
		add_child(special_shot)
		
func make_lightning(): #for case the player uses lightning bubble
	if(special_shot==null):
		remove_child(cur_shot)
		remove_child(next_shot)
		special_shot=lightning_shots.instance();
		special_shot._init2("lightning",Vector2(0,0));
		add_child(special_shot)
	else:
		remove_child(special_shot)
		special_shot=lightning_shots.instance();
		special_shot._init2("lightning",Vector2(0,0));
		add_child(special_shot)

func _on_swap_pressed():
	swap()

