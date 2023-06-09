extends Node
class_name GOAPGoal

func _process(delta: float) -> void:
	clean_cache(delta)

func _name() -> StringName:
	return &'G default'

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


var cache_valid := {}
var cache_priority := {}
var cache_cd := 0.0
func clean_cache(delta):
	if cache_cd > 0:
		cache_cd -= delta
		return
	cache_cd = 0.4
	if !cache_valid.is_empty():
		cache_valid.clear()
		cache_cd += 0.1
	if !cache_priority.is_empty():
		cache_priority.clear()
		cache_cd += 0.1


var score:=0.0
var weights :=[]
func get_weight(id:int)-> float:
	var size := weights.size()
	if id >= size:
		for i in  1 + id - size:
			weights.append(1)
	return weights[id]

func _save():
	_print('saving goap goal')
	var data :={}
	data.name = _name()
	data.weights = weights
	data.score = score
	Goap.save_mutations(data)

func _load():
	_print('loading goap goal')
	var data := Goap.load_mutations(_name())
	if data.is_empty():
		return
	weights = data.weights
	score = data.score

func _print(line):
	return
	print(line)
