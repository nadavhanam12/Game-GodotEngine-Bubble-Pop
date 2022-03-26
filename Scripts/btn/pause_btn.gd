extends TextureButton

func _ready():
	connect("pressed",self.get_parent().get_parent(),"on_pause_press")

