extends Control

func _ready():
	visible = false
	Globals.connect(Globals.signal_toggle_main_menu_string, self, "toggle")

func toggle():
	visible = not visible
	$Pane/Main.visible = true
	Globals.pause()


func _on_SettingsButton_pressed():
	$Pane/Main.visible = false
	$Pane/Settings.visible = true


func _on_CreditsButton_pressed():
	$Pane/Main.visible = false
	$Pane/Credits.visible = true


func _on_ExitButton_pressed():
	Globals.exit()


func _on_BackButton_pressed():
	$Pane/Settings.visible = false
	$Pane/Credits.visible = false
	$Pane/Main.visible = true


func _on_ResumeButton_pressed():
	toggle()
	Globals.resume()
