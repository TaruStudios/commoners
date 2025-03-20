class_name JumpTrait
extends Trait

@export_group("Config")
@export var action_name: String = "jump"
@export var jump_height: float = 512
@export var jump_time_to_peak: float = 0.8
@export var jump_time_to_descent: float = 0.5

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = (2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready
var fall_gravity: float = (2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)
@onready var character: Character = agent as Character


func _ready() -> void:
	assert(agent is Character, "JumpTrait can only be added to characters")


func gravity():
	return fall_gravity if agent.velocity.y > 0 else jump_gravity


func can_jump() -> bool:
	if character.movement_lock & Character.MovementAxis.MOVEMENT_Y_AXIS:
		return false
	return can_do.call()


func jump() -> void:
	character.velocity.y = jump_velocity


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(action_name) and can_jump():
		jump()
