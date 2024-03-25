extends Node

signal stat_change
signal player_dead(is_p1)

var health_p1: int = 3:
	set(value):
		if value < 1:
			player_dead.emit(true)
		health_p1 = value
		stat_change.emit()

var health_p2: int = 3:
	set(value):
		if value < 1:
			player_dead.emit(false)
		health_p2 = value
		stat_change.emit()
