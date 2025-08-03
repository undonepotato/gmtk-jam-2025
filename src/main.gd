extends Node2D

var first_string_node: RigidBody2D
var generic_movable = preload("res://src/level_common/generic_movable.tscn")

var Rope = preload("res://src/level_common/rope.tscn")
var start_pos := Vector2.ZERO
var end_pos := Vector2.ZERO

func _physics_process(delta: float) -> void:
	start_pos = %Player.global_position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if end_pos == Vector2.ZERO:
			end_pos = get_global_mouse_position()
			var rope = Rope.instantiate()
			add_child(rope)
			rope.spawn_rope(start_pos, end_pos)
			end_pos = Vector2.ZERO

func _on_player_object_detached(global_pos: Vector2) -> void:
	var inst = generic_movable.instantiate()
	inst.global_position = global_pos
	add_child(inst)
