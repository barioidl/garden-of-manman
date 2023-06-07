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
	var predators = local_state[NL.predators]
	var _range := 10.0 * get_weight(1)
	var predator = ProximityTool.get_closest_node3d(predators, pos, _range)
	if predator == null:
		return true
	var dir = pos - predator.global_position
	if dir == Vector3.ZERO:
		_print('no hope, gave up')
		return true
	if dir.length_squared() > _range*_range:
		var nav_agent = Interface.get_nav_agent(root)
		if nav_agent != null:
			nav_agent.detach()
		_print('run finished')
		return true
	dir = pos + dir 
	var agent :NavAgent= Interface.attach_nav_agent(root, dir)
	var next_pos = agent.get_next_path_pos()
	
	Interface.walk_to(root,next_pos)
	Interface.turn_head(root,dir,1,0.2)
	_print('running from predator')
	return false



func _print(line:String):
	return
	print(line)
