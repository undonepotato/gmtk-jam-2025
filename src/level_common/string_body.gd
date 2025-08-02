extends RigidBody2D

@export var distance_between_nodes: float

func _process(delta: float) -> void:
	$Icon.position = center_of_mass
	$DampedSpringJoint2D.rest_length = distance_between_nodes
	$DampedSpringJoint2D.length = distance_between_nodes * 1.2
	$DampedSpringJoint2D2.rest_length = distance_between_nodes
	$DampedSpringJoint2D2.length = distance_between_nodes * 1.2

func _physics_process(delta: float) -> void:
	$CollisionShape2D.position = center_of_mass
	
	$DampedSpringJoint2D.global_position = $RigidBody2D.global_position
	$DampedSpringJoint2D.look_at($RigidBody2D2.global_position)
	$DampedSpringJoint2D.rotation_degrees = $DampedSpringJoint2D.rotation_degrees - 90
	
	$DampedSpringJoint2D2.global_position = $RigidBody2D2.global_position
	$DampedSpringJoint2D2.look_at($RigidBody2D3.global_position)
	$DampedSpringJoint2D2.rotation_degrees = $DampedSpringJoint2D2.rotation_degrees - 90
	
	$BetweenNodes1.global_position = global_position
	$BetweenNodes2.global_position = global_position
	
	$BetweenNodes1/CollisionShape2D.shape.a = $RigidBody2D.position
	$BetweenNodes1/CollisionShape2D.shape.b = $RigidBody2D2.position
	print($RigidBody2D.position)
	print($BetweenNodes1/CollisionShape2D.shape.a)
	
	$BetweenNodes2/CollisionShape2D.shape.a = $RigidBody2D2.position
	$BetweenNodes2/CollisionShape2D.shape.b = $RigidBody2D3.position
