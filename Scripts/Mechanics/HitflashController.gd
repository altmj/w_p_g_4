extends Node

@export var mesh_path : NodePath

var flash_material = load("res://Assets/Materials/hitflash_white_material_3d.tres")
var is_flashing : bool = false

@onready var parent = get_parent()

func flash(mesh):
	mesh.set_surface_override_material(0, flash_material)

func unflash(mesh):
	mesh.set_surface_override_material(0, Object.new())

func hitflash():
	is_flashing = true
	#print(parent.get_collision_layer())
	#parent.set_collision_layer(4)
	
	var meshes : Array[MeshInstance3D] = []
	
	#for child_index in range(parent.get_child_count()):
		#var child_node = parent.get_child(child_index)
#
		#if child_node is MeshInstance3D:
			#meshes.append(child_node)
	if mesh_path:
		meshes.append(get_node(mesh_path))
		
		for x in range(3):
			for mesh in meshes:
				flash(mesh)
			await get_tree().create_timer(0.1).timeout
			for mesh in meshes:
				unflash(mesh)
			await get_tree().create_timer(0.1).timeout
	else:
		push_error("mesh_path not initiated")
	
	is_flashing = false
	#parent.set_collision_layer(4)
