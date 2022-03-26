extends "res://Scripts/bubble.gd"


func change_neighbors_translucid():
	var neighbors:Array;
	var translucid_neighbors:Array;
	neighbors=check_radius()
	neighbors.erase(self)
	for cur_bubble in neighbors:
		if((cur_bubble.has_method("explode")) and (cur_bubble.get_type()=="translucid")):
			cur_bubble.change_me(self.type)
			
func change_me(new_type:String):
	if(new_type!="rainbow"):
		self.type=new_type
		$AnimatedSprite2.visible=true
		$AnimatedSprite2.play()
		yield(($AnimatedSprite2),"animation_finished")
		$AnimatedSprite2.visible=false
		#if(self !=null):
			#self.my_sprite.set_texture(possible_textures[new_type])
		self.my_sprite.set_texture(possible_textures[new_type])

	

