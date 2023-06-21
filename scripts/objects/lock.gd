extends StaticBody3D
class_name Lock

enum types{none,generic,red,green,blue,yellow,purple}
@export var password:types
@export var easy_close:=false

@export var cooldown:=0.5
var accept_input:=true
@export var open:=false
signal lock_updated(state)

func _ready() -> void:
	emit_signal("lock_updated",open)
#	add_to_group('tool_tip')
	add_to_group(NL.locks)
	
	set_meta(NL.interact,interact)

func interact(item):
	if !accept_input:
		return
	if open and easy_close:
		_print('closed door without key')
		lock_close()
		return
	
	var item_is_key = item.is_in_group(NL.keys)
	var no_key := false
	if item_is_key:
		no_key = item.password == types.none
	if password == types.none or no_key:
		_print('override door')
		lock_toggle()
		return
	
	if !item_is_key:	return
	if item.password == password:
		_print("unlocked with key")
		lock_toggle()

func lock_toggle():
	open = !open
	start_cooldown()
	emit_signal("lock_updated",open)

func lock_open():
	open = true
	start_cooldown()
	emit_signal("lock_updated",open)

func lock_close():
	open = false
	start_cooldown()
	emit_signal("lock_updated",open)


func start_cooldown():
	accept_input = false
	var timer := get_tree().create_timer(cooldown)
	timer.connect("timeout",end_cooldown.bind())
func end_cooldown():
	accept_input = true

func get_color(_pass)->Color:
	match _pass:
		types.none:
			return Color.BLACK
		types.generic:
			return Color.GHOST_WHITE
		types.red:
			return Color.RED
		types.green:
			return Color.GREEN
		types.blue:
			return Color.BLUE
		types.yellow:
			return Color.YELLOW
		types.purple:
			return Color.PURPLE
	return Color.WHITE


func _print(line):
	return
	print(line)
