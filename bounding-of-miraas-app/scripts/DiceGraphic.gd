extends HBoxContainer

var dice_object

var dice_texture_node : TextureRect
var label_node : Label

func _ready():
	pass # Replace with function body.

func set_nodes_and_parameters(input_dice_object):
	dice_texture_node = $TextureRect
	label_node = $Label
	dice_object = input_dice_object
	dice_texture_node.modulate = Global.get_color_for_sign(dice_object.dice_sign_enum)
	label_node.text = input_dice_object.to_string()
	pass
