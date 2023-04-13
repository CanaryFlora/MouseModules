extends Node

@export var movementSpeed : int = 600
@export var targetNode : Node 
@export var targetNodeCollision : Node
@export var dashHitbox : Node

var xMov : int
var yMov : int 
var mov : Vector2
var dashOnCooldown : bool

func _ready():
	dashHitbox.set_deferred("disabled", true)

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
	# change velocity, set to dash hitbox
	targetNode.velocity = targetNode.velocity * 2.5
	targetNodeCollision.set_deferred("disabled", true)
	dashHitbox.set_deferred("disabled", false)
	print("dash activated, hitbox: ", dashHitbox.disabled)
	await get_tree().create_timer(0.25).timeout
	# after dash expires, change all values back
	targetNodeCollision.set_deferred("disabled", false)
	dashHitbox.set_deferred("disabled", true)
	print("dash deactivated, cooldown initiated, hitbox: ", dashHitbox.disabled)
	targetNode.velocity = mov.normalized() * movementSpeed
	if dashOnCooldown == false:
		dashOnCooldown = true
		await get_tree().create_timer(3).timeout
		print("set to false, value: ", dashOnCooldown)
		dashOnCooldown = false
