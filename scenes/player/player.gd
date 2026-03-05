class_name Player extends CharacterBody2D

signal hit_something
signal money_changed
signal loan_changed
signal game_end

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var money_animation: Label = $MoneyAnimationLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream: AudioStreamPlayer2D = $AudioStreamPlayer2D

const MAX_AGE: int = 80
const DEATH_ANIMATION: StringName = "death"
const MONEY_ANIMATION: StringName = "money_change"

@export var move_x: bool = false
@export var gravity: float = 980.0
@export var jump_force: float = -425.0
@export var age: int = 25
@export var is_dead: bool = false
@export var money: float = 100.0
@export var salary: float = 1621.0
@export var took_loan: bool = false
@export var loan_to_pay: float = 0

@export var sprite_frame_y: int = 0

var game_paused: bool = false
var game_over: bool = false

func _ready() -> void:
	money_animation.visible = false

func get_old() -> bool:
	age += 1
	if age >= MAX_AGE:
		hit_something.emit()
		game_paused = true
		return true
	return false

func change_money(value: float) -> void:
	if took_loan and value < 0:
		var interest: float = min(loan_to_pay, abs(value))
		value += sign(value) * interest
		loan_to_pay -= interest
		loan_changed.emit()
		if loan_to_pay == 0:
			took_loan = false
	money += value
	var abs_value: float = abs(value)
	var signal_str: String = "+" if value > 0 else "-"
	var money_text: String = "R$ %.2f" % abs_value
	money_animation.text = "{0} {1}".format([signal_str, money_text])
	animation_player.play("money_change")
	money_changed.emit()

func take_loan() -> void:
	change_money(10000)
	took_loan = true
	loan_to_pay = 10000
	loan_changed.emit()

func death() -> void:
	animation_player.play("death")
	is_dead = true

func _physics_process(delta: float) -> void:
	if move_x:
		velocity.x = abs(GlobalsData.SPEED.x)
	if not game_paused:
		velocity.y += gravity * delta
		if velocity.y > 0:
			sprite.frame_coords = Vector2i(0, sprite_frame_y)
		else:
			sprite.frame_coords = Vector2i(1, sprite_frame_y)
		if Input.is_action_just_pressed("move"):
			audio_stream.play()
			velocity.y = jump_force
			sprite.frame_coords = Vector2i(1, sprite_frame_y) if sprite.frame_coords.x == 0 else Vector2i(0, sprite_frame_y)
		if move_and_slide():
			hit_something.emit()
			game_paused = true
	else:
		if not is_dead:
			death()
	if position.x >= get_viewport_rect().size.x / 2 and not game_over:
		game_over = true
		collision_shape.disabled = true
		game_end.emit()
