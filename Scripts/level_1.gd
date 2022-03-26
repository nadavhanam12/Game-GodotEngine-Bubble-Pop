extends Node2D

#INIT LEVEL VARIABLES
export (int) var wining_state;              	#pop al bubbles or collect X gems
export (int) var precent_bubbles_to_pop;    	#how many precent of starting bubbles should the player pop
export (int) var total_bubbles;             	#starting total bubbles
export (int) var total_shots;               	#starting total shots

#IN LEVEL VARIABLES
var cur_bubbles;                            	#how much bubbles left on the level
var cur_combo=0;
var cur_stars;
var cur_score;
var cur_poped=0;

#RANDOM BOARD VARIABLES
var width;
var height;
var offset=75;
var start_x=75;
var start_y=150;
var specials_precentege;
var cur_poping_array:Array
var ready_to_pop:Array

#OTHER VARIABLES
var possible_backgrounds=[
	preload("res://art/Buttons and background/backgrounds/background1.png"),
	#preload("res://art/Buttons and background/backgrounds/background2.png"),
	preload("res://art/Buttons and background/backgrounds/background3.jpg"),
	#preload("res://art/Buttons and background/backgrounds/background4.jpg"),
	preload("res://art/Buttons and background/backgrounds/background5.jpg"),
	preload("res://art/Buttons and background/backgrounds/background5.jpg"),
	preload("res://art/Buttons and background/backgrounds/background6.jpg"),]
var special_bubbles={
	"bomb":preload("res://Scenes/bubbles/bomb.tscn"),
	"spark":preload("res://Scenes/bubbles/spark.tscn"),
	"translucid":preload("res://Scenes/bubbles/translucid.tscn"),
	"glass":preload("res://Scenes/bubbles/glass.tscn"),
	"star":preload("res://Scenes/bubbles/star.tscn"),
	};
var regular_bubble=preload("res://Scenes/bubbles/bubble.tscn")
var board=[];
var possible_colors= [
	"blue",
	"green",
	"purple",
	"red",
	"thin",
	"yellow",];
	
func make_random_board():
	randomize();
	board=make_2d_array();
	spawn_bubbles();
	var backgrund_index=floor(rand_range(0,possible_backgrounds.size()))
	var selected_background=possible_backgrounds[backgrund_index]
	get_child(0).get_child(0).set_texture(selected_background)
	
func make_board(board):				#on restart copy the input board and make the bubbles
	self.board=board
	for i in board.size():
		for j in board[0].size():
			add_child(board[i][j].duplicate())
	var backgrund_index=floor(rand_range(0,possible_backgrounds.size()))
	var selected_background=possible_backgrounds[backgrund_index]
	get_child(0).get_child(0).set_texture(selected_background)

func init_random(score,bubbles_to_pop_precent,specials_precentege,total_shots,wining_state,width,height):
	cur_score=score
	self.width=width
	self.height=height
	self.specials_precentege=specials_precentege
	self.total_bubbles=width*height
	self.cur_bubbles=self.total_bubbles
	self.precent_bubbles_to_pop=bubbles_to_pop_precent
	self.total_shots=total_shots
	self.wining_state=wining_state
	cur_combo=0
	cur_stars=0
	make_random_board()
	get_node("Shooter").init(total_shots);
	cur_poping_array=[];

func init_random_restart(board,score,bubbles_to_pop_precent,specials_precentege,total_shots,wining_state,width,height):
	#same as the noraml make but gets a board and copy it
	cur_score=score
	self.width=width
	self.height=height
	self.specials_precentege=specials_precentege
	self.total_bubbles=width*height
	self.cur_bubbles=self.total_bubbles
	self.precent_bubbles_to_pop=bubbles_to_pop_precent
	self.total_shots=total_shots
	self.wining_state=wining_state
	cur_combo=0
	cur_stars=0
	make_board(board)
	get_node("Shooter").init(total_shots);
	cur_poping_array=[];
	
