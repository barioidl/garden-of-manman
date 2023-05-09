extends Node
class_name Platformer

@export var horizontal_speed:=5.0

@export var fall_speed = 0.3

@export var can_walk:=true
@export var walk_speed:=1.0

@export var can_sneak:=true
@export var sneak_speed:=0.8
var sneak_bungee :=0.0

@export var can_sprint:=true
@export var sprint_speed:=1.25

@export var can_jump:=true
@export var jump_speed:=0.9
@export var jump_height :=5.0
@export var jump_bungee := 0.1
@export var extra_jumps :=1
var jump_counter :=0
#---------------------------------
@onready var root=$'..'.root
@onready var input = $'../inputs'

enum states{off=0,walk,sneak,sprint,jump,fall}
var state := states.off
var old_state := state
signal on_state_changed(state:states)
func _init() -> void:
	name = 'platformer'
func _ready():
	owner = root
	input.connect( "jump_pressed", trigger_jump.bind())
	root.set_meta( NameList.delay_platformer, Callable(delay_platformer))
	
func delay_platformer(duration):
	cool_down = duration

var cool_down :=0.0
var time:=0.0
func _process(delta):
	time = delta
	if root == null: return
	if input == null: return
	
	if cool_down >0:
		cool_down -=time
		return
	choose_state()

	if state != old_state:
		old_state = state
		emit_signal(NameList.on_state_changed,state)

var jump_pressed := false
func trigger_jump():
#	print("trigger jump")
	jump_pressed = true

func choose_state():
	var direction :Vector2= input.dpad1
	var is_moving:bool = direction != Vector2.ZERO
	var is_on_floor:bool = root.on_floor
	var is_falling:bool= root.inverted_velocity.y < 0 
	
	if can_sneak or sneak_bungee > 0:
		sneak_bungee -=time
		var sneak_hold = input.shift == true
		if sneak_hold:
			if is_moving:
				var velocity := walk(direction,horizontal_speed* sneak_speed)
				root.local_velocity = velocity
				play_step_sound(1/sneak_speed)
			state = states.sneak
			sneak_bungee = 0.5
			return
	
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
			jump_bungee -= time
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
	
	if is_falling and !is_on_floor:
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
	
	if can_walk:
		if is_moving:
			var velocity := walk(direction,horizontal_speed* walk_speed)
			root.local_velocity = velocity
			play_step_sound(1/walk_speed)
		state = states.walk
		return
	
	state = states.off

func walk(dir:Vector2, speed:float)->Vector3:
	var output = Vector3.ZERO
	output.x = dir.x * speed
	output.z = dir.y * speed
	return output

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
		step_cd -=time
		return
	step_cd = speed*step_speed
	var pos = root.global_position
	AudioPool.create_sound_3d(pos,step_sfx)
