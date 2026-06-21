extends Node

const STARTING_HAND_SIZE := 8
const MAX_PLAYED_CARDS := 5
const STARTING_HANDS := 4
const STARTING_DISCARDS := 3
const STARTING_MONEY := 4
const BASE_DECK_SUITS := [&"Hearts", &"Diamonds", &"Clubs", &"Spades"]
const BASE_DECK_RANKS := [
	&"Ace", &"2", &"3", &"4", &"5", &"6", &"7", &"8", &"9", &"10", &"Jack", &"Queen", &"King"
]

const HAND_BASE_VALUES := {
	&"High Card": {"chips": 5, "mult": 1},
	&"Pair": {"chips": 10, "mult": 2},
	&"Two Pair": {"chips": 20, "mult": 2},
	&"Three of a Kind": {"chips": 30, "mult": 3},
	&"Straight": {"chips": 30, "mult": 4},
	&"Flush": {"chips": 35, "mult": 4},
	&"Full House": {"chips": 40, "mult": 4},
	&"Four of a Kind": {"chips": 60, "mult": 7},
	&"Straight Flush": {"chips": 100, "mult": 8},
}

func blind_target_for(ante: int, blind_index: int) -> int:
	var base_target := 300 * max(1, ante)
	return int(base_target * (1.0 + (blind_index * 0.5)))
