class_name GameManager extends Node


@onready var game_started : bool = false
@onready var game_inited : bool = false
@onready var game_finished : bool = false
@onready var players_slots: PlayersSlots = $"../PlayersSlots"

@onready var dices_container: DiceManager = $"../DicesContainer"

@onready var current_turn : Dictionary = {
	"turn_count": 0,
	"playing_id": 0,
	"roll": { "val6": 0, "val4": 0	},
	"finished": false
}

func _process(delta: float) -> void:
	if game_inited and not game_started:
		start_game()
	if game_started:
		if current_turn.finished:
			start_turn()
		
	

func start_game():
	
	game_started = true
	start_turn()

func init_game():
	game_finished = false
	suffle_deck_all.rpc_id(1)
	build_decks.rpc_id(1)
	deal_cards_characters.rpc_id(1)
	deal_cards_locations.rpc_id(1)
	
	
	decide_players_turn.rpc_id(1)
	players_slots.sit_players.rpc(GameState.game_info.players_turn)
	
	#SignalBus._start_game.emit()
	game_inited = true



@rpc("authority", "call_local")
func start_turn():
	if not multiplayer.is_server(): return
	var playing_id = decide_current_player_turn_id()
	
	current_turn.turn_count += 1
	current_turn.playing_id = playing_id
	current_turn.finished = false
	
	print("Starting turn: ", current_turn.turn_count,  ", pl_id: ", current_turn.playing_id)
	players_lock.rpc(playing_id, true)
	
	
	#player_roll(playing_id)
	#player_action(playing_id)
	#end_turn(playing_id)


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
	print("SETTING CHARACTER: ", character)
	if GameState.active_player.id == pl_id:
		GameState.active_player.character = character
		SignalBus._set_character.emit(pl_id, character)
	GameState.players[pl_id].character = character
	

@rpc("call_local")
func build_decks():
	if not multiplayer.is_server(): return
	for pl in GameState.players.values():
		print("pl: ", pl)
		rearrange_decks.rpc_id(pl.id, "red_cards",Global.deck["red_cards"])
		rearrange_decks.rpc_id(pl.id, "green_cards",Global.deck["green_cards"])
		rearrange_decks.rpc_id(pl.id, "blue_cards",Global.deck["blue_cards"])
	SignalBus._attach_deck.emit("red_cards")
	SignalBus._attach_deck.emit("green_cards")
	SignalBus._attach_deck.emit("blue_cards")
	


@rpc("any_peer", "call_remote")
func rearrange_decks(card_type : String , playing_deck : Array):
	if multiplayer.is_server(): return
	Global.deck[card_type] = playing_deck
	SignalBus._attach_deck.emit(card_type)
	
	



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




@rpc("authority", "call_local")
func deal_cards_locations():
	if not multiplayer.is_server(): return
	set_locations.rpc(GameState.deck["locations"])
	#set_locations(, GameState.dec)

@rpc("authority", "call_local")
func set_locations(locations):
	GameState.deck["locations"] = locations
	SignalBus.set_locations.emit(locations)


func broadcast_to_peers(func_callable: Callable, args: Array, target_id = null):
	if not multiplayer.is_server(): return
	
	if target_id:
		func_callable.rpc_id.callv([target_id] + args)
	else:
		func_callable.rpc.callv(args)




func decide_current_player_turn_id():
	var all_players_count = GameState.players.size()
	if current_turn.turn_count < all_players_count:
		return GameState.game_info.players_turn[current_turn.turn_count-1]
	else:
		return GameState.game_info.players_turn[(current_turn.turn_count%all_players_count)-1]
	


@rpc("any_peer", "call_local")
func end_turn(playing_id):
	current_turn.finished = true
	players_lock.rpc(playing_id, false)
	print("in end turn")

@rpc("authority", "call_local")
func players_lock(playing_id, val):
	print("in players lock ..")
	GameState.players[playing_id].playing = val
	if playing_id == GameState.active_player.id:
		GameState.active_player.playing = val
		#if val: end_turn_button.show()
		#else: end_turn_button.hide()
	
	if val: SignalBus.begin_turn.emit(playing_id)
	else: SignalBus.end_turn.emit(playing_id)
	

func player_roll(playing_id):
	pass
	
func player_action(playing_id):
	pass

@rpc("any_peer", "call_local")
func player_end_turn(playing_id):
	if not multiplayer.is_server(): return
	GameState.players[playing_id].playing = false
	
	
@rpc ("any_peer", "call_local")
func roll_request(caller_id):
	print("roll_request: ", caller_id)
	if not multiplayer.is_server(): return
	
	if caller_id != current_turn.playing_id: return
	
	var roll = dices_container.throw_dices()
	current_turn.roll = roll
	#print("roll: " , roll)
	dices_container.roll_dices.rpc(roll.val6, roll.val4)
	
	
