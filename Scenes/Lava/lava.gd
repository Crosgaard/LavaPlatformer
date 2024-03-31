extends Area2D

func _on_body_entered(body):
	if "die" in body:
		body.die()

func _on_area_entered(area):
	if area.is_in_group("Item"):
		area.queue_free()
