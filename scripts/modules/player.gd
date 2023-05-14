extends Node3D
class_name Player

@onready var camera3d = $Camera3D
var character:Node3D
var input:Node
var head:Node3D

@export var mouse_speed = 3
@export var joypad_speed = 1.5
var invert_x :=1
var invert_y :=1

func _ready():
	camera3d.current = true

func attach_to(_character):
	character = _character
	character.add_to_group(NameList.player)
	input = character.get_node('inputs')
	head = character.get_node('body/head')

var time:=0.0
func _process(delta):
	time = delta
	copy_head_transform()
	reset_dpad2()

#func _physics_process(delta):
#	cursor_cast()
#	get_keys()

func copy_head_transform():
	if head == null: return
	position = head.global_position
	rotation = head.global_rotation

var event:InputEvent
func _input(_event):
	if(input == null):return
	event = _event
	get_movement()
	crosshair_move()
#	cursor_raycast()
	
	key_update()
	mouse_update()
	get_keys()

var main_keys_updated:=false
var interact_keys_updated:=false
var mgr_keys_updated:=false
func key_update():
	if !event is InputEventKey and !event is InputEventJoypadButton:
		return
	if event.is_echo(): return
	main_keys_updated = true
	interact_keys_updated = true
	mgr_keys_updated = true

func mouse_update():
	if !event is InputEventMouseButton:	return
	interact_keys_updated = true

func get_keys():
	if main_keys_updated:
		main_keys_updated = false
		get_main_keys()
	if interact_keys_updated:
		interact_keys_updated = false
		get_interact_keys()
	if mgr_keys_updated:
		mgr_keys_updated = false
		get_management_keys()

func get_main_keys():
	assign_button("jump","ui_accept")
	
	assign_button("ctrl","ctrl")
	assign_button("shift","shift")
	assign_button("alt","alt")
	assign_button("tab","tab")

func get_interact_keys():
	assign_button("act","act")
	assign_button("attack","attack")
	assign_button("skill","skill")
	assign_button("misc","misc")

func get_management_keys():
	assign_button("inventory","inventory")
	assign_button("drop","drop")
	assign_button("reload","reload")
	assign_button("flip","flip")

func assign_button(button:String,action:String):
	if !event.is_action(action):return
	if Input.is_action_pressed(action):
		input.set(button,true)
		if Input.is_action_just_pressed(action):
			input.emit_signal(button+"_pressed")
	else:
		input.set(button,false)
		if Input.is_action_just_released(action):
			input.emit_signal(button+"_released")

func get_movement():
	if event is InputEventKey:
		input.dpad1 = -Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		return
	if event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_LEFT_X:
			input.dpad1.x = event.axis_value
		if event.axis == JOY_AXIS_LEFT_Y:
			input.dpad1.y = event.axis_value
		return

var reset_dpad_2:=0
func reset_dpad2():
	if input == null: return
	if reset_dpad_2 < -2: return
	reset_dpad_2-=1
	if reset_dpad_2 > 0: return
	input.dpad2 = Vector2.ZERO

func crosshair_move():
	reset_dpad_2 = 2
	if event is InputEventMouseMotion:
		var head_rotate = event.relative.y 
		head_rotate*= mouse_speed*invert_x
		var body_rotate =  event.relative.x 
		body_rotate*= mouse_speed*invert_y
		input.dpad2 = Vector2(-body_rotate,head_rotate)
		return
	
	if event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_RIGHT_X:
			input.dpad2.x = event.axis_value 
			input.dpad2.x *= time * joypad_speed*invert_x
			return
		if event.axis == JOY_AXIS_RIGHT_Y:
			input.dpad2.y = event.axis_value 
			input.dpad2.y *= time * joypad_speed*invert_y
			return

#const RAY_LENGTH = 50.0
#func cursor_raycast(event:InputEvent):
#	if !event.is_echo(): 
#		cursor_cast_updated = false
#	if event is InputEventMouseMotion:
#		cursor_position = event.position
#
#var cursor_position:=Vector2.ONE
#var cursor_cast_updated:=false
#func cursor_cast():
#	var set_target = attach_to.get_meta('set_target')
#	if set_target == null:return
#	if cursor_cast_updated: return
#	cursor_cast_updated = true
#	var rc_from:Vector3=camera3d.project_ray_origin(cursor_position)
#	var rc_to:Vector3=rc_from + camera3d.project_ray_normal(cursor_position) * RAY_LENGTH
#	# use global coordinates, not local to node	
#	var space_state = get_world_3d().direct_space_state
#	var query = PhysicsRayQueryParameters3D.create(rc_from, rc_to)
#	var result = space_state.intersect_ray(query)
#	if !result.has('collider'):
#		result.collider = null
#	result.start_point = rc_from
#	result.end_point = rc_to
#	set_target.call(result)
