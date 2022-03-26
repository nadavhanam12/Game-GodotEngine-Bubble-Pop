extends Button


func _ready():
	connect("pressed",self.get_parent(),"on_puchase_press")
