extends Area2D

var speed: int = 2000
var dmg: int = 1
var power: bool = false

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	$SelfDestructTimer.start()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta 

func _on_body_entered(body: CharacterBody2D) -> void:
	if "hit" in body and not (body.dying or body.dead):
		body.hit(dmg + dmg * int(power))
	queue_free()

func _on_self_destruct_timer_timeout() -> void:
	queue_free()
