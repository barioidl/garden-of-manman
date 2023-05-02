extends RigidBody3D
class_name RigidCharacter

var root := self

var rotation_y := 0.0
var offset_rotation:Quaternion
func rotate_body(angle:float):
	rotation_y += angle
	quaternion = offset_rotation * Quaternion(Vector3(0,1,0), rotation_y)

func _ready():
	add_to_group("character")
	setup_body()

func setup_body():
	axis_lock_angular_x = true
	axis_lock_angular_y = true
	axis_lock_angular_z = true
	max_contacts_reported = 2
	contact_monitor = true
	
	var material := PhysicsMaterial.new()
	material.friction = 0.1
	material.rough = false
	material.bounce = 0.1
	material.absorbent = false
	physics_material_override = material

var time := 0.0
func _physics_process(delta):
	time = delta
	move_body()

var on_floor:=false
var on_wall:=false
var on_ceiling:=false
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	on_floor=false
	on_wall=false
	on_ceiling=false
	var up_direction:=basis.y
	for i in state.get_contact_count():
		var normal = state.get_contact_local_normal(i)
		var dist = (normal - up_direction). length_squared()
		if dist <0.5:
			on_floor = true
		if dist > 3.5:
			on_ceiling = true
		else:
			on_wall = true
#	print("on_floor: "+ str(on_floor)+", on_floor: "+ str(on_wall)+", on_ceiling: "+ str(on_ceiling))

var inverted_velocity := Vector3.ZERO
var local_velocity := Vector3.ZERO
@onready var body = $body
func move_body():
	var trans = body.global_transform
	inverted_velocity= trans.inverse().basis * linear_velocity
	var velo :Vector3=inverted_velocity
	
	var abs_x = abs(local_velocity.x)
	var abs_y = abs(local_velocity.y)
	var abs_z = abs(local_velocity.z)
	if !on_floor:
		var friction = 1-time
		abs_x = max(abs_x,abs(velo.x)*friction)
		abs_y = max(abs_y,abs(velo.y))
		abs_z = max(abs_z,abs(velo.z)*friction)
	
	velo.x = clampf(velo.x+local_velocity.x,-abs_x,abs_x)
	velo.y = clampf(velo.y+local_velocity.y,-abs_y,abs_y)
	velo.z = clampf(velo.z+local_velocity.z,-abs_z,abs_z)
	
	local_velocity = Vector3.ZERO
	linear_velocity = trans.basis * velo
#	var _collided=move_and_slide()
