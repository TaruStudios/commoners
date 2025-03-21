class_name MoveTrait
extends Trait

enum Direction {
	NEGATIVE_DIRECTION = -1,
	POSITIVE_DIRECTION = 1,
	NO_DIRECTION = 0,
}

@export_group("Config")
@export var action_negative: String = "left"
@export var action_positive: String = "right"
@export var speed: float = 500.0
@export var ignore_magnitude: bool = true
@export var horizontal_config: bool = true

signal on_intended_direction_changed(direction: Direction)
@onready var intended_direction: Direction = Direction.NO_DIRECTION:
	set(value):
		var old_value = intended_direction
		if old_value != value:
			intended_direction = value
			on_intended_direction_changed.emit(intended_direction)

@onready var character: Character = agent as Character


func _ready() -> void:
	assert(agent is Character, "MoveTrait can only added to Character")


func can_move() -> bool:
	return can_do.call()


func move(speed_vector: Vector2, _delta: float) -> void:
	is_active = true
	character.velocity = speed_vector


func _physics_process(delta: float) -> void:
	var axis: float = Input.get_axis(action_negative, action_positive)
	var direction_vector
	if ignore_magnitude:
		axis = sign(axis)

	if is_zero_approx(axis):
		is_active = false
		if horizontal_config:
			character.velocity = Vector2(0, character.velocity.y)
		else:
			character.velocity = Vector2(character.velocity.x, 0)

	if can_move() and not is_zero_approx(axis):
		intended_direction = sign(axis)
		if horizontal_config:
			move(Vector2(axis * speed, character.velocity.y), delta)
		else:
			move(Vector2(character.velocity.x, axis * speed), delta)
