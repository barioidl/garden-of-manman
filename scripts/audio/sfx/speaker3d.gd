extends AudioStreamPlayer3D

var offset_volume := 0.0

func _ready() -> void:
	connect('finished',finished) # Replace with function body.

func play_sfx(audio):
	add_to_group('audio_player_3d')
	stream = audio
	play()

func finished():
	for group in get_groups():
		remove_from_group(group)
	offset_volume = 0
	var pool :AudioPool= get_parent()
	pool.push_player_3d(self)
