extends StaticBody3D
class_name Button3d

signal button_down
signal button_up
signal pressed
signal toggled(button_pressed)

@export var button_pressed := false
@export var disabled :=false
@export var fire_signal_at_start:=false
var cooldown:=0.0

func _ready() -> void:
	set_interface()
	if fire_signal_at_start:
		fire_signals()

func _process(delta: float) -> void:
	if cooldown > 0:
		cooldown -= delta

func set_interface():
	set_meta(NL.interact,Callable(interact))
	set_meta(NL.toggle,Callable(toggle))
	set_meta(NL.on,Callable(on))
	set_meta(NL.off,Callable(off))

func interact(user):
	toggle()

func toggle():
	if disabled:
		return
	if cooldown >0: 
		return
	button_pressed = !button_pressed
	fire_signals()

func on():
	if disabled:
		return
	if cooldown >0: 
		return
	button_pressed = true
	fire_signals()

func off():
	if disabled:
		return
	if cooldown > 0: 
		return
	button_pressed = false
	fire_signals()

func fire_signals():
	emit_signal("pressed")
	emit_signal("toggled",button_pressed)
	if button_pressed:
		emit_signal("button_down")
	else:
		emit_signal("button_up")
