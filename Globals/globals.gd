extends Node

signal health_change
signal shield_change(is_p1)
signal player_dead(is_p1)

var max_health: int = 3

var health_p1: int = max_health:
	set(value):
		health_p1 = change_health(value, true)
		health_change.emit()
		print("player 1: " + str(health_p1))

var health_p2: int = max_health:
	set(value):
		health_p2 = change_health(value, false)
		health_change.emit()
		print("player 2: " + str(health_p2))

func change_health(value, player):
	if value < 1:
		player_dead.emit(player)
	return min(value, max_health)

var shield_p1: bool = false:
	set(value):
		shield_p1 = value
		shield_change.emit(true)

var shield_p2: bool = false:
	set(value):
		shield_p2 = value
		shield_change.emit(false)
