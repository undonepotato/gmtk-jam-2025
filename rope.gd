extends CanvasItem

var RopePiece = preload("res://src/level_common/rope_piece.tscn")
var piece_length := 12.0
var rope_parts := []
var rope_close_tolerance := 12.0
var rope_points: PackedVector2Array = []
var rope_colors: PackedColorArray = []

var color1 := Color.CORAL
var color2 := Color.BLACK


@onready var rope_start_piece
@onready var rope_end_piece = $RopeEndPiece
@onready var rope_start_joint = $RopeStartPiece/C/J
@onready var rope_end_joint = $RopeEndPiece/C/J

func _process(_delta: float) -> void:
	get_rope_points()
	if not rope_points.is_empty():
		queue_redraw()

func spawn_rope(start_pos: Vector2, end_pos: Vector2):
	rope_start_piece.global_position = start_pos
	rope_end_piece.global_position = end_pos
	start_pos = rope_start_piece.get_node("C/J").global_position
	end_pos = rope_end_piece.get_node("C/J").global_position
	var distance = start_pos.distance_to(end_pos)
	var pieces_amount = round(distance / piece_length)
	var spawn_angle = (end_pos - start_pos).angle() - PI/2
	
	create_rope(pieces_amount, rope_start_piece, end_pos, spawn_angle)
	

func create_rope(pieces_amount: int, parent: Object, end_pos: Vector2, spawn_angle: float) -> void:
	rope_colors.append(color1)
	var last_color
	for i in pieces_amount:
		last_color = color2 if i % 2 == 0 else color1
		rope_colors.append(last_color)
		parent = add_piece(parent, i, spawn_angle)
		parent.set_name("rope_piece" + str(i))
		rope_parts.append(parent)
		
		var joint_pos = parent.get_node("C/J").global_position
		if joint_pos.distance_to(end_pos) < rope_close_tolerance:
			break

	last_color = color1 if last_color == color2 else color2
	rope_colors.append(last_color)

	#rope_end_piece.get_node("C/J").node_a = rope_end_piece.get_path()
	#rope_end_piece.get_node("C/J").node_b = rope_parts[-1].get_path()

func add_piece(parent: Object, id: int, spawn_angle: float) -> Object:
	var joint: PinJoint2D = parent.get_node("C/J") as PinJoint2D
	# this pinjoint2d attaches every piece to its parent
	# the first is RopeStartPiece
	var piece: Object = RopePiece.instantiate() as Object
	piece.global_position = joint.global_position
	piece.rotation = spawn_angle
	piece.parent = self
	piece.id = id
	add_child(piece)
	joint.node_a = parent.get_path()
	joint.node_b = piece.get_path()
	
	return piece

func get_rope_points() -> void:
	rope_points = []
	rope_points.append(rope_start_piece.get_node("C/J").global_position)
	for r in rope_parts:
		rope_points.append(r.global_position)
		#rope_points.append(rope_end_joint.global_position)

func teleport_rigidbody(rb: RigidBody2D, target: Transform2D) -> void:
	#rb.linear_velocity = Vector2.ZERO
	#rb.angular_velocity = 0.0
	rb.global_transform = target
	PhysicsServer2D.body_set_state(rb.get_rid(), PhysicsServer2D.BODY_STATE_TRANSFORM, target)
	rb.reset_physics_interpolation()

func _draw():
	draw_polyline(rope_points, Color.DARK_BLUE, 5, false)
