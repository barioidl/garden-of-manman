extends GOAPGoal
class_name GoalOpenDoor

var _range := 10.0

func _name() -> StringName:
	return &'G open door'


func is_valid(local_state:Dictionary)->bool:
	var root :Node3D= local_state.root
	if cache_valid.has(root):
		return cache_valid[root]
	
	var keys := get_hotbar_keys(root)
	var _valid = !keys.is_empty()
	
	cache_valid[root] = _valid
	return _valid

func priority(local_state:Dictionary)->float:
	var root = local_state[NL.root]
	if cache_cost.has(root):
		return cache_cost[root]
	
	var keys := get_hotbar_keys(root)
	var pos :Vector3= root.global_position
	var closed_lock = ProximityTool.get_closest_node3d(NL.locks, pos, 1, is_lock_open.bind(keys))
	if closed_lock == null:
		cache_cost[root] = 0
		return 0
	
	var _priority = pos.distance_squared_to(closed_lock.global_position)
	_priority /= _range * _range
	_priority = 1 - clampf(_priority,0,1)
	_priority *= get_weight(0)
	_print('open door priority: ' + str(_priority))
	
	cache_cost[root] = _priority
	return _priority

func get_result(local_state:Dictionary)->Dictionary:
	return{
		NL.door_close: -1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var agent = local_state.agent
	agent.loop_plan = true
	agent.set_local_state(NL.unique_steps,false)
	return true


func get_hotbar_keys(root)->Array:
	var hotbar_items := Interface.get_hotbar_items(root)
	if hotbar_items.is_empty(): return []
	var result := []
	for key in hotbar_items:
		if key == null:	continue
		if !key.is_in_group(NL.keys):	continue
		result.append(key)
	return result

func is_lock_open(lock:Node, range:float, keys:Array)->bool:
	var password_matched := false
	for key in keys:
		if key.password != lock.password:	continue
		password_matched = true
	if !password_matched:
		return false
	return !lock.open


func _print(line):
	return
	print(line)
