extends Node
class_name Inputs

@onready var root = get_parent().root

func _init() -> void:
	name = 'inputs'

func _ready() -> void:
	owner = root
	root.set_meta(NL.get_inputs, Callable(get_inputs))

func get_inputs()->Inputs:
	return self

var dpad1:=Vector2.ZERO
var dpad2:=Vector2.ZERO

signal jump_pressed
signal jump_released
var jump := false

signal act_pressed
signal act_released
var act := false
signal attack_pressed
signal attack_released
var attack := false
signal skill_pressed
signal skill_released
var skill := false
signal misc_pressed
signal misc_released
var misc := false

signal ctrl_pressed
signal ctrl_released
var ctrl := false
signal shift_pressed
signal shift_released
var shift := false
signal alt_pressed
signal alt_released
var alt := false
signal tab_pressed
signal tab_released
var tab := false

signal inventory_pressed
signal inventory_released
var inventory := false
signal drop_pressed
signal drop_released
var drop := false
signal reload_pressed
signal reload_released
var reload := false
signal flip_pressed
signal flip_released
var flip := false

func reset():
	dpad1 = Vector2.ZERO
	dpad2 = Vector2.ZERO
	jump = false
	
	act = false
	attack = false
	skill = false
	misc = false
	
	ctrl = false
	shift = false
	alt = false
	tab = false
	
	inventory = false
	drop = false
	reload = false
	flip = false
