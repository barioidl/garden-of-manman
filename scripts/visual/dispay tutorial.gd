extends Area3D

@export var line:="Press [keys] to do something"
enum actions{
	none, ui_accept,
	ui_up,ui_down,ui_left,ui_right,
	ctrl,shift,alt,tab,
	act,attack,skill,misc,
	inventory,drop,reload,flip,
}
@export var key:actions

func _ready() -> void:
	replace_placeholder()
	setup_mask()
	connect("body_entered",body_entered)
	monitorable = false
	monitoring = true

func body_entered(body:Node3D):
	if !body.is_in_group(NL.player):
		return
	Interface.show_dialogue(line)
	queue_free()

func setup_mask():
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_mask_value(8,true)

func replace_placeholder():
	if key == actions.none:
		line.replace('[keys]','')
		return
	var action = actions.keys()[key]
	var keys = get_button_keybinds(action)
	line = line.replace('[keys]',keys)

func get_button_keybinds(action)->String:
	var events = InputMap.action_get_events(action)
	var keys:=''
	for i in events.size():
		if i != 0:
			keys += ' or '
		var event = events[i]
		var input := ''
		if event is InputEventKey:
			input = OS.get_keycode_string(event.physical_keycode)
		elif event is InputEventMouseButton:
			input = event.as_text()
		elif event is InputEventJoypadButton:
			input = event.as_text().get_slice('(',1)
			input = input.rstrip(')')
		else:	continue
		keys+= input
	return keys
