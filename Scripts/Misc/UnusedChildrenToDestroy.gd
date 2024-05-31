extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.queue_free()

