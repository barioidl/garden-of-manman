extends Node

func _ready() -> void:
	attach_to_player()
	queue_free()

func attach_to_player():
	var character = get_parent()
	PlayerInputs.attach_to(character)
	
	var stats = character.get_node('stats')
	var connect_stats :Callable= Hud.get_meta('connect_stats_display')
	connect_stats.call(stats)
