extends Sprite2D

@export var velocity: float = 50.0

@onready var cloud = %Cloud
@onready var cloud_body = $CloudBody

func _process(delta):
	var screen = DisplayServer.screen_get_size()
	if cloud.position.x > 1.1 * screen[0]:
		cloud.position.x = -cloud.scale[0] * cloud_body.size[0]
		cloud.position.y = RandomNumberGenerator.new().randi_range(
			-cloud.scale[1] * cloud_body.size[1] / 2,
			screen[1] -cloud.scale[1] * cloud_body.size[1] / 2
		)
	cloud.position.x += velocity * delta
