extends StaticBody3D
class_name Button3d

signal button_down
signal button_up
signal pressed
signal toggled(button_pressed:bool)

@export var duration = 0.5
@export var active:=false
func _ready() -> void:
	fire_signals()

var cooldown:=0.0
func _process(delta: float) -> void:
	if cooldown >0:
		cooldown -= delta

func interact(user):
#	print("pressed")
	toggle()

func toggle():
	if cooldown >0: 
		return
	active = !active
	fire_signals()

func enable():
	if cooldown >0: 
		return
	active = true
	fire_signals()

func disable():
	if cooldown >0: 
		return
	active = false
	fire_signals()

func fire_signals():
	cooldown = duration
	emit_signal("pressed")
	emit_signal("toggled",active)
	if active:
		emit_signal("button_down")
	else:
		emit_signal("button_up")
