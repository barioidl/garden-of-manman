extends GOAPAction
class_name ActionWaitForElevator

func _name()->StringName:
	return &'A wait for elevator'

func is_valid(local_state:Dictionary)->bool:
	return true

func get_cost(local_state:Dictionary)->float:
	return 1
 
func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.can_enter_elevator:1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	
	return true
