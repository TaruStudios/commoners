class_name Character
extends CharacterBody2D

@export_group("Config")
@export var use_move_and_slide: bool = true

enum Movement {
	MOVEMENT_X_AXIS = 1,
	MOVEMENT_Y_AXIS = 2,
	MOVEMETN_BOTH_AXES = 3,
}


func _apply_gravity(delta: float):
	pass


func _physics_process(delta: float) -> void:
	# this should call move_and_slide or move_and_collide
	if use_move_and_slide:
		call_deferred(move_and_slide.get_method())
	else:
		call_deferred(move_and_collide.get_method())
