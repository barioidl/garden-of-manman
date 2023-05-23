extends ButtonAnimation

func play_animation(button_pressed):
	var angle = Vector3(0,0,55)
	if button_pressed:
		angle.z = 125
	var tween = create_tween()
	tween.tween_property(self,"rotation_degrees",angle, duration).set_trans(transition)
