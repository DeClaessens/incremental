class_name GatherableResource
extends Resource

# This script should be moved as it is the basis of a gatherable node.

@export var name: String
@export var items: Array[Item] = []
@export var scene: PackedScene