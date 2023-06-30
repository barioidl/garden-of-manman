extends GOAPAction
class_name ActionFlee

func _name()->StringName:
	return &'A flee'

func is_valid(local_state:Dictionary)->bool:
	if !local_state.has(NL.predators):
		return false
	return true

func get_cost(local_state:Dictionary)->float:
	return get_weight(0)
 
func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.fear:-1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root = local_state.root
	var pos :Vector3= Interface.get_head_position(root)
	
	var root_pos :Vector3= root.global_position
	var predators = local_state[NL.predators]
	var target = ProximityTool.get_closest_node3d(predators, root_pos)
	if target == null:
		return true
	
	var room = ProximityTool.get_farest_node3d(NL.rooms, target.global_position)
	if room == null:
		return true
	var dist = pos.distance_squared_to(room.global_position)
	
	var _range = local_state[NL.interact_range]
	if dist < _range*_range:
		var nav_agent = Interface.get_nav_agent(root)
		if nav_agent != null:
			nav_agent.detach()
		_print('run finished')
		return true
	var agent :NavAgent= Interface.attach_nav_agent(root, room)
	var next_pos = agent.get_next_path_pos()
	
	Interface.walk_to(root,next_pos)
	Interface.turn_head(root,next_pos,1,0.2)
	_print('running from predator')
	return false



func _print(line:String):
	return
	print(line)
