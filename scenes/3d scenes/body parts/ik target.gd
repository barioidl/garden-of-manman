extends Marker3D

#@onready var root = get_parent().root
@onready var raycast:RayCast3D=$"../RayCast3D"

@export var duration :=0.05
@export var ignore_distance:=0.05
#func _ready() -> void:
#	top_level = true
#	call_deferred()

#var cd:=0.0
#func _physics_process(delta: float) -> void:
#	if cd >0:
#		cd -= delta
#		return
#	cd = duration
#	raycast.force_raycast_update()
#	step(duration)
#	raycast.enabled = true

func step(_duration:float)-> bool:
	var pos:=get_raycast_point()
	var distance = global_position.distance_squared_to(pos)
	if distance < ignore_distance * ignore_distance:
		return false
	global_rotation = raycast.global_rotation
	var tween = create_tween()
	tween.tween_property(self,'global_position', pos, _duration)
	return true

func get_raycast_point()->Vector3:
	if raycast.is_colliding():
		return raycast.get_collision_point()
	return raycast.to_global(raycast.target_position)
