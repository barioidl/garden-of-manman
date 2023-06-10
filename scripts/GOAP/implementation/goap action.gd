extends GOAPSaveLoad
class_name GOAPAction

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


func _print(line):
	return
	print(line)
