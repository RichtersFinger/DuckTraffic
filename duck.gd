extends CharacterBody2D

@export var target_velocity: float = -100.0

var angular_position = 0.0


# returns current target velocity of given duck
func get_target_velocity():
	return target_velocity
