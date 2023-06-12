extends GOAPAction
class_name ActionTurnLightOn

func _name()->StringName:
	return &'A turn light on'

func is_valid(local_state:Dictionary)->bool:
	return true

func get_cost(local_state:Dictionary)->float:
	return get_weight(0)
 
func get_inputs(local_state:Dictionary)->Dictionary:
	return{}

func get_outputs(local_state:Dictionary)->Dictionary:
	return{
		NL.lights_on:1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var root :Node3D= local_state.root
	var pos = root.global_position
	var button = ProximityTool.get_closest_node3d(NL.light_buttons, pos, 1, is_light_off)
	if button == null:
		return false
	var dist = button.global_position.distance_squared_to(pos) 
	var _range = local_state[NL.interact_range]
	if dist >= _range*_range:
		var agent = Interface.attach_nav_agent(root,button)
		var next_pos = agent.get_next_path_pos()
		Interface.walk_to(root,next_pos)
		Interface.turn_head(root,button.global_position,1,0.1)
		_print('walking toward button')
		return false
	Interface.interact_with(root,button,root)
	var nav_agent = Interface.get_nav_agent(root)
	if nav_agent != null:
		nav_agent.detach()
	return true

func is_light_off(light)-> bool:
	return !light.button_pressed


func _print(line):
	return
	print(line)
