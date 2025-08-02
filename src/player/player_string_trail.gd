extends Line2D

@export var length = 100

@onready var point_count = get_point_count()

var point = Vector2()

func add_player_trail_point(pos: Vector2) -> void:
	point_count = get_point_count()
	
	global_position = Vector2.ZERO
	global_rotation = 0.0
	
	point = pos

	while point_count > length:
		point_count = get_point_count()
		remove_point(0)
	
	add_point(point)
