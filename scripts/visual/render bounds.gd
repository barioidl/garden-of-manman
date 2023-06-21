extends Area3D

@export var enable_on_load:= false
signal toggle_visibility(active)

func _ready() -> void:
	visible = true
	connect_areas()
	setup_mask()
	if enable_on_load:
		enable()
	else:
		disable()

func connect_areas():
	connect('area_entered',_on_area_entered)
	connect('area_exited',_on_area_exited)

func setup_mask():
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_mask_value(8,true)


func _on_area_entered(body: Node3D) -> void:
	emit_signal("toggle_visibility",true)
	enable()

func _on_area_exited(body: Node3D) -> void:
	emit_signal("toggle_visibility",false)
	disable()

func enable():
	for node in get_children():
		node.process_mode = Node.PROCESS_MODE_INHERIT
		node.visible = true

func disable():
	
	for node in get_children():
		node.process_mode = Node.PROCESS_MODE_DISABLED
		node.visible = false


func _print(line:String):
	return
	print(line)
