extends GOAPGoal
class_name GoalHuntPrey

func _name() -> StringName:
	return &'G hunt prey'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.preys)

func priority(local_state:Dictionary)-> float:
	var root = local_state.root
	if cache_cost.has(root):
		return cache_cost[root]
	
	var pos :Vector3= root.global_position
	var preys = local_state[NL.preys]
	var prey = ProximityTool.get_closest_node3d(preys, pos)
	if prey == null: 
		cache_cost[root] = 0
		return 0
	
	var _range := 15.0 * get_weight(0)
	var dist = pos.distance_to(prey.global_position)
	dist = 1 - clampf(dist/_range,0,1)
	var _priority = Curves.sample(4,4,dist)
	_priority *= get_weight(1)
	
	cache_cost[root] = _priority
	return _priority

func get_result(local_state:Dictionary)->Dictionary:
	return{
		NL.prey_tension: 1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var agent = local_state.agent
	agent.loop_plan = true
	agent.set_local_state(NL.unique_steps,false)
	return true
