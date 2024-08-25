extends Button

@onready var about_popup = $"../AboutPopup"

var open: bool = false

func _on_pressed():
	if open:
		about_popup.hide()
	else:
		about_popup.show()
	open = not open
