class_name Game extends Node2D

@onready var obstacle_scene: PackedScene = load("res://scenes/obstacle/obstacle.tscn")
@onready var obstacles: Node2D = $Obstacles
@onready var player: Player = $Player

@onready var background1: Background = $Background1
@onready var background2: Background = $Background2
var bg_width: float

@onready var age_label: Label = $GUI/AgeLabel
@onready var money_label: Label = $GUI/MoneyLabel
@onready var loan_label: Label = $GUI/LoanLabel
@onready var game_over_panel: Panel = $GUI/GameOverPanel

@export var bar_start_x: int = 0
@export var gap_between_bars: int = 250
@export var game_paused: bool = true

@export var speed: Vector2 = Vector2(-125, 0)

'''
Ideas:
	- game is generally eternal;
		- players is tired bird going to work and going home
		- many posters about better life, better houses, better cars
		- rarely poster about there being more to life than work
	- super low chance of spawning a graffitti about freedom from capitalism
		- if player goes up on that space, it goes to another level
		- on this level, player now moves towards organization, realizing the true facade of the burgeousie
		- finally, another thing appears which takes to last level of revolution
			- maybe multiple "birds", which fall when hit but overtime more come
			- only loses if every bird falls
	- multiple endings (revolution, death by work)
	- since chance of spawn of billboard is very small:
		- generate random name to player
		- add to chance for every ending got
'''

func _ready() -> void:
	print("Window size: {0}".format([get_viewport_rect().size]))
	for i in range((get_viewport_rect().size.x / gap_between_bars) + 2):
		var x: float = bar_start_x + i * gap_between_bars
		var new_bar: Obstacle = obstacle_scene.instantiate()
		new_bar.position.x = x
		obstacles.add_child(new_bar)
		new_bar.obstacle_name = 'Obstacle {0}'.format([i])
		print("Added {0} bar to x={1}".format([new_bar.obstacle_name, x]))
	bg_width = background1.texture.get_size().x
	background1.setup(0)
	background2.setup(bg_width)
	
	player.money_changed.connect(_on_player_money_changed)
	player.animation_player.animation_finished.connect(_on_player_animation_finished)
	_on_player_money_changed()
	game_paused = false

func _process(delta: float) -> void:
	if not game_paused:
		for obstacle: Obstacle in get_tree().get_nodes_in_group("bars"):
			obstacle.move_and_collide(speed * delta)
		
		background1.position += speed * delta
		background2.position += speed * delta
		if background1.position.x <= -(bg_width):
			background1.setup(background2.position.x + bg_width)
		if background2.position.x <= -(bg_width):
			background2.setup(background1.position.x + bg_width)
			

func set_gui_text() -> void:
	age_label.text = GlobalsData.locale[GlobalsData.selected_language]['game_age'].format([player.age])
	loan_label.text = GlobalsData.locale[GlobalsData.selected_language]['game_loan'].format(["%.2f" % player.loan_to_pay])
	var abs_value: float = abs(player.money)
	var value_sign: String = "" if player.money >= 0 else '- '
	var value_string: String = "$ %.2f" % abs_value
	money_label.text = GlobalsData.locale[GlobalsData.selected_language]['game_money'].format([value_sign, value_string])

func _on_player_hit_something() -> void:
	game_paused = true

func _on_year_up_area_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		if player.get_old():
			game_paused = true
		if player.age % 10 == 0:
			speed *= 1.25
		
		set_gui_text()
		player.change_money(player.salary)

func _on_player_money_changed() -> void:
	set_gui_text()

func _on_awakening_area_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		print("Detected entering REVOLUTION!")

func _on_expenses_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		var expenses: float = 0
		var v: int = 0
		if v == 0: # transportation
			expenses = -randf_range(190, 520)
		elif v == 1: # housing
			expenses = -randf_range(650, 1380)
		elif v == 2: # reocurring expense (light, water, etc)
			expenses = -randf_range(370, 670)
		elif v == 3: # groceries
			expenses = -randf_range(640, 1210)
		player.change_money(expenses)
		print("Detected entering EXPENSES!")

func _on_billboard_area_2d_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		player.sprite_frame_y = 2

func _on_billboard_area_2d_body_exited(body: Node2D) -> void:
	if is_instance_of(body, Player):
		player.sprite_frame_y = 0

func _on_player_loan_changed() -> void:
	if player.loan_to_pay > 0:
		set_gui_text()
		loan_label.visible = true
	else:
		loan_label.visible = false

func _on_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == player.DEATH_ANIMATION:
		money_label.visible = false
		var cause: String = 'game_over_cause_text_overwork' if player.age < player.MAX_AGE else 'game_over_cause_text_old'
		game_over_panel.get_node("TitleLabel").text = GlobalsData.locale[GlobalsData.selected_language]['game_over_title']
		game_over_panel.get_node("QuoteLabel").text = GlobalsData.locale[GlobalsData.selected_language]['game_over_quote_normal']
		game_over_panel.get_node("VBoxContainer/AgeLabel").text = GlobalsData.locale[GlobalsData.selected_language]['game_over_age_text_normal'].format([player.age])
		game_over_panel.get_node("VBoxContainer/MoneyLabel").text = GlobalsData.locale[GlobalsData.selected_language]['game_over_money_text_normal']
		game_over_panel.get_node("VBoxContainer/CauseLabel").text = GlobalsData.locale[GlobalsData.selected_language][cause]
		game_over_panel.get_node("Button").text = GlobalsData.locale[GlobalsData.selected_language]['game_over_button_text_normal']
		game_over_panel.visible = true

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/flappy-bird/main_menu.tscn")
