extends Marker3D

@onready var root = get_parent().root
@onready var platformer = $"../../../platformer"

@export var legs_per_steps:=1
var current_leg:=-1
var total_legs:=0

@export var leg_paths:Array[NodePath]=[]
var leg_nodes:=[]

func _ready() -> void:
	setup_legs()
	platformer.connect(NameList.on_state_changed, on_state_changed)

#var time:=0.0
#func _physics_process(delta: float) -> void:
#	time = delta

func setup_legs():
	for path in leg_paths:
		var leg = get_node_or_null(path)
		if leg == null: 
			continue
		leg_nodes.append(leg)
	total_legs = leg_nodes.size()
	leg_paths=[]

func on_state_changed(state:StringName):
	match state:
		NameList.idle:
			return idle()
		NameList.walk:
			return walk()
		NameList.sneak:
			return sneak()
		NameList.sprint:
			return sprint()
		NameList.jump:
			return jump()
		NameList.fall:
			return fall()
	idle()

func idle():
	var duration = step_duration * 2
	tween_loop(idle,duration)

func walk():
	var duration = step_duration
	tween_loop(walk,duration)
	foot_step(NameList.walk, duration)

func sneak():
	var duration = step_duration*1.25
	tween_loop(sneak,duration)
	foot_step(NameList.sneak, duration)
	
func sprint():
	var duration = step_duration*0.75
	tween_loop(sprint,duration)
	foot_step(NameList.sprint, duration)

func jump():
	if loop_tween.is_valid():
		loop_tween.kill()
	loop_tween = create_tween()

func fall():
	if loop_tween.is_valid():
		loop_tween.kill()
	loop_tween = create_tween()

@export var step_duration :=0.2
var loop_tween :Tween
func tween_loop(_function:Callable, _duration:float):
	if loop_tween != null:
		loop_tween.kill()
#			return
	loop_tween = create_tween()
	loop_tween.tween_interval(_duration)
	loop_tween.tween_callback(_function)
	loop_tween.tween_callback(reset_tween)
	
	print('beep')
func reset_tween():
	loop_tween = null



func foot_step(_state:StringName, duration:float):
#	var leg_moved:=0
#	for i in legs_per_steps:
#		current_leg = wrapi(current_leg+1,0,total_legs)
#		var leg = leg_nodes[current_leg]
#		if leg.play_state(_state, duration):
#			leg_moved += 1
#
#	if leg_moved >0:
		print(_state)
		move_hip(step_duration)

func move_hip(duration:float):
	duration *= 0.25
	var mid :=Vector3(0,0,0)
	var end :=Vector3(0,-0.05,0)
	var tween = create_tween()
	tween.tween_property(self,'position',mid,duration)
	tween.tween_property(self,'position',end,duration)
