@tool
class_name InputController2D extends Node
@icon("icon.svg")

@export var action_left := "ui_left"
@export var action_right := "ui_right"
@export var action_up := "ui_up"
@export var action_down := "ui_down"
@export var acceleration := 50.0
@export var friction := 0.5
@export var maximum_speed := 100.0

var input_vector := Vector2.ZERO
var velocity := Vector2.ZERO
var look_direction := Vector2.ZERO
var move_direction := Vector2.ZERO

func get_look_direction() -> Vector2:
	return look_direction
	
func get_move_direction() -> Vector2:
	return move_direction

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	input_vector.x = Input.get_action_strength(action_right) - Input.get_action_strength(action_left)
	input_vector.y = Input.get_action_strength(action_down) - Input.get_action_strength(action_up)

	if input_vector.length() != 0:
		look_direction = input_vector.normalized()

	velocity = velocity.move_toward(input_vector * maximum_speed * delta, acceleration * delta)
	
	if get_parent() is CharacterBody2D:
		var parent = get_parent() as CharacterBody2D
		parent.velocity = velocity
		parent.move_and_slide()
		velocity = parent.velocity
	elif get_parent() is Node2D:
		var parent = get_parent() as Node2D
		parent.global_position += velocity
		
	if velocity.length() != 0:
		move_direction = velocity.normalized()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if acceleration <= 0.0:
		warnings.append("'acceleration' must be greater than 0.")
	if maximum_speed <= 0.0:
		warnings.append("'maximum_speed' must be greater than 0.")
	if action_left.is_empty():
		warnings.append("'action_left' is not specified.")
	if action_right.is_empty():
		warnings.append("'action_right' is not specified.")
	if action_up.is_empty():
		warnings.append("'action_up' is not specified.")
	if action_down.is_empty():
		warnings.append("'action_down' is not specified.")
	if not get_parent() is Node2D:
		warnings.append("Must be child of Node2D or CharacterBody2D")
	return PackedStringArray(warnings)
