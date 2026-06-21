extends Control

signal new_run_requested

func _ready() -> void:
	$VBoxContainer/NewRunButton.pressed.connect(_on_new_run_pressed)

func _on_new_run_pressed() -> void:
	new_run_requested.emit()
	var root := get_parent()
	if root and root.has_method("start_run"):
		root.start_run()
