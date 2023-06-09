extends GOAPAction
class_name ActionOpenDoor

func _name()->StringName:
	return &'A open door'

func is_valid(local_state:Dictionary)->bool:
	return true

func get_cost(local_state:Dictionary)->float:
	return get_weight(0)
 
func get_inputs(local_state:Dictionary)->Dictionary:
	return{
#		NL.has_key:1
	}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.exploration:1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root :Node3D= local_state.root
	var pos = root.global_position
	var foods = local_state[NL.foods]
	var food = ProximityTool.get_closest_node3d(foods, pos)
	if food == null:
		_print('what food?')
		return false
	if !Interface.interact_with(root,food):
		var agent = Interface.attach_nav_agent(root,food)
		var next_pos = agent.get_next_path_pos()
		Interface.walk_to(root,next_pos)
		Interface.turn_head(root,food.global_position)
		_print('walking toward food')
		return false
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	_print('food reached')
	return true
