class_name Player extends CharacterBody2D

signal hit_something

@onready var sprite: Sprite2D = $Sprite2D

@export var gravity: float = 980.0
@export var jump_force: float = -425.0
@export var age: int = 25
@export var money: float = 0.0

var game_paused: bool = false

func _physics_process(delta: float) -> void:
	if not game_paused:
		velocity.y += gravity * delta
		if velocity.y > 0:
			sprite.frame = 0
		else:
			sprite.frame = 1
		if Input.is_action_just_pressed("move"):
			velocity.y = jump_force
			sprite.frame = 1 if sprite.frame == 0 else 0
		if move_and_slide():
			hit_something.emit()
			game_paused = true
