extends Node

func get_input(body:Node3D)-> Inputs:
	var callable = body.get_meta(NL.get_inputs,false)
	if callable is bool:
		return null
	return callable.call()

func change_health(body,delta:=-1.0)->bool:
	var meta = body.get_meta(NL.change_health,false)
	if meta is bool:
		return false
	meta.call(delta)
	return true

func change_hunger(body,delta:=-1.0)->bool:
	var meta = body.get_meta(NL.change_hunger,false)
	if meta is bool:
		return false
	meta.call(delta)
	return true

func stunt(body,duration:=0.5):
	var callable=body.get_meta(NL.delay_platformer,false)
	if callable is Callable:
		callable.call(duration)

func walk_to(body:Node3D,target:Vector3)->bool:
	var callable = body.get_meta(NL.walk_to_target,false)
	if callable is bool:
		return false
	return callable.call(target)

func turn_head(body:Node3D, target:Vector3, x_speed := 1.0, y_speed := 1.0) -> bool:
	var callable = body.get_meta(NL.turn_head_toward,false)
	if callable is bool:
		return false
	return callable.call(target,x_speed,y_speed)



func is_hotbar_full(body:Node3D)->bool:
	var callable = body.get_meta(NL.is_hotbar_full,false)
	if callable is bool:
		return false
	return callable.call()


func reset_inputs(body:Node3D):
	var callable = body.get_meta(NL.reset_inputs,false)
	if callable is bool:
		return
	return callable.call()

func get_head_target(body:Node3D)->Node3D:
	var callable = body.get_meta(NL.get_head_target,false)
	if callable is bool:
		return null
	return callable.call()

func interact_with(body:Node3D, target:Node, user:Node)-> bool:
	var callable = body.get_meta(NL.interact_with,false)
	if callable is bool:
		return false
	return callable.call(target,user)


func get_head_position(body:Node3D)->Vector3:
	var callable = body.get_meta(NL.get_head_position,false)
	if callable is bool:
		return Vector3.ZERO
	return callable.call()

func attach_nav_agent(body:Node3D,target) -> NavAgent:
	var callable = body.get_meta(NL.get_nav_agent,false)
	if callable is bool:
		var agent = NavAgentPool.get_agent_3d()
		agent.attach_to(body,target)
		return agent
	var agent = callable.call()
	agent.set_target(target)
	return agent

func get_nav_agent(body:Node3D) -> NavAgent:
	var callable = body.get_meta(NL.get_nav_agent,false)
	if callable is bool:
		return null
	return callable.call()


func show_dialogue(line:String):
	var callable = Hud.get_meta(NL.show_dialogue)
	callable.call(line)

func show_image(img:Texture):
	var callable = Hud.get_meta(NL.show_image)
	callable.call(img)


func get_goap_agent(body:Node3D)->GOAPAgent:
	var callable = body.get_meta(NL.get_goap_agent,false)
	if callable is bool:
		return null
	return callable.call()

func reward_agent(body:Node3D,amount:=0.0):
	if is_equal_approx(amount,0):
		return
	var callable = body.get_meta(NL.reward_agent,false)
	if callable is bool:
		return
	return callable.call(amount)

#func get_closest_node3d(body:Node3D, group:StringName, pos:Vector3, _range:=100.0)-> Node3D:
#	if !body.has_meta(NL.get_closest_node3d):
#		return null
#	var meta = body.get_meta(NL.get_closest_node3d)
#	return meta.call(group,pos,_range)
#
#func get_farest_node3d(body:Node3D, group:StringName, pos:Vector3, _range:=100.0)-> Node3D:
#	if !body.has_meta(NL.get_farest_node3d):
#		return null
#	var meta = body.get_meta(NL.get_farest_node3d)
#	return meta.call(group,pos,_range)
#
#func get_position_around(body:Node3D, min_range:=Vector3.ONE, max_range:=Vector3.ONE)-> Vector3:
#	if !body.has_meta(NL.get_random_position):
#		return body.global_position
#	var center = body.global_position
#	var meta = body.get_meta(NL.get_random_position)
#	return meta.call(center,min_range,max_range)

func get_hotbar_items(body:Node3D)-> Array:
	var callable = body.get_meta(NL.get_hotbar_items,false)
	if callable is bool:
		return []
	return callable.call()

func input_use_item(body:Node3D,id:int)-> bool:
	var callable = body.get_meta(NL.input_use_item,false)
	if callable is bool:
		return false
	callable.call(id)
	return true

func drop_item(body:Node3D,id:int)-> bool:
	var callable = body.get_meta(NL.drop_item,false)
	if callable is bool:
		return false
	callable.call(id)
	return true
