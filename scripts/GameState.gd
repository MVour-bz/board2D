extends Node

enum GamePhase {
	IN_LOBBY,
	GAME_STARTED,
	ENDED
}

var game_phase_status

var deck = {
	
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
	"playing": false,
	"dmg": 0
}

var game_settings = {
	"vampires_count": 0,
	"warewolves_count": 0,
	"humans_count"	: 0,
}

var game_info = {
	"players_turn": [],
	"round" : 0,
}
