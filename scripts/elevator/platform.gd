extends AnimatableBody3D

@onready var elevator = $".."
@onready var original_pos:=position
@export var speed := 1.0

func move_x(pos:float):
	move_platform(position.x,pos,'position:x')
func move_y(pos:float):
	move_platform(position.y,pos,'position:y')
func move_z(pos:float):
	move_platform(position.z,pos,'position:z')

var tween:Tween
func move_platform(from,to,property):
	if is_equal_approx(from,to):
		return
	var duration :float= abs(to - from)
	duration *= speed
	elevator.cooldown = duration
	tween = create_tween()
	tween.tween_property(self,property,to,duration)
