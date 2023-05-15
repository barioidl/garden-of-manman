extends Node
class_name Platformer

@onready var root = get_parent().root
@onready var input = $'../inputs'


@export var horizontal_speed:=5.0

@export var fall_speed = 0.3

@export var can_walk:=true
@export var walk_speed:=1.0

@export var can_sneak:=true
@export var sneak_speed:=0.8

@export var can_sprint:=true
@export var sprint_speed:=1.25

@export var can_jump:=true
@export var jump_speed:=0.9
@export var jump_height :=5.0
@export var jump_bungee := 0.1
@export var extra_jumps :=1
var jump_counter :=0


enum states{idle=0,walk,sneak,sprint,jump,fall}
var state := states.idle
var old_state := state
signal on_state_changed(state:states)
func _init() -> void:
	name = 'platformer'
func _ready():
	owner = root
	input.connect( "jump_pressed", trigger_jump.bind())
	set_interface()

var cool_down :=0.0
var dt:=0.0
func _process(delta):
	dt = delta
	if root == null: return
	if input == null: return
	
	if cool_down >0:
		cool_down -=dt
		return
	choose_state()
	if state != old_state:
		old_state = state
		start_signal(state)

var jump_pressed := false
func trigger_jump():
	jump_pressed = true

func choose_state():
	var direction :Vector2= input.dpad1
	var is_moving:bool = direction != Vector2.ZERO
	var is_on_floor:bool = root.on_floor
	var is_falling:bool= root.inverted_velocity.y < 0 
	
	if can_jump:
		var jump_on = input.jump == true
		var is_jumping = state == states.jump
		var jump_strength :=0.0
		#conditions
		if is_on_floor and jump_pressed:
#			print("jump")
			jump_strength = 1
			jump_bungee = 0.4
			jump_counter = 1
			play_jump_sound()
		if jump_counter <= extra_jumps:
			if !is_on_floor and is_falling and jump_pressed:
#				print("extra jump")
				jump_strength = 0.9
				jump_bungee = 0.4
				jump_counter += 1
				play_jump_sound()
		if jump_bungee >0:
			jump_bungee -= dt
			if is_jumping:
				if jump_on or jump_pressed:
					jump_strength = 0.8
#					print("bungee jumping")
		jump_pressed = false
		#action
		if jump_strength > 0:
#			print("jump!")
			var velocity := walk(direction,horizontal_speed* jump_speed)
			velocity.y = jump_height*jump_strength
			root.local_velocity = velocity
			state = states.jump
			return
	
	if !is_on_floor:
#		if is_falling:
		if is_moving:
			var velocity := walk(direction,horizontal_speed* fall_speed)
			root.local_velocity = velocity
		state = states.fall
		return
	
	if can_sprint:
		var sprint_hold = input.ctrl == true
		if sprint_hold:
			if is_moving:
				var velocity := walk(direction,horizontal_speed* sprint_speed)
				root.local_velocity = velocity
				play_step_sound(1/sprint_speed)
				state = states.sprint
				return
		
	if can_sneak:
		var sneak_hold = input.shift == true
		if sneak_hold:
			if is_moving:
				var velocity := walk(direction,horizontal_speed* sneak_speed)
				root.local_velocity = velocity
				play_step_sound(1/sneak_speed)
			state = states.sneak
			return
		
	if can_walk:
		if is_moving:
			var velocity := walk(direction, horizontal_speed * walk_speed)
			root.local_velocity = velocity
			play_step_sound(1/walk_speed)
			state = states.walk
			return
	
	state = states.idle

func walk(dir:Vector2, speed:float)->Vector3:
	var output = Vector3.ZERO
	output.x = dir.x * speed
	output.z = dir.y * speed
	return output

func start_signal(state):
	var state_name
	match state:
		states.idle:
			state_name = NameList.idle
		states.walk:
			state_name = NameList.walk
		states.sneak:
			state_name = NameList.sneak
		states.sprint:
			state_name = NameList.sprint
		states.jump:
			state_name = NameList.jump
		states.fall:
			state_name = NameList.fall
#	print(state_name)
	emit_signal(NameList.on_state_changed, state_name)


func set_interface():
	root.set_meta(NameList.delay_platformer, Callable(delay_platformer))
	
	root.set_meta(NameList.walk_to_target, Callable(walk_to_target))
	root.set_meta(NameList.sneak_to_target, Callable(sneak_to_target))
	root.set_meta(NameList.sprint_to_target, Callable(sprint_to_target))
	root.set_meta(NameList.jump_to_target, Callable(jump_to_target))

func delay_platformer(duration):
	cool_down = duration

func walk_to_target(target:Vector3):
	dpad_from_position(target)
	input.shift = false
	input.ctrl = false
	input.jump = false
func sneak_to_target(target:Vector3):
	dpad_from_position(target)
	input.shift = true
	input.ctrl = false
	input.jump = false
func sprint_to_target(target:Vector3):
	dpad_from_position(target)
	input.shift = false
	input.ctrl = true
	input.jump = false
func jump_to_target(target:Vector3):
	dpad_from_position(target)
	input.shift = false
	input.ctrl = false
	input.jump = true
	input.emit_signal('jump_pressed')

func dpad_from_position(target:Vector3):
	var trans = root.custom_transform.inverse()
	var target_local = trans * target
#	body.to_local(target)
	var dpad1 := Vector2(target_local.x,target_local.z)
	if dpad1 != Vector2.ZERO:
		input.dpad1 = dpad1.limit_length(1)



@export_category('audio')
@export var step_speed=0.25
@export var jump_sfx:AudioList
@export var step_sfx:AudioList

func play_jump_sound():
	var pos = root.global_position
	AudioPool.create_sound_3d(pos,jump_sfx)

var step_cd:=0.0
func play_step_sound(speed):
	if step_cd >0:
		step_cd -=dt
		return
	step_cd = speed*step_speed
	var pos = root.global_position
	AudioPool.create_sound_3d(pos,step_sfx)
