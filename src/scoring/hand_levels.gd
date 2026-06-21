extends Resource
class_name HandLevels

var levels := {}

func level_for(hand_name: StringName) -> int:
	return levels.get(hand_name, 1)

func upgrade(hand_name: StringName, amount: int = 1) -> int:
	var next_level := level_for(hand_name) + amount
	levels[hand_name] = max(1, next_level)
	return levels[hand_name]

func bonus_for(hand_name: StringName) -> Dictionary:
	var level := level_for(hand_name)
	return {
		"chips": (level - 1) * 10,
		"mult": (level - 1),
		"level": level,
	}

func to_save_data() -> Dictionary:
	var data := {}
	for hand_name in levels.keys():
		data[String(hand_name)] = levels[hand_name]
	return data

func load_save_data(data: Dictionary) -> void:
	levels.clear()
	for hand_name in data.keys():
		levels[StringName(hand_name)] = data[hand_name]
