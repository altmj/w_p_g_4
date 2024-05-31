extends Area3D

var is_checking : bool = false
var enemy_type
var root

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if is_checking:
		if not has_overlapping_bodies():
			var enemy_inst = enemy_type.instantiate()
			root.add_child(enemy_inst)
			enemy_inst.global_position = global_position
			enemy_inst.spawn_sequence(true)
			#var text = "position: %v ; global: %v" % [enemy_inst.position, enemy_inst.global_position]
			#print(text)
			queue_free()

func _on_death_timer_timeout():
	queue_free()

func set_enemy_type(instance):
	enemy_type = instance

func set_root(root_path):
	root = root_path

func start_checking():
	is_checking = true
