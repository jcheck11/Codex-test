extends Control
class_name BlindController

signal played_cards(score_result: Dictionary)
signal discarded_cards(cards: Array[CardInstance])

var deck: DeckManager
var modifiers: Array = []
var selected_cards: Array[CardInstance] = []

func configure(next_deck: DeckManager, next_modifiers: Array) -> void:
	deck = next_deck
	modifiers = next_modifiers
	selected_cards.clear()

func toggle_card(card: CardInstance, selected: bool) -> void:
	if selected and selected_cards.size() < GameConfig.MAX_PLAYED_CARDS:
		selected_cards.append(card)
	elif not selected:
		selected_cards.erase(card)

func play_selected() -> Dictionary:
	var cards := selected_cards.duplicate()
	deck.play_cards(cards)
	var result := ScoreService.score(cards, modifiers)
	selected_cards.clear()
	played_cards.emit(result)
	return result

func discard_selected() -> void:
	var cards := selected_cards.duplicate()
	deck.discard_cards(cards)
	selected_cards.clear()
	discarded_cards.emit(cards)
