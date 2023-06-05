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
	add_to_group('lock')
	set_meta(NL.interact,interact)

func interact(item):
	if !accept_input:	return
	#simple overrides
	if open and easy_close:
		open = false
		start_cooldown()
		emit_signal("lock_updated",open)
		return
	
	var no_key:=false
	if item.is_in_group("key"):
		no_key = item.password == types.none
	var no_lock = password == types.none
	if no_lock or no_key:
		open = !open
		start_cooldown()
		emit_signal("lock_updated",open)
		return
	
	if !item.is_in_group("key"):
		return
	if item.password == password:
#		print("unlocked with key")
		open = !open
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
			return Color.INDIAN_RED
		types.green:
			return Color.MEDIUM_SEA_GREEN
		types.blue:
			return Color.CORNFLOWER_BLUE
		types.yellow:
			return Color.YELLOW
		types.purple:
			return Color.PURPLE
	return Color.WHITE
