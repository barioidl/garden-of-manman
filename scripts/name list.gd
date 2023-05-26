#@tool
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
var unique_steps := &'unique_steps'

var has_food := &'has_food'
var has_drink := &'has_drink'
var has_key := &'has_key'


var health := &'health'
var max_health := &'max_health'
var strength := &'strength'
var max_strength := &'max_strength'
var mana := &'mana'
var max_mana := &'max_mana'
var stamina := &'stamina'
var max_stamina := &'max_stamina'
var thirst := &'thirst'
var max_thirst := &'max_thirst'
var hunger := &'hunger'
var max_hunger := &'max_hunger'

var jumpscare := &'jumpscare'
var puzzle := &'puzzle'
var playing := &'playing'

var player_fear := &'player_fear'
var player_tension := &'player_tension'

var root :=&'root'
var agent := &'agent'

func list_of_group_names():pass
var player := &'player'

var food := &'food'
var drink := &'drink'
var healing_item := &'healing_item'
var key := &'key'

var character := &'character'
var ui_save_load := &'ui_save_load'
var goap_save_load := &'goap_save_load'
var billboard_sprites:= &'billboard_sprites'

var on_quit := &'on_quit'

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
var get_head_position := &'get_head_position'
var input_use_item := &'input_use_item'

var append_item := &'append_item'
var append_item_node := &'append_item_node'
var get_hotbar_items := &'get_hotbar_items'
var is_hotbar_full := &'is_hotbar_full'

var turn_head_toward:= &'turn_head_toward' 

var send_message:= &'send_message'
var receive_message:= &'receive_message'

var respawn := &'respawn'

var toggle_goap_agent := &'toggle_goap_agent'

var get_nav_agent := &'get_nav_agent'

var interact:=&'interact'
var toggle := &'toggle'
var on := &'on'
var off := &'off'

func list_of_methods():pass

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


var body_entered := &'body_entered'
var body_exited := &'body_exited'
var body_shape_entered := &'body_shape_entered'
var body_shape_exited := &'body_shape_exited'

var area_entered := &'area_entered'
var area_exited := &'area_exited'
var area_shape_entered := &'area_shape_entered'
var area_shape_exited := &'area_shape_exited'


var change_health := &'change_health'
var change_strength := &'change_strength'
var change_mana := &'change_mana'
var change_stamina := &'stamina_updated'
var change_thirst := &'thirst_updated'
var change_hunger := &'hunger_updated'

var health_updated := &'health_updated'
var strength_updated := &'strength_updated'
var mana_updated := &'mana_updated'
var stamina_updated := &'stamina_updated'
var thirst_updated := &'thirst_updated'
var hunger_updated := &'hunger_updated'



var on_state_changed := &'on_state_changed'

var item_equipped := &'item_equipped'
var item_unequipped := &'item_unequipped'
var item_used := &'item_used'

var button_down := &'button_down'
var button_up := &'button_up'
var pressed := &'pressed'
var toggled := &'toggled'
