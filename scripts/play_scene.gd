class_name PlayScene extends Node2D

@onready var damage_board: DamageBoard = $DamageBoard
@onready var players_slots: Node2D = $PlayersSlots
@onready var player_hud: PlayerHud = $Hud/PlayerHud
@onready var decks_container: HBoxContainer = $DecksContainer
@onready var deck_scn : PackedScene = preload("res://scenes/card_deck.tscn")
@onready var tile_map_layer: GameMap = $TileMapLayer

func _ready():
	suffle_deck_all.rpc_id(1)
	build_decks.rpc_id(1)
	deal_cards_characters.rpc_id(1)
	deal_cards_locations.rpc_id(1)
	
	
	decide_players_turn.rpc_id(1)
	players_slots.sit_players.rpc(GameState.game_info.players_turn)

func play():
	pass

func spawn_players(players):
	damage_board.spawn_players(players)


@rpc("authority", "call_local")
func deal_cards_locations():
	if not multiplayer.is_server(): return
	#set_locations(, GameState.dec)
	broadcast_to_peers(set_locations, [GameState.deck["locations"]])

@rpc("authority", "call_local")
func deal_cards_characters():
	if not multiplayer.is_server():
		return
	var all_chars : Array = GameState.deck.characters.vampires
	all_chars.append_array(GameState.deck.characters.warewolves)
	all_chars.append_array(GameState.deck.characters.humans)
	all_chars.shuffle()
	var created_vamps = 0
	var created_ware = 0
	var created_humans = 0
	for pl in GameState.players:
		var character = all_chars.pop_front()
		while true && character != null:
			if character.species == "vampire":
				if created_vamps < GameState.game_settings.vampires_count:
					created_vamps += 1
					break
			elif character.species == "warewolf":
				if created_ware < GameState.game_settings.warewolves_count:
					created_ware += 1
					break
			elif character.species == "human":
				if created_humans < GameState.game_settings.humans_count:
					created_humans += 1
					break
			character = all_chars.pop_front()
		set_character.rpc(GameState.players[pl].id, character)
		GameState.players[pl].character = character


@rpc("authority", "call_local")
func set_character(pl_id, character):
	if GameState.active_player.id == pl_id:
		GameState.active_player.character = character
		player_hud.init(character.name, character.species, character.goal, character.ability, character.health, 0)
	GameState.players[pl_id].character = character
#func 

@rpc("authority", "call_local")
func set_locations(locations):
	GameState.deck["locations"] = locations
	tile_map_layer.locations_spawn()


@rpc("call_local")
func build_decks():
	if not multiplayer.is_server(): return
	for pl in GameState.players.values():
		print("pl: ", pl)
		rearrange_decks.rpc_id(pl.id, "red_cards",Global.deck["red_cards"])
		rearrange_decks.rpc_id(pl.id, "green_cards",Global.deck["green_cards"])
		rearrange_decks.rpc_id(pl.id, "blue_cards",Global.deck["blue_cards"])
	attach_deck("red_cards")
	attach_deck("green_cards")
	attach_deck("blue_cards")
	
func attach_deck(card_type):
	var new_deck : CardDeck = deck_scn.instantiate()
	decks_container.add_child(new_deck)
	new_deck.add_cards(card_type)
	new_deck.init()

@rpc("any_peer", "call_remote")
func rearrange_decks(card_type : String , playing_deck : Array):
	if multiplayer.is_server(): return
	Global.deck[card_type] = playing_deck
	attach_deck(card_type)
	

@rpc("authority", "call_local")
func suffle_deck_all():
	if multiplayer.is_server():
		suffle_deck_cards("red_cards")
		suffle_deck_cards("blue_cards")
		suffle_deck_cards("green_cards")
		suffle_deck_cards("locations")
		suffle_deck_characters()


func suffle_deck_cards(card_type):
	GameState.deck[card_type] = Global.deck[card_type]
	GameState.deck[card_type].shuffle()


func suffle_deck_characters():
	GameState.deck["characters"] = Global.deck["characters"]
	GameState.deck["characters"].vampires.shuffle()
	GameState.deck["characters"].warewolves.shuffle()
	GameState.deck["characters"].humans.shuffle()
	
@rpc("authority", "call_local")
func decide_players_turn():
	if not multiplayer.is_server():
		return
	for pl in GameState.players:
		GameState.game_info.players_turn.append(GameState.players[pl].id)
	GameState.game_info.players_turn.shuffle()


func start_turns():
	players_lock()
	player_roll()
	player_action()
	player_end_turn()
	
func players_lock():
	pass


func player_roll():
	pass
	
func player_action():
	pass
	
func player_end_turn():
	pass
	

func broadcast_to_peers(func_callable: Callable, args: Array, target_id = null):
	if not multiplayer.is_server(): return
	
	if target_id:
		func_callable.rpc_id.callv([target_id] + args)
	else:
		func_callable.rpc.callv(args)
