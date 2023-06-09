extends GOAPAction
class_name ActionWaitForElevator

func _name()->StringName:
	return &'A wait for elevator'

func is_valid(local_state:Dictionary)->bool:
	return true

func get_cost(local_state:Dictionary)->float:
	return get_weight(0)
 
func get_inputs(local_state:Dictionary)->Dictionary:
	return{
		NL.elevator_closed:-1
	}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.can_enter_elevator:1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root :Node3D= local_state.root
	var pos = root.global_position
	var door = ProximityTool.get_closest_node3d(NL.elevator_doors, pos)
	if door == null:	return false
	if !door.get_meta(NL.is_open).call():
		return false

	_print('wait completed')
	return true

func _print(line):
	return
	print(line)
