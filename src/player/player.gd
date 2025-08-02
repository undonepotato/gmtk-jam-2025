extends CharacterBody2D


@export var speed = 300.0
@export var jump_velocity = -500.0
@export var push_force = 40.0

@onready var knotted_objects = $KnottedObjects

var generic_movable = preload("res://src/level_common/generic_movable.tscn")

const Directions = {
	UP = Vector2(0, -1), 
	DOWN = Vector2(0, 1), 
	LEFT = Vector2(-1, 0), 
	RIGHT = Vector2(1, 0)
}

var gravity := get_gravity()

var knotted = false

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
	
	#for i in get_slide_collision_count():
		#var collision = get_slide_collision(i)
		#var collider := collision.get_collider()
		#print("Collided with ", collider)
		
		#if knotted_objects.get_children() and not knotted:
			#for child in knotted_objects.get_children():
				#child.reparent(child.initial_parent)
				#child.set_physics_process(true)
		#
		#if collider is RigidBody2D:
			#if not collider in knotted_objects.get_children():
				#if knotted:
					#collider.reparent(knotted_objects)
					#collider.set_physics_process(false)
				#else:
					#collider.apply_central_impulse(-collision.get_normal() * push_force)

func _attach_object(body: RigidBody2D, direction: Vector2) -> void:
	# Deletes and recreates because RigidBodies are weird
	# May be a future limitation
	
	# Add logic here for matching to more specific movables and using directions
	# other than left
	var new_child_movable = generic_movable.instantiate()

	var body_size: Vector2 = body.get_node("CollisionShape2D").shape.size
	var player_size: Vector2 = $CollisionShape2D.shape.size
	
	# snap to bottom edge
	var new_position = Vector2(
		0
		- (player_size.x / 2)
		- (body_size.x / 2)
		- 2,
		0
		+ (
			(player_size.y / 2) 
			- (body_size.y / 2)
		  )
		)
	
	new_child_movable.reset_next = true
	new_child_movable.reset_next_pos = new_position
	
	new_child_movable.set_collision_layer_value(1, false)
	new_child_movable.set_collision_layer_value(2, false)
	new_child_movable.set_collision_layer_value(3, false)
	new_child_movable.set_collision_layer_value(4, true)
	
	new_child_movable.set_collision_mask_value(1, true)
	new_child_movable.set_collision_mask_value(2, true)
	new_child_movable.set_collision_mask_value(3, true)
	new_child_movable.set_collision_mask_value(4, true)
	
	body.queue_free()
	
	knotted_objects.add_child.call_deferred(new_child_movable)

func _on_knot_area_top_body_entered(body: Node2D) -> void:
	pass


func _on_knot_area_left_body_entered(body: Node2D) -> void:
	if body not in knotted_objects.get_children():
		_attach_object.call_deferred(body, Directions.LEFT)


func _on_knot_area_bottom_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_knot_area_right_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
