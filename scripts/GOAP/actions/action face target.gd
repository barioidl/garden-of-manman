extends GOAPAction
class_name ActionFaceTarget

func _name()->StringName:
	return &'A face target'

func is_valid(local_state:Dictionary)->bool:
	return local_state.has(NL.jumpscare)

func get_cost(local_state:Dictionary)->float:
	return randf_range(0.1,1)

func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.player_fear:0.3
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root = local_state.root
	var target = local_state.get(NL.jumpscare).target
	
	var target_pos = Interface.get_head_position(target)
	var root_pos = Interface.get_head_position(root)
	
	var target_faced = Interface.turn_head(root,target_pos,2)
	var root_faced = Interface.turn_head(target,root_pos,4)
	return target_faced and root_faced
