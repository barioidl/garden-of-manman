extends Node
class_name SpawnPoints

@onready var root=$'..'.root

func _init() -> void:
	name='spawn_point'

func _ready() -> void:
	owner = root
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
