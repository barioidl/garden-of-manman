extends StaticBody3D

@export var velocity:=Vector3.ZERO

func start():
	constant_linear_velocity = velocity

func reverse():
	constant_linear_velocity = -velocity

func stop():
	constant_linear_velocity = Vector3.ZERO
