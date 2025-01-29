class_name DmgEntryPanel extends PanelContainer

var playerBoardScene : PackedScene = preload("res://scenes/player_dmg_board.tscn")

@onready var dmg_board_entry_players: HBoxContainer = $GridContainer/DmgBoardEntryPlayers

@onready var names: Label = $GridContainer/Names
@onready var no: Label = $GridContainer/No


#var players : Array
var players_in_stage : Array
var stage : String
var names_array : Array
var all_stages : Dictionary

#func
func set_entry(stage_input: String, names_input: Array):
	stage = stage_input
	names_array = names_input

	no.text = str(stage)
	
	names.text = ""
	var i = 0
	while(i < names_array.size()):
		names.text += names_array[i]
		if i < names_array.size() - 1:
			names.text += ", "
		i += 1
	


#func move_player(from_stage, to_stage):
	#pass
	

# player = { "name": ... , "color": ... , "board_scene": ..., "main_scene": ..., "dmg": ..., "max_dmg": .. }
func add_player(player : Dictionary):
	players_in_stage.append(player)
	dmg_board_entry_players.add_child(player.board_scene)
	
func remove_player(player : Dictionary):
	var i = 0
	while i < players_in_stage.size():
		var pl = players_in_stage[i]
		if pl.name == player.name:
			players_in_stage.pop_at(i)
			break
		i += 1
