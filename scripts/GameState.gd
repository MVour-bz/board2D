extends Node

enum GamePhase {
	IN_LOBBY,
	GAME_STARTED,
	ENDED
}

var game_phase_status

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
