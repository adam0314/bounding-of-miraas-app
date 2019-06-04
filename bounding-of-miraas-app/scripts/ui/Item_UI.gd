extends ItemList

#var item_dic = []
const TEXTURE_DICE = preload("res://textures/dice.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("item_selected", get_node("../../HBoxContainer/ButtonRemoveItem"), "_on_DirectItemContainer_item_selected")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func add_item_and_its_data(item):
	self.add_item(item.to_string(), TEXTURE_DICE if item.type == Global.ITEM_TYPES.Dice else Global.DEFAULT_TEXTURE)
	var idx_added = self.get_item_count() - 1
	self.set_item_metadata(idx_added, item.id)
	self.set_item_tooltip(idx_added, item.effect)
	#item_dic.append({"item": item, "ui_id": idx_added})
	pass
