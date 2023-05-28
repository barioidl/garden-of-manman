extends GOAPAction
class_name ActionAttackTarget

func _name()->StringName:
	return &'A attack target'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.jumpscare)

func get_cost(local_state:Dictionary)->float:
	return randf_range(0.5,1)
 
func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.player_fear:0.4
	}

func perform(local_state: Dictionary, dt: float)-> bool:
	var root = local_state.root
	var target = Interface.get_target(root)
	var jumpscare = local_state.get(NL.jumpscare)
	var pos = Interface.get_head_position(jumpscare.target)
	
	if target != jumpscare.target:
		Interface.attach_nav_agent(root,pos)
		return false
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	
	var damage = randi_range(-6,-3)
	Interface.change_health(target,damage)
	
	return true

