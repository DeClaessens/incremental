class_name GatherableFieldComponent
extends Node2D

@export var capacity: int = 0
@export var tile_map_layer: TileMapLayer

signal capacity_changed(has_capacity: bool)
func _ready() -> void:
	_emity_capacity()

func _is_cell_spawnable(cell: Vector2i) -> bool:
	return tile_map_layer.get_cell_tile_data(cell).get_custom_data('spawnable_ground')

func _define_spawnable_cells() -> Array[Vector2i]:
	return tile_map_layer.get_used_cells().filter(_is_cell_spawnable)
#this function is not taking into account whether a cell spawned oin it or not
func _get_random_spawn_position(cells) -> Vector2:	
	return tile_map_layer.map_to_local(cells.pick_random())

# Tracks field capacity and emits event
func _emity_capacity() -> void:
	if self.get_child_count() < capacity and not _define_spawnable_cells().is_empty():
		capacity_changed.emit(true)
	else:
		capacity_changed.emit(false)

func spawn_gatherable(instance: Gatherable):
	var spawnable_cells = _define_spawnable_cells()
	instance.position = _get_random_spawn_position(spawnable_cells)
	instance.tree_exited.connect(_emity_capacity)

	self.add_child(instance)

	_emity_capacity()