extends RayCast3D

var prev_pos:=Vector3.ZERO
@export var duration:=0.1
@export var offset:= 5.0
@onready var container := $".."
var target:Node3D

func _ready() -> void:
	prev_pos = container.global_position
	enabled = true
	exclude_parent = false

var cd:=0.0
func _physics_process(delta: float) -> void:
	leg_offset()
	if cd>0:
		cd-=delta
		return
	cd = duration
#	force_raycast_update()
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
	var tween = create_tween()
	tween.tween_property(target, 'global_position', pos, duration)
