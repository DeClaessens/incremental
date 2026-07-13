class_name HarvestableComponent
extends Node

@onready var hintBox: Control = %HintBox

signal harvested()

var active: bool = false

func activate(body: Node) -> void:
	active = true
	hintBox.show()

func deactivate(body: Node) -> void:
	active = false
	hintBox.hide()

func _process(delta: float) -> void:
	if active:
		if Input.is_physical_key_pressed(Key.KEY_E):
			active = false
			harvested.emit()