class_name Lobby extends Node2D

var lobbyId = ""

var question_mark_sprite : PackedScene = preload("res://scenes/question_mark_sprite.tscn")
@onready var lobby_container: GridContainer = $LobbyPanel/LobbyContainer
@onready var lobby_id: Label = $GridContainer/LobbyId
@onready var start_game_button: Button = $StartGameButton

var q_marks = {}

#var question_mark_texture = preload("")
var max_players = 8

func _ready():
	SignalBus._avatar_created.connect(_on_avatar_created)
	
	if not multiplayer.is_server():
		start_game_button.hide()
	pass

#@rpc("any_peer", "call_local")
func lobby_init(id : String):
	lobbyId = id
	lobby_id.text = id
	


func _on_player_joined(player):
	pass


func _on_avatar_created(name, color):
	print("Sharing avatar")
	share_avatar.rpc(Global.active_player)


@rpc("any_peer", "call_local")
func share_avatar(player):
	# update player info
	Global.players[player.id] = player
	# update pawns
	Global.pawns[player.pawn].player = player
	Global.pawns[player.pawn].available = false
	
	q_marks[player.id].set_sprite_name(player.name)
	q_marks[player.id].use_texture(player.pawn)



@rpc("any_peer")
func lobby_add_player(player):
	print("Lobby: addig player: " , player)
	Global.players[player.id] = (player)
	var new_q_mark = question_mark_sprite.instantiate()
	lobby_container.add_child(new_q_mark)
	q_marks[player.id] = new_q_mark
	
	if multiplayer.is_server():
		for pl in Global.players:
			lobby_add_player.rpc(Global.players[pl])
	print("q_marks: ", q_marks.size())



func _on_button_pressed() -> void:
	SignalBus._return_to_mulitplayer_menu.emit()


func _on_start_game_pressed() -> void:
	start_game.rpc()

@rpc("any_peer", "call_local")
func start_game():
	SignalBus._start_game.emit(lobbyId)
