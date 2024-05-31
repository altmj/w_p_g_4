extends CharacterBody3D
class_name Player_MC

const LERP_VALUE : float = 0.15

var snap_vector : Vector3 = Vector3.DOWN
var speed : float
var joyright_rotation : float
var touch_running : bool = false
var is_peeking : bool = false
var bullet = load("res://Scenes/Weapons/player_bullet.tscn")

@export_group("Movement variables")
@export var walk_speed : float = 2.0
@export var run_speed : float = 3.5
@export var jump_strength : float = 15.0
@export var gravity : float = 50.0
@export var rotation_sensitivity : float = 0.05

@export_group("Offensive variables")
@export var base_projectile_damage := 1.0

@export_group("Camera")
@export var spring_arm_default_angle : float = -60 # in degree
@export var peeking_angle : float = 11 # in degree

@export_group("Virtual Joysticks")
@export var joystick_left : VirtualJoystick
@export var joystick_right : VirtualJoystick

const ANIMATION_BLEND : float = 7.0

@onready var player_mesh : Node3D = $PlayerModelBlender
@onready var spring_arm_pivot : Node3D = $SpringArmPivot
@onready var spring_arm : SpringArm3D = $SpringArmPivot/SpringArm3D
@onready var animator : AnimationTree = $AnimationTree
@onready var animplayer : AnimationPlayer = $AnimationPlayer
@onready var spawner_pivot : Node3D = $BulletSpawnerPivot
@onready var spawner : Node3D = $BulletSpawnerPivot/BulletSpawner
@onready var radar : Area3D = $EnemyDetection
@onready var levelhandler = $Level
@onready var healthbar = $UI/HealthBar
@onready var hitflash = $HitflashController

signal taking_damage

func rad(degree):
	return deg_to_rad(degree)
	
func deg(radian):
	return rad_to_deg(radian)

#func weird_interpolate(y, a, b): # value, min, max, 
	## Ensure y is within the range [a, b]
	#y = max(a, min(b, y))
#
	## Calculate the distance of y from the midpoint of [a, b]
	#var distance_from_midpoint = abs(y - (a + b) / 2)
#
	## Calculate the maximum possible distance from the midpoint
	#var max_distance = abs(b - (a + b) / 2)
#
	## Calculate the ratio of the distance to the maximum distance
	#var x = 1 - (distance_from_midpoint / max_distance)
#
	#return max(0, min(1, x))  # Ensure x is between 0 and 1
func spring_arm_distance():
	return player_mesh.position.z - spring_arm_pivot.position.z

func _ready():
	OS.low_processor_usage_mode = OS.get_name() != "Android"
	spring_arm.rotate_x(rad(spring_arm_default_angle))
	print(deg(spring_arm.rotation.x))
	taking_damage.connect(take_damage)
	
#func threesixty(rotation):
	#var degree = roundf(deg(rotation))
	#if degree == 0 or degree == 360:
		#return 0
	#if degree > 360:
		#degree - 360
		#threesixty(rad(rotation))
	#if degree < 360:
		#degree + 360
		#threesixty(rad(rotation))

func find_nearest_body(bodies: Array) -> Node:
	var nearest_body: Node = null
	var nearest_distance: float = 1e6

	for body in bodies:
		var distance = global_transform.origin.distance_to(body.global_transform.origin)
		if distance < nearest_distance:
			nearest_body = body
			nearest_distance = distance

	return nearest_body

func rotate_towards_target(target: Node) -> void:
	var direction = (target.global_transform.origin - global_transform.origin).normalized()
	
	# Calculate the angle between the forward vector and the target direction
	var angle = atan2(direction.x, direction.z)
	
	# Apply the rotation
	player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, angle, LERP_VALUE)
	spawner_pivot.rotation.y = player_mesh.rotation.y
	
func scan_and_rotate():
	var overlapping_bodies = radar.get_overlapping_bodies()

	if overlapping_bodies.size() > 0:
		var nearest_body = find_nearest_body(overlapping_bodies)
		rotate_towards_target(nearest_body)

func _physics_process(delta):
	GlobalVar.player_globalpos = self.global_position
	GlobalVar.player_globaltrans = self.global_transform
	var move_direction : Vector3 = Vector3.ZERO
	move_direction.x = Input.get_axis("ui_left", "ui_right") # Input.get_action_strength("move_right") - Input.get_action_strength("move_left") # 
	move_direction.z = Input.get_axis("ui_up", "ui_down") # Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forwards")
	move_direction = move_direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	
	velocity.y -= gravity * delta
	
	#if joystick_right and joystick_right.is_pressed:
#
		#var rotation_speed = joystick_right.output.x * rotation_sensitivity
		#spring_arm_pivot.rotate_y(-rotation_speed)
