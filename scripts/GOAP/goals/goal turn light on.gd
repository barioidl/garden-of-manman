extends GOAPGoal
class_name GoalTurnLightOn

func _name() -> StringName:
	return &'G turn light on'

func is_valid(local_state:Dictionary)->bool:
	return true

func priority(local_state:Dictionary)->float:
	var root = local_state.root
	if cache_cost.has(root):
		return cache_cost[root]
	
	var pos :Vector3= root.global_position
	var target = ProximityTool.get_closest_node3d(NL.light_buttons, pos, 1, is_light_off)
	if target == null: 
		_print('no lights?')
		cache_cost[root] = 0
		return 0
	
	var _range := 10.0 * get_weight(0)
	var dist = pos.distance_to(target.global_position)
	dist = 1 - clampf(dist/_range,0,1)
	var _priority = Curves.sample(4,4,dist)
	_priority *= get_weight(1)
	
	cache_cost[root] = _priority
	return _priority

func get_result(local_state:Dictionary)->Dictionary:
	return{
		NL.lights_on: 1
	}

func perform(local_state: Dictionary, dt: float)->bool:
	var agent = local_state.agent
	agent.loop_plan = false
	agent.set_local_state(NL.unique_steps,false)
	return true

func is_light_off(light, range)-> bool:
	return !light.button_pressed

func _print(line:String):
	return
	print(line)
