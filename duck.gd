extends CharacterBody2D

const PI: float = 3.1415926535
const axis: int = -1

var target_velocity: float = 100.0
var consistency_accuracy: float = 0.0  # maximum relative deviation target_velocity
var consistency_phase: float = 0.0  # phase for velocity-variations
var consistency_frequency: float = PI/8.0  # (angular) frequency for velocity-variations
var current_velocity: float
var max_acceleration: float = 40.0
var responsiveness: float = 2.5  # emergency-breaking factor for max_acceleration
var free_dist: float = 0.15*PI
var min_dist: float = 0.12*PI
var collision_dist: float = 0.06*PI

var other_ducks = []  # used to track collisions
@onready var collision_label = $CollisionLabel


func _ready():
	$NameLabel.text = self.name


# returns current velocity of given duck
func step_velocity(delta, time):
	var _target_velocity = target_velocity * (
		1.0 + consistency_accuracy * cos(
			consistency_frequency * time + consistency_phase
		)
	)
	
	var closest_duck = _get_closest()
	if not closest_duck:
		# traffic flowing freely
		current_velocity += delta * max(
			-max_acceleration, min(max_acceleration, _target_velocity - current_velocity)
		)
		return axis * current_velocity

	# eval
	var distance: float = _get_distance(closest_duck)
	if distance < collision_dist:
		current_velocity = min(0.0, current_velocity)
		return axis * current_velocity
	current_velocity += delta * responsiveness * max_acceleration * (
		distance - 0.5*(free_dist + min_dist)
	)
	current_velocity = max(0.0, current_velocity)
	return axis * current_velocity


# sets the current value for the collision label
func _update_collision_label():
	var closest_duck = _get_closest()
	if closest_duck:
		collision_label.text = closest_duck.name
	else:
		collision_label.text = ""


# returns the distance to a given duck in the range [-pi:pi[
func _get_distance(duck):
	var distance = _normalize_position(duck.rotation - rotation)
	if distance > PI:
		return -distance + 2*PI
	return -distance


# returns the closest duck in front of self if any
func _get_closest():
	var closest = free_dist
	var closest_duck = null
	for duck in other_ducks:
		var distance = _get_distance(duck)
		if distance < closest:
			closest = distance
			closest_duck = duck
	return closest_duck


# map current position to range [0, 2pi[
func _normalize_position(position_):
	return fmod(fmod(position_, 2*PI) + 2*PI, 2*PI)


# register duck for collision
func _on_area_2d_area_entered(area):
	var duck = area.get_parent()
	if _get_distance(duck) > 0:
		other_ducks.append(duck)
	_update_collision_label()


func _on_area_2d_area_exited(area):
	other_ducks.erase(area.get_parent())
	_update_collision_label()
