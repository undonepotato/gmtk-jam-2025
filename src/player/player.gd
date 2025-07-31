extends CharacterBody2D


@export var speed = 500.0
@export var jump_velocity = -600.0


func _physics_process(delta: float) -> void:
	var gravity := get_gravity()
	var post_jump_gravity := gravity + Vector2(0, gravity.y * 2)
	if not is_on_floor():
		velocity += get_gravity() * delta


	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_velocity

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	var collision := get_last_slide_collision() # loop through all collisions later
	if collision:
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			collider.apply_central_impulse(-collision.get_normal() * speed / 10)
			print("called")
