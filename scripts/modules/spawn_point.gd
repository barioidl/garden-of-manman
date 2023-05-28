extends Node
class_name SpawnPoints

var root:Node3D

func _init() -> void:
	name='spawn_point'

func _enter_tree() -> void:
	root=$'..'.root
	owner = root
	root.set_meta(NL.respawn,Callable(respawn))

func _ready() -> void:
	root.add_to_group('spawn_point')
	position = root.global_position

var position:=Vector3.ZERO
func save():
	position = root.global_position
func respawn():
	root.global_position = position

#func save_file():
#	pass
#func load_file():
#	pass
