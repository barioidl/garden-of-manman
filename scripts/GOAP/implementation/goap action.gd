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


var score:=0.0
var weights :={}
func get_weight(name:String)->float:
	if weights.has(name):
		_print('use existing weight')
		return weights[name]
	_print('use new weight')
	weights[name] = 1
	return 1

func _save():
	_print('saving goap action')
	var data :={}
	data.name = _name()
	data.weights = weights
	data.score = score
	Goap.save_mutations(data)

func _load():
	_print('loading goap action')
	var data := Goap.load_mutations(_name())
	if data.is_empty():
		return
	weights = data.weights
	score = data.score

func _print(line:String):
	return
	print(line)
