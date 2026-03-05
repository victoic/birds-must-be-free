class_name Background extends Sprite2D

@export var base_texture: String = "res://assets/sprites/revolution_level"

func _ready() -> void:
	texture = load("{0}_{1}.png".format([base_texture, GlobalsData.selected_language]))

func setup(new_pos: float):
	pass
