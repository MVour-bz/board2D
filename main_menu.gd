class_name MainMenu extends Node2D


func _on_quit_button_pressed() -> void:
	SignalBus._exit_game.emit()


func _on_add_player_pressed() -> void:
	SignalBus._add_player.emit()


func _on_play_button_pressed() -> void:
	SignalBus._new_game.emit()
	self.hide()
