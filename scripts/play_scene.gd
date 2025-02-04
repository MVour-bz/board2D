class_name PlayScene extends Node2D

@onready var damage_board: DamageBoard = $DamageBoard
@onready var player_hud: PlayerHud = $PlayerHud


func _ready():
	suffle_deck_all.rpc_id(1)
	deal_cards_characters.rpc_id(1)
	

func play():
	pass

func spawn_players(players):
	damage_board.spawn_players(players)


@rpc("authority", "call_local")
func deal_cards_characters():
	if not multiplayer.is_server():
		pass
	var all_chars : Array = GameState.deck.characters.vampires
	all_chars.append_array(GameState.deck.characters.warewolves)
	all_chars.append_array(GameState.deck.characters.humans)
	all_chars.shuffle()
	print("all chars: ", all_chars)
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
		set_character.rpc_id(GameState.players[pl].id, character)
		GameState.players[pl].character = character


@rpc("authority", "call_local")
func set_character(character):
	print("Character: ", character)
	GameState.active_player.character = character
	player_hud.init(character.name, character.species, character.goal, character.ability, character.health, 0)
#func 


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
	
