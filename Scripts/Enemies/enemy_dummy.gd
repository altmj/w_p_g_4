extends CharacterBody3D

#@export var spawn_sequence_on_ready : bool = false
@export var spawning_sequence := false
@export var exp_on_defeat := 35

var rotation_speed : float = 0.045
var hitpoint := 5.0
var despawning := false

@onready var hitflash = $HitflashController

signal bullet_hit
signal enemy_despawn

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_hit.connect(_on_bullet_hit)
	#if spawn_sequence_on_ready:
		#spawn_sequence()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawning_sequence:
		if position.y < 0:
			position.y = position.y + 0.02 * delta * 60
		else:
			if rotation_degrees.x < 0:
				rotation_degrees.x = rotation_degrees.x + 4.0 * delta * 60
			else:
				spawning_sequence = false
	if despawning:
		var scale_all : float = scale.x
		if scale_all > 0.25:
			scale_all = scale_all - (0.05 * delta * 60)
			scale = Vector3(scale_all, scale_all, scale_all)
		else:
			enemy_despawn.emit()
			queue_free()
	
func spawn_sequence(is_setup_position : bool = false):
	if is_setup_position:
		position.y = -0.5
		rotation_degrees.x = -90
	spawning_sequence = true

func _on_bullet_hit(damage):
	if not check_flashing() and not despawning:
		hitpoint -= damage
		if hitpoint <= 0:
			set_collision_layer_value(3, false)
			despawning = true
			ScoreCounter.add_exp(exp_on_defeat)
			print("exp send")
		else:
			hitflash.hitflash()
		

func check_flashing():
	return hitflash.is_flashing
