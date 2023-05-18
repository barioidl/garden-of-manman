extends Node3D

var agent_3d:= preload("res://scripts/nav_agent/nav_agent.tscn")
var stack_agent_3d :=[]
var pool_size := 5

func push_agent_3d(agent):
	if stack_agent_3d.size() > pool_size:
		agent.queue_free()
		return
	stack_agent_3d.append(agent)

func pop_agent_3d()-> Node3D:
	var available_agent = stack_agent_3d.pop_back()
	if available_agent != null:
		return available_agent
	var new_agent = agent_3d.instantiate()
	add_child(new_agent)
	return new_agent

func get_agent_3d()->Node3D:
	return pop_agent_3d()
