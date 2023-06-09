extends GOAPAction
class_name ActionUseElevator

func _name()->StringName:
	return &'A use elevator'

func is_valid(local_state:Dictionary)->bool:
	return true

func get_cost(local_state:Dictionary)->float:
	return 1
 
func get_inputs(local_state:Dictionary)->Dictionary:
	return{
		NL.is_in_elevator:1
	}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.height_difference:-1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root :Node3D= local_state.root
	var destination = local_state[NL.destination]
	var pos := root.global_position
	var platform = ProximityTool.get_closest_node3d(NL.elevator_panels, pos)
	if platform == null:
		return false
#	Interface.turn_head(root,platform.global_position,1,1)
	var meta = platform.get_meta(NL.use_elevator)
	meta.call(destination)
	return true
