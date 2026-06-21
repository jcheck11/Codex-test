extends Button
class_name CardView

signal card_selected(card: CardInstance, selected: bool)
signal card_hovered(card: CardInstance)

var card: CardInstance

func bind_card(next_card: CardInstance) -> void:
	card = next_card
	text = card.display_name()
	tooltip_text = text

func _ready() -> void:
	toggled.connect(_on_toggled)
	mouse_entered.connect(_on_mouse_entered)

func _on_toggled(is_selected: bool) -> void:
	card_selected.emit(card, is_selected)

func _on_mouse_entered() -> void:
	card_hovered.emit(card)
