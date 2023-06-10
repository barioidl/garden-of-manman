extends GOAPGoal
class_name GoalOpenDoor

func _name() -> StringName:
	return &'G open door'

func is_valid(local_state:Dictionary)->bool:
#	var agent :GOAPAgent= local_state.agent
#	var door = agent.get_closest_node3d(NL.door,10)
	return true

func priority(local_state:Dictionary)->float:
	var root = local_state[NL.root]
	if cache_cost.has(root):
		return cache_cost[root]
	
	var keys := get_hotbar_keys(root)
	var key_count := keys.size()
	_print('key count: ' + str(key_count))
	if key_count <= 0:
		return 0
	
	var pos = root.global_position
	var closed_lock = ProximityTool.get_closest_node3d(NL.locks, pos, 1, is_lock_open)
	if closed_lock == null:
		return 0
#	_print(closed_lock.get_path())
	
	return 0

func get_result(local_state:Dictionary)->Dictionary:
	return{
		NL.door_close: -1
	}

func get_hotbar_keys(root)->Array:
	var hotbar_items := Interface.get_hotbar_items(root)
	if hotbar_items.is_empty(): return []
	_print('hotbar item size: ' + str(hotbar_items.size()))
	var result := []
	for key in hotbar_items:
		if key == null:	continue
		if !key.is_in_group(NL.keys):	continue
		result.append(key)
	return result


func is_lock_open(lock)->bool:
	return !lock.open

func _print(line):
#	return
	print(line)
