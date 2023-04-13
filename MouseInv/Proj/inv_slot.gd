extends Control

var slotNode : Node = self
var clickType : String

var slotBaseTexture = preload("res://AssetsInv/invslot.png")
var slotEquippedTexture = preload("res://AssetsInv/equipped_item.png")
var armorEquippedTexture = preload("res://AssetsInv/equipped_armor.png")

signal slot_clicked(slotNode, input_type)

# when left clicked, equip item
func _on_gui_input(event):
	if event.is_action_pressed("left_click") == true:
		clickType = "LMB"
		emit_signal("slot_clicked", slotNode, clickType)

func _can_drop_data(at_position, data):
	return true
	
func _drop_data(at_position, data):
	data.back().texture = slotBaseTexture

