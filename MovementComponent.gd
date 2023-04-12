extends Node

@export var movementSpeed : int = 600
@export var targetNode : Node 

var xMov : int
var yMov : int 
var mov : Vector2
var dashOnCooldown : bool

func _physics_process(delta):
	movement()
	if Input.is_action_pressed("dashKey") and dashOnCooldown == false:
		dash()
	targetNode.move_and_slide()
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var player_pos : Vector2 = targetNode.global_position

	
func movement():
	xMov = Input.get_action_strength("right") - Input.get_action_strength("left")
	yMov = Input.get_action_strength("down") - Input.get_action_strength("up") 
	mov = Vector2(xMov, yMov)
	targetNode.velocity = mov.normalized() * movementSpeed


func dash():
	targetNode.velocity = targetNode.velocity * 2
	print("dash activated")
	await get_tree().create_timer(0.3).timeout
	print("dash deactivated, cooldown initiated")
	targetNode.velocity = mov.normalized() * movementSpeed
	if dashOnCooldown == false:
		dashOnCooldown = true
		await get_tree().create_timer(3).timeout
		print("set to false, value: ", dashOnCooldown)
		dashOnCooldown = false
