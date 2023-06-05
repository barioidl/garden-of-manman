extends Node
var root:Node3D

@export var is_human:=false
@export var is_monster:=false

func _enter_tree() -> void:
	root = get_parent().root
func _ready() -> void:
	assign_groups()

func assign_groups():
	if is_human:
		root.add_to_group(NL.human)
	if is_monster:
		root.add_to_group(NL.monster)
	
