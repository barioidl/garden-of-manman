extends RayCast3D

var prev_pos:=Vector3.ZERO
@export var duration:=0.1
@export var offset:= 1.0
@export var ignore_distance:= 0.2

@onready var container := $".."
@onready var animation_player := $AnimationPlayer
var target:Node3D

func _ready() -> void:
	prev_pos = container.global_position
	enabled = false
	exclude_parent = false

var cd:=0.0
func _physics_process(delta: float) -> void:
	if cd>0:
		cd-=delta
		return
	cd = duration
	force_raycast_update()
	leg_offset()
	tween_target()

func leg_offset():
	var is_moving = prev_pos == container.global_position
	if is_moving:
		position = Vector3.ZERO
		return
	var pos :Vector3= container.to_local(prev_pos)
	position = -pos * offset
	prev_pos = container.global_position

func get_raycast_point()->Vector3:
	if is_colliding():
		return get_collision_point()
	return to_global(target_position)

func tween_target():
	var pos = get_raycast_point()
	var dist_sq =  target.global_position.distance_squared_to(pos)
	if dist_sq < ignore_distance:
		return
	var pos_tw = create_tween()
	pos_tw.tween_property(target, 'global_position', pos, duration)
	
	var rot = global_rotation
	var rot_tw = create_tween()
	rot_tw.tween_property(target,'global_rotation', rot, duration)

func play_state(_state:StringName, timescale:float, flip:=false)->bool:
	return animation_player.play_state(_state,timescale,flip)
