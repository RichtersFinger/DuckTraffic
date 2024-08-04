extends Node2D

@export var radius: float = 300
@export var number: int = 15

#@onready var ducks_node = %Ducks
var duck = load("res://duck.tscn")
@onready var axis = $Axis

const PI: float = 3.1415926
var separation: float
var ducks

func _ready():
	# instantiate and initialize ducks
	ducks = []
	#ducks = ducks_node.get_children()
	separation = 2.0 * PI / number
	for i in range(number):
		ducks.append(duck.instantiate())
		ducks[i].name = "duck" + str(i)
		add_child(ducks[i])
		ducks[i].rotation = i * separation
		ducks[i].position.x = axis.position.x + radius * cos(ducks[i].rotation)
		ducks[i].position.y = axis.position.y + radius * sin(ducks[i].rotation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
