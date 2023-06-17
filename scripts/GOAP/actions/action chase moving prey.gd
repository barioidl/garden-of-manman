extends GOAPAction
class_name ActionChaseMovingPrey

func _name()->StringName:
	return &'A chase moving prey'

func is_valid(local_state:Dictionary)->bool:
	if !local_state.has(NL.preys):
		return false
	if !local_state.has(NL.motion_sense):
		return false
	return true

func get_cost(local_state:Dictionary)->float:
	return get_weight(0)

func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.prey_distance: -1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root = local_state.root
	var pos :Vector3= root.global_position
	
	var preys = local_state[NL.preys]
	var prey = ProximityTool.get_closest_node3d(preys, pos, 1, is_prey_moving)
	if prey == null:
		reset_input(root)
		_print('no prey to attack')
		return false
	if !is_prey_moving(prey,1):
		reset_input(root)
		_print('prey aint moving')
		return false
	
	var dist = pos.distance_squared_to(prey.global_position)
	var detection_range = local_state[NL.motion_sense]
	if dist > detection_range*detection_range:
		return false
	
	var _range = local_state[NL.interact_range]
	if dist >= _range*_range:
		var agent := Interface.attach_nav_agent(root,prey)
		var next_pos = agent.get_next_path_pos()
		Interface.walk_to(root,next_pos)
		Interface.turn_head(root,prey.global_position)
		_print('walking toward prey')
		return false
	
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	_print('prey reached')
	return true

func is_prey_moving(prey,range)->bool:
	if prey.linear_velocity.length_squared() > 1:
		return true
	return false

func reset_input(root):
	var input = Interface.get_input(root)
	if input != null:
		input.dpad1 = Vector2.ZERO
		input.dpad2 = Vector2.ZERO
