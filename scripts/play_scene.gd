class_name PlayScene extends Node2D

@onready var damage_board: DamageBoard = $DamageBoard
@onready var players_slots: Node2D = $PlayersSlots
@onready var player_hud: PlayerHud = $Hud/PlayerHud
@onready var decks_container: HBoxContainer = $DecksContainer
@onready var deck_scn : PackedScene = preload("res://scenes/card_deck.tscn")
@onready var tile_map_layer: GameMap = $TileMapLayer
@onready var end_turn_button: Button = $EndTurnButton
@onready var game_manager: GameManager = $GameManager
@onready var playing_label: Label = $PlayingLabel
@onready var game_finished : bool = false
@onready var game_started : bool = true
func _ready():
	SignalBus._end_game.connect(_on_end_game)
	#SignalBus._start_game.connect(_on_start_game)
	SignalBus._set_character.connect(_on_set_character)
	SignalBus.set_locations.connect(_on_set_locations)
	SignalBus._attach_deck.connect(_on_attach_deck)
	SignalBus.begin_turn.connect(_on_begin_turn)
	SignalBus.end_turn.connect(_on_end_turn)
	
	game_manager.init_game()
	

#func _process(delta: float) -> void:
	

func play():
	pass

func spawn_players(players):
	damage_board.spawn_players(players)



func _on_set_locations(locations):
	tile_map_layer.locations_spawn()


	
func _on_attach_deck(card_type):
	var new_deck : CardDeck = deck_scn.instantiate()
	decks_container.add_child(new_deck)
	new_deck.add_cards(card_type)
	new_deck.init()



func _on_end_game():
	game_finished = true

func _on_set_character(pl_id, character):
	player_hud.init(character.name, character.species, character.goal, character.ability, character.health, 0)


func _on_begin_turn(pl_id):
	playing_label.hide()
	end_turn_button.hide()
	if pl_id == GameState.active_player.id:
		playing_label.show()
		end_turn_button.show()
	
	
func _on_end_turn(pl_id):
	if pl_id == GameState.active_player.id:
		playing_label.hide()
		end_turn_button.hide()

func _on_end_turn_button_pressed() -> void:
	game_manager.end_turn.rpc_id(1, GameState.active_player.id)
#
#func _on_start_game():
	#if not multiplayer.is_server(): return
	#start_turns.rpc_id(1)
