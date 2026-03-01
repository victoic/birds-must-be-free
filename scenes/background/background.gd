class_name Background extends Sprite2D

signal special_billboard_spawned

@onready var day_billboard: Sprite2D = $DayBillboardSprite2D
@onready var night_billboard: Sprite2D = $NightBillboardSprite2D

@onready var awakening_area: Area2D = $AwakeningArea

const SPECIAL_BILLBOARD_CHANCE: float = 0.01

func setup(new_pos: float, language: String = 'en'):
	position.x = new_pos
	var dir_name: String = "res://assets/sprites/billboards/common/"
	var rn: float = randf()
	if rn < SPECIAL_BILLBOARD_CHANCE:
		dir_name = "res://assets/sprites/billboards/special/"
		awakening_area.monitoring = true
	else:
		awakening_area.monitoring = false
		
	dir_name += language + '/'
	
	var dir := DirAccess.open(dir_name)
	var file_names: PackedStringArray = dir.get_files()
	var image_files: Array[String] = []
	for file: String in file_names:
		if file.ends_with('.png'):
			image_files.append(file)
	var random_index: int = randi_range(0, image_files.size() - 1)
	var random_file: String = dir_name + image_files[random_index]
	print('New billboard: {0}'.format([image_files[random_index]]))
	day_billboard.texture = load(random_file)
	night_billboard.texture = load(random_file)
