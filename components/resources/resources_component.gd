class_name ResourcesComponent
extends Node

# This component is used to keep track of resources and allow players to remove them based on a signal
# The resources should be saved in a Resource .tres file


@export var resources: Array[Item]

signal resource_depleted(items: Array[Item])

func deplete():
	print('depleting')
	#The node should queue_free, remove the item from the resources array, and emit a signal
	resource_depleted.emit(resources)
