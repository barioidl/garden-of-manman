extends GOAPGoal
class_name GoalFlee

func _name() -> StringName:
	return &'G flee'

func is_valid(local_state:Dictionary)->bool:
	if !local_state.has(NL.predators):
		return false
	return true

func priority(local_state:Dictionary)->float:
	var root = local_state.root
	if cache_cost.has(root):
		return cache_cost[root]
	
	var root_pos :Vector3= root.global_position
	var predators = local_state[NL.predators]
	var target = ProximityTool.get_closest_node3d(predators, root_pos)
	if target == null: 
		_print('no predators?')
		cache_cost[root] = 0
		return 0
	
	var _range := 10.0 * get_weight(0)
	var dist = root_pos.distance_to(target.global_position)
	dist = 1 - clampf(dist/_range,0,1)
	var _priority = Curves.sample(4,4,dist)
	_priority *= get_weight(1)
	
	cache_cost[root] = _priority
	return _priority

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
