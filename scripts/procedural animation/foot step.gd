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
#	if leg_moved >1:
#		create_plane()

@export var offset :=20.0
@onready var parent = get_parent()
var prev_pos:=Vector3.ZERO
func offset_footting():
	var velo = parent.global_position - prev_pos
	var end = parent.global_position+velo*offset
	global_position = global_position.lerp(end,time*10)
	prev_pos = parent.global_position

signal  normal_changed(normal)
signal average_pos(position)
var normal_cooldown:=0.0
#func create_plane():
#	normal_cooldown-=time
#	if normal_cooldown >0:return
#	normal_cooldown = 0.1
#	var fl_pos = leg_top_left.global_position
#	var fr_pos = leg_top_right.global_position
#	var bl_pos = leg_bottom_left.global_position
#	var br_pos = leg_bottom_right.global_position
#
#	var plane1 = Plane(bl_pos, fl_pos,fr_pos)
#	var plane2 = Plane(fr_pos, br_pos, bl_pos)
#	var avg_normal :Vector3= plane1.normal.lerp(plane2.normal,0.5)
#	avg_normal = avg_normal.normalized()
#	emit_signal('normal_changed',avg_normal)
#	var avg_pos = (fl_pos+fr_pos+bl_pos+br_pos)*0.25
#	emit_signal('average_pos',avg_pos)
#	body.look_at(body.global_position+avg_normal,basis.z)

@export var body_pos:=Vector3(0,-0.5,0)
@export var body_mid_pos:=Vector3(0,0,0.1)
@onready var body = $'../body'
func move_body(duration):
	duration *=0.5
	var tween = create_tween()
	var mid_pos = body_pos-body_mid_pos
	tween.tween_property(body,'position', mid_pos,duration)
	tween.tween_property(body,'position', body_pos,duration)
