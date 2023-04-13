extends Node

# database which holds the slot and the inventory data
# 11 active slots, 22 passive slots (p)

var activeSlotsArray : Array = []
var labelsArray : Array = []
var passiveSlotsArray : Array = []
var passiveInv = null
var itemsArray : Array = []
var bindingSlot = null

var invslot1 = {
	"item": [null, false],
	"amount": 0,
	"equipped": false, 
	"slot": 1,
	"slotNode": null,
	"itemNode": null
}
var invslot2 = {
	"item": [null, false],
	"amount": 0,
	"equipped": false,
	"slot": 2,
	"slotNode": null,
	"itemNode": null
}
var invslot3 = {
	"item": [null, false],
	"amount": 0,
	"equipped": false,
	"slot": 3,
	"slotNode": null,
	"itemNode": null
}
var invslot4 = {
	"item": [null, false],
	"amount": 0,
	"equipped": false,
	"slot": 4,
	"slotNode": null,
	"itemNode": null
}
var invslot5 = {
	"item": [null, false],
	"amount": 0,
	"equipped": false,
	"slot": 5,
	"slotNode": null,
	"itemNode": null
}
var invslot6 = {
	"item": [null, false],
	"amount": 0,
	"equipped": false,
	"slot": 6,
	"slotNode": null,
	"itemNode": null
}
var invslot7 = {
	"item": [null, false],
	"amount": 0,
	"equipped": false,
	"slot": 7,
	"slotNode": null,
	"itemNode": null
}
var invslot8 = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 8,
	"slotNode": null,
	"itemNode": null
}
var invslot9 = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 9,
	"slotNode": null,
	"itemNode": null
}
var invslot10 = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 10,
	"slotNode": null,
	"itemNode": null
}
var invslot11 = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 11,
	"slotNode": null,
	"itemNode": null
}

var invActive : Array = [invslot1, invslot2, invslot3, invslot4, invslot5, invslot6, invslot7, invslot8, invslot9, invslot10, invslot11]

var invslot1p= {
	"item": [null, false],
	"amount": 0,
	"equipped": false, 
	"slot": 1,
	"slotNode": null,
	"itemNode": null
}
var invslot2p= {
	"item": [null, false],
	"amount": 0,
	"equipped": false,
	"slot": 2,
	"slotNode": null,
	"itemNode": null
}
var invslot3p= {
	"item": [null, false],
	"amount": 0,
	"equipped": false,
	"slot": 3,
	"slotNode": null,
	"itemNode": null
}
var invslot4p= {
	"item": [null, false],
	"amount": 0,
	"equipped": false,
	"slot": 4,
	"slotNode": null,
	"itemNode": null
}
var invslot5p= {
	"item": [null, false],
	"amount": 0,
	"equipped": false,
	"slot": 5,
	"slotNode": null,
	"itemNode": null
}
var invslot6p= {
	"item": [null, false],
	"amount": 0,
	"equipped": false,
	"slot": 6,
	"slotNode": null,
	"itemNode": null
}
var invslot7p= {
	"item": [null, false],
	"amount": 0,
	"equipped": false,
	"slot": 7,
	"slotNode": null,
	"itemNode": null
}
var invslot8p= {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 8,
	"slotNode": null,
	"itemNode": null
}
var invslot9p= {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 9,
	"slotNode": null,
	"itemNode": null
}
var invslot10p = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 10,
	"slotNode": null,
	"itemNode": null
}
var invslot11p = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 11,
	"slotNode": null,
	"itemNode": null
}
var invslot12p = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 12,
	"slotNode": null,
	"itemNode": null
}
var invslot13p = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 13,
	"slotNode": null,
	"itemNode": null
}
var invslot14p = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 14,
	"slotNode": null,
	"itemNode": null
}
var invslot15p = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 15,
	"slotNode": null,
	"itemNode": null
}
var invslot16p = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 16,
	"slotNode": null,
	"itemNode": null
}
var invslot17p = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 17,
	"slotNode": null,
	"itemNode": null
}
var invslot18p = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 18,
	"slotNode": null,
	"itemNode": null
}
var invslot19p = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 19,
	"slotNode": null,
	"itemNode": null
}
var invslot20p = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 20,
	"slotNode": null,
	"itemNode": null
}
var invslot21p = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 21,
	"slotNode": null,
	"itemNode": null
}
var invslot22p = {
	"item": [null, true],
	"amount": 0,
	"equipped": false,
	"slot": 22,
	"slotNode": null,
	"itemNode": null
}

var invPassive : Array = [invslot1p, invslot2p, invslot3p, invslot4p, invslot5p, invslot6p, invslot7p, invslot8p, invslot9p, invslot10p, invslot11p, invslot12p, invslot13p, invslot14p, invslot15p, invslot16p, invslot17p, invslot18p, invslot19p, invslot20p, invslot21p, invslot22p]
