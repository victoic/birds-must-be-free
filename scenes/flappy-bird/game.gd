class_name Game extends Node2D

@export var bar_start_x: int = 400
@export var gap_between_bars: int = 250
@export var game_paused: bool = true
@export var game_over: bool = false

@onready var obstacle_scene: PackedScene = load("res://scenes/obstacle/obstacle.tscn")

'''
Ideas:
	- game is generally eternal;
		- players is tired bird going to work and going home
		- many posters about better life, better houses, better cars
		- rarely poster about there being more to life than work
	- super low chance of spawning a graffitti about freedom from capitalism
		- if player goes up on that space, it goes to another level
		- on this level, player now moves towards organization, realizing the true facade of the burgeousie
		- finally, another thing appears which takes to last level of revolution
			- maybe multiple "birds", which fall when hit but overtime more come
			- only loses if every bird falls
'''

func _ready() -> void:
	for i in range((get_viewport_rect().size.x / gap_between_bars) + 1):
		var x: float = bar_start_x + i * gap_between_bars
		var new_bar: Obstacle = obstacle_scene.instantiate()
		print("Adding bar to x={0}".format([x]))
		new_bar.position.x = x
		add_child(new_bar)
	game_paused = false

func _process(delta: float) -> void:
	if not game_paused:
		for obstacle: Obstacle in get_tree().get_nodes_in_group("bars"):
			print(is_instance_of(obstacle, Obstacle))
			obstacle.move_and_collide(obstacle.speed * delta)

func _on_player_hit_something() -> void:
	game_paused = true
