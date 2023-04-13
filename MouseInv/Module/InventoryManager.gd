extends Node

#preset variables
var invState = "hidden"
var itemSprite
var addedItem : String
var firstEmptyInvSlot

#item settings
@onready var itemsActive : Node = %ItemsActive

#inventory creation settings
var inv_slot = preload("res://inv_slot.tscn")
var inv_slot_passive = preload("res://inv_slot_passive.tscn")
var container = preload("res://inventory_container.tscn")
@onready var invSlotsPassive : Node = %InvSlotsPassive
@onready var invSlotsActive : Node = %InvSlotsActive

#inventory management settings
var invSlotBaseTexture = preload("res://AssetsInv/invslot.png")
@onready var dragItemCancel : Node = $UI/DragItemCancel
var invSlotPath = "UI/InvSlots/InvSlot"
signal on_number_clicked(originSlotIndex, targetSlotIndex)

#connect to slot drop, create active inv
func _ready():
	dragItemCancel.slot_cleared.connect(sync_inv)
	create_active_inv()

#runs functions
func add_item(item, amount, equippable):
	firstEmptyInvSlot = get_first_empty_inv_slot()
	add_item_to_inv(item, amount, equippable)

#checks every inventory slot to see if it has an item assigned
func get_first_empty_inv_slot():
	for i in Inventory.invActive:
		if i["item"].front() == null:
			return i 
	for i in Inventory.invPassive:
		if i["item"].front() == null:
			return [i, "p"]

# adds any item to any inventory, provided with the valid arguments
func add_item_to_inv(item, amount, equippable):
	
	#----------------------------------------------#
	#-----------IF EXISTS IN ACTIVE INV------------#
	#----------------------------------------------#
	
	for i in Inventory.invActive:
	#checks if item already exists in inventory
		if i["item"].front() == item:
		#if exists, increment amount and modify label text, return the dict that item was found in
			i["amount"] += amount
			i["slotNode"].get_child(1).text = str(i["amount"])
			return
	
	#----------------------------------------------#
	#-----------ADD TO ACTIVE INVENTORY------------#
	#----------------------------------------------#
	
	if firstEmptyInvSlot is Dictionary:
		#if item doesn't exist, put item into inventory
		#instantiate item, change name
		var sprite : Node = firstEmptyInvSlot["slotNode"].get_node("ItemSprite")
		sprite.name = item
#		inst_item_base.draggable = false
		#find item array, set texture
		for i in ItemDatabase.Items:
			if i.front() == item:
				sprite.set_texture(i.back())
		#create item, change position, increment amount
		firstEmptyInvSlot["item"] = [item, equippable]
		firstEmptyInvSlot["amount"] += amount
		firstEmptyInvSlot["slotNode"].get_child(1).text = str(firstEmptyInvSlot["amount"])
		return
	
	#----------------------------------------------#
	#-----------IF EXISTS IN PASSIVE INV-----------#
	#----------------------------------------------#
	
	for i in Inventory.invPassive:
	#checks if item already exists in inventory
		if i["item"].front() == item:
		#if exists, increment amount and modify label text, return the dict that item was found in
			i["amount"] += amount
			return
	
	#----------------------------------------------#
	#---------------PASSIVE INVENTORY--------------#
	#----------------------------------------------#
	
	
	if firstEmptyInvSlot is Array:
		var slotNum : int = firstEmptyInvSlot.front()["slot"]
		var slotDict : Dictionary = firstEmptyInvSlot.front()
#		print("sd ", slotDict, "sn ", slotNum)
		slotDict["item"] = [item, equippable]
		slotDict["amount"] += amount
		return

	
#find coords of active inventory slot based on number
func coords_of_slot(slot):
	return Vector2(50 + (85 * (slot - 1)), 1030)


#triggers when an inventory slot is clicked
func equip_item(slot, input_type):
	#checks every inventory slot's node reference to see if it matches with the clicked slot's id
	for i in range(11):
		if Inventory.invActive.slice(i,i+1).back()["slotNode"] == slot:
			#when it's found, checks if the input matches the target input
			if input_type == "LMB":
				#toggles the equipped state of slot
				Inventory.invActive.slice(i,i+1).back()["equipped"] = not Inventory.invActive.slice(i,i+1).back()["equipped"]
				print("state: ", Inventory.invActive.slice(i,i+1).back()["equipped"])
				return
	print("couldn't find slot")



#adds random item
func _on_texture_button_pressed():
	for i in ItemDatabase.Items:
		firstEmptyInvSlot = get_first_empty_inv_slot()
		add_item_to_inv(i.front(), 1, false)
	if Inventory.passiveInv != null:
		sync_inv()

		
#outputs inv
func _on_texture_button_2_pressed():
	print("Active Inventory")
	for i in Inventory.invActive:
		print("Slot: ", i["slot"], " ", "Item: ", i["item"].front(), " ", "Amount: ", i["amount"])
	print("Passive Inventory")
	for i in Inventory.invPassive:
		print("Slot: ", i["slot"], " ", "Item: ", i["item"].front(), " ", "Amount: ", i["amount"])

# syncs the inv by destroying and recreating it
func sync_inv():
	for i in Inventory.activeSlotsArray:
		i.queue_free()
	Inventory.activeSlotsArray = []
	create_active_inv()
	Inventory.passiveInv.queue_free()
	create_passive_inv()



