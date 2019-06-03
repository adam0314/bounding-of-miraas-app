extends Node

var available_items = []

var ITEM_OBJECT_SCRIPT = preload("res://scripts/ItemObject.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func setup():
	load_all_items()
	pass

func load_all_items():
	for item_data in Global.ITEMS_LIST:
		var item = ITEM_OBJECT_SCRIPT.ItemObject.new()
		item.set_values(item_data)
		available_items.append(item)
	pass

func get_item_for_id(id):
	for item in available_items:
		if item["id"] == id:
			return item
	return [] # TODO should throw an error

func erase_item_from_available(item):
	available_items.erase(item)
	pass

func add_to_available_items(item):
	available_items.append(item)
	available_items.sort_custom(self, "sort_compare")
	pass

static func sort_compare(a, b):
	if a["id"] < b["id"]:
		return true
	else:
		return false