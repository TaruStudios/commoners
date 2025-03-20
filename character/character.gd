class_name Character
extends CharacterBody2D

@export_group("Config")
@export var use_move_and_slide: bool = true
@export var default_gravity: float = 980.0
var gravity: Callable = func(): return default_gravity

var movement_lock: MovementAxis = MovementAxis.UNKNOWN

enum MovementAxis {
	UNKNOWN = 0,
	MOVEMENT_X_AXIS = 1,
	MOVEMENT_Y_AXIS = 2,
	MOVEMENT_BOTH_AXES = 3,
}


func _apply_gravity(delta: float):
	if movement_lock & MovementAxis.MOVEMENT_Y_AXIS:
		# this means that we have a lock on Y axis
		# so no gravity for now
		return
	velocity.y += gravity.call() * delta


func lock_movement(axis: MovementAxis):
	movement_lock |= axis


func unlock_movement(axis: MovementAxis):
	movement_lock &= ~axis


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	# this should call move_and_slide or move_and_collide
	if use_move_and_slide:
		call_deferred(move_and_slide.get_method())
	else:
		call_deferred(move_and_collide.get_method())
