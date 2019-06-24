extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const LOSE_TAB = 0
const WIN_TAB = 1

var fight_manager
var can_steal_item : bool = false
var item_stolen : bool = false
var other_player_can_lose_hp : bool = false

onready var tab_result : TabContainer = find_node("TabResultCont")
onready var loot_list : ItemList = find_node("LootList")
onready var ui_item_19 : CenterContainer = find_node("item19labelcont")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(val: Dictionary):
	loot_list.clear()
	ui_item_19.visible = false
	item_stolen = false
	other_player_can_lose_hp = false
	if val["win"] == true:
		# win
		tab_result.current_tab = WIN_TAB
		if val["has_item_19"] == true:
			add_to_loot_list({
				"what": "coin",
				"value": 1
				})
		if val["created_die"] != "":
			add_to_loot_list({
				"what": "die",
				"value": val["created_die"]})
		if val.has("fighting_another_player"):
			if val["fighting_another_player"] == true:
				can_steal_item = true
				for item in fight_manager.other_player_manager.items:
					add_to_loot_list({
						"what": "item",
						"value": item})
				other_player_can_lose_hp = val["other_player_can_lose_hp"]
	else:
		# loss
		tab_result.current_tab = LOSE_TAB
		if val.has("has_item_18"):
			if val["has_item_18"] == true:
				# no health lost
				ui_item_19.visible = true
		other_player_can_lose_hp = false
	pass

func add_to_loot_list(item):
	match item["what"]:
		"coin":
			loot_list.add_item(str(item["value"]), TextureGlobal.TEX_ITEM_PASSIVE, false)
			loot_list.set_item_metadata(
			loot_list.get_item_count() - 1,
			-1)
		"die":
			loot_list.add_item(item["value"], TextureGlobal.TEX_DICE, false)
			loot_list.set_item_icon_modulate(
			loot_list.get_item_count() - 1,
			Global.get_color_for_stringsign(item["value"].left(item["value"].length()-1)))
			loot_list.set_item_metadata(
			loot_list.get_item_count() - 1,
			-1)
		"item":
			var itemm = item["value"]
			loot_list.add_item(itemm.to_string(), TextureGlobal.get_tex_for_item_type(itemm.type))
			var idx_added = loot_list.get_item_count() - 1
			loot_list.set_item_metadata(idx_added, itemm.id)
			loot_list.set_item_tooltip(idx_added, itemm.effect)
	pass

func ui_loot_list_clear_items():
	# Clear items, only coins remain (if there are any)
	var items_to_preserve = []
	for idx in loot_list.get_item_count():
		if loot_list.get_item_metadata(idx) == -1:
			var icon = loot_list.get_item_icon(idx)
			var text = loot_list.get_item_text(idx)
			var meta = loot_list.get_item_metadata(idx)
			items_to_preserve.append({
				"icon": icon,
				"text": text,
				"meta": meta
			})
	loot_list.clear()
	for item in items_to_preserve:
		loot_list.add_item(item["text"], item["icon"], false)
		loot_list.set_item_metadata(loot_list.get_item_count() - 1, item["meta"])
	pass

func _on_BackButton_pressed():
	if (not item_stolen) and other_player_can_lose_hp:
		fight_manager.other_player_manager.lower_hp_by_1()
	get_parent().switch_tabs({"to_tab": "player"})
	pass # Replace with function body.

func _on_LootList_item_activated(index):
	if can_steal_item:
		var item_id = loot_list.get_item_metadata(index)
		if item_id != -1:
			fight_manager.other_player_manager.remove_item_by_id(item_id)
			fight_manager.player_manager.add_new_item(item_id)
			item_stolen = true
			ui_loot_list_clear_items()
	pass # Replace with function body.
