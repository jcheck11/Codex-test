extends Resource
class_name ModifierDefinition

@export var display_name: StringName
@export_multiline var description: String = ""
@export_enum("common", "uncommon", "rare") var rarity: String = "common"
@export var price: int = 4
@export var sell_value: int = 2
@export_enum("flat_chips", "flat_mult", "suit_chips", "hand_mult") var effect_type: String = "flat_chips"
@export var amount: int = 0
@export var suit_filter: StringName = &""
@export var hand_filter: StringName = &""

func applies_to(cards: Array[CardInstance], hand_name: StringName) -> bool:
	match effect_type:
		"suit_chips":
			for card in cards:
				if card.suit == suit_filter:
					return true
			return false
		"hand_mult":
			return hand_name == hand_filter
		_:
			return true

func apply_score(cards: Array[CardInstance], hand_name: StringName, chips: int, mult: int) -> Dictionary:
	if not applies_to(cards, hand_name):
		return {"source": display_name, "chips": chips, "mult": mult, "applied": false}
	match effect_type:
		"flat_chips":
			chips += amount
		"flat_mult":
			mult += amount
		"suit_chips":
			for card in cards:
				if card.suit == suit_filter:
					chips += amount
		"hand_mult":
			mult += amount
	return {"source": display_name, "chips": chips, "mult": mult, "applied": true}
