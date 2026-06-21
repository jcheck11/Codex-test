extends Resource
class_name BlindDefinition

@export var display_name: StringName
@export var blind_index: int
@export var reward_money: int
@export_multiline var rule_text: String = ""

func target_for_ante(ante: int) -> int:
	return GameConfig.blind_target_for(ante, blind_index)
