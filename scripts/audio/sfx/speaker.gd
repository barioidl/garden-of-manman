extends AudioStreamPlayer

var offset_volume := 0.0

func _ready() -> void:
	connect('finished',finished) # Replace with function body.

func play_sfx(audio):
	add_to_group(NL.audio_player)
	stream = audio
	play()

func finished():
	for group in get_groups():
		remove_from_group(group)
	offset_volume = 0
	var pool :AudioPool= get_parent()
	pool.push_player(self)
