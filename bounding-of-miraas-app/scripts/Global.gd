extends Node

enum DICE_SIGNS {
	Positive,
	Neutral,
	Negative
	}
	
enum ITEM_TYPES {
	Passive,
	Consumable,
	Dice
	}
	
const DEFAULT_TEXTURE = preload("res://icon.png")
	
const COLOR_ORANGE = Color(255, 165, 0, 1)
const COLOR_BLUE = Color(0, 0, 255, 1)
const COLOR_GRAY = Color(128, 128, 128, 1)

const ENEMY_POWER_TIMEOUT = 120

func get_color_for_sign(signn) -> Color:
	match signn:
		DICE_SIGNS.Positive:
			return COLOR_ORANGE
		DICE_SIGNS.Neutral:
			return COLOR_GRAY
		DICE_SIGNS.Negative:
			return COLOR_BLUE
	pass

func get_bb_code_for_sign(value, signn) -> String:
	match signn:
		DICE_SIGNS.Positive:
			return "[color=#FFA500]" + str(value) + "[/color] "
		DICE_SIGNS.Neutral:
			return "[color=#808080]" + str(value) + "[/color] "
		DICE_SIGNS.Negative:
			return "[color=#0000FF]" + str(value) + "[/color] "

func get_stringsign_for_sign(signn) -> String:
	match signn:
		DICE_SIGNS.Positive:
			return "+"
		DICE_SIGNS.Neutral:
			return ""
		DICE_SIGNS.Negative:
			return "-"
	pass

func get_color_for_stringsign(stringsign) -> Color:
	match stringsign:
		"+":
			return COLOR_ORANGE
		"":
			return COLOR_GRAY
		"-":
			return COLOR_BLUE
	pass

const ITEMS_LIST = [
{
	"id": 0,
	"name" : "Drobniaki",
	"dice": ["2", "2", "2", "2", "2"],
	"type": ITEM_TYPES.Dice
	},
{
	"id": 1,
	"name" : "Ying Yang",
	"dice": ["+6", "-6"],
	"type": ITEM_TYPES.Dice
	},
{
	"id": 2,
	"name" : "Trojkat",
	"dice": ["3", "+3", "-3"],
	"type": ITEM_TYPES.Dice
	},
{
	"id": 3,
	"name" : "RPG 101",
	"dice": ["20"],
	"type": ITEM_TYPES.Dice
	},
{
	"id": 4,
	"name" : "Jednoreki bandyta",
	"dice": ["50", "-20", "-20"],
	"type": ITEM_TYPES.Dice
	},
{
	"id": 5,
	"name" : "Szczescie",
	"dice": ["+7", "+3"],
	"type": ITEM_TYPES.Dice
	},
{
	"id": 6,
	"name" : "Pech",
	"dice": ["-6", "-4"],
	"type": ITEM_TYPES.Dice
	},
{
	"id": 7,
	"name" : "Piwko",
	"dice": ["18"],
	"type": ITEM_TYPES.Dice
	},
{
	"id": 8,
	"name" : "Kasztan",
	"dice": ["+10", "-5"],
	"type": ITEM_TYPES.Dice
	},
{
	"id": 9,
	"name" : "Sciaga",
	"dice": ["-10", "+5"],
	"type": ITEM_TYPES.Dice
	},
{
	"id": 10,
	"name" : "Kupione lajki",
	"effect" : "Kazdy parzysty rzut +1",
	"type": ITEM_TYPES.Passive
	},
{
	"id": 11,
	"name" : "Pozytywna reforma",
	"effect" : "Kazdy nieparzysty rzut -1",
	"type": ITEM_TYPES.Passive
	},
{
	"id": 12,
	"name" : "W kupie sila",
	"effect" : "Kazdy rzut k6 zamieniany na 3k2",
	"type": ITEM_TYPES.Passive
	},
{
	"id": 13,
	"name" : "Loteria",
	"effect" : "Jesli suma rzutu parzysta, podwajamy, jesli nie, polowimy",
	"type": ITEM_TYPES.Passive
	},
{
	"id": 14,
	"name" : "Sztuczka z moneta",
	"effect" : "Kazdy rzut k2 pomnoz przez 2",
	"type": ITEM_TYPES.Passive
	},
{
	"id": 15,
	"name" : "Jestes zwyciezca",
	"effect" : "Wartosc bezwzgledna z rzutu",
	"type": ITEM_TYPES.Consumable
	},
{
	"id": 16,
	"name" : "Punkt widzenia",
	"effect" : "Wynik mnozony przez -1",
	"type": ITEM_TYPES.Consumable
	},
{
	"id": 17,
	"name" : "All in",
	"effect" : "Odrzuc wynik, zsumuj kosci, i rzuc suma",
	"type": ITEM_TYPES.Consumable
	},
{
	"id": 18,
	"name" : "Duzo promili",
	"effect" : "Nie tracisz HP za przegranie tej walki",
	"type": ITEM_TYPES.Consumable
	},
{
	"id": 19,
	"name" : "500+",
	"effect" : "Wygrana walka daje 1 monete",
	"type": ITEM_TYPES.Passive
	},
{
	"id": 20,
	"name" : "Wytrych",
	"effect" : "Dziala jak klucz",
	"type": ITEM_TYPES.Consumable
	},
{
	"id": 21,
	"name" : "Plaster",
	"effect" : "Przywraca 1 HP",
	"type": ITEM_TYPES.Consumable
	}
]	

