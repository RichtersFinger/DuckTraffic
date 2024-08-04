extends CharacterBody2D

const PI: float = 3.1415926535
const axis: int = -1

var max_target_velocity: float = 100.0
var free_dist: float = 0.5*PI
var min_dist: float = 0.3*PI
var other_ducks = []  # used to track collisions
var active = false


# returns current velocity of given duck
func get_current_velocity():
	# skip calculation if moving freely
	if not active or len(other_ducks) == 0:
		return axis * max_target_velocity
	# find next neighbor (closest and in front)
	var closest = 2*PI
	for duck in other_ducks:
		var distance = fmod(2*PI - (duck.rotation - self.rotation), 2*PI)
		if distance > 0:
			closest = min(closest, distance)
	# eval
	if closest < min_dist:
		return 0.0
	return axis * max_target_velocity


# register duck for collision
func _on_area_2d_area_entered(area):
	self.scale[0] = 0.24
	other_ducks.append(area.get_parent())


func _on_area_2d_area_exited(area):
	self.scale[0] = 0.2
	other_ducks.erase(area.get_parent())
