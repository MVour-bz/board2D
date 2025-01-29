class_name PlayScene extends Node2D
@onready var damage_board: DamageBoard = $DamageBoard

@onready var player_info: Label = $Panel/PlayerInfo

func _ready():
	SignalBus.connect("_avatar_created", _on_avatar_created)


func spawn_players(players):
	damage_board.spawn_players(players)


func _on_avatar_created(name, color):
	print("mphke")
	player_info.text = ""
	for attr in Global.active_player:
		if Global.active_player[attr] != "":
			player_info.text += Global.active_player[attr] + " ~/~ "
