extends Panel

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_toggle_hud_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		animation_player.play("ToggleHud")
	else:
		animation_player.play_backwards("ToggleHud")
