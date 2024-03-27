extends Area2D

var speed: int = 2000
var direction: Vector2 = Vector2.RIGHT
var dmg: int = 1
var power: bool = false

func _ready():
	$SelfDestructTimer.start()

func _process(delta):
	position += direction * speed * delta 

func _on_body_entered(body):
	if "hit" in body:
		body.hit(dmg + dmg * int(power))
	queue_free()

func _on_self_destruct_timer_timeout():
	queue_free()
