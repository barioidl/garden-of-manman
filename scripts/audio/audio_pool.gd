extends Node3D

var pool_size:=10

var disable_sfx:=true
var disable_sfx_2d:=true
var disable_sfx_3d:=true

var audio_player:=preload("res://scripts/audio/sfx/speaker.tscn")
var audio_player_2d:=preload("res://scripts/audio/sfx/speaker2d.tscn")
var audio_player_3d:=preload("res://scripts/audio/sfx/speaker3d.tscn")

var stack_player:=[]
var stack_player_2d:=[]
var stack_player_3d:=[]


func push_player(speaker:AudioStreamPlayer):
	if stack_player.size() > pool_size:
		speaker.queue_free()
		return
	stack_player.append(speaker)

func push_player_2d(speaker:AudioStreamPlayer2D):
	if stack_player_2d.size() > pool_size:
		speaker.queue_free()
		return
	stack_player_2d.append(speaker)

func push_player_3d(speaker:AudioStreamPlayer3D):
	if stack_player_3d.size() > pool_size:
		speaker.queue_free()
		return
	stack_player_3d.append(speaker)


func pop_audio()->AudioStreamPlayer:
	var available_player = stack_player.pop_back()
	if available_player != null:
		_print('use existing audio')
		return available_player
	_print('used new audio')
	var player = audio_player.instantiate()
	add_child(player)
	return player

func pop_audio_2d()->AudioStreamPlayer2D:
	var available_player = stack_player_2d.pop_back()
	if available_player != null:
		_print('use existing audio 2d')
		return available_player
	_print('use new audio 2d')
	var player = audio_player_2d.instantiate()
	add_child(player)
	return player

func pop_audio_3d()->AudioStreamPlayer3D:
	var available_player = stack_player_3d.pop_back()
	if available_player != null:
		_print('use existing audio 3d')
		return available_player
	_print('used new audio 3d')
	var player = audio_player_3d.instantiate()
	add_child(player)
	return player


func create_sound(list:AudioList,id:=-1)->AudioStreamPlayer:
	if disable_sfx: 
		_print('audio effect is disabled')
		return null
	id = convert_id(list,id)
	if id <0: 
		_print('audio convert id failed')
		return null
	var player := pop_audio()
	player.play_sfx(list.streams[id])
	change_speaker_prop(player, list.pitch_range, list.volume_range)
	return player

func create_sound_2d(pos:Vector2,list:AudioList,id:=-1)-> AudioStreamPlayer2D:
	if disable_sfx_2d: 
		_print('audio effect 2d is disabled')
		return null
	id = convert_id(list,id)
	if id <0: 
		_print('audio convert id failed')
		return null
	var player := pop_audio_2d()
	player.play_sfx(list.streams[id])
	change_speaker_prop(player, list.pitch_range, list.volume_range)
	player.global_position = pos
	return player

func create_sound_3d(pos:Vector3,list:AudioList,id:=-1)->AudioStreamPlayer3D:
	if disable_sfx_3d: 
		_print('audio effect 3d is disabled')
		return null
	id = convert_id(list,id)
	if id <0: 
		_print('audio convert id failed')
		return null
	var player := pop_audio_3d()
	player.play_sfx(list.streams[id])
	change_speaker_prop(player, list.pitch_range, list.volume_range)
	player.global_position = pos
	return player


func convert_id(list,id)->int:
	if list == null:
		_print('audio list unavailable')
		return -1
	var list_size = list.streams.size()
	if list_size <=0:
		_print('audio list empty')
		return -1
	if id <0:
		id = randi()
	id %= list_size
	return id

func change_speaker_prop(player,pitch:Vector2,volume:Vector2):
	player.pitch_scale = randf_range(pitch.x,pitch.y)
	player.volume_db = randf_range(volume.x,volume.y)

func _print(line:String):
	print(line)
