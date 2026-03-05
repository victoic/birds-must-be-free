extends Control

@onready var title: Label = $Title
@onready var new_game: Button = $VBoxContainer/NewGameButton
@onready var exit: Button = $VBoxContainer/ExitButton
@onready var locale_label: Label = $VBoxContainer/LocaleLabel
@onready var texture_rect: TextureRect = $TextureRect
@onready var credits_button: Button = $VBoxContainer/CreditsButton
@onready var credits: Panel = $Credits
@onready var music_by: Label = $Credits/MusicByLabel
@onready var back_button: Button = $Credits/BackButton

const MENU_NORMAL: Texture2D = preload("res://assets/images/backgrounds/menu-bg01.png")
const MENU_REVOLUTION_STARTED: Texture2D = preload("res://assets/images/backgrounds/menu-bg02.png")
const MENU_REVOLUTION_FINISHED: Texture2D = preload("res://assets/images/backgrounds/menu-bg03.png")

func _ready() -> void:
	title.text = GlobalsData.locale[GlobalsData.selected_language]['menu_title']
	new_game.text = GlobalsData.locale[GlobalsData.selected_language]['menu_new_game']
	exit.text = GlobalsData.locale[GlobalsData.selected_language]['menu_exit_game']
	credits_button.text = GlobalsData.locale[GlobalsData.selected_language]['menu_credits']
	music_by.text = GlobalsData.locale[GlobalsData.selected_language]['menu_credits_music_by']
	back_button.text = GlobalsData.locale[GlobalsData.selected_language]['menu_credits_back']
	
	if Stats.get_value('stats', 'num_wins') > 0:
		texture_rect.texture = MENU_REVOLUTION_FINISHED
	elif Stats.get_value('stats', 'num_revolutions') > 0:
		texture_rect.texture = MENU_REVOLUTION_STARTED
	else:
		texture_rect.texture = MENU_NORMAL

func change_scene(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)

func _on_new_game_button_pressed() -> void:
	call_deferred("change_scene", 'res://scenes/flappy-bird/levels/game.tscn')

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
	credits_button.text = GlobalsData.locale[GlobalsData.selected_language]['menu_credits']
	music_by.text = GlobalsData.locale[GlobalsData.selected_language]['menu_credits_music_by']
	back_button.text = GlobalsData.locale[GlobalsData.selected_language]['menu_credits_back']

func _on_back_button_pressed() -> void:
	credits.visible = false

func _on_credits_button_pressed() -> void:
	credits.visible = true
