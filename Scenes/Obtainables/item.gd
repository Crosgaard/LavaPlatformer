extends Area2D
var available_options = ["rapid_fire", "power", "shield", "double_jump", "health"]
var type = available_options[randi() % len(available_options)]

# Colors
var red  = Color(1., 0.2, 0.4)
var yellow = Color(1., 1., 0.2)
var purple = Color(0.6, 0.4, 1.)
var blue = Color(0.1, 0.75, 1.)
var green= Color(0.5, 1., 0.6)

func _ready():
	if type == "health":
		$Sprite2D.modulate = red
		$PointLight2D.color = red
	elif type == "rapid_fire":
		$Sprite2D.modulate = yellow
		$PointLight2D.color = yellow
	elif type == "power":
		$Sprite2D.modulate = purple
		$PointLight2D.color = purple
	elif type == "shield":
		$Sprite2D.modulate = blue
		$PointLight2D.color = blue
	elif type == "double_jump":
		$Sprite2D.modulate = green
		$PointLight2D.color = green
	$AnimationPlayer.play("animate")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		var is_p1 = body.is_player1
		if type == "health":
			if is_p1:
				Globals.health_p1 += 1
			else:
				Globals.health_p2 += 1
		elif type == "rapid_fire":
			body.rapid_fire = true
		elif type == "power":
			body.power = true
		elif type == "shield":
			if is_p1:
				Globals.shield_p1 = true
			else:
				Globals.shield_p2 = true
		elif type == "double_jump":
			body.double_jump = true
		queue_free()
