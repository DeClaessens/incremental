class_name SpawnComponent
extends Node2D

@export var gatherable_field_component: GatherableFieldComponent
@export var gatherable_resources: Array[GatherableResource]

@onready var timer: Timer = $Timer

const GATHERABLE_NODE:= preload('res://scenes/gatherable/Gatherable.tscn')


func _ready() -> void:
	if (gatherable_resources.is_empty()):
		print('No resources have been configured for this component')
		return;

	timer.timeout.connect(_on_timer_timeout)

	_check_and_start_timer()

	
func _on_timer_timeout() -> void:
	if not gatherable_field_component.has_capacity():
		timer.stop()
		return

	var instance: Gatherable = GATHERABLE_NODE.instantiate()
	var resource = gatherable_resources.pick_random()
	instance.gatherable_resource = resource

	instance.tree_exited.connect(_check_and_start_timer)

	gatherable_field_component.spawn_gatherable(instance)

func _check_and_start_timer() -> void:
	if gatherable_field_component.has_capacity() and timer.is_stopped():
		timer.start()
