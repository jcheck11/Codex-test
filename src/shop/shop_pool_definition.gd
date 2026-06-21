extends Resource
class_name ShopPoolDefinition

@export var base_reroll_cost: int = 3
@export var slots: int = 3
@export var weighted_items: Array[Resource] = []

func roll_inventory(reroll_count: int = 0) -> Array[Resource]:
	var available := weighted_items.duplicate()
	var rolled: Array[Resource] = []
	while rolled.size() < slots and not available.is_empty():
		var index := RunRng.next_int(available.size())
		rolled.append(available[index])
		available.remove_at(index)
	return rolled

func reroll_cost(reroll_count: int) -> int:
	return base_reroll_cost + reroll_count

static func starter_pool() -> ShopPoolDefinition:
	var pool := ShopPoolDefinition.new()
	pool.weighted_items.assign(StarterModifierLibrary.build())
	pool.weighted_items.append_array(StarterConsumableLibrary.build())
	return pool
