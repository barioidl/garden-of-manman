extends GOAPGoal
class_name GoalFindKey

func _name() -> StringName:
	return &'G find key'

func is_valid(local_state:Dictionary)->bool:
	return true

func priority(local_state:Dictionary)->float:
	var root = local_state.root
	if cache_cost.has(root):
		return cache_cost[root]
		
	var pos :Vector3= root.global_position
	var predators = local_state[NL.predators]
	var key = ProximityTool.get_closest_node3d(NL.keys, pos, 1,key_check)
	if key == null: 
		_print('no keys?')
		cache_cost[root] = 0
		return 0
	
	var _range := 10.0 * get_weight(0)
	var dist = pos.distance_to(key.global_position)
	dist = 1 - clampf(dist/_range,0,1)
	var _priority = Curves.sample(4,4,dist)
	_priority *= get_weight(1)
	
	cache_cost[root] = _priority
	return _priority

func get_result(local_state:Dictionary)->Dictionary:
	return{
		NL.has_key: 1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var agent = local_state.agent
	agent.loop_plan = false
	agent.set_local_state(NL.unique_steps,false)
	return true

func key_check(key:Node)->bool:
	return key.is_in_overworld

func _print(line):
#	return
	print(line)