func init_normal(score):
	#should get a ready map so update only the core
	cur_score=score
	cur_combo=0
	cur_stars=0
	get_node("Shooter").init(total_shots);
	cur_poping_array=[];

func update_score(newscore:int):
	cur_score=newscore
	if(get_parent() !=null):
		get_parent().set_score(newscore)
		var cur_status=total_bubbles*(100-precent_bubbles_to_pop)/100
		if(cur_bubbles<=cur_status)and get_parent() !=null:
			yield(get_tree().create_timer(0.5), "timeout")
			if(get_parent() !=null):
				get_parent().has_won()
	
func make_2d_array():
	var new_board = [];
	for i in height:
		new_board.append([]);
		for j in width:
			new_board[i].append(null);
	return new_board;

func spawn_bubbles():
	#make al the bubbles on board, specials and normals
	for i in height:
		for j in width:
			var bubble_position=init_bubble_position(i,j);
			var bubble_type;
			var random_bubble;
			#random to make special ot not
			var special_or_not=floor(rand_range(1,100))
			if(special_or_not<=specials_precentege):
				var random_type=floor(rand_range(0,special_bubbles.size()))
				bubble_type=special_bubbles.keys()[random_type]
				random_bubble=special_bubbles[bubble_type].instance();
				if((bubble_type=="spark")or(bubble_type=="star")):				#spark and star get normal color
					var random_color=floor(rand_range(0,possible_colors.size()))
					bubble_type=possible_colors[random_color];
			else:
				 random_bubble=regular_bubble.instance();
				 var random_color=floor(rand_range(0,possible_colors.size()))
				 bubble_type=possible_colors[random_color];
				
			random_bubble._init2(bubble_type,bubble_position);
			add_child(random_bubble);
			board[i][j]=random_bubble.duplicate();

func init_bubble_position(row,column):
	var new_x=start_x +(offset *column);
	var new_y=start_y + (offset *row);
	return Vector2(new_x,new_y);
	
func _on_collusion_started(started_bubble): #this function gets called in every collusion by signal
#GET THE SAME-COLORS COMBOS
	ready_to_pop.append(started_bubble);
	cur_poping_array.append(started_bubble);
	while(not cur_poping_array.empty()):
		var cur_poping= cur_poping_array.pop_front()
		var cur_neighbors=cur_poping.check_neighbors();
		for cur_neighbor in cur_neighbors:
			if(not self.ready_to_pop.has(cur_neighbor)):
				ready_to_pop.append(cur_neighbor);
				cur_poping_array.append(cur_neighbor);
				
#UPDATE THE SCORE & COMBOS
	if(ready_to_pop.size()>2):
		if (started_bubble.type=="rainbow"):
			deal_with_rainbow()
			if(ready_to_pop.size()==1):
				ready_to_pop.erase(started_bubble)
				started_bubble.explode()
		cur_poped=ready_to_pop.size();
		for item in ready_to_pop:
			item.explode()
		check_for_traslucids()
	elif(started_bubble.type=="rainbow"):
		ready_to_pop.erase(started_bubble)
		started_bubble.explode()

#GET THE BOMBS COMBOS
	deal_with_bombs(started_bubble.check_special_neighbors())
	if(cur_poped>0):
		cur_combo+=1
		var new_score=(cur_score+((cur_combo*10)*cur_poped))
		cur_bubbles-=cur_poped
		update_score(new_score)
	else:
		cur_combo=0;
		
	ready_to_pop.clear()
	cur_poping_array.clear()
	cur_poped=0;
	
	yield(get_tree().create_timer(1), "timeout")
	clear_hanging()

func clear_hanging():
	#after the bubbles pop check if there bubbles hanging in the air
	var total_hanged=0;
	var no_tops=check_no_tops()
	while(not no_tops.empty()):
		for item in no_tops:
			if(item.time_to_fade==false):
				item.fade()
				total_hanged+=1
				
		no_tops=check_no_tops()
		
	cur_bubbles-=total_hanged
	var new_score=(cur_score+((cur_combo*10)*total_hanged))
	update_score(new_score)
	
