class_name Revolution extends Node2D

@onready var background: Sprite2D = $Background

@export var game_paused: bool = false
@export var speed: Vector2 = Vector2(-250, 0)
@onready var obstacle_scene: PackedScene = load("res://scenes/obstacle/obstacle.tscn")
@onready var obstacles: Node2D = $Obstacles
@onready var player: Player = $Player

const TOTAL_OBSTACLE: int = 48

const OBSTACLE_TEXTURES: Dictionary[int, String] = {
	0: "res://assets/images/bar_textures/bar_texture_revolution_01.png",
	3: "res://assets/images/bar_textures/bar_texture_revolution_02.png",
	12: "res://assets/images/bar_textures/bar_texture_revolution_03.png"
}

func _ready() -> void:
	for i in range(TOTAL_OBSTACLE):
		var x = i * 250
		var new_bar: Obstacle = obstacle_scene.instantiate()
		new_bar.position.x = x
		obstacles.add_child(new_bar)
		new_bar.obstacle_name = 'Obstacle {0}'.format([i])
		print("Added {0} bar to x={1}".format([new_bar.obstacle_name, x]))

func _process(delta: float) -> void:
	if not game_paused:
		for obstacle: Obstacle in get_tree().get_nodes_in_group("bars"):
			obstacle.move_and_collide(speed * delta)
		
		var bg_width = background.texture.get_size().x
		background.position += speed * delta
		if background.position.x <= -(bg_width - get_viewport_rect().size.x):
			print("Game Over")
			game_paused = true
