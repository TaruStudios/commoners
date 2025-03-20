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
@onready var jump_strength_timer: Timer = Timer.new()


func _ready() -> void:
	assert(agent is Character, "JumpTrait can only be added to characters")
	jump_strength_timer.wait_time = jump_time_to_peak
	jump_strength_timer.one_shot = true
	add_child(jump_strength_timer)


func gravity():
	return fall_gravity if agent.velocity.y > 0 else jump_gravity


func can_jump() -> bool:
	if character.movement_lock & Character.MovementAxis.MOVEMENT_Y_AXIS:
		return false
	return can_do.call()


func finish_jump() -> void:
	is_active = false
	character.velocity.y = 0
	jump_strength_timer.stop()


func jump() -> void:
	is_active = true
	character.velocity.y = jump_velocity
	jump_strength_timer.start(jump_time_to_peak)


func _process(delta: float) -> void:
	# TODO: research if it is ok to put jump function here instead of physics
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_released(action_name) and not is_zero_approx(jump_strength_timer.time_left):
		finish_jump()


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(action_name) and can_jump():
		jump()
