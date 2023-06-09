extends GOAPAction
class_name ActionGetInElevator

func _name()->StringName:
	return &'A get in elevator'

func is_valid(local_state:Dictionary)->bool:
	return true

func get_cost(local_state:Dictionary)->float:
	return get_weight(0)
 
func get_inputs(local_state:Dictionary)->Dictionary:
	return{
		NL.can_enter_elevator:1
	}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.is_in_elevator:1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root :Node3D= local_state.root
	var pos := root.global_position
	var panel = ProximityTool.get_closest_node3d(NL.elevator_panels, pos)
	if panel == null:
		return false
	var dist=pos.distance_squared_to(panel.global_position)
	var _range = local_state[NL.interact_range]
	if dist >= _range:
		_print('walking toward panel')
		var agent = Interface.attach_nav_agent(root,panel)
		var next_pos :Vector3= agent.get_next_path_pos()
		Interface.walk_to(root,next_pos)
		Interface.turn_head(root,panel.global_position,1,0.1)
		return false
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	return true

func _print(line):
	return
	print(line)
