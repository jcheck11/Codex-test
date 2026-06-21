extends Resource
class_name ConsumableDefinition

@export var display_name: StringName
@export_multiline var description: String = ""
@export var price: int = 3
@export_enum("upgrade_hand", "enhance_card", "add_card", "remove_card") var effect_type: String = "upgrade_hand"
@export var target_hand: StringName = &"High Card"
@export var enhancement: StringName = &"bonus"
@export var created_rank: StringName = &"Ace"
@export var created_suit: StringName = &"Hearts"

func apply(deck: DeckManager, hand_levels: HandLevels, selected_cards: Array[CardInstance]) -> bool:
	match effect_type:
		"upgrade_hand":
			hand_levels.upgrade(target_hand)
			return true
		"enhance_card":
			if selected_cards.is_empty():
				return false
			return deck.transform_card(selected_cards[0], enhancement)
		"add_card":
			deck.add_card(_create_card(deck))
			return true
		"remove_card":
			if selected_cards.is_empty():
				return false
			return deck.remove_card(selected_cards[0])
	return false

func _create_card(deck: DeckManager) -> CardInstance:
	var card := CardInstance.new()
	card.id = _next_card_id(deck)
	card.rank = created_rank
	card.suit = created_suit
	card.chip_value = 10
	return card

func _next_card_id(deck: DeckManager) -> int:
	var highest := 0
	for card in deck.all_live_cards():
		highest = max(highest, card.id)
	for card in deck.removed_cards:
		highest = max(highest, card.id)
	return highest + 1
