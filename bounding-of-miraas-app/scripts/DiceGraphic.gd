extends HBoxContainer

const COLOR_ORANGE = Color(255, 165, 0, 1)
const COLOR_BLUE = Color(0, 0, 255, 1)
const COLOR_GRAY = Color(128, 128, 128, 1)

var dice_object

var dice_texture_node : TextureRect
var label_node : Label

func _ready():
	pass # Replace with function body.

func set_nodes_and_parameters(input_dice_object):
	dice_texture_node = $TextureRect
	label_node = $Label
	dice_object = input_dice_object
	dice_texture_node.modulate = get_color_for_tex()
	label_node.text = str(dice_object.dice_value) + dice_object.dice_sign
	pass

func get_color_for_tex() -> Color:
	match dice_object.dice_sign_enum:
		Global.DICE_SIGNS.Positive:
			return COLOR_ORANGE
		Global.DICE_SIGNS.Neutral:
			return COLOR_GRAY
		Global.DICE_SIGNS.Negative:
			return COLOR_BLUE
	pass
