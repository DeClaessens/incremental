class_name ResourcesComponent
extends Node

@export var resources: Array[Item]

signal resource_depleted(items: Array[Item])

func deplete():
	resource_depleted.emit(resources)
