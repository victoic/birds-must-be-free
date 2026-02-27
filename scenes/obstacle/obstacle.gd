class_name Obstacle extends StaticBody2D

@onready var upper_bar: Bar = $UpperBarStaticBody2D
@onready var lower_bar: Bar = $LowerBarStaticBody2D

@export var speed: Vector2 = Vector2(-100, 0)
@export var width: int = 50
@export var gap_height: int = 200
@export var border_padding: int = 50

func _ready() -> void:
	setup()

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

func _process(delta: float) -> void:
	if position.x <= -width:
		position.x = get_viewport_rect().size.x + width
		setup()
