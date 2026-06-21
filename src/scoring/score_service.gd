extends RefCounted
class_name ScoreService

static func score(cards: Array[CardInstance], modifiers: Array = []) -> Dictionary:
	var hand_name := HandEvaluator.evaluate(cards)
	var base_values: Dictionary = GameConfig.HAND_BASE_VALUES[hand_name]
	var chips: int = base_values["chips"]
	var mult: int = base_values["mult"]
	var events: Array[Dictionary] = [{"source": hand_name, "chips": chips, "mult": mult}]
	for card in cards:
		chips += card.chip_value
		events.append({"source": card.display_name(), "chips": card.chip_value, "mult": 0})
	for modifier in modifiers:
		if modifier.has_method("apply_score"):
			var result: Dictionary = modifier.apply_score(cards, hand_name, chips, mult)
			chips = result.get("chips", chips)
			mult = result.get("mult", mult)
			events.append(result)
	return {
		"hand": hand_name,
		"chips": chips,
		"mult": mult,
		"total": chips * mult,
		"events": events,
	}