#
		#var vertical_rotation_speed = joystick_right.output.y * rotation_sensitivity
		#spring_arm.rotate_x(-vertical_rotation_speed)
	#
		#spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
		
	var spring_x_rot = spring_arm.rotation.x
	if is_peeking:
		if deg(spring_x_rot) < peeking_angle: # -25 smaller than 11
			#var w_intr = weird_interpolate(deg(spring_x_rot), spring_arm_default_angle, peeking_angle)
			spring_arm.rotate_x(rotation_sensitivity) #  + (0.01 * w_intr)
			spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
		if spring_arm_distance() < -0.1:
			spring_arm_pivot.position.z = spring_arm_pivot.position.z - 0.05
	else:
		if deg(spring_x_rot) > spring_arm_default_angle:
			spring_arm.rotate_x(-rotation_sensitivity) #  + (0.01 * w_intr)
			spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
		if spring_arm_distance() > -0.78: # default
			spring_arm_pivot.position.z = spring_arm_pivot.position.z + 0.05
		
	#print(deg(spring_x_rot))
	
	if Input.is_action_pressed("run") or (touch_running == true):
		speed = run_speed
	else:
		speed = walk_speed
		
	if Input.is_action_pressed("ui_cancel"):  # Change "ui_cancel" to your defined "esc" action if different
		get_tree().quit()
	
	velocity.x = move_direction.x * speed
	velocity.z = move_direction.z * speed

	if radar.has_overlapping_bodies():
		scan_and_rotate()
	else:
		if move_direction:
			player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(velocity.x, velocity.z), LERP_VALUE)
			spawner_pivot.rotation.y = player_mesh.rotation.y
		#$UI/DebugLabel.text = "Rotation: " + str(roundi(deg(spawner_pivot.rotation.y)))
	
	#var just_landed := is_on_floor() and snap_vector == Vector3.ZERO
	#var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")
	#if is_jumping:
		#velocity.y = jump_strength
		#snap_vector = Vector3.ZERO
	#elif just_landed:
		#snap_vector = Vector3.DOWN
	
	apply_floor_snap()
	move_and_slide()
	animate(delta)

func animate(_delta):
	if velocity.length() > 0:
		animator.set("parameters/idle_walk_transition/transition_request", "walk")
		#if speed == run_speed:
			#animplayer.set_speed_scale(3.0)
		#else:
			#animplayer.set_speed_scale(1.0)
	else:
		animator.set("parameters/idle_walk_transition/transition_request", "idle")
		
	#if is_on_floor():
		#animator.set("parameters/ground_air_transition/transition_request", "grounded")
		
		#if velocity.length() > 0:
			#if speed == run_speed:
				#animator.set("parameters/iwr_blend/blend_amount", lerp(animator.get("parameters/iwr_blend/blend_amount"), 1.0, delta * ANIMATION_BLEND))
			#else:
				#animator.set("parameters/iwr_blend/blend_amount", lerp(animator.get("parameters/iwr_blend/blend_amount"), 0.0, delta * ANIMATION_BLEND))
		#else:
			#animator.set("parameters/iwr_blend/blend_amount", lerp(animator.get("parameters/iwr_blend/blend_amount"), -1.0, delta * ANIMATION_BLEND))
	#else:
		#animator.set("parameters/ground_air_transition/transition_request", "air")

func _on_button_sprint_btn_pressed():
	touch_running = true

func _on_button_sprint_btn_released():
	touch_running = false

func _on_button_peek_btn_pressed():
	is_peeking = true
	
func _on_button_peek_btn_released():
	is_peeking = false

func _on_shooting_timer_timeout():
	if radar.has_overlapping_bodies():
		var player_moving_speed : float = 0.0
		if velocity.length() > 0:
			player_moving_speed = speed
		var bullet_inst = bullet.instantiate()
		bullet_inst.launch(deg(spawner_pivot.rotation.y), player_moving_speed)
		bullet_inst.position = spawner.global_position
		bullet_inst.set_damage(base_projectile_damage)
		#bullet_inst.bullet_despawn.connect(_on_bullet_despawn)
		#bullet_inst.rotation = spawner_pivot.rotation
		get_parent().add_child(bullet_inst)

#func _on_bullet_despawn():
	#get_parent().remove_child(bullet_inst)

func _on_check_exp_timer_timeout():
	var exp_waiting : int = ScoreCounter.check_queue_exp()
	if exp_waiting > 0:
		print("morethan 0")
		levelhandler.add_experience(exp_waiting)

#func _on_button_take_damage_btn_pressed():
	#healthbar.take_damage(10)

func check_flashing():
	return hitflash.is_flashing

func take_damage(damage : float):
	if not check_flashing():
		healthbar.take_damage(damage)
		hitflash.hitflash()

func _on_check_damage_timer_timeout():
	if GlobalVar.cached_damage > 0.0:
		take_damage(GlobalVar.cached_damage)
		GlobalVar.cached_damage = 0.0
