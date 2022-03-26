extends Node2D

#Variabels
var score=0;
var res_score=0
var level_number=1;
var coins=500;
var Power_ups_Rainbow=0;
var Power_ups_Lightning=0;
var cur_level;

#VARIABLES FOR THE RANDOM MAP
export (int) var random_maps=1;
export (int) var random_bubbles_to_pop_precent=10;
export (int) var random_percent_specials=20;
export (int) var random_total_shots=10;
export (int) var random_winnig_state=0;
export (int) var random_width=0;
export (int) var random_height=0;

#in case user currently in menu
var on_mnu=false;
var down_mnu=preload("res://Scenes/buttons/down_mnu.tscn").instance()
var purchase_mnu=preload("res://Scenes/buttons/buying_mnu.tscn").instance()
var win_mnu=preload("res://Scenes/buttons/win_mnu.tscn").instance()
var lose_mnu=preload("res://Scenes/buttons/lose_mnu.tscn").instance()

func get_next_level():
	remove_child(cur_level)
	#level_number+=1					#in case we have made up levels
	var path=("res://Scenes/levels/level_"+(self.level_number as String)+".tscn")
	cur_level=(load(path)).instance()
	add_child(cur_level)
	set_gems(0)
	
	if(random_maps==1):				#make random map
		cur_level.init_random(
			score,
			random_bubbles_to_pop_precent,
			random_percent_specials,
			random_total_shots,
			random_winnig_state,
			random_width,
			random_height)
	else:
		cur_level.init_normal(score)
	remove_child(down_mnu)
	add_child(down_mnu)
	
func restart_level():
	var board=cur_level.board				#get the cur level starting board for reset
	remove_child(cur_level)
	var path=("res://Scenes/levels/level_"+(self.level_number as String)+".tscn")
	cur_level=(load(path)).instance()
	add_child(cur_level)
	#set_score(0)
	set_gems(0)
	
	if(random_maps==1):
		cur_level.init_random_restart(
			board,
			res_score,
			random_bubbles_to_pop_precent,
			random_percent_specials,
			random_total_shots,
			random_winnig_state,
			random_width,
			random_height)
	else:
		cur_level.init_normal(score)
		
	remove_child(down_mnu)
	add_child(down_mnu)
	down_mnu.set_score(res_score)
	
func _ready():
	var path=("res://Scenes/levels/level_"+(self.level_number as String)+".tscn")
	cur_level=load(path).instance()
	add_child(cur_level)
	set_score(0)
	set_gems(0)
	if(random_maps==1):					#make random map
		cur_level.init_random(
			score,
			random_bubbles_to_pop_precent,
			random_percent_specials,
			random_total_shots,
			random_winnig_state,
			random_width,
			random_height)
	else:
		cur_level.init_normal(score)
		
	remove_child(down_mnu)
	add_child(down_mnu)
		
func on_lightning_press():
	#for further development
		#purchase_mnu.init("lightning")
		#add_child(purchase_mnu)
	get_child(1).get_child(1).make_lightning()

func on_rainbow_press():
	#for further development
		#purchase_mnu.init("rainbow")
		#add_child(purchase_mnu)
	get_child(1).get_child(1).make_rainbow()
	
func on_pause_press():
	print("pause")
	
func purchase_mnu(did_buy,item):
	set_on_mnu(false)
	remove_child(purchase_mnu)
	if(did_buy):
		if(coins>=100):
			coins-=100
			if(item=="lightning"):
				#Power_ups_Lightning+=1
				get_child(1).get_child(1).make_lightning()
			else:
				#Power_ups_Rainbow+=1
				get_child(1).get_child(1).make_rainbow()
		else:
			print("sry no money")
	
func set_score(new_score:int):
	var dif=new_score-score
	score=new_score
	coins+=dif					#coins gets diffenrece in scores
	down_mnu.set_score(score)
	
func set_gems(new_gems:int):
	down_mnu.set_gems(new_gems)
	
func has_won():				#on win get win menu
	win_mnu.set_score(score)
	set_on_mnu(true)
	add_child(win_mnu)
	
func decition_mnu(dec:String):      #on win menu decision
	set_on_mnu(false)
	match dec :
		"continue":
			res_score=score
			remove_child(win_mnu)
			get_next_level()
		"restart":
			score=res_score
			remove_child(win_mnu)
			restart_level()
		"quit":
			remove_child(win_mnu)
			get_tree().quit()

func lose():		#on lose get lose menu
	set_on_mnu(true)
	lose_mnu.set_score(score)
	add_child(lose_mnu)
	
func decition_mnu_lose(dec:String):			#on lose menu decision
	set_on_mnu(false)
	match dec :
		"restart":
			score=res_score
			remove_child(lose_mnu)
			restart_level()
		"quit":
			remove_child(lose_mnu)
			get_tree().quit()

func set_on_mnu(state):				#set on menu for stop other touch functions
	yield(get_tree().create_timer(0.1), "timeout")
	on_mnu=state
	
