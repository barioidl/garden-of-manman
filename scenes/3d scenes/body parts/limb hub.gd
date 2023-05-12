extends LimbAnimator
class_name LimbHub

#@export var rig :Node3D

@export var bob_height:=0.01

@export var leg_paths:Array[NodePath]=[]
var limb_nodes:=[]

func _ready() -> void:
	super._ready()
	setup_legs()

func setup_legs():
	for path in leg_paths:
		var leg = get_node_or_null(path)
		if leg == null: 
			continue
		limb_nodes.append(leg)
	leg_paths=[]

func idle():
	var duration = step_duration * 2
	tween_loop(idle,duration)
	set_limbs_state(NameList.idle, duration)

func walk():
	var duration = step_duration
	tween_loop(walk,duration)
	set_limbs_state(NameList.walk, duration)

func sneak():
	var duration = step_duration*1.25
	tween_loop(sneak,duration)
	set_limbs_state(NameList.sneak, duration)
	
func sprint():
	var duration = step_duration*0.75
	tween_loop(sprint,duration)
	set_limbs_state(NameList.sprint, duration)

func jump():
	var duration := step_duration*2
	set_limbs_state(NameList.jump, duration)

func fall():
	var duration = step_duration*3
	tween_loop(fall,duration)
	set_limbs_state(NameList.walk, duration)

@export var step_duration :=0.2
var loop_tween :Tween
func tween_loop(_function:Callable, _duration:float):
	if loop_tween != null:
		loop_tween.kill()
	loop_tween = create_tween()
	loop_tween.tween_interval(_duration)
	loop_tween.tween_callback(_function)
	loop_tween.tween_callback(reset_tween)

func reset_tween():
	loop_tween = null

func set_limbs_state(_state:StringName, _duration:float):
	for i in limb_nodes:
		i.play_state(_state,_duration)

func move_hip(duration:float):
	duration *= 0.25
	var mid :=rig.position - Vector3(0,bob_height,0)
	var end :=rig.position
	var tween = create_tween()
	tween.tween_property(rig,'position',mid,duration)
	tween.tween_property(rig,'position',end,duration)
