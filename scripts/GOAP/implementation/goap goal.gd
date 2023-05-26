extends Resource
class_name GOAPGoal

func _name() -> StringName:
	return 'G default'

func is_valid(local_state:Dictionary)->bool:
	return true

func priority(local_state:Dictionary)->float:
	return 1

func get_result(local_state:Dictionary)->Dictionary:
	return{}

func perform(local_state: Dictionary, dt: float)->bool:
	var agent = local_state.agent
	agent.loop_plan = false
	agent.set_local_state(NL.unique_steps,false)
	return true


var weights :={}
func get_weight(name:String)->float:
	if weights.has(name):
		return weights[name]
	weights[name] = 1
	return 1

func _save() ->Dictionary:
	return weights

func _load(data:Dictionary):
	weights = data
