extends HBoxContainer

@onready var value_label = $HSlider/Value
@onready var h_slider = $HSlider


func _ready():
	set_slider_value_label(h_slider.value)


func _on_h_slider_value_changed(value):
	set_slider_value_label(value)


func set_slider_value_label(value):
	value_label.text = str(value)
