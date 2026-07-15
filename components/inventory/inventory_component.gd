class_name InventoryComponent
extends Node2D

var max_amount_of_items: int = 10
var items: Array[Item] = []

func _ready() -> void:
	SignalBus.gathered_resources.connect(add_item)

func add_item(_items: Array[Item]) -> void:
	items.append_array(_items)
	print(items)

func remove_item(_item: Item) -> void:
	items.erase(_item)

func get_items() -> Array[Item]:
	return items