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

	gatherable_field_component.capacity_changed.connect(_on_capacity_changed)
	timer.timeout.connect(_on_timer_timeout)

func _on_capacity_changed(has_capacity: bool) -> void:
	if has_capacity and timer.is_stopped():
		return timer.start()
	
	if not has_capacity:
		return timer.stop()
	
func _on_timer_timeout() -> void:
	var instance: Gatherable = GATHERABLE_NODE.instantiate()
	var resource = gatherable_resources.pick_random()
	instance.gatherable_resource = resource
	gatherable_field_component.spawn_gatherable(instance)