extends Node

var root:Node3D

func _init() -> void:
	name = NL.monster

func _enter_tree() -> void:
	root = get_parent().root

func _ready() -> void:
	root.add_to_group(NL.monster)
	
	var agent = Interface.get_goap_agent(root)
	agent.set_local_state(NL.preys,[NL.human])
	agent.set_local_state(NL.foods,[NL.meat])
	agent.set_local_state(NL.destination, root.global_position)
	
#	agent.set_local_state(NL.sight,20)
	agent.set_local_state(NL.motion_sense,5)
#	agent.set_local_state(NL.sound,20)
	
#	agent.set_local_state(NL.smell,1)
	
	queue_free()