func no_more_shots():
	var cur_status=total_bubbles*(100-precent_bubbles_to_pop)/100
	if(cur_bubbles>cur_status):
		get_parent().lose()

func add_bubble():
	if(cur_bubbles != null):
		cur_bubbles+=1
	
func deal_with_bombs(special_neighbors):
	var specials_array=special_neighbors.duplicate()
	var specials_poping=special_neighbors.duplicate()
	while(not specials_poping.empty()):
		var cur_special=specials_poping.pop_front()
		var cur_neighbors=cur_special.check_neighbors()
		for cur_neighbor in cur_neighbors:
			if(not specials_array.has(cur_neighbor)):
				specials_array.append(cur_neighbor);
				if(cur_neighbor.type=="bomb"):
					specials_poping.append(cur_neighbor);
				
	cur_poped+=specials_array.size()
	for item in specials_array:
			item.explode()
	
func _on_spark(bubble_to_kill):
	#do the spark pop, differ from spark a bomb or other
	if(bubble_to_kill.type=="bomb"):
		deal_with_bombs([bubble_to_kill])
	else:
		bubble_to_kill.explode()
		cur_poped+=1
	if(cur_combo==0):
		cur_combo+=1
	var new_score=(cur_score+((cur_combo*10)*cur_poped))
	cur_bubbles-=cur_poped
	update_score(new_score)
	cur_poped=0;
	clear_hanging()
	
func check_for_traslucids():
	var explosion_array=self.ready_to_pop;
	for cur in explosion_array:
		cur.change_neighbors_translucid()
		
func _on_star(stra_type:String):
	cur_stars+=1
	get_parent().set_gems(cur_stars)
	
func _on_lightning(row_neighbors):
	var cur_array=row_neighbors.duplicate()
	cur_poped+=1              #for the lightning bubble
	var bombs=[];
	for bubble in cur_array:
		if (bubble.type=="bomb"):
			bombs.append(bubble)
		else:
			bubble.explode()
			cur_poped+=1
	deal_with_bombs(bombs)
	cur_combo+=1
	var new_score=(cur_score+((cur_combo*10)*cur_poped))
	cur_bubbles-=cur_poped
	update_score(new_score)
	
	yield(get_tree().create_timer(1), "timeout")
	clear_hanging()
				
func deal_with_rainbow():
	#should check ready_to_pop to get only the 2 or more same colors that with the rainbow bubble have 3 or more bubbles
	var cur_array=ready_to_pop.duplicate()
	var got_match=false;
	for bubble in cur_array:
		got_match=false;
		if(not (bubble.type=="rainbow")):
			for bubble_check_match in cur_array:
				if((bubble.type==bubble_check_match.type)and(bubble_check_match !=bubble)):
					got_match=true;
			if(not got_match):
				ready_to_pop.erase(bubble)

func check_no_tops():
	var no_top=[]
	if(is_inside_tree()):
		var normal_balls=.get_children()
		var shot_balls=.get_node("Shooter").get_children()
		shot_balls.resize(shot_balls.size()-2)
		var all=normal_balls+shot_balls
		for bubble in all:
			if(bubble.has_method("explode")):
				if(bubble.time_to_fade==false):
					var has_top=false;
					if(bubble.get_global_position().y==150):  #to leave the first line untouch
						has_top=true
					else:
						var bubble_position=bubble.get_global_position()
						for cur_bubble in all:
							if(cur_bubble.has_method("explode")and (cur_bubble !=bubble) ):
								var cur_position=cur_bubble.get_global_position()
								#now we check if bubble has anyone else above him
								var in_x_range=(abs(bubble_position.x - cur_position.x)<150)
								var in_y_range=(bubble_position.y -125<= cur_position.y)and(bubble_position.y>cur_position.y)
								if(in_x_range and in_y_range and cur_bubble.time_to_fade==false):
									has_top=true
									break
					if not has_top :
						no_top.append(bubble)
		return no_top;
						
