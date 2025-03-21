class_name DashTrait
extends Trait

@export_group("Config")
@export var action_dash: String = "dash"
@export var speed: float = 800.0
@export var cast_time: float = 0.4

@onready var character: Character = agent as Character
@onready var _cast_timer: Timer = Timer.new()


func _ready() -> void:
	assert(agent is Character, "DashTrait can only be added to Character")
	_cast_timer.wait_time = cast_time
	_cast_timer.one_shot = true
	_cast_timer.timeout.connect(_cast_timer_timeout)
	add_child(_cast_timer)


func _cast_timer_timeout() -> void:
	is_active = false
	character.velocity.x = 0


func can_dash() -> bool:
	return can_do.call()


func dash() -> void:
	# TODO: get the intended dash direction maybe from traits? or character? based on facing
	is_active = true
	var speed_vector = Vector2(speed, 0)

	speed_vector = speed_vector.rotated(deg_to_rad(character.facing))
	prints("dash speed_vector", speed_vector)
	if is_zero_approx(character.velocity.x) and is_zero_approx(character.velocity.y):
		# that means we are standing still
		character.velocity = speed_vector * 200
	else:
		character.velocity *= speed
	_cast_timer.start(cast_time)


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed(action_dash) and can_dash():
		dash()
