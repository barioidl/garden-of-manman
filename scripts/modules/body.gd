extends Node3D

@onready var root=$".."

func _init() -> void:
	name = 'body'
func _ready() -> void:
	owner = root

func _process(delta: float) -> void:
	root.custom_transform = global_transform
