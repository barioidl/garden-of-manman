extends Area3D

@export var brightness := 1.0
@export var oxygen := 1.0
@export var pressure := 1.0
@export var temperature := 25.0
@export var moisture := 0.0


@export var enable_on_load:= false
signal toggle_visibility(active)

func _ready() -> void:
	connect_signals()
	setup_mask()
	if enable_on_load:
		enable()
	else:
		disable()

func connect_signals():
	connect('body_entered',_on_body_entered)
	connect('body_exited',_on_body_exited)
	
	connect('area_entered',_on_area_entered)
	connect('area_exited',_on_area_exited)

func setup_mask():
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_mask_value(8,true)


func _on_body_entered(body: Node3D) -> void:
	add_character(body)

func _on_body_exited(body: Node3D) -> void:
	remove_character(body)

func _on_area_entered(body: Node3D) -> void:
	emit_signal("toggle_visibility",true)
	enable()

func _on_area_exited(body: Node3D) -> void:
	emit_signal("toggle_visibility",false)
	disable()


func enable():
	visible = true
	for node in get_children():
		node.process_mode = Node.PROCESS_MODE_INHERIT

func disable():
	visible = false
	for node in get_children():
		node.process_mode = Node.PROCESS_MODE_DISABLED

func add_character(body):
	if !body.is_in_group(NL.character):
		return
	body.set_meta(NL.get_room,get_room)
	_print('added character')

func remove_character(body):
	if !body.is_in_group(NL.character):
		return
	if !body.has_meta(NL.get_room):
		return
	if body.get_meta(NL.get_room) != get_room:
		return
	body.remove_meta(NL.get_room)
	_print('removed character')

func get_room()->Node:
	return self



func _print(line:String):
#	return
	print(line)
