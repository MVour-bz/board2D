extends Node2D

@onready var dmg_board_sprite : PackedScene =  preload("res://scenes/player_dmg_board.tscn")
@onready var multiplayer_controller: MultiplayerController = $CanvasLayer/MultiplayerController

@onready var canvas_layer: CanvasLayer = $CanvasLayer

@onready var main_menu: MainMenu = $CanvasLayer/MainMenu


@onready var play_scene_pack : PackedScene = preload("res://scenes/play_scene.tscn")
var play_scene

func _ready()->void :
	SignalBus.connect("_exit_game", _on_exit_game)
	SignalBus.connect("_add_player", _on_add_player)
	SignalBus.connect("_new_game", _on_new_game)
	SignalBus.connect("_return_to_main_menu", _on_main_menu)
	SignalBus.connect("_start_game", _on_start_game)
	set_main_screen()


func set_main_screen():
	main_menu.show()
	multiplayer_controller.hide()
	
func _on_main_menu():
	set_main_screen()

func _on_new_game():
	main_menu.hide()
	multiplayer_controller.show()
	
	
func _on_start_game(id):
	play_scene = play_scene_pack.instantiate()
	
	canvas_layer.add_child(play_scene)
	main_menu.hide()
	multiplayer_controller.hide()
	#create_player.show()

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
