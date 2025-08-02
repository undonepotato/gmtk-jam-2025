extends Node2D

@export var string_node_radius: float
@export var string_node_gap: float

@onready var string_nodes = $StringNodes

var new_string_node: RigidBody2D
var new_string_collision: CollisionShape2D
var new_string_pin_joint: PinJoint2D
var previous_string_node: RigidBody2D

var next_x_pos = 0.0

func _ready() -> void:
	for i in range(15):
		create_string_node()

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func create_string_node() -> void:
	new_string_node = RigidBody2D.new()
	new_string_node.position = Vector2(next_x_pos, 0.0)
	
	new_string_node.set_collision_layer_value(1, false)
	new_string_node.set_collision_layer_value(5, true)
	
	new_string_node.set_collision_mask_value(1, true)
	new_string_node.set_collision_mask_value(2, true)
	new_string_node.set_collision_mask_value(5, true)
	# TODO make it interact with movables as well
	
	new_string_collision = CollisionShape2D.new()
	new_string_collision.shape = CircleShape2D.new()
	new_string_collision.shape.radius = string_node_radius
	
	new_string_node.add_child(new_string_collision)
	string_nodes.add_child(new_string_node)
	
	new_string_pin_joint = PinJoint2D.new()
	new_string_pin_joint.node_a = new_string_node.get_path()
	if previous_string_node:
		new_string_pin_joint.node_b = previous_string_node.get_path()
	
	new_string_node.add_child(new_string_pin_joint)

	next_x_pos += (string_node_radius * 2) + string_node_gap
	previous_string_node = new_string_node
