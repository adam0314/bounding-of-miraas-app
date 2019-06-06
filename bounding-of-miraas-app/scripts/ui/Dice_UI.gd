extends ItemList

var dice_dic = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_item_and_its_data(die):
	self.add_item(die.to_string(), TextureGlobal.TEX_DICE)
	var idx_added = self.get_item_count() - 1
	self.set_item_icon_modulate(idx_added, Global.get_color_for_sign(die.dice_sign_enum))
	self.set_item_metadata(idx_added, idx_added)
	self.set_item_tooltip(
	idx_added,
	die.to_string() + ": " + ("Startowa" if die.item_id == -1 else Global.get_item_values_for_id(die.item_id)["name"]))
	dice_dic.append({"die": die, "ui_id": idx_added})
	pass
