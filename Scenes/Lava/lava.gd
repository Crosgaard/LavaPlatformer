extends Area2D

func _on_body_entered(body):
	print(body)
	if "die" in body:
		body.die()
		print("hello there")
