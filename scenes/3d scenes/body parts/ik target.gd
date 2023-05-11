extends Marker3D

#@onready var root = get_parent().root
@onready var raycast:RayCast3D=$"../RayCast3D"

var frame_updated:=false
func _process(delta: float) -> void:
	frame_updated=true
func _physics_process(delta: float) -> void:
	if frame_updated:
		frame_updated = false
		global_position = get_raycast_point()

func get_raycast_point()->Vector3:
	if raycast.is_colliding():
		return raycast.get_collision_point()
	return raycast.to_global(raycast.target_position)

#@export var ignore_distance:=0.05
#func step(_duration:float)-> bool:
#	var pos:=get_raycast_point()
#	var distance = global_position.distance_squared_to(pos)
#	if distance < ignore_distance * ignore_distance:
#		return false
#	global_rotation = raycast.global_rotation
#	var tween = create_tween()
#	tween.tween_property(self,'global_position', pos, _duration)
#	return true

