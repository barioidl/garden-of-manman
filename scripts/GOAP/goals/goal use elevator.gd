extends GOAPGoal
class_name GoalUseElevator

func _name() -> StringName:
	return &'G use elevator'

func is_valid(self_state:Dictionary)->bool:
	return true

func priority(self_state:Dictionary)-> float:
	
	return 1

func get_result(self_state:Dictionary)->Dictionary:
	return{
		NL.hunger: -1,
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var agent = local_state.agent
	agent.loop_plan = true
	agent.set_local_state(NL.unique_steps,false)
	return true
