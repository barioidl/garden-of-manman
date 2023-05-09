extends Node3D
@onready var root = get_parent().root
@export var step_duration :=0.2
var cool_down :=0.0

@export var legs_per_steps:=1
var current_leg:=-1
var total_legs:=0
@export var legs:=[]

func _ready() -> void:
	prev_pos=global_position
	
	total_legs = legs.size()
	for i in total_legs:
		var path = legs[i]
		if path is NodePath:
			legs[i] = get_node_or_null(path)

var time :=0.0
func _process(delta: float) -> void:
	time = delta
	foot_step()
	offset_footting()

func foot_step():
	cool_down -= time
	if cool_down >0:
		return
	cool_down = step_duration
	
	var leg_moved:=0
	for i in legs_per_steps:
		current_leg = wrapi(current_leg+1,0,total_legs)
		if legs[current_leg].step(step_duration):
			leg_moved += 1
	
	if leg_moved >0:
		move_body(step_duration)

@export var offset :=20.0
@onready var parent = get_parent()
var prev_pos:=Vector3.ZERO
func offset_footting():
	var velo = parent.global_position - prev_pos
	var end = parent.global_position+velo*offset
	global_position = global_position.lerp(end,time*10)
	prev_pos = parent.global_position

var body_pos:=Vector3.ZERO
@export var body_mid_pos:=Vector3(0,0,0.1)
@onready var body = $'../body'
func move_body(duration):
	duration *=0.5
	var tween = create_tween()
	body_pos = body.position
	var mid_pos = body_pos-body_mid_pos
	tween.tween_property(body,'position', mid_pos,duration)
	tween.tween_property(body,'position', body_pos,duration)
