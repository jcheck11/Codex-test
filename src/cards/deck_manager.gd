extends RefCounted
class_name DeckManager

var draw_pile: Array[CardInstance] = []
var hand: Array[CardInstance] = []
var discard_pile: Array[CardInstance] = []
var played_pile: Array[CardInstance] = []
var removed_cards: Array[CardInstance] = []

static func create_standard_deck() -> Array[CardInstance]:
	var cards: Array[CardInstance] = []
	var next_id := 1
	for suit in GameConfig.BASE_DECK_SUITS:
		for rank_index in range(GameConfig.BASE_DECK_RANKS.size()):
			var card := CardInstance.new()
			card.id = next_id
			card.rank = GameConfig.BASE_DECK_RANKS[rank_index]
			card.suit = suit
			card.chip_value = min(rank_index + 1, 10)
			cards.append(card)
			next_id += 1
	return cards

func start_new_deck() -> void:
	draw_pile = RunRng.shuffle_array(create_standard_deck())
	hand.clear()
	discard_pile.clear()
	played_pile.clear()
	removed_cards.clear()

func draw_cards(count: int) -> Array[CardInstance]:
	var drawn: Array[CardInstance] = []
	for _i in range(count):
		if draw_pile.is_empty():
			reshuffle_discards()
		if draw_pile.is_empty():
			break
		var card := draw_pile.pop_back() as CardInstance
		hand.append(card)
		drawn.append(card)
	return drawn

func play_cards(cards: Array[CardInstance]) -> void:
	for card in cards:
		if hand.has(card):
			hand.erase(card)
			played_pile.append(card)

func discard_cards(cards: Array[CardInstance]) -> void:
	for card in cards:
		if hand.has(card):
			hand.erase(card)
			discard_pile.append(card)

func cleanup_played_cards() -> void:
	discard_pile.append_array(played_pile)
	played_pile.clear()

func reshuffle_discards() -> void:
	draw_pile = RunRng.shuffle_array(discard_pile)
	discard_pile.clear()
