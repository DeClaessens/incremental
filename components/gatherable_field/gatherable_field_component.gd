class_name GatherableFieldComponent
extends Node2D

var _active_gatherables: Array[Gatherable] = []
var entity_layer: Node2D
@export var capacity: int = 0
@export var tile_map_layer: TileMapLayer

signal capacity_freed

func _ready() -> void:
	entity_layer = get_tree().get_first_node_in_group("entity_layer") as Node2D
	assert(entity_layer != null, "No node in group 'entity_layer'")

func _is_cell_spawnable(cell: Vector2i) -> bool:
	return tile_map_layer.get_cell_tile_data(cell).get_custom_data('spawnable_ground')

func _define_spawnable_cells() -> Array[Vector2i]:
	return tile_map_layer.get_used_cells().filter(_is_cell_spawnable)
#this function is not taking into account whether a cell spawned oin it or not
func _get_random_spawn_position(cells) -> Vector2:	
	return tile_map_layer.map_to_local(cells.pick_random())

# Tracks field capacity and emits event
func has_capacity() -> bool:
	return _active_gatherables.size() < capacity and not _define_spawnable_cells().is_empty()

func spawn_gatherable(instance: Gatherable):
	var spawnable_cells = _define_spawnable_cells()
	if spawnable_cells.is_empty():
		return
	var cell: Vector2i = spawnable_cells.pick_random()
	
	instance.tree_exited.connect(_on_gatherable_removed.bind(instance))
	entity_layer.add_child(instance)

	instance.global_position = tile_map_layer.to_global(tile_map_layer.map_to_local(cell))
	_active_gatherables.append(instance)

func _on_gatherable_removed(instance: Gatherable):
	_active_gatherables.erase(instance)
	capacity_freed.emit()
