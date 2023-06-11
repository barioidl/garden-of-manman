extends GOAPGoal
class_name GoalReachDestination

var _range := 5

func _name() -> StringName:
	return &'G reach destination'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.destination)

func priority(local_state:Dictionary)-> float:
	return lerpf(0.2,0.5,get_weight(0)) 

func get_result(local_state:Dictionary)->Dictionary:
	return{
		NL.destination: 1,
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var agent = local_state.agent
	agent.loop_plan = false
	agent.set_local_state(NL.unique_steps,false)
	return true

func _print(line:String):
	return
	print(line)
