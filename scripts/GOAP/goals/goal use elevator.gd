extends GOAPGoal
class_name GoalUseElevator

var _range := 5

func _name() -> StringName:
	return &'G use elevator'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.destination)

func priority(local_state:Dictionary)-> float:
	var root = local_state.root
	if cache_priority.has(root):
		return cache_priority[root]
	
	if !local_state.has(NL.destination):
		cache_priority[root] = 0
		return 0
	var destination :Vector3= local_state[NL.destination]
	var delta_y = root.global_position.y - destination.y
	delta_y = absf(delta_y / _range)
	delta_y = clampf(delta_y,0,1)
	delta_y = Curves.sample(1,4,delta_y)
	delta_y *= 0.6 * get_weight(0)
	
	cache_priority[root] = delta_y
	return delta_y

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
