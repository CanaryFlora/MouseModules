extends CharacterBody2D

# basic move script to test ui

@export var movement_speed : int = 1000


func _physics_process(delta):
	movement()
	var mouse_pos = get_viewport().get_mouse_position()
	var player_pos = global_position
	
	
	
func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_raw_strength("up")
	var mov = Vector2(x_mov, y_mov) 
	velocity = Input.get_vector("left", "right", "up", "down") * movement_speed
	velocity = mov.normalized()*movement_speed
	move_and_slide()
	
