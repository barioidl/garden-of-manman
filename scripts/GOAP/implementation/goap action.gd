extends Resource
class_name GOAPAction

func _process(delta: float) -> void:
	clean_cache(delta)


func _name()->StringName:
	return &'A default'

func is_valid(local_state:Dictionary)->bool:
	return true

func get_cost(local_state:Dictionary)->float:
	return 1


func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{}


func start(local_state: Dictionary):
	pass

func perform(local_state: Dictionary, dt: float)->bool:
	return true

func end(local_state: Dictionary):
	pass


var cache_valid := {}
var cache_cost := {}
var cache_cd := 0.0
func clean_cache(delta):
	if cache_cd > 0:
		cache_cd -= delta
		return
	cache_cd = randf_range(0.4,0.6)
	if !cache_valid.is_empty():
		cache_valid.clear()
	if !cache_cost.is_empty():
		cache_cost.clear()


var score:=0.0
var weights :=[]
func get_weight(id:int)-> float:
	var size := weights.size()
	if id >= size:
		for i in  1 + id - size:
			weights.append(1)
	return weights[id]

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
#	score = data.score


func _print(line):
	return
	print(line)
