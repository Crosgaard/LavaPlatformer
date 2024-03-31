extends "res://Scenes/Tiles/special_tiles.gd"

@export var lava_range = 300

func _ready():
	$Area2D.position.y = lava_range

func _on_area_2d_area_entered(area):
	if area.name == "Lava":
		$LavaShader.visible = true
		$SelfDestruct.start()

func _on_self_destruct_timeout():
	queue_free()
