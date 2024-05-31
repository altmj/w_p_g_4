extends RigidBody3D

var base_speed : float = 4.0
var despawning : bool = false
var bullet_damage := 0.0

signal bullet_despawn

@onready var timer = $DespawnTimer

func set_damage(damage):
	bullet_damage = damage

func rad(degree):
	return deg_to_rad(degree)

func launch(degree, player_speed):
	#degree = abs(fmod(roundf(degree), 360.0))
	var bullet_speed = base_speed + player_speed
	var velocity = Vector3(bullet_speed * sin(rad(degree)), 0, bullet_speed * cos(rad(degree)))
	#var text = "Shot at %f degree, %f speed, on %v"
	#text = text % [degree, bullet_speed, velocity]
	#print(text)
	set_linear_velocity(velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_collision_mask())
	if despawning:
		var scale_all : float = scale.x
		if scale_all > 0.25:
			scale_all = scale_all - (0.05 * delta * 60)
			scale = Vector3(scale_all, scale_all, scale_all)
		else:
			bullet_despawn.emit()
			queue_free()
	else:
		for node in get_colliding_bodies():
			if node is CharacterBody3D:
				if node.get_collision_layer() == 3:
					node.bullet_hit.emit()
				
func _on_despawn_timer_timeout():
	if not despawning:
		despawning = true

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		if not body.check_flashing():
			despawning = true
		body.bullet_hit.emit(bullet_damage)

		#else:
			#set_collision_mask(1)
			#pass
