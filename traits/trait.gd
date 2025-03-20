class_name Trait
extends Node2D

@export var agent: Node2D

signal on_active_changed(state: bool)
var is_active: bool = false:
	set(value):
		var old_value = is_active
		if old_value != value:
			is_active = value
			on_active_changed.emit(is_active)
var can_do: Callable = func(): return true


func _ready() -> void:
	assert(agent, "Agent must not be null.")
