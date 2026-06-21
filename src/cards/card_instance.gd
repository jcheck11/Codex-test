extends Resource
class_name CardInstance

@export var id: int
@export var rank: StringName
@export var suit: StringName
@export var chip_value: int
@export var enhancement: StringName = &""
@export var seal: StringName = &""
@export var edition: StringName = &""

func display_name() -> String:
	return "%s of %s" % [rank, suit]

func scoring_chip_value() -> int:
	var value := chip_value
	if enhancement == &"bonus":
		value += 30
	if edition == &"foil":
		value += 50
	return value

func scoring_mult_bonus() -> int:
	var value := 0
	if enhancement == &"mult":
		value += 4
	if edition == &"holographic":
		value += 10
	return value

func scoring_mult_factor() -> float:
	var factor := 1.0
	if enhancement == &"glass":
		factor *= 2.0
	if edition == &"polychrome":
		factor *= 1.5
	return factor

func to_save_data() -> Dictionary:
	return {
		"id": id,
		"rank": String(rank),
		"suit": String(suit),
		"chip_value": chip_value,
		"enhancement": String(enhancement),
		"seal": String(seal),
		"edition": String(edition),
	}

static func from_save_data(data: Dictionary) -> CardInstance:
	var card := CardInstance.new()
	card.id = data.get("id", 0)
	card.rank = StringName(data.get("rank", ""))
	card.suit = StringName(data.get("suit", ""))
	card.chip_value = data.get("chip_value", 0)
	card.enhancement = StringName(data.get("enhancement", ""))
	card.seal = StringName(data.get("seal", ""))
	card.edition = StringName(data.get("edition", ""))
	return card
