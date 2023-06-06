extends Node

var root:Node3D

func _init() -> void:
	name = NL.monster

func _enter_tree() -> void:
	root = get_parent().root

func _ready() -> void:
	root.add_to_group(NL.monster)
	
	var agent = Interface.get_goap_agent(root)
	agent.set_local_state(NL.predators,[NL.monster])
	
	queue_free()
