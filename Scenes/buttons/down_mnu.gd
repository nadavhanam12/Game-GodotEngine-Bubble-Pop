extends Node2D

signal decition(decition,item)
var light=preload("res://art/Buttons and background/lightning.png")
var rainbow=preload("res://art/Buttons and background/rainbow.png")
var my_type;

func init(my_str):
	my_type=my_str
	if(my_str=="lightning"):
		get_child(2).set_texture(light)
	else:
		get_child(2).set_texture(rainbow)
		
func _ready():
	connect("decition",self.get_parent(),"purche_mnu")
		
func on_puchase_press():
	emit_signal("decition",true,my_type)
func on_no_puchase_press():
	emit_signal("decition",false,my_type)

func set_score(new_score):
	get_child(5).set_text(new_score as String )

func set_gems(new_gems):
	get_child(6).set_text(new_gems as String )
