extends Button3d

@export var offset_pos:=Vector3(0,-1,0)
@export var locked:= false

func _ready() -> void:
	add_to_group(NL.elevator_buttons)
