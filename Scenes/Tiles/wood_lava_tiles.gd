extends SpecialTiles

@export var lava_range: int = 300

func _ready() -> void:
	$Area2D.position.y = lava_range

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Lava":
		$LavaShader.visible = true
		$SelfDestruct.start()

func _on_self_destruct_timeout() -> void:
	queue_free()
