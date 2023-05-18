extends Node
class_name GOAPAction

func name()->StringName:
	return 'default action'

func is_valid(self_state:Dictionary)->bool:
	return true

func get_cost(self_state:Dictionary)->int:
	return 10

func get_inputs(self_state:Dictionary)->Dictionary:
	return{}

func get_outputs(self_state:Dictionary)->Dictionary:
	return{}

func perform(local_state: Dictionary, dt: float)->bool:
	return false
