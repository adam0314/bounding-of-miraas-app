extends Node

enum DICE_SIGNS {
	Positive,
	Neutral,
	Negative
	}
	
enum ITEM_TYPES {
	Passive,
	Consumable
	}
	
const COLOR_ORANGE = Color(255, 165, 0, 1)
const COLOR_BLUE = Color(0, 0, 255, 1)
const COLOR_GRAY = Color(128, 128, 128, 1)

func get_color_for_sign(signn) -> Color:
	match signn:
		DICE_SIGNS.Positive:
			return COLOR_ORANGE
		DICE_SIGNS.Neutral:
			return COLOR_GRAY
		DICE_SIGNS.Negative:
			return COLOR_BLUE
	pass
	
const ITEMS_LIST = [
[10, ITEM_TYPES.Passive, "parzysty wynik +1"],
[11, ITEM_TYPES.Passive, "nieparzysty wynik -1"],
[12, ITEM_TYPES.Passive, "kazda k6 => 3k2"],
[13, ITEM_TYPES.Passive, "suma parzysta ? *2 : /2"],
[14, ITEM_TYPES.Passive, "kazdy rzut k2 *2"],
[15, ITEM_TYPES.Consumable, "abs(rzut)"],
[16, ITEM_TYPES.Consumable, "wynik * -1"],
[17, ITEM_TYPES.Consumable, "sumuj kosci i rzuc jedna"],
[18, ITEM_TYPES.Consumable, "nie tracisz hp przy przegraniu"],
[19, ITEM_TYPES.Consumable, "wytrych"]
]

func get_item_values_for_id(item_id : int) -> Array:
	for item in ITEMS_LIST:
		if item[0] == item_id:
			return item
	return [] # TODO: should throw an error
	pass
	
const ENEMIES_LIST = [
{
	"id": 0,
	"name": "enemy id 0",
	"dice": ["2", "2", "2", "2", "2"],
	"type": DICE_SIGNS.Neutral,
	"allowed_dice": [DICE_SIGNS.Neutral, DICE_SIGNS.Positive]
	},
{
	"id": 1,
	"name": "enemy id 1",
	"dice": ["20", "3-"],
	"type": DICE_SIGNS.Neutral,
	"allowed_dice": [DICE_SIGNS.Neutral, DICE_SIGNS.Positive, DICE_SIGNS.Negative]
	},
{
	"id": 2, 
	"name": "enemy id 2", 
	"dice": ["6", "6", "3+", "3+"], 
	"type": DICE_SIGNS.Neutral, 
	"allowed_dice": [DICE_SIGNS.Neutral, DICE_SIGNS.Positive]
	},
{
	"id": 3,
	"name": "enemy id 3",
	"dice": ["7-"],
	"type": DICE_SIGNS.Neutral,
	"allowed_dice": [DICE_SIGNS.Negative]
	},
{
	"id": 4,
	"name": "enemy id 4",
	"dice": ["3", "3", "3", "10-", "10-"],
	"type": DICE_SIGNS.Negative,
	"allowed_dice": [DICE_SIGNS.Negative, DICE_SIGNS.Positive]
	},
{
	"id": 5,
	"name": "enemy id 5",
	"dice": ["6+", "6+"],
	"type": DICE_SIGNS.Positive,
	"allowed_dice": [DICE_SIGNS.Negative, DICE_SIGNS.Positive]
	},
{
	"id": 6,
	"name": "enemy id 6",
	"dice": ["5", "5", "5", "5"],
	"type": DICE_SIGNS.Neutral,
	"allowed_dice": [DICE_SIGNS.Neutral]
	},
{
	"id": 7,
	"name": "enemy id 7",
	"dice": ["2", "3", "4", "5", "6"],
	"type": DICE_SIGNS.Neutral,
	"allowed_dice": [DICE_SIGNS.Neutral, DICE_SIGNS.Positive, DICE_SIGNS.Negative]
	}
]

func get_enemy_for_id(item_id : int) -> Dictionary:
	for enemy in ENEMIES_LIST:
		if enemy["id"] == item_id:
			return enemy
	return {} # TODO: should throw an error
	pass