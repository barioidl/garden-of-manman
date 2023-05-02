extends Marker3D
@onready var root = get_parent().root
@onready var step_raycast:RayCast3D=$'..'
@export var step_distance:=1.0

@export var step_height :=1.0
func step(duration:float)-> bool:
	var target_pos:=Vector3.ZERO
	if step_raycast.is_colliding():
		target_pos = step_raycast.get_collision_point()
	else:
		target_pos = step_raycast.to_global( step_raycast.target_position)
	var distance = global_position.distance_to(target_pos)
	if distance < step_distance:
		return false
	var half_way = global_position.lerp(target_pos,0.5)
	var time = duration*0.5
	var tween = create_tween()
	tween.tween_property(self,'global_position', half_way + owner.global_transform.basis.y * step_height, time)
	tween.tween_property(self,'global_position', target_pos, time)
	global_rotation = step_raycast.global_rotation
	return true
