extends RichTextLabel


func _ready():
	clear()
	pass
	
func clear_log():
	clear()
	bbcode_text = ""
	pass
	
func print_throws(throws, sum = ""):
	var textt = ""
	for t in throws:
		textt += format_throw(t) + " "
	if str(sum) != "":
		textt += "(" + str(sum) + ")"
	textt += "\n"
	bbcode_text += textt

func print_line(line : String):
	bbcode_text += (line + "\n")
	pass

func format_throw(throw) -> String:
	match throw["sign"]:
		Global.DICE_SIGNS.Positive:
			return "[color=#FFA500]" + str(throw["value"]) + "[/color]"
		Global.DICE_SIGNS.Neutral:
			return "[color=#808080]" + str(throw["value"]) + "[/color]"
		Global.DICE_SIGNS.Negative:
			return "[color=#0000FF]" + str(throw["value"]) + "[/color]"
	pass