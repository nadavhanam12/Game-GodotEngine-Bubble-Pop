extends TextureButton
onready var reg_pic=preload("res://art/Buttons and background/rainbow.png")
onready var spe_pic=preload("res://art/Buttons and background/new_streamtexture.tres")

func _ready():
	connect("pressed",self.get_parent().get_parent(),"on_rainbow_press")
	start_anim()
	pass
	
func start_anim():
	texture_normal=reg_pic
	yield(get_tree().create_timer(0.5), "timeout")
	texture_normal=spe_pic
	yield(get_tree().create_timer(0.5), "timeout")
	start_anim()

