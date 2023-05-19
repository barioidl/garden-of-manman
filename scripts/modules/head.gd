extends RayCast3D
class_name HotbarUser

@onready var hotbar:=$"../hotbar"
@onready var root:=$'../..'
@onready var input:Inputs=$'../../inputs'
@onready var shape :=$"../../shape"
#@onready var platformer=$'../../platformer'
#var body
@export var interact_range:=2.0

func _init() -> void:
	name = 'head'
func _ready() -> void:
	owner = root
	add_exception(root)
	
	connect_hotbar()
	set_interface()
	get_head_bone()
	use_shape_size()
	connect_goap_agent()

func _process(delta: float) -> void:
	copy_bone_position()

func connect_hotbar():
	if hotbar == null: return
	input.connect(NL.drop_pressed,drop_start)
	input.connect(NL.drop_released,drop_stop)
	
	input.connect(NL.act_pressed,act)
	input.connect(NL.attack_pressed,attack)
	input.connect(NL.skill_pressed,skill)
	input.connect(NL.misc_pressed,misc)

func set_interface():
	root.set_meta(NL.get_target, Callable(get_target))
	root.set_meta(NL.input_use_item, Callable(input_use_item))

func connect_goap_agent():
	var agent = get_node_or_null("../../goap_agent")
	if agent == null: return
	agent.set_local_state(NL.head,self)

func input_use_item(id:int):
	match id:
		0:input.emit_signal(NL.attack_pressed)
		1:input.emit_signal(NL.skill_pressed)
		2:input.emit_signal(NL.misc_pressed)
		_:input.emit_signal(NL.act_pressed)

@export var connect_to_shape:=true
@export var head_margin:=0.2
func use_shape_size():
	if !connect_to_shape: return
	if head_bone != null: return
	shape.connect('on_size_changed',on_size_changed)

func on_size_changed(_size:Vector3):
	position = Vector3(0,_size.y - head_margin,0)

func get_head_bone():
	if !connect_to_bone: return
	head_bone = $"../rig".get_head_bone()

@export var connect_to_bone:=false
var head_bone:Node3D
func copy_bone_position():
	if head_bone == null: return
	var pos = head_bone.global_position
	global_position = pos

func get_target(_range:=interact_range)->PhysicsBody3D:
	if _range > target_position.z:
		target_position.z = _range
	var target = get_collider()
	if target == null:
		return null
	var dist_sq = global_position. distance_squared_to(target.global_position)
	if dist_sq > _range * _range:
		return null
	return target

func get_contact()->Vector3:
	if is_colliding():
		return get_collision_point()
	return to_global(target_position)


func act():
	default_interact()

func attack():
	use_item(0)

func skill():
	use_item(1)

func misc():
	use_item(2)

func use_item(id:int):
	if hotbar.hotbar_items.size() <= id: return
	var item = hotbar.hotbar_items[id]
	if item == null: 
		default_interact()
		return
	item.use_item(self)
	drop_id = id

func default_interact():
	var body = get_target()
	if body == null: return
	var dist_sq = global_position.distance_squared_to(body.global_position)
	if dist_sq > interact_range * interact_range: return
	if !body.has_method(NL.interact): return
	body.interact(self)


var drop_id:=0
var drop_strength:=0.0:
	get:
		return drop_strength
	set(value):
		if drop_strength == value:return
		drop_strength = value
		emit_signal('drop_updated',value)

signal drop_updated(value)
var drop_tween:Tween
func drop_start():
	drop_strength = 0
	drop_tween = create_tween()
	drop_tween.tween_property(self,'drop_strength',1,1.0)
	drop_tween.tween_callback(drop_item)
	drop_tween.tween_callback(func():drop_tween = null)

func drop_stop():
	if drop_tween == null:return
	drop_tween.kill()
	drop_item()

func drop_item():
	if drop_id <0: return
	if drop_strength <0: return
	var aim_at = to_global(Vector3(0,0,10))
	hotbar.drop_item(drop_id,aim_at,drop_strength)
	drop_strength = 0
