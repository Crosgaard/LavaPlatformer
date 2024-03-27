extends Area2D
var available_options = ["rapid_fire", "power", "shield", "double_jump", "health"]
var type = available_options[randi() % len(available_options)]

var direction: Vector2
var distance: int = randi_range(150, 250)

func _ready():
	if type == "health":
		$Sprite2D.modulate = Color(0.5, 0.2, 0.1)
	elif type == "rapid_fire":
		$Sprite2D.modulate = Color(0.7, 0.5, 0.4)
	elif type == "power":
		$Sprite2D.modulate = Color(0.3, 0.0, 0.7)
	elif type == "shield":
		$Sprite2D.modulate = Color(0.0, 0.0, 0.5)
	elif type == "double_jump":
		$Sprite2D.modulate = Color(0.3, 0.6, 0.2)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		var is_p1 = body.is_player1
		if type == "health":
			if is_p1:
				Globals.health_p1 += 1
			else:
				Globals.health_p2 += 1
		elif type == "rapid_fire":
			Globals.laser_amount += 5
		elif type == "grenade":
			Globals.grenade_amount += 2
		queue_free()
