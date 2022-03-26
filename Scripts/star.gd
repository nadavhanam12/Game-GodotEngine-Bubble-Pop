extends "res://Scripts/bubble.gd"

var time_to_move=false;
var end=Vector2(450,50);			#the location of the stars counter


signal star(type_star)
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("star", get_parent(), "_on_star")

func _init2(_type:String,relative_pos:Vector2):
		self.sound=AudioStreamPlayer.new()
		self.sound.stream=possible_sounds;
		self.sound.volume_db=5;
		
		self.position=relative_pos;
		self.my_collisionShape2D=self.get_child(0);
		self.my_collisionShape2D.scale=self.my_collisionShape2D.scale*my_collision_scale
		self.my_sprite=self.get_child(1);
		self.my_area=self.get_child(2);
		
		self.scale=Vector2(my_scale,my_scale)
		my_area.scale=Vector2(my_area_scale,my_area_scale)
	
		#"star":                       
		self.type = _type;
		self.my_sprite.set_texture(self.possible_star_textures[_type])
		self.name="star"
		
		
func fade():
	time_to_fade=true
	explode()
	
func explode():
	animation()
	
	
func _physics_process(delta):
	if(time_to_move):
		self.position = self.position.linear_interpolate(end, delta * FOLLOW_SPEED)
		if(self.position==end):
			time_to_move=false
	elif(time_to_fade):
		self.position = self.position.linear_interpolate(end_fade, delta * FOLLOW_SPEED)
		if(self.position==end_fade):
			queue_free()
			
			
func animation():
	var start=self.position
	time_to_move=true
	
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("star",self.type)
	queue_free()
	

