extends Node3D

@export var areas:Array
signal toggle_visibility(active)

func _ready() -> void:
	visible = true
	disable()
	connect_areas()

func connect_areas():
	for path in areas:
		var area = get_node_or_null(path)
		if area == null:
			_print("area is missing"+ str(path))
		else:
			area.connect('area_entered',_on_area_entered)
			area.connect('area_exited',_on_area_exited)

func _on_area_entered(body: Node3D) -> void:
	update_area(1)
func _on_area_exited(body: Node3D) -> void:
	update_area(-1)

var active_areas:=0
var is_active:=false
func update_area(delta):
	active_areas += delta
	var active = active_areas >0
	if active == is_active:
		return
	is_active = active
	emit_signal("toggle_visibility",active)
	if active:
		enable()
	else:
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
