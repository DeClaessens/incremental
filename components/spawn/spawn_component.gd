class_name SpawnComponent
extends Node2D

@export var gatherable_field_component: GatherableFieldComponent
@onready var timer: Timer = $Timer

const gatherable_node:= preload('res://scenes/gatherable/Gatherable.tscn')
const tree_resource: GatherableResource = preload('res://data/gatherables/Tree/tree.tres')

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	if (gatherable_field_component.has_capacity()):
		var instance: Gatherable = gatherable_node.instantiate()
		
		instance.gatherable_resource = tree_resource
		gatherable_field_component.spawn_gatherable(instance)
