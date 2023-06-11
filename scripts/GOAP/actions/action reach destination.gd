extends GOAPAction
class_name ActionReachDestination

func _name()->StringName:
	return &'A reach destination'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.destination)

func get_cost(local_state:Dictionary)->float:
	return get_weight(0)
 
func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.destination:1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root :Node3D= local_state.root
	var pos = root.global_position
	var destination :Vector3= local_state[NL.destination]
	destination.y = pos.y
	if destination.distance_squared_to(pos) > 0.5:
		var agent = Interface.attach_nav_agent(root,destination)
		var next_pos :Vector3= agent.get_next_path_pos()
		var final_pos = agent.get_final_pos()
		if next_pos.distance_squared_to(final_pos) < 0.5:
			agent.detach()
			return true
		Interface.walk_to(root,next_pos)
		Interface.turn_head(root,next_pos,1,0.1)
		return false
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	return true
