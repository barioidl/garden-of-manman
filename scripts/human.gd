extends Node

var root:Node3D

func _init() -> void:
	name = NL.human

func _enter_tree() -> void:
	root = get_parent().root

func _ready() -> void:
	root.add_to_group(NL.human)
	
	var agent = Interface.get_goap_agent(root)
	agent.set_local_state(NL.predators,[NL.monster])
	agent.set_local_state(NL.foods,[NL.meat])
	queue_free()
