extends Control

# this removes the item when it's dropped out of the inv

var slotBaseTexture = preload("res://AssetsInv/invslot.png")
signal slot_cleared

# finds the slot number by item name
func find_slot_by_item(itemName):
	for i in Inventory.invPassive:
		if i["item"].front() == itemName:
			return i


func _can_drop_data(at_position, data):
	return true
	
# when item dropped, clear the slot
func _drop_data(at_position, data):
	data.back().texture = slotBaseTexture
	var originSlot : Dictionary = find_slot_by_item(data.front())
	originSlot["item"] = [null, true]
	originSlot["amount"] = 0
	originSlot["equipped"] = false
	emit_signal("slot_cleared")
	print("slot ", originSlot["slot"], " cleared")
	
