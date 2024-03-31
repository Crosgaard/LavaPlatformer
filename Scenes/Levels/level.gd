extends Node2D

var arrow_scene: PackedScene = preload("res://Scenes/Projectiles/arrow.tscn")

func player_won(text: String) -> void:
	$GameOver.visible = true
	$GameOver.winner = text + " WON!"
	get_tree().paused = true

func _on_player_arrow(pos: Vector2, is_p1: bool, power: bool) -> void:
	var arrow = arrow_scene.instantiate()
	arrow.position = pos
	arrow.power = power
	if not is_p1:
		arrow.direction = Vector2.LEFT
		arrow.rotation_degrees = 180
	$Projectiles.add_child(arrow)

func _on_start_lava_timeout() -> void:
	pass
	# var tween = get_tree().create_tween()
	#tween.tween_property($Lava, "position", Vector2(0,-600), 80)

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body is Player:
		player_won("PLAYER 1" if body.is_player1 else "PLAYER 2")

func _on_player_has_died(is_p1: bool) -> void:
	player_won("PLAYER 2" if is_p1 else "PLAYER 1")


