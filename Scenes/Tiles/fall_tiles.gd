extends "res://Scenes/Tiles/special_tiles.gd"

@export var acc: float = 0.2
@export var range: float = 200
var speed: float = 0
var going_up: bool = false
var going_down: bool = false
@onready var start_pos = position

func _ready():
	pass

func _physics_process(_delta):
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
	
func _on_area_2d_body_entered(body):
	if "is_player1" in body:
		going_down = true
		going_up = false
		speed = 0

func _on_area_2d_body_exited(body):
	if "is_player1" in body:
		going_down = false
		going_up = true
		speed = 0
