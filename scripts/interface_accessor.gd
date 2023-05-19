extends Node

func change_health(body,delta:=-1.0)->bool:
	if body == null:return false
	if !body.has_meta(NL.change_health):
		return false
	var meta = body.get_meta(NL.change_health)
	meta.call(delta)
	return true

func change_hunger(body,delta:=-1.0)->bool:
	if body == null: return false
	if !body.has_meta(NL.change_hunger):
		return false
	var meta = body.get_meta(NL.change_hunger)
	meta.call(delta)
	return true

func stunt(body,duration:=0.5):
	if body == null:return
	if body.has_meta('delay_platformer'):
		body.get_meta('delay_platformer').call(duration)


func walk_to(body:Node3D,target:Vector3)->bool:
	if body == null:
		return false
	if !body.has_meta(NL.walk_to_target):
		return false
	var walk_to = body.get_meta(NL.walk_to_target)
	walk_to.call(target)
	return true

func turn_head(body:Node3D, target:Vector3, speed:=1.0) -> bool:
	if body == null:
		return false
	if !body.has_meta(NL.turn_head_toward):
		return false
	var turn_head = body.get_meta(NL.turn_head_toward)
	return turn_head.call(target,speed)


func get_input(body:Node3D)->Node:
	if body == null:
		return null
	if !body.has_meta(NL.get_inputs):
		return null
	return body.get_meta(NL.get_inputs).call()

func is_hotbar_full(body:Node3D)->bool:
	if body == null:
		return true
	if !body.has_meta(NL.is_hotbar_full):
		return true
	return body.get_meta(NL.is_hotbar_full).call()

func get_target(body:Node3D)->Node3D:
	if body == null:
		return null
	if !body.has_meta(NL.get_target):
		return null
	return body.get_meta(NL.get_target).call()
