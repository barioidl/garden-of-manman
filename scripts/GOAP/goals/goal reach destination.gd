extends GOAPGoal
class_name GoalReachDestination

func _name() -> StringName:
	return &'G reach destination'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.destination)

func priority(local_state:Dictionary)-> float:
	var root = local_state[NL.root]
	var pos :Vector3= root.global_position
	var destination = local_state[NL.destination]
	var _priority = pos.distance_squared_to(destination)
	if _priority <1:
		return 0
	return get_weight(0) * 0.2

func get_result(local_state:Dictionary)->Dictionary:
	return{
		NL.destination: 1,
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var agent = local_state.agent
	agent.loop_plan = true
	agent.set_local_state(NL.unique_steps,false)
	return true

func _print(line:String):
	return
	print(line)
