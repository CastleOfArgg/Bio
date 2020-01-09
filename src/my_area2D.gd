extends Area2D

export var path := NodePath()
var controller : Node2D

func _ready():
	controller = get_node(path)