class_name SpawnComponent
extends Node2D

@export var gatherable_field_component: GatherableFieldComponent
@export var gatherable_resources: Array[GatherableResource]

@onready var timer: Timer = $Timer

const GATHERABLE_NODE:= preload('res://scenes/gatherable/Gatherable.tscn')


func _ready() -> void:
	if (not gatherable_resources.is_empty()):
		timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	if (gatherable_field_component.has_capacity()):
		var instance: Gatherable = GATHERABLE_NODE.instantiate()
		var resource = gatherable_resources.pick_random()
		instance.gatherable_resource = resource
		gatherable_field_component.spawn_gatherable(instance)