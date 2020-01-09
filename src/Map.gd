extends Node2D

var Tile := load("res://Tile.tscn")

var MapWidth := 10
var MapHeight := 10

func _init():
	CreateMap()

func CreateMap():
	var i := 0
	while i < MapHeight:
		var u := 0
		while u < MapWidth:
			var tile = Tile.instance()
			#tile.Tile(i, u, tile.static_map(i,u,0))
			tile.Tile(
				i, 
				u, 
				tile.complete_random_map(int(), 3), 
				Vector2(tile.complete_random_map(float(), 3.0), tile.complete_random_map(float(), 3.0))
			)
			add_child(tile)
			u = u + 1
		i = i + 1


