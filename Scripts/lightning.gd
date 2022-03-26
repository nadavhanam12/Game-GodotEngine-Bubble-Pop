extends "res://Scripts/shot_script.gd"

signal lightning(row_neighbors)


func neighbors_lightning():
	#will return all the bubbles in same line with the lightning bubble
	var bubbles_shooter=get_parent().get_children();
	var count_of_bubbles_shooter=bubbles_shooter.size();
	var bubbles_level=get_parent().get_parent().get_children();
	var count_of_bubbles_level=bubbles_level.size();
	
	var bubbles_in_same_line=[];
	for bubble in bubbles_shooter:
		if(check_bubble_y(bubble)):
			bubbles_in_same_line.append(bubble)
	for bubble in bubbles_level:
		if(check_bubble_y(bubble)):
			bubbles_in_same_line.append(bubble)
			
	emit_signal("lightning",bubbles_in_same_line);
	
func check_bubble_y(bubble):
	#checks if the givven bubble is in same line with cur bubble
	var my_y_position=self.get_global_position().y
	if(bubble.has_method("explode")and(bubble !=self)):
			var bubble_y_position=bubble.get_global_position().y
			if((bubble_y_position<my_y_position+50)and(bubble_y_position>my_y_position-50)):
				return true;
	return false;
				

func _ready():
	self.connect("lightning", get_parent().get_parent(), "_on_lightning")

func explode():
	yield(get_tree().create_timer(0.2), "timeout")
	neighbors_lightning()
	animation()
