class_name GameSettings extends Panel

@onready var vampires_count: Label = $VBoxContainer/HBoxContainer/VampiresCount
@onready var humans_count: Label = $VBoxContainer/HBoxContainer3/HumansCount
@onready var warewolves_count: Label = $VBoxContainer/HBoxContainer2/WarewolvesCount

@onready var vamp_dec: Button = $VBoxContainer/HBoxContainer/VampDec
@onready var vamp_inc: Button = $VBoxContainer/HBoxContainer/VampInc
@onready var ware_dec: Button = $VBoxContainer/HBoxContainer2/WareDec
@onready var ware_inc: Button = $VBoxContainer/HBoxContainer2/WareInc
@onready var humans_dec: Button = $VBoxContainer/HBoxContainer3/HumansDec
@onready var humans_inc: Button = $VBoxContainer/HBoxContainer3/HumansInc


func _ready():
	load_default_composition()
	manage_settings_access()


func manage_settings_access():
	if not multiplayer.is_server():
		vamp_dec.disabled = true
		vamp_inc.disabled = true
		ware_dec.disabled = true
		ware_inc.disabled = true
		humans_dec.disabled = true
		humans_inc.disabled = true

func load_default_composition():
	var pl_count = GameState.players.size()
	if (pl_count >= 4 && pl_count <= 8 ) || pl_count == 2 :
		var play_set = Global.game_settings_default["players"][pl_count]
		vampires_count.text = str(play_set["vampires_count"])
		humans_count.text = str(play_set["humans_count"])
		warewolves_count.text = str(play_set["warewolves_count"])
		
		GameState.game_settings["vampires_count"] = play_set["vampires_count"]
		GameState.game_settings["humans_count"] = play_set["humans_count"]
		GameState.game_settings["warewolves_count"] = play_set["warewolves_count"]
	else:
		vampires_count.text = str(-1)
		humans_count.text = str(-1)
		warewolves_count.text = str(-1)
		GameState.game_settings["vampires_count"] = -1
		GameState.game_settings["humans_count"] = -1
		GameState.game_settings["warewolves_count"] = -1


func _on_vamp_dec_pressed() -> void:
	GameState.game_settings["vampires_count"] -= 1
	vampires_count.text = str(GameState.game_settings["vampires_count"])
	

func _on_vamp_inc_pressed() -> void:
	GameState.game_settings["vampires_count"] += 1
	vampires_count.text = str(GameState.game_settings["vampires_count"])
	


func _on_ware_dec_pressed() -> void:
	GameState.game_settings["warewolves_count"] -= 1
	warewolves_count.text = str(GameState.game_settings["warewolves_count"])
	

func _on_ware_inc_pressed() -> void:
	GameState.game_settings["warewolves_count"] += 1
	warewolves_count.text = str(GameState.game_settings["warewolves_count"])
	


func _on_humans_dec_pressed() -> void:
	GameState.game_settings["humans_count"] = GameState.game_settings["humans_count"] - 1
	humans_count.text = str(GameState.game_settings["humans_count"])

func _on_humans_inc_pressed() -> void:
	GameState.game_settings["humans_count"] = GameState.game_settings["humans_count"] + 1
	humans_count.text = str(GameState.game_settings["humans_count"])
