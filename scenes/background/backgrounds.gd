class_name Backgrounds extends Node2D

signal background_end

@export var is_moving: bool = true
@export var is_looping: bool = true

func setup() -> void:
	var starting_x: float = 0
	for background in get_children():
		if is_instance_of(background, Background):
			background.setup(starting_x)
			starting_x += background.texture.get_width()

func total_width() -> float:
	var width: float = 0
	for node in get_children():
		if is_instance_of(node, Background):
			width += node.texture.get_width()
	return width

func _process(delta: float) -> void:
	var starting_x: float = 0
	if not GlobalsData.game_paused and is_moving: 
		for background in get_children():
			if is_instance_of(background, Background):
				var bg_width = background.texture.get_width()
				background.position += GlobalsData.SPEED * delta
				var end_position: float = -bg_width if is_looping else -(bg_width - get_viewport_rect().size.x)
				if background.position.x <= end_position:
					if is_looping:
						background.position.x = total_width() - bg_width
					else:
						is_moving = false
						background_end.emit()
