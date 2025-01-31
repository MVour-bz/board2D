class_name MultiplayerController extends Control

@onready var multiplayer_menu_container: VBoxContainer = $MultiplayerMenuContainer
#@onready var lobby: Lobby = $Lobby
@onready var line_edit: LineEdit = $ConnectToLobby/Panel/LineEdit
@onready var connect_to_lobby: Node2D = $ConnectToLobby
@onready var return_button: Button = $ConnectToLobby/Panel/ReturnButton
@onready var lobby_scene : PackedScene = preload("res://scenes/lobby.tscn")
var lobby : Lobby

var peer
var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".split("")
var default_id_len = 10
var lobbies = {
	# "id" : {"server": "..", "peers": [PLAYERS] } }
}

func _ready():
	return_button.pressed.connect(_on_return_button_pressed)
	SignalBus.connect("_return_to_mulitplayer_menu", _on_return_button_pressed)
	SignalBus.connect("_start_game", _on_start_game)
	
	multiplayer.peer_connected.connect(_on_peer_conected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connecion_failed)


func _on_back_pressed() -> void:
	SignalBus._return_to_main_menu.emit()
	pass # Replace with function body.


func _on_join_pressed() -> void:
	connect_to_lobby.show()
	if lobby:
		lobby.queue_free()
		lobby = null
	multiplayer_menu_container.hide()
	pass # Replace with function body.


func _on_host_pressed() -> void:
	multiplayer_menu_container.hide()
	connect_to_lobby.hide()
	
	
	create_host()
	pass # Replace with function body.


func _on_connect_lobby_button_pressed() -> void:
	
	create_client()
	pass # Replace with function body.


func _on_visibility_changed() -> void:
	#print("self.visible: " , self.visible)
	if self.visible:
		multiplayer_menu_container.show()
		if lobby:
			lobby.queue_free()
			lobby = null
		connect_to_lobby.hide()


func _on_return_button_pressed() -> void:
	multiplayer_menu_container.show()
	lobby.hide()
	connect_to_lobby.hide()


func create_lobby_id() -> String:
	var l_id = random_id_generator()
	while lobbies.has(l_id):
		l_id = random_id_generator()
	return l_id

func random_id_generator() -> String:
	var random_id = ""
	
	for i in range(default_id_len):
		random_id += chars[randi() % chars.size()]
	
	return random_id

@rpc("any_peer")
func exist_lobby(id) -> bool:
	return lobbies.has(id)
		
		
###############################
@export var address = "127.0.0.1"
@export var port = 8080

# on the server and clients
func _on_peer_conected(id):
	print("Player Connected " , id)
	#lobby.lobby_add_player()
	pass

# on the sever and clients
func _on_peer_disconnected(id):
	print("Player Disconnected " , id)
	pass

# only from the clients
func _on_connected_to_server():
	print("Connected to Server!")
	
	GameState.active_player.id = multiplayer.get_unique_id()
	lobby.lobby_add_player.rpc_id(1, GameState.active_player)

# only from the clients
func _on_connecion_failed():
	print("Connected Failed!")
	pass
	
func create_host():
	peer = ENetMultiplayerPeer.new()
	
	var error = peer.create_server(port, 8)
	if error != OK:
		print("Couldnt create server: ", )
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting For Players")
	
	GameState.active_player.id = multiplayer.get_unique_id()
	
	
	lobby = lobby_scene.instantiate()
	add_child(lobby)
	lobby.show()
	lobby.lobby_init(create_lobby_id())
	lobby.lobby_add_player(GameState.active_player)

	
func create_client():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)


	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	
	GameState.active_player.id = multiplayer.get_unique_id()
	
	var lobby_id = line_edit.text
	connect_to_lobby.hide()
	if not lobby:
		lobby = lobby_scene.instantiate()
		add_child(lobby)
		lobby.lobby_init(lobby_id)
	
	
	
	
	### Sholuld utilize lobby manager here --> later with netfox / nakama
	#if not exist_lobby.rpc_id(1):
		#peer.disconnect()
	
	pass
	
	
func _on_start_game(id):
	pass





@rpc("any_peer")
func update_player_info(player):
	GameState.player[player.id] = player
	if GameState.active_player.id == player.id:
		GameState.active_player = player
	
	if multiplayer.is_server():
		for pl in GameState.players:
			update_player_info.rpc(player)


@rpc("any_peer")
func set_state(GAME_PHASE, players):
	GameState.game_phase_status = GAME_PHASE
	GameState.players = players
	pass
	
