extends Node2D

signal decition(decition)

func set_score(score:int):
	get_child(1).set_text("YOUR SCORE IS: "+score as String)
	
func _ready():
	connect("decition",self.get_parent(),"decition_mnu")
		
func on_continue_press():
	emit_signal("decition","continue")

func on_restart_press():
	emit_signal("decition","restart")

func on_quit_press():
	emit_signal("decition","quit")
