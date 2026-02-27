class_name Bar extends StaticBody2D

@onready var polygon: Polygon2D = $Polygon2D
@onready var collision: CollisionShape2D = $CollisionShape2D

@export var mercy_padding_size: int = 0

const VERTIX_WITH_DIMENSIONS: int = 2

func _ready() -> void:
	collision.shape = RectangleShape2D.new()

func setup(polygon_set: PackedVector2Array, width: float, y: float):
	position.y = y
	polygon.polygon = polygon_set
	collision.position.y = polygon_set[VERTIX_WITH_DIMENSIONS].y / 2
	collision.shape.size = Vector2(width, polygon_set[VERTIX_WITH_DIMENSIONS].y)
