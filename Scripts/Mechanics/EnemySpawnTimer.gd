extends Timer

@export var enemy_to_spawn : PackedScene

@onready var root = get_parent()
@onready var player = root.find_child("Player")
@onready var checker = load("res://Scenes/Mechanics/enemy_spawn_check.tscn")

func _ready():
	timeout.connect(_on_enemy_spawn_timer_timeout)

func player_pos_rand(coord):
	return randf_range(coord + 1.0, coord + 4.0)
	
func _on_enemy_spawn_timer_timeout():
	var enemy_count = get_tree().get_nodes_in_group("enemies").size()
	if enemy_count < 20:
		var random_x = player_pos_rand(player.global_position.x)
		if randi()%2 == 0:
			random_x = -random_x
		var random_z = player_pos_rand(player.global_position.z)
		if randi()%2 == 0:
			random_z = -random_z
		
		var checker_inst = checker.instantiate()
		root.add_child(checker_inst)
		checker_inst.global_position = Vector3(random_x, 0, random_z)
		var _text = "checker, position: %v ; global: %v" % [checker_inst.position, checker_inst.global_position]
		#print(text)
		checker_inst.set_enemy_type(enemy_to_spawn)
		checker_inst.set_root(root)
		checker_inst.start_checking()
	else:
		print("Max amount of enemy on area")
