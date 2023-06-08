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
	var pos = root.global_position
	var button = ProximityTool.get_closest_node3d(NL.elevator_platforms, pos)
	if button == null:
		return false
	if !Interface.interact_with(root,button):
		var agent = Interface.attach_nav_agent(root,button)
		var next_pos = agent.get_next_path_pos()
		Interface.walk_to(root,next_pos)
		Interface.turn_head(root,button.global_position)
		_print('walking toward platform')
		return false
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	return true
