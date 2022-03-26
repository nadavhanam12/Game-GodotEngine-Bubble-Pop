extends "res://Scripts/shot_script.gd"

var exepted_matches=["blue","green","purple","red","thin","yellow",]


func check_neighbors():
	var neighbors:Array;
	var same_color_neighbors:Array;
	#neighbors=self.my_area.get_overlapping_bodies()
	neighbors=check_radius()
	neighbors.erase(self)
	for cur_bubble in neighbors:
		if(cur_bubble.has_method("explode") and 
		(exepted_matches.has(cur_bubble.type))):
			same_color_neighbors.append(cur_bubble)
	return same_color_neighbors;
	
	
func _ready():
	pass 

