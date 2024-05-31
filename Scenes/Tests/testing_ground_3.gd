extends Node3D

var flash_material = load("res://Assets/Materials/hitflash_white_material_3d.tres")
var is_flashing : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click") and not is_flashing:
		hitflash()
		

func flash(mesh):
	mesh.set_surface_override_material(0, flash_material)

func unflash(mesh):
	mesh.set_surface_override_material(0, Object.new())

func hitflash():
	is_flashing = true
	var meshes : Array = []
	for child_index in range($EnemyDummy.get_child_count()):
		var child_node = $EnemyDummy.get_child(child_index)

		if child_node is MeshInstance3D:
			#print("MeshInstance3D Name: ", child_node.name)
			#print("get_surface_override_material_count: ", child_node.get_surface_override_material_count())
			#print("get_surface_override_material: ", child_node.get_surface_override_material(0))
			#child_node.set_surface_override_material(0, Object.new())
			meshes.append(child_node)
			
	for x in range(5):
		for mesh in meshes:
			flash(mesh)
		await get_tree().create_timer(0.15).timeout
		for mesh in meshes:
			unflash(mesh)
		await get_tree().create_timer(0.15).timeout
	
	is_flashing = false
