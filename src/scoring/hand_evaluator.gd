extends RefCounted
class_name HandEvaluator

const RANK_ORDER := {
	&"Ace": 14, &"King": 13, &"Queen": 12, &"Jack": 11, &"10": 10, &"9": 9, &"8": 8,
	&"7": 7, &"6": 6, &"5": 5, &"4": 4, &"3": 3, &"2": 2,
}

static func evaluate(cards: Array[CardInstance]) -> StringName:
	if cards.is_empty():
		return &"High Card"
	var rank_counts := _counts_for(cards, "rank")
	var suit_counts := _counts_for(cards, "suit")
	var counts := rank_counts.values()
	counts.sort()
	counts.reverse()
	var is_flush := suit_counts.size() == 1 and cards.size() >= 5
	var is_straight := _is_straight(cards)
	if is_flush and is_straight:
		return &"Straight Flush"
	if counts[0] == 4:
		return &"Four of a Kind"
	if counts[0] == 3 and counts.size() > 1 and counts[1] == 2:
		return &"Full House"
	if is_flush:
		return &"Flush"
	if is_straight:
		return &"Straight"
	if counts[0] == 3:
		return &"Three of a Kind"
	if counts[0] == 2 and counts.size() > 1 and counts[1] == 2:
		return &"Two Pair"
	if counts[0] == 2:
		return &"Pair"
	return &"High Card"

static func _counts_for(cards: Array[CardInstance], property: String) -> Dictionary:
	var counts := {}
	for card in cards:
		var value = card.get(property)
		counts[value] = counts.get(value, 0) + 1
	return counts

static func _is_straight(cards: Array[CardInstance]) -> bool:
	if cards.size() < 5:
		return false
	var ranks: Array[int] = []
	for card in cards:
		ranks.append(RANK_ORDER[card.rank])
	ranks.sort()
	if ranks == [2, 3, 4, 5, 14]:
		return true
	for index in range(1, ranks.size()):
		if ranks[index] != ranks[index - 1] + 1:
			return false
	return true
