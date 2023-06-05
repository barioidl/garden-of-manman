extends GOAPAction
class_name ActionFlee

var _range := 20.0

func _name()->StringName:
	return &'A flee'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.predators)

func get_cost(local_state:Dictionary)->float:
	return randf_range(0.1,1)
 
func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.fear:-1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root = local_state.root
	var root_pos :Vector3= root.global_position
	var predators = local_state[NL.predators]
	
	var proxi_tool :ProximityTool= local_state[NL.proximity_tool]
	var predator = proxi_tool.get_closest_node3d(predators, root_pos, _range)
	var dir = root_pos.direction_to(predator.global_position)
	if !reached_target(root):
		Interface.attach_nav_agent(root,root_pos + dir * 5)
		return false
	Interface.walk_to(root,root_pos + dir * 5)
	
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	return true

func reached_target(a):
	pass
