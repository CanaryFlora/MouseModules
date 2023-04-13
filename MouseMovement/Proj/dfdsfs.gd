extends Node
var mousePos : Vector2


func _ready():
	for i in range(5):
		await get_tree().create_timer(0.5).timeout
		print(i)