func get_item_values_for_id(item_id : int) -> Dictionary:
	for item in ITEMS_LIST:
		if item["id"] == item_id:
			return item
	return {} # TODO: should throw an error
	pass

enum ENEMY_TYPE {
	Normal,
	Boss,
	Player
}
	
const ENEMIES_LIST = [
{
	"id": 0,
	"name": "Moneciarz",
	"dice": ["2", "2", "2", "2", "2"],
	"sign": DICE_SIGNS.Neutral,
	"allowed_dice": [DICE_SIGNS.Neutral, DICE_SIGNS.Positive],
	"type": ENEMY_TYPE.Normal
	},
{
	"id": 1,
	"name": "Krzywooki",
	"dice": ["20", "-3"],
	"sign": DICE_SIGNS.Neutral,
	"allowed_dice": [DICE_SIGNS.Neutral, DICE_SIGNS.Positive, DICE_SIGNS.Negative],
	"type": ENEMY_TYPE.Normal
	},
{
	"id": 2, 
	"name": "Blyskotek", 
	"dice": ["6", "6", "+3", "+3"], 
	"sign": DICE_SIGNS.Neutral, 
	"allowed_dice": [DICE_SIGNS.Neutral, DICE_SIGNS.Positive],
	"type": ENEMY_TYPE.Normal
	},
{
	"id": 3,
	"name": "Deszczowiec",
	"dice": ["-7"],
	"sign": DICE_SIGNS.Negative,
	"allowed_dice": [DICE_SIGNS.Negative],
	"type": ENEMY_TYPE.Normal
	},
{
	"id": 4,
	"name": "Taplacz",
	"dice": ["3", "3", "3", "-10", "-10"],
	"sign": DICE_SIGNS.Negative,
	"allowed_dice": [DICE_SIGNS.Negative, DICE_SIGNS.Positive],
	"type": ENEMY_TYPE.Normal
	},
{
	"id": 5,
	"name": "Zlotoskrzydly",
	"dice": ["+6", "+6"],
	"sign": DICE_SIGNS.Positive,
	"allowed_dice": [DICE_SIGNS.Negative, DICE_SIGNS.Positive],
	"type": ENEMY_TYPE.Normal
	},
{
	"id": 6,
	"name": "Czteroskrzydly",
	"dice": ["5", "5", "5", "5"],
	"sign": DICE_SIGNS.Neutral,
	"allowed_dice": [DICE_SIGNS.Neutral],
	"type": ENEMY_TYPE.Normal
	},
{
	"id": 7,
	"name": "Kolekcjoner",
	"dice": ["2", "3", "4", "5", "6"],
	"sign": DICE_SIGNS.Neutral,
	"allowed_dice": [DICE_SIGNS.Neutral, DICE_SIGNS.Positive, DICE_SIGNS.Negative],
	"type": ENEMY_TYPE.Normal
	},
{
	"id": 101,
	"name": "Wladca much",
	"dice": ["15", "15"],
	"dice_phase_2": ["10", "+2", "+2", "+2", "+2", "+2"],
	"dice_phase_3": ["40", "-20"],
	"phase": 1,
	"sign": DICE_SIGNS.Neutral,
	"allowed_dice": [DICE_SIGNS.Neutral, DICE_SIGNS.Positive, DICE_SIGNS.Negative],
	"type": ENEMY_TYPE.Boss
	}
]

func get_enemy_for_id(item_id : int) -> Dictionary:
	for enemy in ENEMIES_LIST:
		if enemy["id"] == item_id:
			return enemy
	return {} # TODO: should throw an error
	pass