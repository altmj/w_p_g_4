extends CharacterBody3D

#@export var spawn_sequence_on_ready : bool = false
@export var spawning_sequence : bool = false
var rotation_speed : float= 0.045

@onready var hitflash = $HitflashController

signal bullet_hit

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
	
func spawn_sequence(is_setup_position : bool = false):
	if is_setup_position:
		position.y = -0.5
		rotation_degrees.x = -90
	spawning_sequence = true

func _on_bullet_hit():
	hitflash.hitflash()
