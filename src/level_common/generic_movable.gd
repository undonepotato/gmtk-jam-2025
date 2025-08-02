extends RigidBody2D

class_name GenericMovable

var initial_parent: Node
var new_parent: Node
var reset_next := false
var reset_next_pos: Vector2

var waiting_reset_frame := false

func _ready() -> void:
	initial_parent = get_parent()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if waiting_reset_frame:
		set_deferred("freeze", true)
		set_collision_layer_value(4, true)
		set_collision_layer_value(3, false)
		set_collision_mask_value(2, false)
		state = _reset_pos(state)
		waiting_reset_frame = false
	if reset_next:
		reparent.call_deferred(new_parent)
		waiting_reset_frame = true
		# wait one frame for the reparent to take effect
		# then freeze, change collision layers, set position
		reset_next = false

func _reset_pos(state: PhysicsDirectBodyState2D) -> PhysicsDirectBodyState2D:
	var result = state
	
	result.transform.origin = reset_next_pos
	result.linear_velocity = Vector2(0, 0)

	var pin_joint_1_pos = Vector2(
		reset_next_pos.x
		+ $CollisionShape2D.shape.size.x, 
		reset_next_pos.y
		- $CollisionShape2D.shape.size.y / 4
	)

	var pin_joint_2_pos = Vector2(
		pin_joint_1_pos.x,
		reset_next_pos.y
		+ $CollisionShape2D.shape.size.y / 4
	)

	var pin_joint_1 = PinJoint2D.new()
	var pin_joint_2 = PinJoint2D.new()
	
	add_sibling(pin_joint_1)
	add_sibling(pin_joint_2)
	
	pin_joint_1.set_node_a(get_path())
	pin_joint_2.set_node_b(get_path_to(%Player))
	
	pin_joint_1.position = pin_joint_1_pos
	pin_joint_2.position = pin_joint_2_pos
	
	return result
