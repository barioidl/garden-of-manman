extends GOAPGoal
class_name GoalFlee

func _name() -> StringName:
	return &'G flee'

func is_valid(local_state:Dictionary)->bool:
	if !local_state.has(NL.predators):
		return false
	if !local_state.has(NL.proximity_tool):
		return false
	return true

func priority(local_state:Dictionary)->float:
	var root = local_state.root
	var root_pos :Vector3= root.global_position
	var predators = local_state[NL.predators]
	
	var _range := 5.0 * get_weight(0)
	var proxi_tool :ProximityTool= local_state[NL.proximity_tool]
	var target = proxi_tool.get_closest_node3d(predators, root_pos, _range)
	if target == null: return 0
	
	var dist = root_pos.distance_to(target.global_position)
	dist = 1 - clampf(dist/_range,0,1)
	var priority = Curves.sample(5,7,dist)
	return priority * get_weight(1)

func get_result(local_state:Dictionary)->Dictionary:
	return{
		NL.fear: -1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var agent = local_state.agent
	agent.loop_plan = true
	agent.set_local_state(NL.unique_steps,false)
	return true

func _print(line:String):
	return
	print(line)
