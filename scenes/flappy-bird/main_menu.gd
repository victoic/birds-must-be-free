extends Control

@onready var title: Label = $Title
@onready var new_game: Button = $VBoxContainer/NewGameButton
@onready var exit: Button = $VBoxContainer/ExitButton
@onready var locale_label: Label = $VBoxContainer/LocaleLabel

func _ready() -> void:
	title.text = GlobalsData.locale[GlobalsData.selected_language]['menu_title']
	new_game.text = GlobalsData.locale[GlobalsData.selected_language]['menu_new_game']
	exit.text = GlobalsData.locale[GlobalsData.selected_language]['menu_exit_game']

func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/flappy-bird/game.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		GlobalsData.selected_language = 'en'
	elif index == 1:
		GlobalsData.selected_language = 'pt'
	
	title.text = GlobalsData.locale[GlobalsData.selected_language]['menu_title']
	new_game.text = GlobalsData.locale[GlobalsData.selected_language]['menu_new_game']
	exit.text = GlobalsData.locale[GlobalsData.selected_language]['menu_exit_game']
	locale_label.text = GlobalsData.locale[GlobalsData.selected_language]['menu_language']
