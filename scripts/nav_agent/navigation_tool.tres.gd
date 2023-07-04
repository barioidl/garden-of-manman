extends Node3D

@onready var agent := $NavigationAgent3D

var baked_paths := {}
var resolution := Vector3.ONE

var agent_3d:= preload("res://scripts/nav_agent/nav_agent.tscn")
var stack_agent_3d :=[]
var pool_size := 5

func _process(delta: float) -> void:
	cleanup_paths(delta)


func find_path(start:Vector3,end:Vector3)-> PathData:
	start = start.snapped(resolution)
	end = end.snapped(resolution)
	var key := str(start)+str(end)
	
	var path_data = baked_paths.get(key,false)
	if !(path_data is bool):
		_print('return baked path')
		return path_data
	
	global_position = start
	agent.target_position = end
	agent.get_next_path_position()
	
	var new_data = PathData.new()
	new_data.start = start
	new_data.end = end
	new_data.key = key
	new_data.path = agent.get_current_navigation_path()
	new_data.distance_to_end = agent.get_final_position().distance_to(end)
	baked_paths[key] = new_data
	_print('request new path')
	return new_data

var cleanup_cd := 0.0
var threshold := 10
func cleanup_paths(delta:float):
	if cleanup_cd > 0:
		cleanup_cd -= delta
		return
	cleanup_cd = 1
	
	var keys := baked_paths.keys()
	if keys.size() < threshold:
		return
	
	for key in keys:
		var path :PathData= baked_paths[key]
		if path.lifetime > 10:
			baked_paths.erase(key)
			continue
		path.lifetime += 1


func push_agent_3d(agent):
	if stack_agent_3d.size() > pool_size:
		agent.queue_free()
		return
	stack_agent_3d.push_back(agent)

func pop_agent_3d()-> Node:
	var available_agent = stack_agent_3d.pop_back()
	if available_agent != null:
		return available_agent
	var new_agent = agent_3d.instantiate()
	add_child(new_agent)
	return new_agent

func get_agent_3d()->Node:
	return pop_agent_3d()


func _print(line):
	print(line)
