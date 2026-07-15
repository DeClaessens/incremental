extends Node2D

@export var gatherableResource: GatherableResource
@export var harvestableComponent: HarvestableComponent
@export var resourceComponent: ResourcesComponent

func _ready() -> void:
	var area2d: Area2D = prepare()
	area2d.body_entered.connect(_on_body_entered)
	area2d.body_exited.connect(_on_body_exited)
	harvestableComponent.harvested.connect(resourceComponent.deplete)
	resourceComponent.resource_depleted.connect(_on_resource_depleted)
	
func prepare() -> Area2D:
	print(self)
	print(gatherableResource)
	resourceComponent.resources = gatherableResource.items
	var instance: StaticBody2D = gatherableResource.scene.instantiate()
	add_child(instance)
	return instance.get_node('Area2D')
	
	
func _on_body_entered(node: Node) -> void:
	if _is_node_a_character(node):
		harvestableComponent.activate(node)

func _on_body_exited(node: Node) -> void:
	if _is_node_a_character(node):
		harvestableComponent.deactivate(node)
		
func _on_resource_depleted(items: Array[Item]) -> void:
	SignalBus.gathered_resources.emit(items)
	self.queue_free()

func _is_node_a_character(body: Node) -> bool:
	return body is CharacterBody2D
