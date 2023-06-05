extends Node

var root:Node3D
@onready var stats : = get_parent()

@export var accel_offset := 5.0
@export var accel_range := 50.0
@export var accel_damage := 20.0

var prev_pos:=Vector3.ZERO
var prev_velocity := 0.0

func _enter_tree() -> void:
	root = get_parent().root

func _ready() -> void:
	prev_pos = root.global_position

func _physics_process(delta: float) -> void:
	calculate_speed(delta)

var cd := 0.0
func calculate_speed(delta):
	cd += delta
	if cd < 0.1:
		return
	var duration := cd
	cd = 0
	
	var pos = root.global_position
	if pos.is_equal_approx(prev_pos):
		return
	var velocity := pos.distance_squared_to(prev_pos) / duration
	prev_pos =  root.global_position
	
	if velocity == prev_velocity:
		return
	var accel = absf(velocity - prev_velocity)
	prev_velocity = velocity
	
	if accel < accel_offset:
		return
	accel -= accel_offset
	accel = accel / accel_range * accel_damage
	if accel < 0.5:
		return
	
	stats.change_health(-round(accel))
