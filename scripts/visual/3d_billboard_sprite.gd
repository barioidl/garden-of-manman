@tool
extends Billboard3d
class_name BillboardSprite

@export var use_shade:=true
@export var has_shadow:= true
@export var alphacut:=SpriteBase3D.ALPHA_CUT_DISCARD

func _ready() -> void:
	super._ready()
	if sprites == null:
		print(str(get_path())+' billboard sprite with null sides')
	set_up_sprite()
	set_face_axis()

func set_up_sprite():
	var sprite = self
	sprite.set_draw_flag(SpriteBase3D.FLAG_DOUBLE_SIDED, false)
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	sprite.shaded = use_shade
	sprite.alpha_cut = alphacut
	sprite.transparent = true
	var shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_DOUBLE_SIDED if has_shadow else GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	sprite.cast_shadow = shadow

func set_face_axis():
	var sprite = self
	match face_camera:
		bill_board_modes.bill_board:
			sprite.axis = Vector3.AXIS_Z
		bill_board_modes.lock_y_axis:
			sprite.axis = Vector3.AXIS_Y
		bill_board_modes.six_sides:
			sprite.axis = Vector3.AXIS_Z

@export var sprites:BillboardSides:
	get:
		return sprites
	set(value):
		if sprites == value: return
		sprites = value
		if sprites == null:	return
		sprites._init()
		select(current_side)

func select(side):
	current_side = side
	if sprites == null:
		return
	var sprite = sprites.get_sprite(side)
	if sprite == null: 
		return
	self.texture = sprite
	emit_signal("sprite_changed")
