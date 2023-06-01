extends GOAPGoal
class_name GoalFlee

func _name() -> StringName:
	return &'G flee'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.predators)

func priority(local_state:Dictionary)->float:
	var root = local_state.root
	var root_pos :Vector3= root.global_position
	var predators = local_state[NL.predators]
	var _range := 6.0 * get_weight(&'range')
	var proxi_tool :ProximityTool= local_state[NL.proximity_tool]
	var target = proxi_tool.get_closest_node3d(predators, root_pos, _range)
	if target == null:
		return 0
	var dist = root_pos.distance_to(target.global_position)
	dist = 1 - clampf(dist/_range,0,1)
	var priority = Curves.sample(4,2,dist)
	_print('distance to predator: ' + str(priority))
	return priority * get_weight(&'predator_distance')

func get_result(local_state:Dictionary)->Dictionary:
	return{
		NL.fear: -1
	}

#func _print(line:String):
#	print(line)
