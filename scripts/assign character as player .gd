extends Node

func _ready() -> void:
	attach_to_player()
	queue_free()

func attach_to_player():
	var character = get_parent()
	PlayerInputs.attach_to(character)
	
	var stats = character.get_node('stats')
	if stats != null:
		var connect_stats :Callable= Hud.get_meta(NL.connect_stats_display)
		
		connect_stats.call(stats)
	
	if character.has_meta(NL.toggle_goap_agent):
		var toggle_goap = character.get_meta(NL.toggle_goap_agent)
		toggle_goap.call(false)
