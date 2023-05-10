extends RayCast3D

@export var offset:=10.0
@onready var container :Node3D= get_parent()

func _ready() -> void:
	enabled = true
	previous_position = global_position


func _process(delta: float) -> void:
	velocity_offset(delta)


var previous_position:=Vector3.ZERO
func velocity_offset(delta:=0.0):
	if container.global_position == previous_position:
		position = Vector3.ZERO
		return
	
	var velocity = container.to_local(previous_position)
	velocity = velocity * offset
	position = -velocity
	previous_position = container.global_position
