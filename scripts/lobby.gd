class_name Lobby extends Node2D

var lobbyId = ""

var question_mark_sprite : PackedScene = preload("res://scenes/question_mark_sprite.tscn")
@onready var lobby_container: GridContainer = $LobbyPanel/LobbyContainer
@onready var lobby_id: Label = $GridContainer/LobbyId
@onready var start_game_button: Button = $StartGameButton
@onready var players_in_lobby: Label = $GridContainer/PlayersInLobby

@export var q_marks = {}

#var question_mark_texture = preload("")
var max_players = 8

func _ready():
	SignalBus._avatar_created.connect(_on_avatar_created)
	
	pass

#@rpc("any_peer", "call_local")
func lobby_init(id : String):
	lobbyId = id
	lobby_id.text = id
	
	print("multiplayr is server: ", multiplayer.is_server(), " / ", multiplayer.get_unique_id())
	if not multiplayer.is_server():
		start_game_button.hide()


func _on_player_joined(player):
	pass


func _on_avatar_created(name, color):
	print("Sharing avatar")
	share_avatar.rpc(GameState.active_player)


@rpc("any_peer", "call_local")
func share_avatar(player):
	# update player info
	GameState.players[player.id] = player
	# update pawns
	Global.pawns[player.pawn].player = player.name
	Global.pawns[player.pawn].available = false
	
	q_marks[player.id].set_sprite_name(player.name)
	q_marks[player.id].use_texture(player.pawn)



@rpc("any_peer")
func lobby_add_player(player):
	print("Lobby: adding player: " , player)
	
	GameState.players[player.id] = (player)
	if multiplayer.is_server():
		player = set_temp_name(player)
	
	if not q_marks.has(player.id):
		var new_q_mark = question_mark_sprite.instantiate()
		lobby_container.add_child(new_q_mark)
		new_q_mark.init(player)
		q_marks[player.id] = new_q_mark
	
	if multiplayer.is_server():
		for pl in GameState.players:
			lobby_add_player.rpc(GameState.players[pl])
	
	players_in_lobby.text = str(GameState.players.size())



func _on_button_pressed() -> void:
	SignalBus._return_to_mulitplayer_menu.emit()


func _on_start_game_pressed() -> void:
	start_game.rpc()

func set_temp_name(player):
	print("edw")
	if not player.name == null:
		print("edw edw")
		if player.name == "":
			var name = "Player_" + str(GameState.players.size())
			print("new name: ", name)
			player.name = name
			GameState.players[player.id].name = name
			if GameState.active_player.id == player.id:
				GameState.active_player.name = 	name			
	return player







@rpc("any_peer", "call_local")
func start_game():
	SignalBus._start_game.emit(lobbyId)
