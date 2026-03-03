class_name Bar extends StaticBody2D

@onready var polygon: Polygon2D = $Polygon2D
@onready var collision: CollisionShape2D = $CollisionShape2D

@export var mercy_padding_size: int = 0

const VERTIX_WITH_DIMENSIONS: int = 2

func _ready() -> void:
	collision.shape = RectangleShape2D.new()

func set_texture(texture_path: String, shader_path: String) -> void:
	polygon.texture = load(texture_path)
	'''if shader_path != "":
		polygon.material.shader = load(shader_path)'''
	polygon.texture_offset = Vector2(randi_range(0, 100), randi_range(10, 638  - polygon.polygon[VERTIX_WITH_DIMENSIONS].y))

func setup(polygon_set: PackedVector2Array, width: float, y: float):
	position.y = y
	polygon.polygon = polygon_set
	collision.position.y = polygon_set[VERTIX_WITH_DIMENSIONS].y / 2
	collision.shape.size = Vector2(width, polygon_set[VERTIX_WITH_DIMENSIONS].y)
	
