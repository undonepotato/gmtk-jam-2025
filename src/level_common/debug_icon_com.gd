extends Sprite2D

func _process(delta: float) -> void:
	position = get_parent().center_of_mass
