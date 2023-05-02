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
