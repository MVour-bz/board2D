class_name DamageBoard  extends HBoxContainer

@onready var damage_entries: VBoxContainer = $DamageEntries
@onready var entry_scene:PackedScene  = preload("res://scenes/dmg_entry_panel.tscn")

var show_board : bool = false

var entries_defaults : Dictionary = {
	"14" : {"names": ["M", "N"], "players": [], "icon": "" },
	"13" : {"names": ["L"], "players": [], "icon": "" },
	"12" : {"names": ["M", "N"], "players": [], "icon": "" },
	"11" : {"names": ["M", "N"], "players": [], "icon": "" },
	"10" : {"names": ["M", "N"], "players": [], "icon": "" },
	"9" : {"names": ["A"], "players": [], "icon": "" },
	"8" : {"names": [], "players": [], "icon": "" },
	"7" : {"names": [], "players": [], "icon": "" },
	"6" : {"names": [], "players": [], "icon": "" },
	"5" : {"names": [], "players": [], "icon": "" },
	"4" : {"names": [], "players": [], "icon": "" },
	"3" : {"names": [], "players": [], "icon": "" },
	"2" : {"names": [], "players": [], "icon": "" },
	"1" : {"names": [], "players": [], "icon": "" },
	"0" : {"names": [], "players": [], "icon": "" }
}

var all_stages : Dictionary

func _ready() -> void:
	reset_board()



func reset_board():
	show_board = false
	_on_button_pressed()
	board_clear_entries()
	board_populate()


func board_populate():
	for stage in entries_defaults:
		var new_entry = entry_scene.instantiate()
		damage_entries.add_child(new_entry)
		new_entry.set_entry(stage, entries_defaults[stage].names)
		all_stages[stage] = new_entry
	
	
func board_clear_entries():
	for child in damage_entries.get_children():
		child.free()
	all_stages = {}

		
func move_player(from_stage : String, to_stage : String):
	pass

#players = [{ "name": ... , "color": ... , "board_scene": ..., "main_scene": ... }, {}, ...]
func spawn_players(players : Array):
	for player in players:
		all_stages["0"].add_player(player)

func _on_collapse():
	pass


func _on_button_pressed() -> void:
	show_board = !show_board
	if show_board:
		damage_entries.hide()
	else:
		damage_entries.show()
		
		
