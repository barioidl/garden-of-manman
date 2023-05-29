extends Node3D

var root:Node3D

func _init() -> void:
	name = 'body'
func _enter_tree() -> void:
	root = get_parent().root
	owner = root
	
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if root is RigidCharacter:
		root.custom_transform = global_transform
