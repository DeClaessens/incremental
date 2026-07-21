extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var inventory_component: InventoryComponent
@export var input_component: MovementInputComponent

func _ready() -> void:
	input_component.started_moving.connect(_on_started_moving)
	input_component.stopped_moving.connect(_on_stopped_moving)

func _on_started_moving():
	animation_player.play("walking")
	
func _on_stopped_moving():
	if animation_player.is_playing():
		animation_player.stop()