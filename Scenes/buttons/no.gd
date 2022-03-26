extends Button


func _ready():
	connect("pressed",self.get_parent(),"on_no_puchase_press")
