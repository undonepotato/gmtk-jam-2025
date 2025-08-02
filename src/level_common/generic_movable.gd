extends Node2D

class_name GenericMovable

var initial_parent: Node
var reset_next := false
var reset_next_pos: Vector2

func _ready() -> void:
	initial_parent = get_parent()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	_reset_pos(state)

func _reset_pos(state: PhysicsDirectBodyState2D) -> void:
	if reset_next and is_inside_tree() and initial_parent is Marker2D:
		state.transform.x = Vector2(1, 0)
		state.transform.y = Vector2(0, 1)
		state.transform.origin = reset_next_pos
		state.linear_velocity = Vector2(0, 0)

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
		
		print(reset_next, reset_next_pos)
		reset_next = false
