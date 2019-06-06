extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const LOSE_TAB = 0
const WIN_TAB = 1

onready var tab_result : TabContainer = find_node("TabResultCont")
onready var loot_list : ItemList = find_node("LootList")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(val):
	loot_list.clear()
	if val["win"] == true:
		tab_result.current_tab = WIN_TAB
		if val["has_item_19"] == true:
			add_to_loot_list({
				"what": "coin",
				"amount": 1
				})
		
	else:
		tab_result.current_tab = LOSE_TAB
	pass

func add_to_loot_list(item):
	if item["what"] == "coin":
		loot_list.add_item(str(item["amount"]), TextureGlobal.TEX_ITEM_PASSIVE)
	pass

func _on_BackButton_pressed():
	get_parent().switch_tabs({"to_tab": "player"})
	pass # Replace with function body.
