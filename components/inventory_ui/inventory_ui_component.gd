class_name InventoryUIComponent
extends CanvasLayer

@onready var item_slot: PackedScene = preload("res://scenes/ItemSlot.tscn")
@onready var grid_container: GridContainer = %GridContainer
@export var inventory_component: InventoryComponent


func _ready() -> void:
	self.hide()
	
func _process(delta) -> void:
	if Input.is_physical_key_pressed(Key.KEY_I):
		_open_inventory()
	
	if Input.is_physical_key_pressed(Key.KEY_ESCAPE):
		_close_inventory()

func _open_inventory() -> void:
	if (self.visible):
		return
	var items: Array[Item] = inventory_component.get_items()
	for item in items:
		var instance = item_slot.instantiate()
		grid_container.add_child(instance)
		instance.set_texture(item.icon)
	self.show()

func _close_inventory() -> void:
	self.hide()
	for child in grid_container.get_children():
		child.queue_free()
