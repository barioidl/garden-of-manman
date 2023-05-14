@tool
extends Node

func list_of_states():pass
var die := &'die'
var idle:= &'idle'
var walk:= &'walk'
var sneak := &'sneak'
var sprint := &'sprint'
var jump := &'jump'
var fall := &'fall'

func list_of_goap_states():pass
var creativity := &'creativity'
var curiosity := &'curiosity'
var integrity := &'integrity'
var compassion := &'compassion'
var efficient := &'efficient'
var ambitious := &'ambitious'
var honesty := &'honesty'
var bravery := &'bravery'

var plan_width := &'plan_width'
var plan_depth := &'plan_depth'

var has_food := &'has_food'
var has_drink := &'has_drink'
var has_key := &'has_key'

var hunger := &'hunger'
var max_hunger := &'max_hunger'

var health := &'health'
var max_health := &'max_health'

var mana := &'mana'
var max_mana := &'max_mana'


func list_of_group_names():pass
var player := &'player'

var food := &'food'
var drink := &'drink'
var healing_item := &'healing_item'
var key := &'key'

var character := &'character'
var ui_save_load := &'ui_save_load'
var billboard_sprites:= &'billboard_sprites'

func list_of_meta():pass
var show_dialogue:= &'show_dialogue'
var show_image:= &'show_image'
var connect_stats_display := &'connect_stats_display'

var get_inputs := &'get_inputs'

var delay_platformer := &'delay_platformer'
var walk_to_target := &'walk_to_target'
var sneak_to_target := &'sneak_to_target'
var sprint_to_target := &'sprint_to_target'
var jump_to_target := &'jump_to_target'

var get_target := &'get_target'
var input_use_item := &'input_use_item'

var append_item := &'append_item'
var append_item_node := &'append_item_node'
var get_hotbar_items := &'get_hotbar_items'
var is_hotbar_full := &'is_hotbar_full'

var turn_head_toward:= &'turn_head_toward' 

var send_message:= &'send_message'
var receive_message:= &'receive_message'

var respawn := &'respawn'



func list_of_methods():pass
var interact:=&'interact'

func list_of_signals():pass
var jump_pressed := &'jump_pressed'
var jump_released := &'jump_released'

var act_pressed := &'act_pressed'
var act_released := &'act_released'
var attack_pressed := &'attack_pressed'
var attack_released := &'attack_released'
var skill_pressed := &'skill_pressed'
var skill_released := &'skill_released'
var misc_pressed := &'misc_pressed'
var misc_released := &'misc_released'

var ctrl_pressed := &'ctrl_pressed'
var ctrl_released := &'ctrl_released'
var shift_pressed := &'shift_pressed'
var shift_released := &'shift_released'
var alt_pressed := &'alt_pressed'
var alt_released := &'alt_released'
var tab_pressed := &'tab_pressed'
var tab_released := &'tab_released'

var inventory_pressed := &'inventory_pressed'
var inventory_released := &'inventory_released'
var drop_pressed := &'drop_pressed'
var drop_released := &'drop_released'
var reload_pressed := &'reload_pressed'
var reload_released := &'reload_released'
var flip_pressed := &'flip_pressed'
var flip_released := &'flip_released'


var health_updated:= &'health_updated'
var mana_updated:= &'mana_updated'
var hunger_updated:= &'hunger_updated'

var on_state_changed := &'on_state_changed'

var item_equipped := &'item_equipped'
var item_unequipped := &'item_unequipped'
var item_used := &'item_used'
