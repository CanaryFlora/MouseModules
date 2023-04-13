extends Panel

# when item dropped onto container, do nothing

var slotBaseTexture = preload("res://AssetsInv/invslot.png")

func _can_drop_data(at_position, data):
	return true
	
func _drop_data(at_position, data):
	data.back().texture = slotBaseTexture
	
