extends Node

signal stat_change
signal player_dead(is_p1)

var health_p1: int = 3:
	set(value):
		health_p1 = change_health(value)
		stat_change.emit()

var health_p2: int = 3:
	set(value):
		health_p2 = change_health(value)
		stat_change.emit()

func change_health(value):
	if value < 1:
		player_dead.emit(false)
	return value
