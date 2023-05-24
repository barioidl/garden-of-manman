extends CollisionShape3D

@export var duration := 0.2

@export var open_position:=1.4
@export var clode_position:=0.5
@export var mirrored:=false
enum axis{x,y,z}
@export var direction:=axis.z

@export var ease:=Tween.EASE_IN_OUT
@export var transition := Tween.TRANS_LINEAR

@export var lock :Node3D

func slide(open:bool) -> float:
	if lock != null:
		lock.cooldown = duration
	
	var tween = create_tween()
	var end = open_position if open else clode_position
	if mirrored:
		end *= -1
	match direction:
		axis.x:
			tween.tween_property(self,'position:x',end, duration).set_ease(ease).set_trans(transition)
		axis.y:
			tween.tween_property(self,'position:y',end, duration).set_ease(ease).set_trans(transition)
		axis.z:
			tween.tween_property(self,'position:z',end, duration).set_ease(ease).set_trans(transition)
	return duration
