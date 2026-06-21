extends Node
class_name RunController

signal blind_started(state: RunState)
signal blind_completed(state: RunState)
signal run_failed(state: RunState)

var state := RunState.new()
var deck := DeckManager.new()
var modifiers: Array = []

func start_new_run(seed_value: int = Time.get_unix_time_from_system()) -> void:
	RunRng.set_run_seed(seed_value)
	state.start(seed_value)
	deck.start_new_deck()
	deck.draw_cards(GameConfig.STARTING_HAND_SIZE)
	blind_started.emit(state)

func apply_score(score_result: Dictionary) -> void:
	state.score += score_result["total"]
	state.hands_remaining -= 1
	if state.score >= state.target_score:
		blind_completed.emit(state)
	elif state.hands_remaining <= 0:
		run_failed.emit(state)

func advance_blind() -> void:
	state.blind_index += 1
	if state.blind_index > 2:
		state.blind_index = 0
		state.ante += 1
	state.score = 0
	state.hands_remaining = GameConfig.STARTING_HANDS
	state.discards_remaining = GameConfig.STARTING_DISCARDS
	state.target_score = GameConfig.blind_target_for(state.ante, state.blind_index)
	blind_started.emit(state)
