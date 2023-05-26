extends Resource
class_name GOAPAction

func _name()->StringName:
	return 'A default'

func is_valid(local_state:Dictionary)->bool:
	return true

func get_cost(local_state:Dictionary)->float:
	return 1

func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{}

func perform(local_state: Dictionary, dt: float)->bool:
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
