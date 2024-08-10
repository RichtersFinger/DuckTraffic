extends MarginContainer

@onready var simulation = $".."


func _on_check_button_toggled(toggled_on):
	simulation.toggle_duck_labels(toggled_on)
