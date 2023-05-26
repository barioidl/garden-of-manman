extends Area3D

func _ready() -> void:
	add_to_group("bound")
	connect('area_entered',new_spawnpoint)
#	connect('area_exited',new_spawnpoint)
func new_spawnpoint(body):
	var sp = body.get_node_or_null('spawn_point')
	if sp != null:
		sp.save()
