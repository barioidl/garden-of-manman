extends GOAPAction
class_name ActionWaitForElevator

func _name()->StringName:
	return &'A wait for elevator'

func is_valid(local_state:Dictionary)->bool:
	return true

func get_cost(local_state:Dictionary)->float:
	return 1
 
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
#	var dist = pos.distance_squared_to(door.global_position)
#	if dist > 3:
#		var agent = Interface.attach_nav_agent(root,door)
#		var next_pos = agent.get_next_path_pos()
#		Interface.walk_to(root,next_pos)
#		_print('walking toward button')
#		return false
	if !door.is_open:
		return false
#	var nav_agent = Interface.get_nav_agent(root)
#	if nav_agent != null:
#		nav_agent.detach()
	_print('wait completed')
	return true
