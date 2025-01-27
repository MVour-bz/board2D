extends Node2D
@onready var dmg_board_sprite : PackedScene =  preload("res://scenes/player_dmg_board.tscn")
@onready var create_player: Node2D = $CanvasLayer/CreatePlayer

@onready var play_scene: PlayScene = $CanvasLayer/PlayScene

func _ready()->void :
	SignalBus.connect("_exit_game", _on_exit_game)
	SignalBus.connect("_add_player", _on_add_player)
	SignalBus.connect("_new_game", _on_new_game)
	
	set_main_screen()


func set_main_screen():
	play_scene.hide()
	create_player.hide()

func _on_new_game():
	#play_scene.show()
	create_player.show()

func _on_exit_game():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("esc"):
		get_tree().quit()


#players = [{ "name": ... , "color": ... , "board_scene": ..., "main_scene": ... }, {}, ...]
func _on_add_player():
	var pl_brd_scn = dmg_board_sprite.instantiate()
	pl_brd_scn.get_node("PlayerBoardSprite").texture = Global.colors_sprites["red"]
	var player = {"name": "mike", "color": "red", "board_scene": pl_brd_scn, "main_scene": "..."}
	play_scene.spawn_players([player])
