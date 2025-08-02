extends Node2D

var first_string_node: RigidBody2D
var generic_movable = preload("res://src/level_common/generic_movable.tscn")

func _on_string_body_2d_first_node_created(node: RigidBody2D) -> void:
	first_string_node = node
	#$PinJoint2D.node_b = node.get_path()
	#$PinJoint2D2.node_b = node.get_path()
	#$PinJoint2D.softness = 2.0
	#$PinJoint2D2.softness = 2.0

func _physics_process(delta: float) -> void:
	pass
	#first_string_node.apply_central_impulse(%Player.get_real_velocity())
	#$PinJoint2D.global_position = $Player.global_position
	#$PinJoint2D2.global_position = $Player.global_position


func _on_player_object_detached(global_pos: Vector2) -> void:
	var inst = generic_movable.instantiate()
	inst.global_position = global_pos
	add_child(inst)
