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

func is_lock_open(lock)->bool:
	return !lock.open

func _print(line):
#	return
	print(line)
