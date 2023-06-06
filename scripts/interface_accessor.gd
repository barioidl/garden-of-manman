extends Node

func get_input(body:Node3D)-> Inputs:
	if !body.has_meta(NL.get_inputs):
		return null
	return body.get_meta(NL.get_inputs).call()

func change_health(body,delta:=-1.0)->bool:
	if !body.has_meta(NL.change_health):
		return false
	var meta = body.get_meta(NL.change_health)
	meta.call(delta)
	return true

func change_hunger(body,delta:=-1.0)->bool:
	if !body.has_meta(NL.change_hunger):
		return false
	var meta = body.get_meta(NL.change_hunger)
	meta.call(delta)
	return true

func stunt(body,duration:=0.5):
	if body.has_meta(NL.delay_platformer):
		body.get_meta(NL.delay_platformer).call(duration)

func walk_to(body:Node3D,target:Vector3)->bool:
	if !body.has_meta(NL.walk_to_target):
		return true
	var walk_to = body.get_meta(NL.walk_to_target)
	return walk_to.call(target)

func turn_head(body:Node3D, target:Vector3, x_speed := 1.0, y_speed := 1.0) -> bool:
	if !body.has_meta(NL.turn_head_toward):
		return false
	var turn_head = body.get_meta(NL.turn_head_toward)
	return turn_head.call(target,x_speed,y_speed)



func is_hotbar_full(body:Node3D)->bool:
	if !body.has_meta(NL.is_hotbar_full):
		return true
	return body.get_meta(NL.is_hotbar_full).call()


func reset_inputs(body:Node3D):
	if !body.has_meta(NL.reset_inputs):
		return null
	return body.get_meta(NL.reset_inputs).call()

func get_head_target(body:Node3D)->Node3D:
	if !body.has_meta(NL.get_head_target):
		return null
	return body.get_meta(NL.get_head_target).call()

func interact_with(body:Node3D, target:Node)-> bool:
	if !body.has_meta(NL.interact_with):
		return false
	return body.get_meta(NL.interact_with).call(target,body)


func get_head_position(body:Node3D)->Vector3:
	if !body.has_meta(NL.get_head_position):
		return Vector3.ZERO
	var meta = body.get_meta(NL.get_head_position)
	return meta.call()

func attach_nav_agent(body:Node3D,target) -> Node3D:
	if !body.has_meta(NL.get_nav_agent):
		var agent = NavAgentPool.get_agent_3d()
		agent.attach_to(body,target)
		return agent
	var agent = body.get_meta(NL.get_nav_agent).call()
	agent.set_target(target)
	return agent

func get_nav_agent(body:Node3D) -> Node3D:
	if !body.has_meta(NL.get_nav_agent):
		return null
	var meta = body.get_meta(NL.get_nav_agent)
	return meta.call()


func show_dialogue(line:String):
	var meta = Hud.get_meta(NL.show_dialogue)
	meta.call(line)

func show_image(img:Texture):
	var meta = Hud.get_meta(NL.show_image)
	meta.call(img)

func get_goap_agent(body:Node3D)->GOAPAgent:
	if !body.has_meta(NL.get_goap_agent):
		return
	var meta = body.get_meta(NL.get_goap_agent)
	return meta.call()

func reward_agent(body:Node3D,amount:=0.0):
	if is_equal_approx(amount,0):
		return
	if !body.has_meta(NL.reward_agent):
		return
	var meta = body.get_meta(NL.reward_agent)
	return meta.call(amount)

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

func get_position_around(body:Node3D, min_range:=Vector3.ONE, max_range:=Vector3.ONE)-> Vector3:
	if !body.has_meta(NL.get_random_position):
		return body.global_position
	var center = body.global_position
	var meta = body.get_meta(NL.get_random_position)
	return meta.call(center,min_range,max_range)
	

