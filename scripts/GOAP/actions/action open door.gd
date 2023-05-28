extends GOAPAction
class_name ActionOpenDoor

func _name()->StringName:
	return &'A open door'

func is_valid(local_state:Dictionary)->bool:
	return true

func get_cost(local_state:Dictionary)->float:
	return 1
 
func get_inputs(local_state:Dictionary)->Dictionary:
	return{
		NL.has_key:1
	}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.exploration:1
	}

func perform(local_state: Dictionary, dt: float)->bool:
#	var jumpscare = local_state.get(NL.jumpscare)
#	jumpscare.scream()
	return true
