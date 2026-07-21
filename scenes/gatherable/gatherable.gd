class_name Gatherable
extends Node2D

@export var gatherable_resource: GatherableResource
@export var harvestable_component: HarvestableComponent
@export var resource_component: ResourcesComponent

func _ready() -> void:
	var area2d: Area2D = prepare()
	area2d.body_entered.connect(_on_body_entered)
	area2d.body_exited.connect(_on_body_exited)
	harvestable_component.harvested.connect(resource_component.deplete)
	resource_component.resource_depleted.connect(_on_resource_depleted)
	
func prepare() -> Area2D:
	resource_component.resources = gatherable_resource.items
	var instance: StaticBody2D = gatherable_resource.scene.instantiate()
	add_child(instance)
	return instance.get_node('DetectionBox')
	
func _on_body_entered(node: Node) -> void:
	if _is_node_a_character(node):
		harvestable_component.activate(node)

func _on_body_exited(node: Node) -> void:
	if _is_node_a_character(node):
		harvestable_component.deactivate(node)
		
func _on_resource_depleted(items: Array[Item]) -> void:
	SignalBus.gathered_resources.emit(items)
	self.queue_free()

func _is_node_a_character(body: Node) -> bool:
	return body is CharacterBody2D
