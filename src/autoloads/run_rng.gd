extends Node

var _rng := RandomNumberGenerator.new()
var current_seed: int = 1

func set_run_seed(seed_value: int) -> void:
	current_seed = seed_value
	_rng.seed = seed_value

func next_int(max_exclusive: int) -> int:
	return _rng.randi_range(0, max_exclusive - 1)

func shuffle_array(items: Array) -> Array:
	var shuffled := items.duplicate()
	for i in range(shuffled.size() - 1, 0, -1):
		var j := _rng.randi_range(0, i)
		var temp = shuffled[i]
		shuffled[i] = shuffled[j]
		shuffled[j] = temp
	return shuffled
