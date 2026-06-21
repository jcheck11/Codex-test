extends PanelContainer
class_name ModifierSlot

var modifier: Resource

func bind_modifier(next_modifier: Resource) -> void:
	modifier = next_modifier
	tooltip_text = modifier.resource_name if modifier else "Empty modifier slot"
