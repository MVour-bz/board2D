class_name CreatePlayer extends Node2D
@onready var name_line: LineEdit = $Panel/NameLine

var color = ""
var buttons = {}
var btn_scene : PackedScene = preload("res://scenes/select_player_icon_button.tscn")
@onready var panel: Panel = $Panel
@onready var avatar_container: GridContainer = $Panel/AvatarContainer
#@onready var avatar_container: FlowContainer = $Panel/AvatarContainer




func _ready():
	SignalBus.connect("_new_game", _on_new_game)
	reset_buttons()
	pass


func _process(delta: float) -> void:
	check_valid_buttons()


func _on_new_game():
	reset_buttons()


func reset_buttons():
	remove_buttons()
	create_buttons()
	
func remove_buttons():
	for button in buttons:
		buttons[button].queue_free()

func create_buttons():
	var all_pawns = Global.pawns
	for pawn in all_pawns:
		var new_btn = btn_scene.instantiate()
		new_btn.color = all_pawns[pawn].color
		new_btn.connect("toggled", _on_btn_pressed.bind(pawn))
		new_btn.use_texture()
		avatar_container.add_child(new_btn)
		buttons[pawn] = new_btn


func check_valid_buttons():
	for btn in buttons:
		if not Global.pawns[btn].available:
			buttons[btn].disabled = true
		else:
			buttons[btn].disabled = false
	
	
func _on_btn_pressed(toggled_on, btn_color):
	if toggled_on:
		release_prev_btn()
		reserve_btn(btn_color)
	else:
		release_btn(btn_color)

func reserve_btn(btn_color):
	color = btn_color
	Global.pawns[btn_color].availabe = false
	Global.pawns[btn_color].player = GameState.active_player
	GameState.active_player["pawn"] = btn_color
	
	SignalBus._avatar_reserved.emit(btn_color)


func release_prev_btn():
	var prev_btn_clr = color
	if prev_btn_clr:
		Global.pawns[prev_btn_clr].available = true
		buttons[prev_btn_clr].button_pressed = false
	
	SignalBus._avatar_released.emit(prev_btn_clr)
	
func release_btn(btn_color)	:
	Global.pawns[btn_color].available = true
	SignalBus._avatar_released.emit(btn_color)
	
	


func _on_lock_button_pressed() -> void:
	#pass
	GameState.active_player.name = name_line.text
	GameState.active_player.pawn = color # no need of r hits -->  its already set above inside the reserve btn
	SignalBus._avatar_created.emit(name_line.text , color)
	#print("creating: " , name_line.text, " , ", color)
