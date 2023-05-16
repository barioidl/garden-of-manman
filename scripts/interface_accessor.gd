extends Node

func change_health(body,delta:=-1.0):
	if body == null:return
	if !body.is_in_group("stats"):return
	var change_health = body.get_meta("change_health")
	if change_health == null: return
	change_health.call(delta)

func stunt(body,duration:=0.5):
	if body == null:return
	if body.has_meta('delay_platformer'):
		body.get_meta('delay_platformer').call(duration)


func walk_to(body:Node3D,target:Vector3):
	if body == null:
		return false
	if !body.has_meta(NameList.walk_to_target):
		return false
	var walk_to = body.get_meta(NameList.walk_to_target)
	walk_to.call(target)
	return true

func turn_head(body:Node3D, target:Vector3) -> bool:
	if body == null:
		return false
	if !body.has_meta(NameList.turn_head_toward):
		return false
	var turn_head = body.get_meta(NameList.turn_head_toward)
	turn_head.call(target)
	return true
