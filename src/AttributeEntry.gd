extends Control

var att_name : String
var parent : Node
var callback : String

func set_parent(p:Node, cb:String):
	parent = p
	callback = cb

func set_name(name:String)->void:
	att_name = name
	$RichTextLabel.text = Constants.format(name)
	$Button.connect("pressed", parent, callback, [name])

func update():
	$Button.disabled = Globals.player.my_attribute_details[att_name][Globals.player.MY_ATT_COUNT_POS] \
		>= Globals.player.attributes[att_name][Globals.player.ATT_LIMIT_POS]