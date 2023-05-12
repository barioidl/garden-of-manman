extends Marker3D

#var raycast:RayCast3D
#
#func _physics_process(delta: float) -> void:
#	if raycast == null: return
#	global_position = get_raycast_point()
#	global_rotation = raycast.global_rotation
#
#func get_raycast_point()->Vector3:
#	if raycast.is_colliding():
#		return raycast.get_collision_point()
#	return raycast.to_global(raycast.target_position)
