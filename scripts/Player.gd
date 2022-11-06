extends KinematicBody

signal hit

export var speed = 14
export var jump_impulse = 20
export var bounce_impulse = 16
export var fall_acceleration = 75

var velocity = Vector3.ZERO

func _physics_process(delta):
	_movement(delta)

func _movement(delta):
	var direction = Vector3.ZERO
	
	direction.x = Input.get_axis("move_left", "move_right")
	direction.z = -Input.get_axis("move_back", "move_forward")
	
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse
	
	if direction != Vector3.ZERO:
		$Pivot.look_at(translation + direction, Vector3.UP)
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse
	
	velocity.x = direction.x * speed 
	velocity.z = direction.z * speed 
	velocity.y -= fall_acceleration * delta
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	for index in range(get_slide_count()):
		var collision = get_slide_collision((index))
		
		if collision.collider.is_in_group("mob"):
			var mob = collision.collider 
			
			if Vector3.UP.dot(collision.normal) > 0.1:
				mob.squash()
				velocity.y = bounce_impulse

func die():
	emit_signal("hit")
	queue_free()

func _on_MobDetector_body_entered(_body):
	die()
