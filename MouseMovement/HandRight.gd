extends Node2D
@onready var hand_right = $HandRight
var mousePos : Vector2

func _process(delta):
	mousePos = get_global_mouse_position()
	rad_to_deg(get_angle_to(mousePos))
	


