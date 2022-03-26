extends "res://Scripts/bubble.gd"


signal explotion(how_much)
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("explotion", get_parent(), "_on_explotion_started")


func check_neighbors():
	var neighbors:Array;
	#neighbors=self.my_area.get_overlapping_bodies()		#possible 1 for getting nearby objects
	neighbors=check_radius()								#possible 2 for getting nearby objects by distance
	neighbors.erase(self)
	for cur_bubble in neighbors:
		if(not cur_bubble.has_method("explode")):
			neighbors.erase(cur_bubble)
	return neighbors;
	
func check_radius():
	var normal_balls=get_parent().get_children()
	var shot_balls=get_parent().get_node("Shooter").get_children()
	var in_range=[]
	for bubble in normal_balls:
		if(bubble.has_method("explode")):			#if its bubble
			var start=self.get_global_position()
			var end =bubble.position
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
	

	

