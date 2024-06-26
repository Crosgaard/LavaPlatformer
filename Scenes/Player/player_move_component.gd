extends Node

func get_movement_direction(left: String, right: String) -> float:
	return Input.get_axis(left, right)

# Return a boolean indicating if the character wants to jump
func wants_jump(jump: String) -> bool:
	return Input.is_action_just_pressed(jump)

func wants_shoot(shoot: String) -> bool:
	return Input.is_action_just_pressed(shoot)
