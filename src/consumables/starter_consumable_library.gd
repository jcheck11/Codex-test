extends RefCounted
class_name StarterConsumableLibrary

static func build() -> Array[ConsumableDefinition]:
	return [
		_create_upgrade(&"Pocket Notes", "Upgrade Pair by one level.", &"Pair"),
		_create_enhancement(&"Gold Stamp", "Add the bonus enhancement to a selected card.", &"bonus"),
		_create_enhancement(&"Stage Paint", "Add the mult enhancement to a selected card.", &"mult"),
		_create_add_card(&"Spare Ace", "Add an Ace of Hearts to the discard pile.", &"Ace", &"Hearts"),
	]

static func _create_upgrade(display_name: StringName, description: String, hand_name: StringName) -> ConsumableDefinition:
	var item := ConsumableDefinition.new()
	item.display_name = display_name
	item.resource_name = String(display_name)
	item.description = description
	item.effect_type = "upgrade_hand"
	item.target_hand = hand_name
	return item

static func _create_enhancement(display_name: StringName, description: String, enhancement: StringName) -> ConsumableDefinition:
	var item := ConsumableDefinition.new()
	item.display_name = display_name
	item.resource_name = String(display_name)
	item.description = description
	item.effect_type = "enhance_card"
	item.enhancement = enhancement
	return item

static func _create_add_card(display_name: StringName, description: String, rank: StringName, suit: StringName) -> ConsumableDefinition:
	var item := ConsumableDefinition.new()
	item.display_name = display_name
	item.resource_name = String(display_name)
	item.description = description
	item.effect_type = "add_card"
	item.created_rank = rank
	item.created_suit = suit
	return item
