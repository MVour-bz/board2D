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
	"hidden": true,
	"dmg": 0
}
	#"dmg": "",
	#"max_dmg": "",}

var game_settings_default = {
	"players" : {
		4 : {"vampires_count": 2, "warewolves_count": 2, "humans_count": 0},
		5 : {"vampires_count": 2, "warewolves_count": 2, "humans_count": 1},
		6 : {"vampires_count": 2, "warewolves_count": 2, "humans_count": 2},
		7 : {"vampires_count": 2, "warewolves_count": 2, "humans_count": 3},
		8 : {"vampires_count": 3, "warewolves_count": 3, "humans_count": 2}
	},
	"chairs_config" : {
		2 : ["slot1", "slot4"],
		3 : ["slot1", "slot4", "slot7"],
		4 : ["slot1", "slot2", "slot4", "slot7"],
		5 : ["slot1", "slot2", "slot4", "slot6", "slot8"],
		6 : ["slot1", "slot2", "slot4", "slot5", "slot6", "slot8"],
		7 : ["slot1", "slot2", "slot3", "slot4", "slot5", "slot6", "slot8"],
		8 : ["slot1", "slot2", "slot3", "slot4", "slot5", "slot6", "slot7", "slot8"],
	}
}


var deck = {
	"characters": {
		"humans" : [
			{"id": "h1", "species": "human", "name": "Ada", "health": 8, "ability_code": "G:H/++", "ability": "Once per game can restore full health", "goal": "Survive until the end."},
			{"id": "h2", "species": "human", "name": "Hope", "health": 8, "ability_code": "G:W/LP", "ability": "Once per game can, change to winning condiiton. From supporting the right player, to support the left player", "goal": "Wins if the player on the RIGHT wins"},
		],
		"vampires": [
			{"id": "v1", "species": "vampire", "name": "Volco", "health": 13, "ability_code": "A:H/+2", "ability": "Heal +2 when you successfully attack!", "goal": "No warewolfs standing" },
			{"id": "v2", "species": "vampire", "name": "Mel", "health": 14, "ability_code": "D:A", "ability": "When attacked you can return the attack! (Can be used even not in yout turn, Can't return the attack that killed you)", "goal": "No warewolfs standing"}
		],
		"warewolves": [
			{"id": "w1", "species": "warewolf", "name": "Frederick", "health": 12, "ability_code": "G:A/6Z", "ability": "Once per game can choos to attack with the 6 sided dice.", "goal": "No vampiers standing"},
			{"id": "w1", "species": "warewolf", "name": "Gregor", "health": 14, "ability_code": "G:A/4Z", "ability": "Once per game can choos to attack with the 4 sided dice.", "goal": "No vampiers standing"}
		]
	},
	"locations" : [
		{"id": "l1", "name": "old_chappel", "label": "Old Chappel", "effect": "Draw: Red, Blue", "position": 0, "players": []},
		{"id": "l2", "name": "old_chappel", "label": "Old Chappel", "effect": "Draw: Red, Blue", "position": 0, "players": []},
		{"id": "l3", "name": "old_chappel", "label": "Old Chappel", "effect": "Draw: Red, Blue", "position": 0, "players": []},
		{"id": "l4", "name": "old_chappel", "label": "Old Chappel", "effect": "Draw: Red, Blue", "position": 0, "players": []},
		{"id": "l5", "name": "old_chappel", "label": "Old Chappel", "effect": "Draw: Red, Blue", "position": 0, "players": []},
		{"id": "l6", "name": "old_chappel", "label": "Old Chappel", "effect": "Draw: Red, Blue", "position": 0, "players": []},
	],
	"blue_cards" : [
		{"id": "bc1", "title": "Some Blue Card", "text": "Some BlueCard Text"},
		{"id": "bc2", "title": "Some Blue Card", "text": "Some BlueCard Text"},
		{"id": "bc3", "title": "Some Blue Card", "text": "Some BlueCard Text"},
		{"id": "bc4", "title": "Some Blue Card", "text": "Some BlueCard Text"},
		{"id": "bc5", "title": "Some Blue Card", "text": "Some BlueCard Text"}
	],
	"green_cards" : [
		{"id": "gc1", "title": "Some Green Card", "text": "Some GreenCard Text"},
		{"id": "gc2", "title": "Some Green Card", "text": "Some GreenCard Text"},
		{"id": "gc3", "title": "Some Green Card", "text": "Some GreenCard Text"},
		{"id": "gc4", "title": "Some Green Card", "text": "Some GreenCard Text"},
		{"id": "gc5", "title": "Some Green Card", "text": "Some GreenCard Text"}
		
	],
	"red_cards" : [
		{"id": "rc1", "title": "Some Red Card", "text": "Some RedCard Text"},
		{"id": "rc2", "title": "Some Red Card", "text": "Some RedCard Text"},
		{"id": "rc3", "title": "Some Red Card", "text": "Some RedCard Text"},
		{"id": "rc4", "title": "Some Red Card", "text": "Some RedCard Text"},
		{"id": "rc5", "title": "Some Red Card", "text": "Some RedCard Text"}
		
	]
	
}


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
