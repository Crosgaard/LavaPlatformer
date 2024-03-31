extends "res://Scenes/Tiles/special_tiles.gd"

@export var acc: float = 0.2
@export var range: float = 200.0

var speed: float = 0.0
var going_up: bool = false
var going_down: bool = false

@onready var start_pos = position

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if going_down:
		speed += acc
		position.y += speed
		if position.y > start_pos.y + range:
			position.y = start_pos.y + range
			going_down = false
	
	if going_up:
		speed += acc/4
		position.y -= speed
		if position.y <= start_pos.y:
			position.y = start_pos.y
			going_up = false
	
func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body is Player:
		going_down = true
		going_up = false
		speed = 0

func _on_area_2d_body_exited(body:CharacterBody2D) -> void:
	if body is Player:
		going_down = false
		going_up = true
		speed = 0
