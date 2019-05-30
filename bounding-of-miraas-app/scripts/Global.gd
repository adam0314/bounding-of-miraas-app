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