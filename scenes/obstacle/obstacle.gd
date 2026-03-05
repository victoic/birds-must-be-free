class_name Obstacle extends StaticBody2D

@onready var upper_bar: Bar = $UpperBarStaticBody2D
@onready var lower_bar: Bar = $LowerBarStaticBody2D

@export var obstacle_name: String = ''
@export var width: int = 50
@export var gap_height: int = 200
@export var border_padding: int = 50
@export var reset_position_x: float = 1500

var level_obstacles_data: LevelObstaclesData

func _ready() -> void:
	setup()

func set_textures():
	level_obstacles_data.obstacle_counter = (level_obstacles_data.obstacle_counter + 1) % level_obstacles_data.TOTAL_OBSTACLE
	var texture_path: String = level_obstacles_data.OBSTACLE_TEXTURES[0]
	for j in level_obstacles_data.OBSTACLE_TEXTURES:
		if j <= level_obstacles_data.obstacle_counter:
			texture_path = level_obstacles_data.OBSTACLE_TEXTURES[j]
		else: break
	var shader_path: String = level_obstacles_data.OBSTACLE_SHADERS[0]
	for j in level_obstacles_data.OBSTACLE_SHADERS:
		if j <= level_obstacles_data.obstacle_counter:
			shader_path = level_obstacles_data.OBSTACLE_SHADERS[j]
	upper_bar.set_texture(texture_path, shader_path)
	lower_bar.set_texture(texture_path, shader_path)

func setup():
	var offset: Vector2 = Vector2(width, 0) / 2
	var window_size: Vector2 = get_viewport_rect().size
	var upper_point = Vector2.ZERO
	var upper_bar_end: float = randf_range(border_padding, window_size.y - border_padding - gap_height)
	var lower_bar_start: float = upper_bar_end + gap_height
	
	var upper_points: PackedVector2Array = PackedVector2Array([
		upper_point - offset,
		Vector2(width, upper_point.y) - offset,
		Vector2(width, upper_bar_end) - offset,
		Vector2(upper_point.x, upper_bar_end) - offset
	])
	upper_bar.setup(upper_points, width, 0)
	
	var lower_bar_height: float = window_size.y - lower_bar_start
	var lower_points: PackedVector2Array = PackedVector2Array([
		upper_point - offset,
		Vector2(width, upper_point.y) - offset,
		Vector2(width, lower_bar_height) - offset,
		Vector2(upper_point.x, window_size.y - lower_bar_start) - offset
	])
	lower_bar.setup(lower_points, width, lower_bar_start)
	set_textures()

func _process(delta: float) -> void:
	if position.x <= -width:
		position.x += reset_position_x
		print("{0} changed position to {1}".format([obstacle_name, position]))
		setup()
