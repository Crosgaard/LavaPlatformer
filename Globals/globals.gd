extends Node

signal health_change
signal shield_change(is_p1: bool)
signal player1_dead()
signal player2_dead()

var max_health: int = 3

var health_p1: int = max_health:
	set(value):
		health_p1 = change_health(value, true)
		health_change.emit()

var health_p2: int = max_health:
	set(value):
		health_p2 = change_health(value, false)
		health_change.emit()

func change_health(value: int, is_p1: bool) -> int:
	if value < 1:
		if is_p1:
			player1_dead.emit()
		else:
			player2_dead.emit()
	return min(value, max_health)

var shield_p1: bool = false:
	set(value):
		shield_p1 = value
		shield_change.emit(true)

var shield_p2: bool = false:
	set(value):
		shield_p2 = value
		shield_change.emit(false)
