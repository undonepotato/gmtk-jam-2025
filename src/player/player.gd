extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -600.0


func _physics_process(delta: float) -> void:
	var gravity = get_gravity()
	var post_jump_gravity = gravity + Vector2(0, gravity.y * 2)
	if not is_on_floor():
		velocity += get_gravity() * delta


	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
