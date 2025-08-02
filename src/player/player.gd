extends CharacterBody2D


@export var speed = 300.0
@export var jump_velocity = -500.0
@export var push_force = 40.0

var generic_movable = preload("res://src/level_common/generic_movable.tscn")

var gravity := get_gravity()

var knotted = false

var reset_next_pos: Vector2

func _process(delta: float) -> void:
	if Input.is_action_just_released("knot"):
		knotted = true if not knotted else false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_velocity

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if velocity != Vector2.ZERO:
		$PlayerStringTrail.add_player_trail_point(global_position)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider := collision.get_collider()
		
		if collider is RigidBody2D and not collider in get_children():
			collider.apply_central_impulse(-collision.get_normal() * push_force)

func _attach_object(body: RigidBody2D, direction: Vector2) -> void:
	
	# TODO Add logic here for matching to more specific movables

	var body_size: Vector2 = body.get_node("CollisionShape2D").shape.size
	var player_size: Vector2 = $CollisionShape2D.shape.size

	match direction:
		Vector2.LEFT:
			reset_next_pos = Vector2(
				0
				- (player_size.x / 2)
				- (body_size.x / 2)
				- 2,
				0
				- (body_size.y / 2)
				+ (player_size.y / 2)
			)
		Vector2.RIGHT:
			reset_next_pos = Vector2(
				0
				+ (player_size.x / 2)
				+ (body_size.x / 2)
				+ 2,
				0
				- (body_size.y / 2)
				+ (player_size.y / 2)
			)

	if body.has_method("_reset_pos"):
		body.reset_next = true
		body.reset_next_pos = to_global(reset_next_pos)
		body.new_parent = self
		# WARNING this does not move correctly if it is not
		# a direct child of the player
		# there is definitely a reason why but you can figure that out later
		# if you need to

func _on_knot_area_left_body_entered(body: Node2D) -> void:
	if knotted:
		_attach_object(body, Vector2.LEFT)


func _on_knot_area_right_body_entered(body: Node2D) -> void:
	if knotted:
		_attach_object(body, Vector2.RIGHT)
