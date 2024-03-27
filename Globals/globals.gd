extends Node

signal stat_change
signal player_dead(is_p1)

var health_p1: int = 3:
	set(value):
		health_p1 = change_health(value, true)
		stat_change.emit()
		print("player 1: " + str(health_p1))

var health_p2: int = 3:
	set(value):
		health_p2 = change_health(value, false)
		stat_change.emit()
		print("player 2: " + str(health_p2))

func change_health(value, player):
	if value < 1:
		player_dead.emit(player)
	return value
