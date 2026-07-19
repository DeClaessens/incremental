extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var inventory_component: InventoryComponent
@export var input_component: MovementInputComponent

func _process(delta: float) -> void:
	print(animation_player.current_animation)
	
	if input_component.is_moving:
		animation_player.play("walking")
	else:
		animation_player.stop()
