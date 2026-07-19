class_name MovementInputComponent
extends Node


var is_moving: bool = false
@export var character: CharacterBody2D
@export var character_stats: CharacterStats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
	if direction.length() > 0:
		is_moving = true
		character.velocity = character.velocity.move_toward(direction * character_stats.max_speed, character_stats.acceleration * delta)
	else:
		is_moving = false
		character.velocity = character.velocity.move_toward(Vector2.ZERO, character_stats.friction * delta)
