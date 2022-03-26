extends TextureButton

func _ready():
	connect("pressed",self.get_parent(),"on_continue_press")
