extends Node3D

var pool_size:=10

var audio_player:=preload("res://scripts/audio/sfx/speaker.tscn")
var audio_player_2d:=preload("res://scripts/audio/sfx/speaker2d.tscn")
var audio_player_3d:=preload("res://scripts/audio/sfx/speaker3d.tscn")

var queue_player:=[]
var queue_player_2d:=[]
var queue_player_3d:=[]


func add_player(speaker:AudioStreamPlayer):
	if queue_player.size() > pool_size:
		speaker.queue_free()
		return
	queue_player.append(speaker)

func add_player_2d(speaker:AudioStreamPlayer2D):
	if queue_player_2d.size() > pool_size:
		speaker.queue_free()
		return
	queue_player_2d.append(speaker)

func add_player_3d(speaker:AudioStreamPlayer3D):
	if queue_player_3d.size() > pool_size:
		speaker.queue_free()
		return
	queue_player_3d.append(speaker)


func get_audio()->AudioStreamPlayer:
	var available_player = queue_player.pop_back()
	if available_player != null:
		return available_player
	var player = audio_player.instantiate()
	add_child(player)
	return player

func get_audio_2d()->AudioStreamPlayer2D:
	var available_player = queue_player_2d.pop_back()
	if available_player != null:
		return available_player
	var player = audio_player_2d.instantiate()
	add_child(player)
	return player

func get_audio_3d()->AudioStreamPlayer3D:
	var available_player = queue_player_3d.pop_back()
	if available_player != null:
		return available_player
	var player = audio_player_3d.instantiate()
	add_child(player)
	return player


func create_sound(list:AudioList,id:=-1)->AudioStreamPlayer:
	id = convert_id(list,id)
	if id <0: return null
	var player :=get_audio()
	player.play_sfx(list.streams[id])
	change_speaker_prop(player, list.pitch_range, list.volume_range)
	return player

func create_sound_2d(pos:Vector2,list:AudioList,id:=-1)->AudioStreamPlayer2D:
	id = convert_id(list,id)
	if id <0: return null
	var player := get_audio_2d()
	player.play_sfx(list.streams[id])
	change_speaker_prop(player, list.pitch_range, list.volume_range)
	player.global_position = pos
	return player

func create_sound_3d(pos:Vector3,list:AudioList,id:=-1)->AudioStreamPlayer3D:
	id = convert_id(list,id)
	if id <0: return null
	var player := get_audio_3d()
	player.play_sfx(list.streams[id])
	change_speaker_prop(player, list.pitch_range, list.volume_range)
	player.global_position = pos
	return player


func convert_id(list,id)->int:
	if list == null:
		push_error('audio list unavailable')
		return -1
	var list_size = list.streams.size()
	if list_size <=0:
		push_error('audio list empty')
		return -1
	if id <0:
		id = randi()
	id %= list_size
	return id

func change_speaker_prop(player,pitch:Vector2,volume:Vector2):
	player.pitch_scale = randf_range(pitch.x,pitch.y)
	player.volume_db = randf_range(volume.x,volume.y)
