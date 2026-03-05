class_name LevelObstaclesData extends Resource

@export var speed: Vector2 = Vector2(-250, 0)
@export var obstacle_counter: int = 0
@export var TOTAL_OBSTACLE: int = 16
@export var OBSTACLE_TEXTURES: Dictionary[int, String] = {
	0: "res://assets/images/bar_textures/bar_texture_01.png",
	4: "res://assets/images/bar_textures/bar_texture_02.png",
	12: "res://assets/images/bar_textures/bar_texture_01.png"
}
@export var OBSTACLE_SHADERS: Dictionary[int, String] = {
	0:  "res://shaders/normal_shader_material.tres",
	12: "res://shaders/night_outdoor_shader_material.tres"
}
