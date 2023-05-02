#@tool
extends Billboard3d
class_name BillboardSprite

func _ready() -> void:
	sprites.change_frame(0)
	super._ready()

#func _process(delta: float) -> void:
#	super._process(delta)

@export var sprites:BillboardSides:
	get:
		return sprites
	set(value):
		if sprites == value: return
		sprites = value
		sprites.init()
		select(current_side)

func select(side):
	current_side = side
	if sprites == null:	return
	self.texture = sprites.get_sprite(side)
	emit_signal("sprite_changed")
