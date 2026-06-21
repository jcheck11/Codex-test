extends Node
class_name RunController

signal blind_started(state: RunState, blind: BlindDefinition)
signal blind_completed(state: RunState, reward_money: int)
signal shop_opened(inventory: Array[Resource])
signal run_failed(state: RunState)

var state := RunState.new()
var deck := DeckManager.new()
var modifiers: Array[ModifierDefinition] = []
var blinds: Array[BlindDefinition] = BlindDefinition.default_blinds()
var shop_pool := ShopPoolDefinition.starter_pool()

func start_new_run(seed_value: int = Time.get_unix_time_from_system()) -> void:
	RunRng.set_run_seed(seed_value)
	state.start(seed_value)
	deck.start_new_deck()
	deck.draw_cards(GameConfig.STARTING_HAND_SIZE)
	_start_current_blind()

func apply_score(score_result: Dictionary) -> void:
	state.score += score_result["total"]
	state.hands_remaining -= 1
	if state.score >= state.target_score:
		_complete_current_blind()
	elif state.hands_remaining <= 0:
		run_failed.emit(state)

func add_modifier(modifier: ModifierDefinition) -> void:
	if not modifiers.has(modifier):
		modifiers.append(modifier)

func sell_modifier(modifier: ModifierDefinition) -> bool:
	if not modifiers.has(modifier):
		return false
	modifiers.erase(modifier)
	state.money += modifier.sell_value
	return true

func open_shop() -> Array[Resource]:
	var inventory := shop_pool.roll_inventory(state.reroll_count)
	shop_opened.emit(inventory)
	return inventory

func buy_shop_item(item: Resource) -> bool:
	if item is ModifierDefinition and state.money >= item.price:
		state.money -= item.price
		add_modifier(item)
		return true
	return false

func reroll_shop() -> Array[Resource]:
	var cost := shop_pool.reroll_cost(state.reroll_count)
	if state.money < cost:
		return []
	state.money -= cost
	state.reroll_count += 1
	return open_shop()

func advance_blind() -> void:
	state.blind_index += 1
	if state.blind_index >= blinds.size():
		state.blind_index = 0
		state.ante += 1
	state.score = 0
	state.hands_remaining = GameConfig.STARTING_HANDS
	state.discards_remaining = GameConfig.STARTING_DISCARDS
	state.reroll_count = 0
	_start_current_blind()

func save_run() -> void:
	SaveService.save_run(state.to_save_data())

func load_run() -> bool:
	var data := SaveService.load_run()
	if data.is_empty():
		return false
	state.load_save_data(data)
	RunRng.set_run_seed(state.seed_value)
	_start_current_blind()
	return true

func _complete_current_blind() -> void:
	var reward := _current_blind().reward_money + max(0, state.hands_remaining)
	state.money += reward
	state.completed_blinds += 1
	blind_completed.emit(state, reward)
	open_shop()

func _start_current_blind() -> void:
	var blind := _current_blind()
	state.target_score = blind.target_for_ante(state.ante)
	blind_started.emit(state, blind)

func _current_blind() -> BlindDefinition:
	return blinds[state.blind_index]
