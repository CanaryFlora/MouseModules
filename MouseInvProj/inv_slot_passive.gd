extends Control

# preload nodes and sprites
@onready var item_sprite = $ItemSprite
@onready var moveTexture = preload("res://AssetsInv/selected_slot.png")
@onready var baseTexture = preload("res://AssetsInv/invslot.png")


# preset variables
var slotNode : Node = self
var clickType : String
var slotNumber : int
var slotDict : Dictionary

signal slot_dropped(itemName, droppedSlot)

func _ready():
	# find current slot number and dict
	slotNumber = find_slot_number(slotNode)
	slotDict = find_dict(slotNumber)

#finds the slot's number by comparing the current node reference against other slots node references
func find_slot_number(slotNode):
	for i in range(22):
		if Inventory.invPassive.slice(i,i+1).back()["slotNode"] == slotNode:
			return i

#with provided slot number, finds dict by comparing the number against other slots numbers
func find_dict(slotNumber):
	return Inventory.invPassive.slice(slotNumber, slotNumber + 1).back()

#------------------------------------------#
#---------------Drag & Drop----------------#
#------------------------------------------#

func _can_drop_data(at_position, data):
	return true


func _get_drag_data(Vector2): 
	# set base slot node, change texture to move texture
	var baseSlotNode : Node = get_node("InventorySlot")
	get_node("InventorySlot").texture = moveTexture 
	get_node("InventorySlot").size = Vector2(250, 250)
	# cancel dragging into same slot
	if item_sprite.name == "ItemSprite":
		return
	var itemName : String = item_sprite.name
	# set drag preview settings
	var dragTexture : Node = TextureRect.new()
	dragTexture.expand = true
	dragTexture.texture = item_sprite.texture
	dragTexture.size = Vector2(60, 60)
	
	# add drag preview
	var control : Node = Control.new()
	control.add_child(dragTexture)
	dragTexture.position = -0.5 * dragTexture.size
	set_drag_preview(control)
	
	return [itemName, baseSlotNode]
	
func _drop_data(at_position, data):
		get_node("InventorySlot").texture = baseTexture
		# cancel dropping into same slot
		if data.front() == slotDict["item"].front():
			return
		var itemName : String
		# emit signal with some data
		itemName = data.front()
		emit_signal("slot_dropped", itemName, slotNumber)
		print("slot_dropped signal sent with itemName = ", itemName)
	
# bind items
func _on_item_sprite_gui_input(event):
	if event.is_action_pressed("left_click") == true and Inventory.bindingSlot == null:
		print("!")
		Inventory.bindingSlot = find_slot_number(self)
		# set texture to moving texture
		get_node("InventorySlot").texture = moveTexture 
		get_node("InventorySlot").size = Vector2(250, 250)

