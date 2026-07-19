extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var inventory_component: InventoryComponent
@export var input_component: MovementInputComponent

func _process(delta: float) -> void:
	if input_component.is_moving:
		animation_player.play("walking")

	if animation_player.is_playing():
		if not input_component.is_moving:
			animation_player.stop()

