class_name ObstaclesContainer extends Node2D

@onready var obstacle_scene: PackedScene = load("res://scenes/obstacle/obstacle.tscn")

@export var level_obstacles_data: LevelObstaclesData
@export var bar_start_x: int = 0
@export var gap_between_bars: int = 250
@export var is_moving: bool = true

func setup() -> void:
	for i in range((get_viewport_rect().size.x / gap_between_bars) + 2):
		var x: float = bar_start_x + i * gap_between_bars
		var new_bar: Obstacle = obstacle_scene.instantiate()
		new_bar.position.x = x
		new_bar.level_obstacles_data = level_obstacles_data
		add_child(new_bar)
		new_bar.obstacle_name = 'Obstacle {0}'.format([i])
		print("Added {0} bar to x={1}".format([new_bar.obstacle_name, x]))

func _process(delta: float) -> void:
	if not GlobalsData.game_paused and is_moving:
		for obstacle: Obstacle in get_tree().get_nodes_in_group("bars"):
			obstacle.move_and_collide(GlobalsData.SPEED * delta)
