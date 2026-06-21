extends Control

@export var menu_scene: PackedScene = preload("res://scenes/screens/MainMenu.tscn")
@export var run_scene: PackedScene = preload("res://scenes/run/RunController.tscn")

var current_child: Node

func _ready() -> void:
	show_main_menu()

func show_main_menu() -> void:
	_set_child(menu_scene.instantiate())

func start_run(seed_value: int = Time.get_unix_time_from_system()) -> void:
	var run := run_scene.instantiate() as RunController
	_set_child(run)
	run.start_new_run(seed_value)

func _set_child(node: Node) -> void:
	if current_child:
		current_child.queue_free()
	current_child = node
	add_child(current_child)
