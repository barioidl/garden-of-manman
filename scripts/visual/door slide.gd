extends CollisionShape3D

@export var duration := 0.2

@export var open_position:=1.4
@export var clode_position:=0.5
@export var mirrored:=false
enum axis{x,y,z}
@export var direction:=axis.z

@export var ease:=Tween.EASE_IN_OUT
@export var transition := Tween.TRANS_LINEAR

func slide(state) -> void:
	var tween = get_tree().create_tween()
	var start = open_position if !state else clode_position
	var end = open_position if state else clode_position
	if mirrored:
		start *=-1
		end *= -1
	match direction:
		axis.x:
			tween.tween_method(slide_x,start,end, duration).set_ease(ease).set_trans(transition)
		axis.y:
			tween.tween_method(slide_y,start,end, duration).set_ease(ease).set_trans(transition)
		axis.z:
			tween.tween_method(slide_z,start,end, duration).set_ease(ease).set_trans(transition)

func slide_x(value):
	position.x = value
func slide_y(value):
	position.y = value
func slide_z(value):
	position.z = value
