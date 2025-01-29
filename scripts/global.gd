extends Node


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

var player_default = {
	"sprite_color": "",
	"pawn": "",
	"name": "",
	"board_scene": "", 
	"main_scene": "", 
	#"dmg": "",
	#"max_dmg": "",
}

var players = {}

var active_player = {
	"id": 0,
	"turn": 0,
	"sprite_color": "",
	"pawn": "",
	"name": "",
	"board_scene": "", 
	"main_scene": "",
	"character": "",
}
	#"dmg": "",
	#"max_dmg": "",}

var pawns = {
	"white": {
		"color": "white",
		"sprite": preload("res://assets/white.png"),
		"available": true,
		"reserved": false,
		"playing": false,
		"player": {}
	},
	"blue": {
		"color": "blue",
		"sprite": preload("res://assets/blue.png"),
		"available": true,
		"playing": false,
		"player": {}
	},
	"red": {
		"color": "red",
		"sprite": preload("res://assets/red.png"),
		"available": true,
		"playing": false,
		"player": {}
	},
	"green": {
		"color": "green",
		"sprite": preload("res://assets/green.png"),
		"available": true,
		"playing": false,
		"player": {}
	},
	"light_blue": {
		"color": "light_blue",
		"sprite": preload("res://assets/light_blue.png"),
		"available": true,
		"playing": false,
		"player": {}
	},
	"yellow": {
		"color": "yellow",
		"sprite": preload("res://assets/yellow.png"),
		"available": true,
		"playing": false,
		"player": {}
	},
	"purple": {
		"color": "purple",
		"sprite": preload("res://assets/purple.png"),
		"available": true,
		"playing": false,
		"player": {}
	},
	"orange": {
		"color": "orange",
		"sprite": preload("res://assets/orange.png"),
		"available": true,
		"playing": false,
		"player": {}
	},
}
