extends Node3D

@onready var root = get_parent().root

func _init() -> void:
	name = 'body'
func _ready() -> void:
	owner = root
