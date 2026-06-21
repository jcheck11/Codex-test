extends RefCounted
class_name StarterModifierLibrary

static func build() -> Array[ModifierDefinition]:
	return [
		_create(&"Lucky Ink", "Adds +20 chips to every played hand.", "common", 4, "flat_chips", 20),
		_create(&"Loud Shoes", "Adds +2 multiplier to every played hand.", "common", 5, "flat_mult", 2),
		_create(&"Heartwood", "Each played Heart adds +12 chips.", "uncommon", 6, "suit_chips", 12, &"Hearts"),
		_create(&"Crowded Table", "Pairs gain +4 multiplier.", "uncommon", 7, "hand_mult", 4, &"", &"Pair"),
	]

static func _create(
	display_name: StringName,
	description: String,
	rarity: String,
	price: int,
	effect_type: String,
	amount: int,
	suit_filter: StringName = &"",
	hand_filter: StringName = &""
) -> ModifierDefinition:
	var modifier := ModifierDefinition.new()
	modifier.display_name = display_name
	modifier.resource_name = String(display_name)
	modifier.description = description
	modifier.rarity = rarity
	modifier.price = price
	modifier.sell_value = max(1, price / 2)
	modifier.effect_type = effect_type
	modifier.amount = amount
	modifier.suit_filter = suit_filter
	modifier.hand_filter = hand_filter
	return modifier
