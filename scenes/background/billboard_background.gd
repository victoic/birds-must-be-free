class_name BillboardBackground extends Background

signal special_billboard_spawned

@onready var day_billboard: Sprite2D = $DayBillboardSprite2D
@onready var night_billboard: Sprite2D = $NightBillboardSprite2D
@onready var awakening_area: Area2D = $AwakeningArea

const COMMON_BILLBOARD_DIR: String = 'common/'
const SPECIAL_BILLBOARD_DIR: String = 'special/'
const REVOLUTION_BILLBOARD_ID: int = 0
const LOAN_BILLBOARD_ID: int = 1

@export var cur_billboard_directory: String = COMMON_BILLBOARD_DIR
@export var cur_billboard_id: int = 0
@export var revolution_billboard: bool = false
@export var loan_billboard: bool = false

const SPECIAL_BILLBOARD_CHANCE: float = 0.1

func setup(new_pos: float):
	revolution_billboard = false
	loan_billboard = false	
	awakening_area.monitoring = false
	
	var num_deaths: int = Stats.get_value('stats', 'num_deaths')
	var num_revolutions: int = Stats.get_value('stats', 'num_revolutions')
	var bonus_special_chance: float = (num_deaths - num_revolutions) / 100.0 + num_revolutions / 50.0
	print("SPECIAL BILLBOARD CHANCE = {0} + {1} = {2}".format([SPECIAL_BILLBOARD_CHANCE, bonus_special_chance, SPECIAL_BILLBOARD_CHANCE + bonus_special_chance]))
	position.x = new_pos
	cur_billboard_directory = COMMON_BILLBOARD_DIR
	var rn: float = randf()
	if rn < min(SPECIAL_BILLBOARD_CHANCE + bonus_special_chance, 0.5):
		cur_billboard_directory = SPECIAL_BILLBOARD_DIR
	var dir_name: String = "res://assets/sprites/billboards/" + cur_billboard_directory + GlobalsData.selected_language + '/'
	
	var dir := DirAccess.open(dir_name)
	var file_names: PackedStringArray = dir.get_files()
	var image_files: Array[String] = []
	for file: String in file_names:
		if file.ends_with('.png'):
			image_files.append(file)
	cur_billboard_id = randi_range(0, image_files.size() - 1)
	var random_file: String = dir_name + image_files[cur_billboard_id]
	
	if cur_billboard_directory == SPECIAL_BILLBOARD_DIR:
		if cur_billboard_id == REVOLUTION_BILLBOARD_ID:
			revolution_billboard = true
			awakening_area.monitoring = true
		elif cur_billboard_id == LOAN_BILLBOARD_ID:
			loan_billboard = true
	
	print('New billboard: {0}'.format([image_files[cur_billboard_id]]))
	day_billboard.texture = load(random_file)
	night_billboard.texture = load(random_file)

func _on_billboard_area_2d_body_exited(body: Node2D) -> void:
	if is_instance_of(body, Player):
		var player: Player = body
		if cur_billboard_directory == SPECIAL_BILLBOARD_DIR and cur_billboard_id == LOAN_BILLBOARD_ID and not player.took_loan:
			player.take_loan()
