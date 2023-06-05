extends RigidBody3D
class_name ItemOverworld

var item:Resource

var root:RigidCharacter
var hotbar
var id :=-1
var is_in_overworld:=true
var holder:Node3D

@export var interact_range:=2.0
signal item_equipped
signal item_unequipped
signal item_used

func _ready() -> void:
	setup_interface()

var dt :=0.0
func _physics_process(delta: float) -> void:
	dt = delta
	item_physics()

func setup_interface():
	set_meta(NL.interact,interact)

func equip_item(_hotbar,_id:=-1):
	emit_signal(NL.item_equipped)
	hotbar = _hotbar
	root = _hotbar.root
	id=_id
	is_in_overworld = false
	toggle_physics()
	add_collision_exception_with(root)
	
	if hotbar.item_holders.size() > id:
		holder = hotbar.item_holders[id]
	else:
		holder = null
		position = Vector3.ZERO

func unequip_item():
	emit_signal(NL.item_unequipped)
	root = null
	holder = null
	id = -1
	is_in_overworld = true
	toggle_physics()
	var tween = create_tween()
	tween.tween_interval(0.2)
	tween.tween_callback(reset_exception.bind(root))

func reset_exception(_root):
	if _root == null: return
	remove_collision_exception_with(_root)

func use_item(head:HotbarUser)->bool:
	emit_signal(NL.item_used)
	if head == null:
		return false
	var body = head.get_target(interact_range)
	return head.interact_with(body,self)
	

func interact(user):
	if !is_in_overworld:
		hotbar.drop_item(id)
	
	user = user.root
	if user == null:return
	if !user.has_meta(NL.append_item_node):return
	var append_item_node = user.get_meta(NL.append_item_node)
	var added = append_item_node.call(self)
	if !added:
		use_item(null)


var gravity: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity") * ProjectSettings.get_setting("physics/3d/default_gravity_vector")

var time :=0.0
func item_physics():
	if is_in_overworld: 
		return
	if holder == null:
		return
	global_position = holder.hand.global_position


func toggle_physics():
	var lock_axis = !is_in_overworld
	axis_lock_linear_x = lock_axis
	axis_lock_linear_y = lock_axis
	axis_lock_linear_z = lock_axis
	axis_lock_angular_x = lock_axis
	axis_lock_angular_y = lock_axis
	axis_lock_angular_z = lock_axis
	
	for shape in get_children():
		if not shape is CollisionShape3D: 
			continue
		shape.disabled = lock_axis
