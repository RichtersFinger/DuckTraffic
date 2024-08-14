extends MarginContainer

@onready var simulation = $".."


func _on_check_button_toggled(toggled_on):
	simulation.toggle_duck_labels(toggled_on)


func _on_start_pressed():
	simulation.start()


func _on_pause_pressed():
	simulation.pause()


func _on_reset_pressed():
	simulation.reset()


func _on_apply_pressed():
	pass
