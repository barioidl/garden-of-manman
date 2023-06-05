extends LimbAnimator
class_name Hip

@export var bob_height:=0.01
@export var spine_paths:Array[NodePath]=[]
var spine_nodes:Array[Node3D]=[]

var root :Node3D
func _enter_tree() -> void:
	root = get_parent().root
	owner = root

func _ready() -> void:
	super._ready()
	setup_spine()

func setup_spine():
	for path in spine_paths:
		var bone = get_node_or_null(path)
		if bone == null: 
			continue
		spine_nodes.append(bone)

func idle():
	var duration = step_duration * 2
	tween_loop(idle,duration)
#	hip_bob(duration)
	straight_spine(duration)

func walk():
	var duration = step_duration
	tween_loop(walk,duration)
	hip_bob(duration)
	straight_spine(duration)

func sneak():
	var duration = step_duration*1.25
	tween_loop(sneak,duration)
	hip_bob(duration)
	crouch_spine(duration)

func sprint():
	var duration = step_duration*0.75
	tween_loop(sprint,duration)
	hip_bob(duration)
	straight_spine(duration)

func jump():
	var duration := step_duration*2
	straight_spine(duration)

func fall():
	var duration = step_duration*3
	straight_spine(duration)

var step_duration :=0.5
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

func hip_bob(duration:float):
	duration *= 0.5*time_scale
	var mid := container.position - Vector3(0,bob_height,0)
	var end := container.position
	var tween = create_tween()
	tween.tween_property(container,'position',mid,duration)
	tween.tween_property(container,'position',end,duration)

func straight_spine(duration:float):
	duration *= 0.5
	var rot = Vector3.ZERO
	if rot.z == 0:
		rot.z = deg_to_rad(1)
	rot.z *= -1
	rotation = rot
	for i in spine_nodes:
		var tween = create_tween()
		tween.tween_property(i,'rotation',rot,duration)

func crouch_spine(duration:float):
	duration *= 0.5
	var rot = Vector3(deg_to_rad(30),0,0)
	rotation = -rot
	for i in spine_nodes:
		var tween = create_tween()
		tween.tween_property(i,'rotation',rot,duration)
