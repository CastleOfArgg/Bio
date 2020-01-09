extends Control

const SCORE_STRING := "Score: "

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect(Globals.signal_update_ui_string, self, "update")


func update():
	$RichTextLabel.text = SCORE_STRING + str(Globals.player.points)



func _on_UpgradeMenuButton_pressed() -> void:
	Globals.emit_signal(Globals.signal_toggle_game_menu_string)

func _on_MainMenuButton_pressed() -> void:
	Globals.emit_signal(Globals.signal_toggle_main_menu_string)
