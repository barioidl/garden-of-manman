extends Node3D

func _ready() -> void:
	setup_panel()

func setup_panel():
	for i in get_child_count():
		var button = get_child(i)
		button.connect('pressed',button_pressed.bind(i))

func button_pressed(id:int):
	pass
