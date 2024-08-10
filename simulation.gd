extends Node2D

@export var radius: float = 300
@export var number: int = 20

var duck = load("res://duck.tscn")
@onready var axis = $Axis

const PI: float = 3.1415926
var separation: float
var ducks


# initialize simulation (create ducks and set initial position)
func _ready():
	# instantiate and initialize ducks
	ducks = []
	var rand = RandomNumberGenerator.new()
	separation = 2.0 * PI / number
	for i in range(number):
		ducks.append(duck.instantiate())
		ducks[i].name = "duck" + str(i)
		set_duck(ducks[i], i * separation)
		# randomize duck properties
		#ducks[i].target_velocity *= rand.randf_range(1.0, 1.5)
		add_child(ducks[i])
	ducks[0].target_velocity *= 1.5

# update ducks per frame
func _process(delta):
	for duck in ducks:
		set_duck(duck, duck.rotation + duck.step_velocity(delta) / radius * delta)


# set duck position-helper
func set_duck(duck, angle: float):
	duck.rotation = angle
	duck.position.x = axis.position.x + radius * cos(duck.rotation)
	duck.position.y = axis.position.y + radius * sin(duck.rotation)
