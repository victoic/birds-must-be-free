class_name Game extends Node2D

@onready var backgrounds: Backgrounds = $Backgrounds
@onready var obstacles: ObstaclesContainer = $Obstacles
@onready var player: Player = $Player

@onready var gui: Control = $GUI
@onready var name_label: Label = $GUI/NameLabel
@onready var age_label: Label = $GUI/AgeLabel
@onready var money_label: Label = $GUI/MoneyLabel
@onready var loan_label: Label = $GUI/LoanLabel
@onready var game_over_panel: Panel = $GUI/GameOverPanel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var money_sfx_player: AudioStreamPlayer2D = $MoneyAudioStreamPlayer2D
@onready var hit_sfx_player: AudioStreamPlayer2D = $HitAudioStreamPlayer2D

@export var level_data: LevelData

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
	if not level_data.is_revolution:
		GlobalsData.cur_name = GlobalsData.name_list.pick_random()
	if level_data.is_revolution:
		money_label.visible = false
		loan_label.visible = false
	player.name = GlobalsData.cur_name
	name_label.text = player.name
	obstacles.setup()
	backgrounds.setup()
	
	player.money_changed.connect(_on_player_money_changed)
	player.animation_player.animation_finished.connect(_on_player_animation_finished)
	_on_player_money_changed()
	GlobalsData.game_paused = false
	GlobalsData.SPEED = level_data.speed

func _process(delta: float) -> void:
	if game_over_panel.visible == true and Input.is_action_just_pressed("restart"):
		obstacles.level_obstacles_data.obstacle_counter = 0
		get_tree().reload_current_scene()

func set_gui_text() -> void:
	age_label.text = GlobalsData.locale[GlobalsData.selected_language]['game_age'].format([player.age])
	loan_label.text = GlobalsData.locale[GlobalsData.selected_language]['game_loan'].format(["%.2f" % player.loan_to_pay])
	var abs_value: float = abs(player.money)
	var value_sign: String = "" if player.money >= 0 else '- '
	var value_string: String = "$ %.2f" % abs_value
	money_label.text = GlobalsData.locale[GlobalsData.selected_language]['game_money'].format([value_sign, value_string])

func change_scene(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)

func change_ending_label(id: int) -> void:
	var new_text: String = GlobalsData.locale[GlobalsData.selected_language]['end_game_text_0{0}'.format([id+1])]
	gui.get_node("EndingLabel").text = new_text

func _on_player_hit_something() -> void:
	if not GlobalsData.game_paused:
		hit_sfx_player.play()
	GlobalsData.game_paused = true
	Stats.save_config(level_data.is_revolution, false)

func _on_year_up_area_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		if player.get_old():
			GlobalsData.game_paused = true
		if player.age % 10 == 0:
			GlobalsData.SPEED *= 1.25
		set_gui_text()
		player.change_money(player.salary)
		money_sfx_player.play()

func _on_player_money_changed() -> void:
	set_gui_text()

func _on_awakening_area_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		call_deferred("change_scene", "res://scenes/flappy-bird/levels/revolution.tscn")

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
		money_sfx_player.play()

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
		var quote: String = 'game_over_quote_normal' if not level_data.is_revolution else 'game_over_quote_revolution'
		var age: String = 'game_over_age_text_normal' if not level_data.is_revolution else 'game_over_age_text_revolution'
		var money: String = 'game_over_money_text_normal'
		if player.loan_to_pay > 0:
			money = 'game_over_money_text_loan'
		if level_data.is_revolution:
			money = 'game_over_money_text_revolution'
		var cause: String = 'game_over_cause_text_old'
		if player.age < player.MAX_AGE:
			cause = 'game_over_cause_text_overwork' 
		if level_data.is_revolution:
			cause = 'game_over_cause_text_revolution'
		var button: String = 'game_over_button_text_normal' if not level_data.is_revolution else 'game_over_button_text_revolution'
		
		game_over_panel.get_node("TitleLabel").text = GlobalsData.locale[GlobalsData.selected_language]['game_over_title']
		game_over_panel.get_node("QuoteLabel").text = GlobalsData.locale[GlobalsData.selected_language][quote]
		game_over_panel.get_node("VBoxContainer/AgeLabel").text = GlobalsData.locale[GlobalsData.selected_language][age].format([player.age])
		game_over_panel.get_node("VBoxContainer/MoneyLabel").text = GlobalsData.locale[GlobalsData.selected_language][money]
		game_over_panel.get_node("VBoxContainer/CauseLabel").text = GlobalsData.locale[GlobalsData.selected_language][cause]
		game_over_panel.get_node("Button").text = GlobalsData.locale[GlobalsData.selected_language][button]
		game_over_panel.get_node("RestartLabel").text = GlobalsData.locale[GlobalsData.selected_language]['game_over_restart']
		game_over_panel.visible = true
	elif anim_name == "end_scene":
		call_deferred("change_scene", "res://scenes/flappy-bird/main_menu.tscn")

func _on_button_pressed() -> void:
	call_deferred("change_scene", "res://scenes/flappy-bird/main_menu.tscn")

func _on_backgrounds_background_end() -> void:
	player.move_x = true
	obstacles.is_moving = false

func _on_player_game_end() -> void:
	name_label.visible = false
	age_label.visible = false
	money_label.visible = false
	loan_label.visible = false
	GlobalsData.game_paused = true
	animation_player.play("end_scene")
	Stats.save_config(level_data.is_revolution, true)