func create_passive_inv():
	#instantiate invslot and container, change container positions
	var inst_container : Node = container.instantiate()
	Inventory.passiveInv = inst_container
	invSlotsPassive.add_child(inst_container)
	inst_container.position = Vector2(0, 750)
	for i in range(22):
		#create invslots, set variables in singleton
		var inst_slot : Node = inv_slot_passive.instantiate()
		Inventory.invPassive.slice(i,i+1).back()["slotNode"] = inst_slot
		inst_container.get_node("InvSpacer").add_child(inst_slot)
		Inventory.passiveSlotsArray.append(inst_slot)
		inst_slot.slot_dropped.connect(on_slot_dropped)
	#sync slots
	for j in Inventory.invPassive:
	#check for filled slots, set variables and name of item
		if j["item"].front() != null:
			var sprite : Node = j["slotNode"].get_node("ItemSprite")
			var item : Array = j["item"] 
			sprite.name = item.front()
			#find texture in sprite database, set item base textureRect texture to the item's texture
			for n in ItemDatabase.Items:
				if n.front() == item.front():
					sprite.set_texture(n.back())
			#create item base, set position and amount
			itemSprite = sprite.texture
			j["slotNode"].get_child(1).text = str(j["amount"])

#creates the active inventory
func create_active_inv():
	#create 11 inventory slots, add them as active, set their positions
	for i in range(11):
		var inst_slot : Node = inv_slot.instantiate()
		invSlotsActive.add_child(inst_slot)
		Inventory.invActive.slice(i,i+1).back()["slotNode"] = inst_slot
		Inventory.activeSlotsArray.append(inst_slot)
		inst_slot.global_position = Vector2(12.5 + 87.5 * i, 1000)
	for j in Inventory.invActive:
	#check for filled slots, set variables and name of item
		if j["item"].front() != null:
			var sprite : Node = j["slotNode"].get_node("ItemSprite")
			var item : Array = j["item"] 
			sprite.name = item.front()
			#find texture in sprite database, set item base textureRect texture to the item's texture
			for n in ItemDatabase.Items:
				if n.front() == item.front():
					sprite.set_texture(n.back())
			#create item base, set position and amount
			itemSprite = sprite.texture
			j["slotNode"].get_child(1).text = str(j["amount"])
	for i in Inventory.activeSlotsArray:
		i.slot_clicked.connect(equip_item)

#hide/show passive
func _unhandled_input(event):
	if event.is_action_pressed("inv_open"):
		if invState == "hidden":
			create_passive_inv()
			invState = "shown"
			return
		elif invState == "shown":
			Inventory.passiveInv.queue_free()
			invState = "hidden"
			return
		# move item from passive to active inventories
	if Inventory.bindingSlot != null:
		if event.is_action_pressed("1"):
			emit_signal("on_number_clicked", Inventory.bindingSlot, 0)
		if event.is_action_pressed("2"):
			emit_signal("on_number_clicked", Inventory.bindingSlot, 1)
		if event.is_action_pressed("3"):
			emit_signal("on_number_clicked", Inventory.bindingSlot, 2)
		if event.is_action_pressed("4"):
			emit_signal("on_number_clicked", Inventory.bindingSlot, 3)
		if event.is_action_pressed("5"):
			emit_signal("on_number_clicked", Inventory.bindingSlot, 4)
		if event.is_action_pressed("6"):
			emit_signal("on_number_clicked", Inventory.bindingSlot, 5)
		if event.is_action_pressed("7"):
			emit_signal("on_number_clicked", Inventory.bindingSlot, 6)
		if event.is_action_pressed("8"):
			emit_signal("on_number_clicked", Inventory.bindingSlot, 7)
		if event.is_action_pressed("9"):
			emit_signal("on_number_clicked", Inventory.bindingSlot, 8)
		Inventory.bindingSlot = null
#

#runs when an item is dropped into a slot
func on_slot_dropped(itemName, droppedSlotIndex):
	# thank you qubus/ste for helping me code this func
	# the slot index here is needed because we want to get the actual position of the slot
	# inside the inventory
	# set origin slot
	var originSlotIndex: int
	for slotIndex in Inventory.invPassive.size():
		if Inventory.invPassive[slotIndex]["item"].front() == itemName:
			originSlotIndex = slotIndex
	
	# set the dropped slot to the original slot
	var tempSlot: Dictionary = Inventory.invPassive[droppedSlotIndex]
	Inventory.invPassive[droppedSlotIndex] = Inventory.invPassive[originSlotIndex]
	# set original slot to dropped slot
	Inventory.invPassive[originSlotIndex] = tempSlot
	
# recreate inv
	sync_inv()
	Inventory.bindingSlot = null

#move items between active and passive inv
func active_passive_move(originSlotIndex : int, targetSlotIndex: int):
	#works like the above func
	var tempSlot: Dictionary = Inventory.invActive[targetSlotIndex]
	Inventory.invActive[targetSlotIndex] = Inventory.invPassive[originSlotIndex]
	Inventory.invPassive[originSlotIndex] = tempSlot
	sync_inv()
	Inventory.bindingSlot = null
	Inventory.invPassive[originSlotIndex]["slotNode"].get_node("InventorySlot").texture = invSlotBaseTexture


	
	
