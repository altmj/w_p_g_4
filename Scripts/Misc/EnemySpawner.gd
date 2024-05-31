extends Node3D

@export var timer_in_second : float = 1.0

@onready var timer = $SpawnerTimer
@onready var mesh = get_parent().get_mesh()
@onready var dummy = load("res://Scenes/Enemies/enemy_dummy.tscn")
signal spawn

func _ready():
	timer.set_wait_time(timer_in_second)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_spawner_timer_timeout():
	var area = mesh.get_size()
	var spawnlocation : Vector3 = Vector3(	randf_range(-(area.x / 2.0), area.x / 2.0),
											0,
											randf_range(-(area.y / 2.0), area.y / 2.0))
	var enemy_inst = dummy.instantiate()

	enemy_inst.position = spawnlocation
	get_parent().get_parent().add_child(enemy_inst)
	
	
	
