extends Node
class_name GOAPAction

func name()->StringName:
	return 'default action'

func is_valid(local_state:Dictionary)->bool:
	return true

func get_cost(local_state:Dictionary)->float:
	return 1

func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{}

func perform(local_state: Dictionary, dt: float)->bool:
	return false
