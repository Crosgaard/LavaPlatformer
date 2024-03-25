extends Node2D

var arrow_scene: PackedScene = preload("res://Scenes/Projectiles/arrow.tscn")

func _on_player_1_arrow(pos, player1):
	var arrow = arrow_scene.instantiate()
	arrow.position = pos
	if !player1:
		arrow.direction = Vector2.LEFT
		arrow.rotation_degrees = 180
	$Projectiles.add_child(arrow)

func _on_start_lava_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property($Lava, "position", Vector2(0,-600), 90)
