extends Resource
class_name RunState

@export var seed_value: int = 1
@export var ante: int = 1
@export var blind_index: int = 0
@export var money: int = 0
@export var hands_remaining: int = 0
@export var discards_remaining: int = 0
@export var score: int = 0
@export var target_score: int = 0
@export var reroll_count: int = 0
@export var completed_blinds: int = 0

func start(seed_to_use: int) -> void:
	seed_value = seed_to_use
	ante = 1
	blind_index = 0
	money = GameConfig.STARTING_MONEY
	hands_remaining = GameConfig.STARTING_HANDS
	discards_remaining = GameConfig.STARTING_DISCARDS
	score = 0
	reroll_count = 0
	completed_blinds = 0
	target_score = GameConfig.blind_target_for(ante, blind_index)

func to_save_data() -> Dictionary:
	return {
		"version": 1,
		"seed_value": seed_value,
		"ante": ante,
		"blind_index": blind_index,
		"money": money,
		"hands_remaining": hands_remaining,
		"discards_remaining": discards_remaining,
		"score": score,
		"target_score": target_score,
		"reroll_count": reroll_count,
		"completed_blinds": completed_blinds,
	}

func load_save_data(data: Dictionary) -> void:
	seed_value = data.get("seed_value", seed_value)
	ante = data.get("ante", ante)
	blind_index = data.get("blind_index", blind_index)
	money = data.get("money", money)
	hands_remaining = data.get("hands_remaining", hands_remaining)
	discards_remaining = data.get("discards_remaining", discards_remaining)
	score = data.get("score", score)
	target_score = data.get("target_score", target_score)
	reroll_count = data.get("reroll_count", reroll_count)
	completed_blinds = data.get("completed_blinds", completed_blinds)
