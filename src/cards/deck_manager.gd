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

func all_live_cards() -> Array[CardInstance]:
	var cards: Array[CardInstance] = []
	cards.append_array(draw_pile)
	cards.append_array(hand)
	cards.append_array(discard_pile)
	cards.append_array(played_pile)
	return cards

func add_card(card: CardInstance, to_discard := true) -> void:
	if to_discard:
		discard_pile.append(card)
	else:
		draw_pile.append(card)

func remove_card(card: CardInstance) -> bool:
	for zone in [draw_pile, hand, discard_pile, played_pile]:
		if zone.has(card):
			zone.erase(card)
			removed_cards.append(card)
			return true
	return false

func transform_card(card: CardInstance, enhancement: StringName = &"", seal: StringName = &"", edition: StringName = &"") -> bool:
	if not all_live_cards().has(card):
		return false
	if enhancement != &"":
		card.enhancement = enhancement
	if seal != &"":
		card.seal = seal
	if edition != &"":
		card.edition = edition
	return true

func to_save_data() -> Dictionary:
	return {
		"draw_pile": _serialize_cards(draw_pile),
		"hand": _serialize_cards(hand),
		"discard_pile": _serialize_cards(discard_pile),
		"played_pile": _serialize_cards(played_pile),
		"removed_cards": _serialize_cards(removed_cards),
	}

func load_save_data(data: Dictionary) -> void:
	draw_pile = _deserialize_cards(data.get("draw_pile", []))
	hand = _deserialize_cards(data.get("hand", []))
	discard_pile = _deserialize_cards(data.get("discard_pile", []))
	played_pile = _deserialize_cards(data.get("played_pile", []))
	removed_cards = _deserialize_cards(data.get("removed_cards", []))

func _serialize_cards(cards: Array[CardInstance]) -> Array[Dictionary]:
	var serialized: Array[Dictionary] = []
	for card in cards:
		serialized.append(card.to_save_data())
	return serialized

func _deserialize_cards(serialized: Array) -> Array[CardInstance]:
	var cards: Array[CardInstance] = []
	for data in serialized:
		cards.append(CardInstance.from_save_data(data))
	return cards
