@tool
extends Sprite3D

@export var billboard_sprite:Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if billboard_sprite == null:
		billboard_sprite = get_node_or_null("../Sprite3D")
	if billboard_sprite == null: return
	billboard_sprite.connect('sprite_changed',sprite_changed)
	billboard_sprite.connect('rotation_changed',rotation_changed)
	
	call_deferred('set_up_sprite')

func set_up_sprite():
	set_draw_flag(SpriteBase3D.FLAG_DOUBLE_SIDED, false)
	texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	shaded = billboard_sprite.use_shade
	alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	axis = billboard_sprite.axis

func sprite_changed():
	texture = billboard_sprite.texture

func rotation_changed():
	global_rotation = billboard_sprite.global_rotation
