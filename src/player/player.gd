extends CharacterBody2D

signal object_detached(global_pos: Vector2)

@export var speed = 300.0
@export var jump_velocity = -500.0
@export var push_force = 30.0

var generic_movable = preload("res://src/level_common/generic_movable.tscn")

var gravity := get_gravity()

var knotted = false

var reset_next_pos: Vector2

func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("knot"):
		knotted = true if not knotted else false
		print(knotted)
	
	if not knotted:
		for child in get_children():
			if child is CollisionShape2D and str(child.name)[0] == "@":
				_detach_object(child)
	
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
		var collider = collision.get_collider()
		
		# TODO this piece of code is causing the rigidbody to rotate
		# due to collision with the ground as soon as player tries to knot it
		# from comments on https://docs.godotengine.org/en/stable/classes/class_rigidbody2d.html:
		# try this later
		#func teleport(rb : RigidBody2D, target : Transform2D) -> void:
		#rb.linear_velocity = Vector2.ZERO
		#rb.angular_velocity = 0.0
		#rb.global_transform = target
		#PhysicsServer2D.body_set_state(rb.get_rid(), PhysicsServer2D.BODY_STATE_TRANSFORM, target)
		#rb.reset_physics_interpolation()
		if collider is RigidBody2D and not collider in get_tree().get_nodes_in_group("knotted"):
			collider.apply_central_impulse.call_deferred(-collision.get_normal() * push_force)
			# probably should be using RigidBody2D.apply_central_force() instead?
			# TODO later

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
	
	var new_collision = CollisionShape2D.new()
	var new_collision_sprite = Sprite2D.new()
	var collision_sprite_texture = CompressedTexture2D.new()
	collision_sprite_texture.load("res://assets/level_common/icon.svg")
	new_collision_sprite.texture = collision_sprite_texture
	
	new_collision.position = reset_next_pos
	new_collision.shape = RectangleShape2D.new()
	new_collision.shape.size = body_size

	add_child(new_collision)
	add_child(new_collision_sprite)
	body.free() # dangerous but who cares???
	
	#if body.has_method("_set_new_parent_pos"):
		#body.reset_next = true
		#body.reset_next_pos = to_global(reset_next_pos)
		#body.new_parent = self
		# WARNING this does not move correctly if it is not
		# a direct child of the player
		# there is definitely a reason why but you can figure that out later
		# if you need to

func _detach_object(body: CollisionShape2D) -> void:
	var associated_sprite: Sprite2D
	for child in get_children():
		if child is Sprite2D and child.position == body.position:
			associated_sprite = child
			break
	
	object_detached.emit(body.global_position)
	if associated_sprite:
		associated_sprite.queue_free()
	body.free()
	

func _on_knot_area_left_body_entered(body: Node2D) -> void:
	if knotted:
		_attach_object(body, Vector2.LEFT)


func _on_knot_area_right_body_entered(body: Node2D) -> void:
	if knotted:
		_attach_object(body, Vector2.RIGHT)
