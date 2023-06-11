extends GOAPGoal
class_name GoalUseElevator

var _range := 5

func _name() -> StringName:
	return &'G use elevator'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.destination)

func priority(local_state:Dictionary)-> float:
	var root = local_state.root
	if cache_cost.has(root):
		return cache_cost[root]
	
	if !local_state.has(NL.destination):
		cache_cost[root] = 0
		return 0
	var destination :Vector3= local_state[NL.destination]
	var _priority = root.global_position.y - destination.y
	_priority = absf(_priority / _range)
	_priority = Curves.sample(1,4,_priority)
	_priority = clampf(_priority - 0.2,0,1) * get_weight(0)
	
	cache_cost[root] = _priority
	return _priority

func get_result(local_state:Dictionary)->Dictionary:
	return{
		NL.height_difference: -1,
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var agent = local_state.agent
	agent.loop_plan = false
	agent.set_local_state(NL.unique_steps,false)
	return true

func _print(line:String):
	return
	print(line)
