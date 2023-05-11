extends RayCast3D

@export var offset:=10.0
@onready var container :Node3D= get_parent()

func get_raycast_point()->Vector3:
	if is_colliding():
		return get_collision_point()
	return to_global(target_position)
