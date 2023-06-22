extends LimbAnimator
class_name Limb

@export var raycast :RayCast3D
@export var target :Node3D
@export var hand :Node3D

@export var mirrored:=true

func _ready() -> void:
	super._ready()
	raycast.add_exception(container.root)
	raycast.target = target

func get_item_holder()->Node3D:
	return self

func state_changed(_state:StringName):
	raycast.play_state(_state,time_scale,mirrored)
