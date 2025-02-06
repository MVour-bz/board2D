class_name PlayersSlots extends Node2D

@onready var slot_1: Node2D = $Slot1
@onready var slot_2: Node2D = $Slot2
@onready var slot_3: Node2D = $Slot3
@onready var slot_4: Node2D = $Slot4
@onready var slot_5: Node2D = $Slot5
@onready var slot_6: Node2D = $Slot6
@onready var slot_7: Node2D = $Slot7
@onready var slot_8: Node2D = $Slot8

@onready var player_slot_info_scn = preload("res://scenes/player_slot_info.tscn")

var active_chairs : Array


@rpc("any_peer", "call_local")
func sit_players(decided_turn):
	if not multiplayer.is_server():
		GameState.game_info.players_turn = decided_turn
	
	## Decid which preconfigured set of chairs to use
	decide_chairs()
	
	## Assign chair seats to players -> maintain each player's pov
	assign_chairs()

func decide_chairs():
	var players_num = GameState.players.size()
	var chairs_set = "slot1"
	if players_num == 0:
		return 
	else:
		chairs_set = Global.game_settings_default.chairs_config[GameState.players.size()]
	
	for chair in chairs_set:
		if chair == "slot1":
			active_chairs.append({"slot" : slot_1})
		elif chair == "slot2":
			active_chairs.append({"slot" : slot_2})
		elif chair == "slot3":
			active_chairs.append({"slot" : slot_3})
		elif chair == "slot4":
			active_chairs.append({"slot" : slot_4})
		elif chair == "slot5":
			active_chairs.append({"slot" : slot_5})
		elif chair == "slot6":
			active_chairs.append({"slot" : slot_6})
		elif chair == "slot7":
			active_chairs.append({"slot" : slot_7})
		elif chair == "slot8":
			active_chairs.append({"slot" : slot_8})


func assign_chairs():
	var pl_turns = GameState.game_info.players_turn
	
	## Rotate players locally in order to apply POV chairs
	## change is only local to this func in order to maintain players turns
	var local_turn = rotate_to_element(pl_turns, GameState.active_player.id)
	
	var chair_used = 0
	for pl_id in local_turn:
		var player_info = player_slot_info_scn.instantiate()

		self.add_child(player_info)
		player_info.position = active_chairs[chair_used].slot.position
		player_info.sit(GameState.players[pl_id])
		active_chairs[chair_used]["scene"] = player_info
		chair_used += 1


# Utility function
func rotate_to_element(arr : Array, target):
	var index = arr.find(target)
	if index == -1:
		return arr
	return arr.slice(index) + arr.slice(0,index)
