class_name Bar extends StaticBody2D

@onready var polygon: Polygon2D = $Polygon2D
@onready var collision: CollisionShape2D = $CollisionShape2D

@export var mercy_padding_size: int = 0

const VERTIX_WITH_DIMENSIONS: int = 2

func _ready() -> void:
	collision.shape = RectangleShape2D.new()

func set_texture(texture_path: String, shader_material: String) -> void:
	polygon.texture = load(texture_path)
	polygon.material = load(shader_material)
	var bar_width: int = 50
	var x_offset: int = randi_range(0, polygon.texture.get_width() - bar_width)
	var y_offset: int = randi_range(0, polygon.texture.get_height() - polygon.polygon[VERTIX_WITH_DIMENSIONS].y)
	polygon.texture_offset = Vector2(x_offset, y_offset)

func setup(polygon_set: PackedVector2Array, width: float, y: float):
	position.y = y
	polygon.polygon = polygon_set
	collision.position.y = polygon_set[VERTIX_WITH_DIMENSIONS].y / 2
	collision.shape.size = Vector2(width, polygon_set[VERTIX_WITH_DIMENSIONS].y)
	
