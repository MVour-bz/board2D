class_name PlayScene extends Node2D
@onready var damage_board: DamageBoard = $DamageBoard



func spawn_players(players):
	damage_board.spawn_players(players)
