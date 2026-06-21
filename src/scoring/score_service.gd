extends RefCounted
class_name ScoreService

static func score(cards: Array[CardInstance], modifiers: Array = [], hand_levels: HandLevels = null) -> Dictionary:
	var hand_name := HandEvaluator.evaluate(cards)
	var base_values: Dictionary = GameConfig.HAND_BASE_VALUES[hand_name]
	var chips: int = base_values["chips"]
	var mult: int = base_values["mult"]
	var events: Array[Dictionary] = [{"source": hand_name, "chips": chips, "mult": mult}]
	if hand_levels:
		var level_bonus := hand_levels.bonus_for(hand_name)
		chips += level_bonus["chips"]
		mult += level_bonus["mult"]
		events.append({"source": "Hand Level %d" % level_bonus["level"], "chips": level_bonus["chips"], "mult": level_bonus["mult"]})
	for card in cards:
		var card_chips := card.scoring_chip_value()
		var card_mult := card.scoring_mult_bonus()
		chips += card_chips
		mult += card_mult
		var factor := card.scoring_mult_factor()
		if factor != 1.0:
			mult = int(ceil(mult * factor))
		events.append({"source": card.display_name(), "chips": card_chips, "mult": card_mult, "factor": factor})
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
