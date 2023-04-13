extends CharacterBody2D

@onready var handLeft : Node = $LeftPoint/HandLeft
@onready var handRight : Node = $RightPoint/HandRight
@onready var leftPoint = $LeftPoint
@onready var rightPoint = $RightPoint
@onready var text_edit = $"../UI/TextEdit"
@onready var check_box = $"../UI/CheckBox"

var mousePos : Vector2
var handRightToMouse : int
var handLeftToMouse : int
var currentHand : String = "left"
var leftAttackOnCooldown : bool
var rightAttackOnCooldown : bool
var changeInProgressLeft : bool
var changeInProgressRight : bool
var attackCooldown
var holdingLMB : bool

func _physics_process(delta):
	# ---------------CALCULATE VARIABLES AND RESET HAND POSITION --------------- #
	attackCooldown = text_edit.text.to_int()
	if text_edit.text.is_valid_int() == false:
		attackCooldown = 0.75
	mousePos = get_global_mouse_position()
	# offset the angle difference by subtracting 90 deg
	handLeftToMouse = rad_to_deg(handLeft.get_angle_to(mousePos)) - 90
	handRightToMouse = rad_to_deg(handRight.get_angle_to(mousePos)) - 90
	# set closer to mouse variable, reset opposite hand to normal position
	if Input.is_action_just_pressed("switchHand") and currentHand == "left":
		var eTween : Tween = get_tree().create_tween()
		currentHand = "right"
		eTween.tween_property(leftPoint, "rotation_degrees", 0, 0.1)
		print("switched to right")
	elif Input.is_action_just_pressed("switchHand") and currentHand == "right":
		var eTween2 : Tween = get_tree().create_tween()
		currentHand = "left"
		eTween2.tween_property(rightPoint, "rotation_degrees", 0, 0.1)
		print("switched to left")
	var tween : Tween = get_tree().create_tween()
#	print("closer ", closerToMouseX, " left ", LeftToMouse, " right ", RightToMouse, " mousepos ", mousePos)
#	print("left global pos ", handLeft.global_position, " right global pos ", handRight.global_position)
	# --------------- PICK HAND BASED ON MOUSE LOCATION, ROTATE HAND TO MOUSE --------------- #
	if currentHand == "left":
		tween.tween_property(leftPoint, "rotation_degrees", rotation_cap(handLeftToMouse, false), 0.1)
	elif currentHand == "right":
		tween.tween_property(rightPoint, "rotation_degrees", rotation_cap(handRightToMouse, true), 0.1)
	oneHandAttack()

func rotation_cap(val : int, invert : bool) -> int:
	if invert == false:
		if val < -120 and val > -300:
			val = 90
		if val < -40:
			val = -40
	if invert == true:
		if val < -90 and val > -300:
			val = -90
		if val > 40:
			val = 40
	return val


func setCooldownHandAttack():
	if leftAttackOnCooldown == true and changeInProgressLeft == false:
		changeInProgressLeft = true
		await get_tree().create_timer(attackCooldown).timeout
		leftAttackOnCooldown = false
		changeInProgressLeft = false
		print("left cd completed")
	if rightAttackOnCooldown == true and changeInProgressRight == false:
		changeInProgressRight = true
		await get_tree().create_timer(attackCooldown).timeout
		rightAttackOnCooldown = false
		changeInProgressRight = false
		print("right cd completed")


func _unhandled_input(event):
	if event.is_action_pressed("attack", false):
		holdingLMB = true
		print("pressed")
	if event.is_action_released("attack", false):
		holdingLMB = false
		print("released")


func _on_check_box_pressed():
	if check_box.button_pressed == true:
		handLeft.get_node("Dagger").hide()
		handRight.get_node("Dagger").hide()
	elif check_box.button_pressed == false:
		handLeft.get_node("Dagger").show()
		handRight.get_node("Dagger").show()
		
func oneHandAttack():
	if holdingLMB:
#		print("currenthand ", currentHand, " left ", leftAttackOnCooldown, " right ", rightAttackOnCooldown)
		if currentHand == "left":
			if leftAttackOnCooldown == false:
				leftAttackOnCooldown = true
				var tween3 : Tween = get_tree().create_tween()
				tween3.tween_property(handLeft, "position", Vector2(handLeft.position.x, handLeft.position.y + 50), 0.2)
				await get_tree().create_timer(0.2).timeout
				print("timed out left")
				var tween4 : Tween = get_tree().create_tween()
				tween4.finished.connect(setCooldownHandAttack)
				tween4.tween_property(handLeft, "position", Vector2(-3, 10), 0.2)
	if holdingLMB:
		if currentHand == "right":
			if rightAttackOnCooldown == false:
				rightAttackOnCooldown = true
				var tween5 : Tween = get_tree().create_tween()
				tween5.tween_property(handRight, "position", Vector2(handRight.position.x, handRight.position.y + 50), 0.2)
				await get_tree().create_timer(0.2).timeout
				print("timed out right")
				var tween6 : Tween = get_tree().create_tween()
				tween6.finished.connect(setCooldownHandAttack)
				tween6.tween_property(handRight, "position", Vector2(3, 10), 0.2)
