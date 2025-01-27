class_name PlayerDmgBoard extends Node
@onready var player_board_sprite: Sprite2D = $PlayerBoardSprite

var color: String = "red"

var colors_sprites = {
	"white": preload("res://assets/white.png"),
	"blue": preload("res://assets/blue.png"),
	"red": preload("res://assets/red.png"),
	"green": preload("res://assets/green.png"),
	"light_blue": preload("res://assets/light_blue.png"),
	"yellow": preload("res://assets/yellow.png"),
	"purple": preload("res://assets/purple.png"),
	"orange": preload("res://assets/orange.png"),
}

func _ready():
	pass
	
func set_player_board_sprite(player_color : String):
	player_board_sprite.texture = colors_sprites[player_color]
