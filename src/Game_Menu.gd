extends Control

var Attribute_Entrty_Scene = preload("res://scenes/AttributeEntry.tscn")

var language := 0 setget change_language
###UPDATE get_player_value() ON ANY CHANGES TO attributes!!!!!
const attributes := [
	#["en"]
	["Speed"],
	["Weight"]
]
const attribute_descriptions := [
	#["en"]
	["How fast you can move."],
	["The heaviness of the cell. Affects other attributes like speed."]
]

func get_player_value(num:int)->int:
	var value := 0
	if num == 0:
		value = Globals.player.speed
	elif num == 1:
		value = Globals.player.weight
	return value

func _ready()->void:
	visible = false
	Globals.connect(Globals.signal_toggle_game_menu_string, self, "toggle")
	init_info_page()
	init_att_page()

func change_language(new_lan:int)->void:
	language = new_lan
	init_info_page()


func init_att_page()->void:
	var num := 0
	for name in Globals.player.my_attribute_details:
		var att = Attribute_Entrty_Scene.instance()
		att.rect_position.x = 0
		att.rect_position.y = 75 * (num + 1)
		att.set_parent(self, "_on_Att_Button_pressed")
		att.set_name(name)
		att.update()
		$Panel/AttributePage.add_child(att)
		num = num + 1

func init_info_page()->void:
	var num := 0
	for name in attributes:
		var att = Button.new()
		att.rect_size.x = 100
		att.rect_size.x = 50
		att.rect_position.x = 80
		att.rect_position.y = 50 * num
		att.text = name[language] + ": " + str(get_player_value(num))
		att.connect("pressed", self, "att_pressed", [num])
		$Panel/InfoPage.add_child(att)
		num = num + 1

func att_pressed(num:int) -> void:
	$Panel/RichTextLabel.text = attribute_descriptions[num][language]

func toggle()->void:
	visible = not visible
	$Panel/AttributePage.visible = true
	$Panel/InfoPage.visible = false


func _on_InfoPage_pressed()->void:
	$Panel/AttributePage.visible = false
	$Panel/InfoPage.visible = true
	$Panel/RichTextLabel.text = "Cell Info Page"


func _on_AttributePage_pressed()->void:
	$Panel/AttributePage.visible = true
	$Panel/InfoPage.visible = false
	$Panel/RichTextLabel.text = "Buy an Attribute"

func _on_Att_Button_pressed(att_name:String)->void:
	if Globals.player.add_attribute(att_name):
		Globals.emit_signal("signal_update_ui")
		for child in $Panel/AttributePage.get_children():
			child.update()