extends "res://Scripts/bubble.gd"
var time_to_kill=false;
var end;

signal spark(bubble_to_kill)

func _ready():
	self.connect("spark", get_parent(), "_on_spark")

func random_kill():
	#return a random bubble to pop
	var search=true;
	var bubble_to_kill;
	while(search):
		var count_of_childs=get_parent().get_child_count();
		var index_kill=floor(rand_range(2,count_of_childs))
		bubble_to_kill=get_parent().get_child(index_kill);
		search=not bubble_to_kill.has_method("explode");
	return bubble_to_kill
	
	
func _init2(_type:String,relative_pos:Vector2):
		self.sound=AudioStreamPlayer.new()
		self.sound.stream=possible_sounds;
		self.sound.volume_db=5;
		self.position=relative_pos;
		self.my_collisionShape2D=self.get_child(0);
		self.my_sprite=self.get_child(1);
		self.my_area=self.get_child(2);
		
		self.scale=Vector2(my_scale,my_scale)
		my_area.scale=Vector2(my_area_scale,my_area_scale)
	
		#"spark":                       
		self.type = _type;
		self.my_sprite.set_texture(self.possible_spark_textures[_type])
		self.name="spark"
		
		
func explode():
	if(get_tree()!=null):
		yield(get_tree().create_timer(1), "timeout")
		animation()
	
func _physics_process(delta):
	if(time_to_kill): #means we want the spark to move for the kill
		self.position = self.position.linear_interpolate(end, delta * FOLLOW_SPEED)
		if(self.position==end):
			time_to_kill=false
	if(time_to_fade): #means the spark should fade
		self.position = self.position.linear_interpolate(end_fade, delta * FOLLOW_SPEED)
		if(self.position==end_fade):
			queue_free()
			
func animation():
	var to_kill=random_kill()
	var start=self.position
	end=to_kill.position
	time_to_kill=true
	
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("spark",to_kill)
	queue_free()

	

