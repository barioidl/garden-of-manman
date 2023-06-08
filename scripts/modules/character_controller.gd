extends RigidBody3D
class_name RigidCharacter

var root = self

var inverted_velocity := Vector3.ZERO
var local_velocity := Vector3.ZERO
var custom_transform :Node3D= self

func _init() -> void:
	setup_body()

func _ready():
	add_to_group(NL.character)

var dt := 0.0
func _process(delta: float) -> void:
	dt = delta
	set_damp()
	bungee_time()

func _physics_process(delta):
	move_body()

func setup_body():
	axis_lock_angular_x = true
	axis_lock_angular_y = true
	axis_lock_angular_z = true
	max_contacts_reported = 2
	contact_monitor = true
	
#	physics_material_override = load("res://materials/default_physics_material.tres")

func set_damp():
	var damp := 0
	if on_floor:
		damp += 4
	if on_wall:
		damp += 0.5
	if on_ceiling:
		damp += 1
	linear_damp = damp

var bungee_duration := 0.1
var on_floor_bungee := 0.0
var on_wall_bungee := 0.0
var on_ceiling_bungee := 0.0
func bungee_time():
	on_floor_bungee -= dt
	on_wall_bungee -= dt
	on_ceiling_bungee -= dt
	
	on_floor = on_floor_bungee > 0
	on_wall = on_wall_bungee > 0
	on_ceiling = on_ceiling_bungee > 0

var on_floor:=false
var on_wall:=false
var on_ceiling:=false
func _integrate_forces(state: PhysicsDirectBodyState3D):
	for i in state.get_contact_count():
		var normal = state.get_contact_local_normal(i)
		var dist = normal.dot(basis.y)
		if dist > 0.7:#45 degrees
			on_floor_bungee = bungee_duration
			continue
		if dist < -0.7:
			on_ceiling_bungee = bungee_duration
			continue
		on_wall_bungee = bungee_duration

func move_body():
	var tran = custom_transform.global_transform
	inverted_velocity = tran.inverse().basis * linear_velocity
	var velo := inverted_velocity
	
	var abs_x = max(abs(local_velocity.x), abs(velo.x))
	var abs_y = max(abs(local_velocity.y), abs(velo.y))
	var abs_z = max(abs(local_velocity.z), abs(velo.z))
	
	velo.x = clampf(velo.x + local_velocity.x, -abs_x, abs_x)
	velo.y = clampf(velo.y + local_velocity.y, -abs_y, abs_y)
	velo.z = clampf(velo.z + local_velocity.z, -abs_z, abs_z)
	
	local_velocity = Vector3.ZERO
	linear_velocity = tran.basis * velo
#	var _collided=move_and_slide()
