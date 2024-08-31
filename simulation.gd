extends Node2D

@export var radius: float = 300
var time: float = 0.0

var duck_template = load("res://duck.tscn")
@onready var axis = $Axis

const PI: float = 3.1415926
var separation: float
var ducks
var running = false
var visible_labels = false

@onready var number_slider = $GUI/MarginContainer/VBoxContainer/NumberSlider/HSlider
var number: int = 20
# raft - settings
@onready var raft_target_velocity_slider = $GUI/MarginContainer/VBoxContainer/TabContainer/Collective/VBoxContainer/VelocitySlider/HSlider
var raft_target_velocity: float = 100
@onready var raft_max_acceleration_slider = $GUI/MarginContainer/VBoxContainer/TabContainer/Collective/VBoxContainer/MaxAccelerationSlider/HSlider
var raft_max_acceleration: float = 40
@onready var raft_accuracy_slider = $GUI/MarginContainer/VBoxContainer/TabContainer/Collective/VBoxContainer/AccuracySlider/HSlider
var raft_accuracy: float = 0.9
@onready var raft_responsiveness_slider = $GUI/MarginContainer/VBoxContainer/TabContainer/Collective/VBoxContainer/ResponsivenessSlider/HSlider
var raft_responsiveness: float = 2.5
@onready var raft_freedist_slider = $GUI/MarginContainer/VBoxContainer/TabContainer/Collective/VBoxContainer/FreeDistSlider/HSlider
var raft_freedist: float = 0.12
# rogue - settings
@onready var rogue_active_button = $GUI/MarginContainer/VBoxContainer/TabContainer/Single/VBoxContainer/Active
var rogue_active = false
@onready var rogue_target_velocity_slider = $GUI/MarginContainer/VBoxContainer/TabContainer/Single/VBoxContainer/VelocitySlider/HSlider
var rogue_target_velocity: float = 100
@onready var rogue_max_acceleration_slider = $GUI/MarginContainer/VBoxContainer/TabContainer/Single/VBoxContainer/MaxAccelerationSlider/HSlider
var rogue_max_acceleration: float = 40
@onready var rogue_accuracy_slider = $GUI/MarginContainer/VBoxContainer/TabContainer/Single/VBoxContainer/AccuracySlider/HSlider
var rogue_accuracy: float = 0.9
@onready var rogue_responsiveness_slider = $GUI/MarginContainer/VBoxContainer/TabContainer/Single/VBoxContainer/ResponsivenessSlider/HSlider
var rogue_responsiveness: float = 2.5
@onready var rogue_freedist_slider = $GUI/MarginContainer/VBoxContainer/TabContainer/Single/VBoxContainer/FreeDistSlider/HSlider
var rogue_freedist: float = 0.12


# initialize simulation (create ducks and set initial position)
func _ready():
	reset()
	start()


# update ducks per frame
func _process(delta):
	if not running:
		return
	time += delta
	for duck in ducks:
		set_duck(duck, duck.rotation + duck.step_velocity(delta, time) / radius * delta)


# set duck position-helper
func set_duck(duck, angle: float):
	duck.rotation = angle
	duck.position.x = axis.position.x + radius * cos(duck.rotation)
	duck.position.y = axis.position.y + radius * sin(duck.rotation)


func toggle_duck_labels(on: bool):
	visible_labels = on
	for duck in ducks:
		duck.refresh_name_label(on)


func start():
	running = true


func pause():
	running = false


func reset():
	# load settings
	number = number_slider.value
	raft_target_velocity = raft_target_velocity_slider.value
	raft_max_acceleration = raft_max_acceleration_slider.value
	raft_accuracy = raft_accuracy_slider.value
	raft_responsiveness = raft_responsiveness_slider.value
	raft_freedist = raft_freedist_slider.value
	rogue_active = rogue_active_button.button_pressed
	rogue_target_velocity = rogue_target_velocity_slider.value
	rogue_max_acceleration = rogue_max_acceleration_slider.value
	rogue_accuracy = rogue_accuracy_slider.value
	rogue_responsiveness = rogue_responsiveness_slider.value
	rogue_freedist = rogue_freedist_slider.value
	# cleanup existing ducks
	if ducks:
		for duck in ducks:
			duck.queue_free()
	# instantiate and initialize ducks
	ducks = []
	var rand = RandomNumberGenerator.new()
	separation = 2.0 * PI / number
	for i in range(number):
		ducks.append(duck_template.instantiate())
		ducks[i].label_text = "duck" + str(i)
		set_duck(ducks[i], i * separation)
		# configure ducks
		ducks[i].target_velocity = raft_target_velocity
		ducks[i].max_acceleration = raft_max_acceleration
		ducks[i].responsiveness = raft_responsiveness
		ducks[i].consistency_accuracy = 1.0 - raft_accuracy
		ducks[i].consistency_phase = rand.randf_range(0.0, 2 * PI)
		ducks[i].target_velocity *= rand.randf_range(raft_accuracy, 2.0 - raft_accuracy)
		ducks[i].free_dist = raft_freedist * PI
		add_child(ducks[i])
	if rogue_active:
		ducks[0].target_velocity = rogue_target_velocity
		ducks[0].max_acceleration = rogue_max_acceleration
		ducks[0].responsiveness = rogue_responsiveness
		ducks[0].consistency_accuracy = 1.0 - rogue_accuracy/2.0
		ducks[0].consistency_phase = rand.randf_range(0.0, 2 * PI)
		ducks[0].target_velocity *= rand.randf_range(rogue_accuracy, 2.0 - rogue_accuracy)
		ducks[0].free_dist = rogue_freedist * PI
		ducks[0].refresh_highlight(true)

	toggle_duck_labels(visible_labels)
