extends Node3D
class_name Limb

@export var rig :Node3D
@export var animation_player:AnimationPlayer
@export var raycast :RayCast3D
@export var target :Node3D

@export var mirrored:=true
@export var step_duration:=0.2

func _ready() -> void:
	animation_player.container = self
	raycast.add_exception(rig.root)
	raycast.target = target

func play_state(_state:StringName, _duration:float)->bool:
	animation_player.play_state(_state,_duration)
	return true
