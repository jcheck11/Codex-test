extends Resource
class_name BlindDefinition

@export var display_name: StringName
@export var blind_index: int
@export var reward_money: int
@export var score_scale: float = 1.0
@export_multiline var rule_text: String = ""

func target_for_ante(ante: int) -> int:
	return int(GameConfig.blind_target_for(ante, blind_index) * score_scale)

static func default_blinds() -> Array[BlindDefinition]:
	return [
		_create(&"Small Blind", 0, 3, 1.0, "A baseline blind with no special rule."),
		_create(&"Big Blind", 1, 4, 1.0, "A larger score target with a better payout."),
		_create(&"Boss Blind", 2, 6, 1.1, "A boss blind placeholder for future rule mutations."),
	]

static func _create(display_name: StringName, blind_index: int, reward_money: int, score_scale: float, rule_text: String) -> BlindDefinition:
	var blind := BlindDefinition.new()
	blind.display_name = display_name
	blind.resource_name = String(display_name)
	blind.blind_index = blind_index
	blind.reward_money = reward_money
	blind.score_scale = score_scale
	blind.rule_text = rule_text
	return blind
