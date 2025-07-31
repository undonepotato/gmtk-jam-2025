extends RigidBody2D

func push_away():
	apply_impulse(Vector2(-500, 0))
