extends Node2D

@export var radius: float = 300
@export var number: int = 15

var duck = load("res://duck.tscn")
@onready var axis = $Axis

const PI: float = 3.1415926
var separation: float
var ducks


# initialize simulation (create ducks and set initial position)
func _ready():
	# instantiate and initialize ducks
	ducks = []
	separation = 2.0 * PI / number
	for i in range(number):
		ducks.append(duck.instantiate())
		ducks[i].name = "duck" + str(i)
		add_child(ducks[i])
		set_duck(ducks[i], i * separation)


# update ducks per frame
func _process(delta):
	for duck in ducks:
		set_duck(duck, duck.rotation + duck.get_target_velocity() / radius * delta)


# set duck position-helper
func set_duck(duck, angle: float):
	duck.rotation = angle
	duck.position.x = axis.position.x + radius * cos(duck.rotation)
	duck.position.y = axis.position.y + radius * sin(duck.rotation)
