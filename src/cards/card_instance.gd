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
