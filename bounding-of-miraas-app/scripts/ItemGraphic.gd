extends HBoxContainer

var item_object

var item_texture_node : TextureRect
var type_label_node : Label
var effect_label_node : Label

func _ready():
	pass # Replace with function body.

func set_nodes_and_parameters(input_item_object):
	item_texture_node = $TextureRect
	type_label_node = $Type
	effect_label_node = $Effect
	item_object = input_item_object
	item_texture_node.modulate = Global.get_color_for_sign(item_object.item_type)
	type_label_node.text = get_text_for_item_type()
	effect_label_node.text = item_object.item_effect_description
	pass

func get_color_for_tex() -> Color:
	match item_object.item_type:
		Global.ITEM_TYPES.Passive:
			return Global.COLOR_ORANGE
		Global.ITEM_TYPES.Consumable:
			return Global.COLOR_BLUE
	pass

func get_text_for_item_type() -> String:
	match item_object.item_type:
		Global.ITEM_TYPES.Passive:
			return "Passive"
		Global.ITEM_TYPES.Consumable:
			return "Consumable"