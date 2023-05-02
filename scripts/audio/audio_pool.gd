extends Node3D

func change_speaker_prop(player,pitch:Vector2,volume:Vector2):
	player.pitch_scale = randf_range(pitch.x,pitch.y)
	player.volume_db = randf_range(volume.x,volume.y)

var audio_player_3d:=preload("res://scripts/audio/sfx/speaker3d.tscn")
func create_sound_3d(pos:Vector3,list:AudioList,id:=-1)->AudioStreamPlayer3D:
	if list == null:
		push_error('audio list unavailable')
		return null
	var list_size = list.streams.size()
	if list_size <=0:
		push_error('audio list empty')
		return null
	if id <0:
		id = randi()
	id %= list_size
	
	var player :AudioStreamPlayer3D= audio_player_3d.instantiate()
	player.stream = list.streams[id]
	change_speaker_prop(player,list.pitch_range,list.volume_range)
	add_child(player)
	player.global_position = pos
	return player

var audio_player_2d:=preload("res://scripts/audio/sfx/speaker2d.tscn")
func create_sound_2d(pos:Vector2,list:AudioList,id:=-1)->AudioStreamPlayer2D:
	if list == null:
		push_error('audio list unavailable')
		return null
	var list_size = list.streams.size()
	if list_size <=0:
		push_error('audio list empty')
		return null
	if id <0:
		id = randi()
	id %= list_size
	
	var player :AudioStreamPlayer2D= audio_player_2d.instantiate()
	player.stream = list.streams[id]
	change_speaker_prop(player,list.pitch_range,list.volume_range)
	add_child(player)
	player.global_position = pos
	return player

var audio_player:=preload("res://scripts/audio/sfx/speaker.tscn")
func create_sound(list:AudioList,id:=-1)->AudioStreamPlayer:
	if list == null:
		push_error('audio list unavailable')
		return null
	var list_size = list.streams.size()
	if list_size <=0:
		push_error('audio list empty')
		return null
	if id <0:
		id = randi()
	id %= list_size
	
	var player :AudioStreamPlayer= audio_player.instantiate()
	player.stream = list.streams[id]
	change_speaker_prop(player,list.pitch_range,list.volume_range)
	add_child(player)
	return player
