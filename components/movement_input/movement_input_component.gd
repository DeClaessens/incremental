class_name MovementInputComponent
extends Node

@export var character: CharacterBody2D
@export var character_stats: CharacterStats

signal started_moving
signal stopped_moving

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
	if direction.length() > 0:
		character.velocity = character.velocity.move_toward(direction * character_stats.max_speed, character_stats.acceleration * delta)
		started_moving.emit()	
	else:
		character.velocity = character.velocity.move_toward(Vector2.ZERO, character_stats.friction * delta)
		stopped_moving.emit()
