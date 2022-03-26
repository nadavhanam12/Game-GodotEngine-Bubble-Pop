extends "res://Scripts/bubble.gd"

var speed = 1500
var velocity = Vector2()
var on_the_move;

signal collusion_started(starting_bubble)

func _ready():
	self.connect("collusion_started", self.get_parent().get_parent(), "_on_collusion_started")
	
func check_special_neighbors():
	var neighbors:Array;
	var special_neighbors:Array;
	#neighbors=self.my_area.get_overlapping_bodies()
	neighbors=check_radius()
	neighbors.erase(self)
	for cur_bubble in neighbors:
		if((cur_bubble.has_method("explode")) and
		 (cur_bubble.get_type()=="bomb")):
			special_neighbors.append(cur_bubble)
	return special_neighbors;

func check_radius():
	var normal_balls=get_parent().get_parent().get_children()
	var shot_balls=get_parent().get_children()
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
			var dis=(self.position).distance_to(bubble.position)
			if(dis<=neighbor_distance):
				in_range.append(bubble)
	return in_range	

func shoot(dir):
	on_the_move=true;
	rotation = dir.angle()
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	if(on_the_move==true):
		var collision = move_and_collide(velocity * delta)
		if collision:
			if(collision.collider.is_class("StaticBody2D")): #hit the wall and bounce
				velocity = velocity.bounce(collision.normal)
			elif(collision.collider.is_class("KinematicBody2D")):
				if(collision.collider.type=="glass"):        #break the glass
					collision.collider.explode()
				if(self.type=="lightning"):                  #lightning explode no matter what he hits
					self.explode()
				else:
					emit_signal("collusion_started",self)    #start the collusion script
				self.on_the_move=false;
		elif(not $VisibilityEnabler2D.is_on_screen()):       #delete bubble out of sight
			queue_free()
			
	if(time_to_fade):                                        #means the bubble is hanged in the air
		self.position = self.position.linear_interpolate(end_fade, delta * FOLLOW_SPEED)
		if(self.position==end_fade):
			queue_free()
			
func fade():
	queue_free()
