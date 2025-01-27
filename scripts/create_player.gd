class_name CreatePlayer extends Node2D
@onready var name_line: LineEdit = $Panel/NameLine

var color = ""
@onready var green_player_button: Button = $Panel/GreenPlayerButton
@onready var blue_player_button: Button = $Panel/BluePlayerButton
@onready var purple_player_button: Button = $Panel/PurplePlayerButton
@onready var yellow_player_button: Button = $Panel/YellowPlayerButton
@onready var red_player_button: Button = $Panel/RedPlayerButton
@onready var white_player_button: Button = $Panel/WhitePlayerButton
@onready var orange_player_button: Button = $Panel/OrangePlayerButton
@onready var light_blue_player_button: Button = $Panel/LightBluePlayerButton



func _on_lock_button_pressed() -> void:
	#pass
	SignalBus._lock_avatar.emit(name_line.text , color)
	print("creating: " , name_line.text, " , ", color)


func _on_green_player_button_pressed() -> void:
	SignalBus._select_avatar.emit("green")
	color = "green"


func _on_blue_player_button_pressed() -> void:
	SignalBus._select_avatar.emit("blue")
	color = "blue"
	pass # Replace with function body.


func _on_purple_player_button_pressed() -> void:
	SignalBus._select_avatar.emit("purple")
	color = "purple"
	pass # Replace with function body.


func _on_yellow_player_button_pressed() -> void:
	SignalBus._select_avatar.emit("yellow")
	color = "yellow"
	pass # Replace with function body.


func _on_red_player_button_pressed() -> void:
	SignalBus._select_avatar.emit("red")
	color = "red"
	pass # Replace with function body.


func _on_white_player_button_pressed() -> void:
	SignalBus._select_avatar.emit("white")
	color = "white"
	pass # Replace with function body.


func _on_orange_player_button_pressed() -> void:
	SignalBus._select_avatar.emit("orange")
	color = "orange"
	pass # Replace with function body.


func _on_light_blue_player_button_pressed() -> void:
	SignalBus._select_avatar.emit("light_blue")
	color = "light_blue"
	pass # Replace with function body.
