extends Panel
@onready var player_hud: PlayerHud = $PlayerHud
@onready var player_cards: Panel = $PlayerCards
@onready var player_help: Panel = $PlayerHelp

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_toggle_hud_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		animation_player.play("ToggleHud")
	else:
		animation_player.play_backwards("ToggleHud")


func _on_toggle_help_button_pressed() -> void:
	player_hud.hide()
	player_cards.hide()
	player_help.show()


func _on_toggle_cards_button_pressed() -> void:
	player_hud.hide()
	player_cards.show()
	player_help.hide()


func _on_toggle_info_button_pressed() -> void:
	player_hud.show()
	player_cards.hide()
	player_help.hide()
