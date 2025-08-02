extends RigidBody2D

class_name GenericMovable

@onready var initial_parent = get_parent()

var new_parent: Node

var reset_next := false
var reset_next_pos: Vector2
var reset_to: Node

var waiting_reset_frame := false

#func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#var parent = get_parent()
	#if waiting_reset_frame:
		#if parent == new_parent:
			#set_deferred("freeze", true)
			#set_collision_layer_value(4, true)
			#set_collision_layer_value(3, false)
			#set_collision_mask_value(2, false)
			#state = _set_new_parent_pos(state)
			#waiting_reset_frame = false
		#elif parent == initial_parent:
			#set_deferred("freeze", false)
			#set_collision_layer_value(4, false)
			#set_collision_layer_value(3, true)
			#set_collision_mask_value(2, true)
			#waiting_reset_frame = false
	#if reset_next:
		#if parent == initial_parent:
			#reparent.call_deferred(new_parent)
			#add_to_group("knotted")
			#waiting_reset_frame = true
			## wait one frame for the reparent to take effect
			## then freeze, change collision layers, set position
			#reset_next = false
		#elif parent == new_parent:
			#reparent.call_deferred(initial_parent)
			#remove_from_group("knotted")
			#waiting_reset_frame = true
			#reset_next = false
#
#
#func _set_new_parent_pos(state: PhysicsDirectBodyState2D) -> PhysicsDirectBodyState2D:
	#var result = state
	#
	#result.transform.origin = reset_next_pos
	#result.linear_velocity = Vector2(0, 0)
#
	##var pin_joint_1 = PinJoint2D.new()
	##var pin_joint_2 = PinJoint2D.new()
	##
	##add_sibling(pin_joint_1)
	##add_sibling(pin_joint_2)
	##
	##pin_joint_1.set_node_a(get_path())
	##pin_joint_2.set_node_b(get_path_to(%Player))
	#
	#return result
