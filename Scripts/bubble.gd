extends KinematicBody2D

export var type:String
var sound:AudioStreamPlayer ;

#SCALES
export var my_scale=1;
export var my_area_scale=1;
export var my_collision_scale=1;

#properties
var my_collisionShape2D;
var my_sprite:Sprite;
var my_area:Area2D;

#states & data
var neighbor_distance=125
var time_to_fade=false;
var end_fade;
const FOLLOW_SPEED = 4.0

var possible_sounds=preload("res://Sounds/bubbles/pop-1.ogg")

var possible_textures= {
	"blue":preload("res://art/new bubbles/blue.png"),
	"green":preload("res://art/new bubbles/green.png"),
	"purple":preload("res://art/new bubbles/purple.png"),
	"red":preload("res://art/new bubbles/red.png"),
	"thin":preload("res://art/new bubbles/thin.png"),
	"yellow":preload("res://art/new bubbles/yellow.png"),
};
var possible_spark_textures= {
	"blue":preload("res://art/bubbles/spark/blue.png"),
	"green":preload("res://art/bubbles/spark/green.png"),
	"purple":preload("res://art/bubbles/spark/purple.png"),
	"red":preload("res://art/bubbles/spark/red.png"),
	"thin":preload("res://art/bubbles/spark/thin.png"),
	"yellow":preload("res://art/bubbles/spark/yellow.png"),
};
var possible_star_textures= {
	"blue":preload("res://art/bubbles/star/blue.png"),
	"green":preload("res://art/bubbles/star/green.png"),
	"purple":preload("res://art/bubbles/star/purple.png"),
	"red":preload("res://art/bubbles/star/red.png"),
	"thin":preload("res://art/bubbles/star/thin.png"),
	"yellow":preload("res://art/bubbles/star/yellow.png"),
};

func _init2(_type:String,relative_pos:Vector2):
	
		self.sound=AudioStreamPlayer.new()
		self.sound.stream=possible_sounds;
		self.sound.volume_db=5;
		
		self.position=relative_pos;
		self.my_collisionShape2D=self.get_child(0);
		self.my_sprite=self.get_child(1);
		self.my_area=self.get_child(2);
		
		#for scale testing
		self.scale=Vector2(my_scale,my_scale)
		my_area.scale=Vector2(my_area_scale,my_area_scale)
		
		match _type:
			"bomb":
				self.name="bomb"
				self.type = _type;
			"translucid":
				self.name="translucid"
				self.type = _type;
			"glass":
				self.name="glass"
				self.type = _type;
			"rainbow":
				self.name="rainbow"
				self.type = _type;
			"lightning":
				self.name="lightning"
				self.type = _type;
			_:                                #regular bubble case
				self.name=_type
				self.type = _type;
				self.my_sprite.set_texture(self.possible_textures[_type])
		
func change_neighbors_translucid():
	var neighbors:Array;
	var translucid_neighbors:Array;
	neighbors=check_radius()
	neighbors.erase(self)
	for cur_bubble in neighbors:
		if((cur_bubble.has_method("explode")) and (cur_bubble.get_type()=="translucid")):
			cur_bubble.change_me(self.type)
			
func set_type(arg:String):
	self.type = arg

func get_type():
	return self.type
	
func get_my_collisionShape2D():
	return self.my_collisionShape2D
	
func get_my_sprite():
	return self.my_sprite
	
func check_neighbors():
	var neighbors:Array;
	var same_color_neighbors:Array;
	#neighbors=self.my_area.get_overlapping_bodies()			#possible 1 for getting nearby objects
	neighbors=check_radius()									#possible 2 for getting nearby objects by distance
	neighbors.erase(self)
	for cur_bubble in neighbors:
		if((cur_bubble.has_method("explode")) and (cur_bubble.get_type()==self.type)):
			same_color_neighbors.append(cur_bubble)
	return same_color_neighbors;
	
func check_radius():
	var normal_balls=get_parent().get_children()
	var shot_balls=get_parent().get_node("Shooter").get_children()
	var in_range=[]
	for bubble in normal_balls:
		if(bubble.has_method("explode")):
			var start=self.get_global_position()
			var end =bubble.get_global_position()
			var dis=start.distance_to(end)
			if(dis<=neighbor_distance):
				in_range.append(bubble)
	for bubble in shot_balls:
		if(bubble.has_method("explode")):
			var start=self.get_global_position()
			var end =bubble.get_global_position()
			var dis=start.distance_to(end)
			if(dis<=neighbor_distance):
				in_range.append(bubble)
	return in_range
	
func explode():
	animation()
	
func animation():
	$AnimatedSprite.visible=true
	$AnimatedSprite.play()
	yield(($AnimatedSprite),"animation_finished")
	queue_free()

func fade():
	end_fade=self.get_global_position()
	end_fade.y+=1200
	time_to_fade=true
	_physics_process2()
		
func _physics_process2():
	if(self != null and time_to_fade and self.type !="star" and end_fade!=null):
		self.position = self.position.linear_interpolate(end_fade, FOLLOW_SPEED)
		if(self.position==end_fade):
			queue_free()
