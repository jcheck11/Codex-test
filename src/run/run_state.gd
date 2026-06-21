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

func start(seed_to_use: int) -> void:
	seed_value = seed_to_use
	ante = 1
	blind_index = 0
	money = GameConfig.STARTING_MONEY
	hands_remaining = GameConfig.STARTING_HANDS
	discards_remaining = GameConfig.STARTING_DISCARDS
	score = 0
	target_score = GameConfig.blind_target_for(ante, blind_index)
