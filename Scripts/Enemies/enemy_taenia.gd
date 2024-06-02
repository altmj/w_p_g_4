extends CharacterBody3D

#@export var spawn_sequence_on_ready : bool = false
@export var spawning_sequence := false
@export var hitpoint := 5.0
@export var damage_to_player := 10.0
@export var exp_on_defeat := 35

var rotation_speed : float = 0.045
var despawning := false
var nav_speed := 0.4
var nav_accel := 10.0
var nav_rotspeed : float = 5.0

@onready var hitflash = $HitflashController
@onready var navagent = $NavigationAgent3D
@onready var animplyr = $AnimationPlayer
@onready var collision = $CollisionShape3D
@onready var playerdetector = $PlayerDamageDetector

signal bullet_hit
signal enemy_despawn

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_hit.connect(_on_bullet_hit)
	animplyr.play("ArmatureAction")
	collision.disabled = true
	#if GlobalVar.player_globalpos:
		#navagent.set_target_position(GlobalVar.player_globalpos)
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
				collision.disabled = false
	if despawning:
		var scale_all : float = scale.x
		if scale_all > 0.25:
			scale_all = scale_all - (0.05 * delta * 60)
			scale = Vector3(scale_all, scale_all, scale_all)
		else:
			enemy_despawn.emit()
			GlobalVar.cached_kill += 1
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
			GlobalVar.cached_kill += 1
			print("exp send")
		else:
			hitflash.hitflash()
		

func check_flashing():
	return hitflash.is_flashing

func _physics_process(delta):
	#var current_location = global_transform.origin
	#var next_location = navagent.get_next_path_position()
	#var new_velocity = (next_location - current_location).normalized() * nav_speed
	#
	#velocity = new_velocity * 0.25
	#move_and_slide()
	
	var direction = Vector3()
	
	navagent.target_position = GlobalVar.player_globalpos
	
	direction = navagent.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * nav_speed, nav_accel * delta)
	
	move_and_slide()
	
	look_at(GlobalVar.player_globalpos, Vector3(0, 1, 0), true)

	## Step 1: Calculate the direction to the target
	#var target_position = GlobalVar.player_globaltrans.origin
	#var direction_to_target = (target_position - global_transform.origin).normalized()
	#
	## Avoid issues when characters overlap (direction is zero)
	#if direction_to_target.length() == 0:
		#return
	#
	## Step 2: Calculate the target basis using looking_at
	#var target_basis = Basis().looking_at(target_position, Vector3.UP)
#
	#var rotation_180 = Basis(Vector3.UP, PI)  # 180 degrees around the Y-axis
	#target_basis = target_basis * rotation_180
	#target_basis = target_basis.orthonormalized()
	#
	## Step 3: Interpolate between the current basis and the target basis
	#var current_basis = global_transform.basis.orthonormalized()
	#var new_basis = current_basis.slerp(target_basis, nav_rotspeed * delta)
	#
	## Step 4: Apply the new basis to the character
	#global_transform.basis = new_basis

func _on_player_damage_detector_body_entered(body):
	if body.name == "Player":
		#Player_MC.taking_damage.emit()
		GlobalVar.cached_damage += damage_to_player
