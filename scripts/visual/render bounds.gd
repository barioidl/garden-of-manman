extends Area3D

@export var brightness := 1.0
@export var oxygen := 20
@export var pressure := 100
@export var temperature := 25
@export var moisture := 10


@export var enable_on_load:= false
signal toggle_visibility(active)

func _ready() -> void:
	connect_signals()
	set_layers_masks()
	if enable_on_load:
		enable()
	else:
		disable()

func connect_signals():
	connect('body_entered',_on_body_entered)
	connect('body_exited',_on_body_exited)
	
	connect('area_entered',_on_area_entered)
	connect('area_exited',_on_area_exited)

func set_layers_masks():
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
	body.set_meta(NL.get_room,get_room)
	_print('added character')

func remove_character(body):
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
