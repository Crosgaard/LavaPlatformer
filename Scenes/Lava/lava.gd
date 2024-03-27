extends Area2D

func _on_body_entered(body):
	if "die" in body:
		body.die()
