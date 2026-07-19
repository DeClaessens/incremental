class_name GatherableFieldComponent
extends Node2D

@export var capacity: int = 0
@export var tile_map_layer: TileMapLayer

func get_random_spawn_position() -> Vector2:
	return tile_map_layer.map_to_local(tile_map_layer.get_used_cells().pick_random())

func has_capacity() -> int:
	return self.get_child_count() < capacity

func spawn_gatherable(instance: Gatherable):
	instance.position = get_random_spawn_position()
	self.add_child(instance)
