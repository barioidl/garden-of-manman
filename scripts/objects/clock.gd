extends Label3D
class_name Clock

var root:Node3D

signal on_second_changed(sec)
signal on_minute_changed(min)
signal on_hour_changed(hour)

@export var timescale := 1.0
@export var show_second := true

var counter := 0.0
var seconds := 59
var minutes := 59
var hours := 23

func _enter_tree() -> void:
	root = get_parent().root

func _ready() -> void:
	root.set_meta(NL.get_clock,get_clock)
	
	connect('on_second_changed',update_seconds)
	connect('on_minute_changed',update_minutes)
	connect('on_hour_changed',update_hours)

func _process(delta: float) -> void:
	counter += delta * timescale
	if counter < 1: return
	var iterations := floori(counter) 
	counter -= iterations
	increment_second(iterations)
	edit_label()


func get_clock()->Node:
	return self

func increment_second(ticks:int):
	seconds += ticks
	var cap := 60
	if seconds < cap:
		emit_signal('on_second_changed',seconds)
		return
	var iterations := floori(seconds / cap)
	seconds -= cap * iterations
	emit_signal('on_second_changed',seconds)
	increment_minute(iterations)

func increment_minute(tick:int):
	minutes += tick
	var cap := 60
	if minutes < cap:
		emit_signal('on_minute_changed',minutes)
		return
	var iterations := floori(minutes / cap)
	minutes -= cap * iterations
	emit_signal('on_minute_changed',minutes)
	increment_hour(iterations)

func increment_hour(tick:int):
	hours += tick
	var cap := 24
	if hours < cap:
		emit_signal('on_hour_changed',hours)
		return
	var iterations := floori(hours / cap)
	hours -= cap * iterations
	emit_signal('on_hour_changed',hours)


var str_sec:=""
var str_min:=""
var str_hour:=""
func update_seconds(value):
	if !show_second:
		str_sec = ''
		return
	str_sec = str(value)
	str_sec = ":" + str_sec.lpad(2,'0')
func update_minutes(value):
	str_min = str(value)
	str_min = ":" + str_min.lpad(2,'0')
func update_hours(value):
	str_hour = str(value)
	str_hour = str_hour.lpad(2,'0')

func edit_label():
	text = str_hour+str_min+str_sec
