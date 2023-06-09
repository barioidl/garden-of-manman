extends GOAPAction
class_name ActionCallElevator

func _name()->StringName:
	return &'A call elevator'

func is_valid(local_state:Dictionary)->bool:
	return true

func get_cost(local_state:Dictionary)->float:
	return get_weight(0)
 
func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.elevator_closed:-1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root :Node3D= local_state.root
	var pos = root.global_position
	var button = ProximityTool.get_closest_node3d(NL.elevator_buttons, pos)
	if button == null:
		return false
	if !Interface.interact_with(root,button):
		var agent = Interface.attach_nav_agent(root,button)
		var next_pos = agent.get_next_path_pos()
		Interface.walk_to(root,next_pos)
		Interface.turn_head(root,button.global_position,1,0.1)
		_print('walking toward button')
		return false
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	return true

func _print(line):
	return
	print(line)
