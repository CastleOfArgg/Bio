extends Node2D

#################################
#consts
#################################
const STATIC_MAP := [

]
const STATIC_MAP_SUNLIGHT_INDEX := 0


const IMG_WIDTH := 128 #px
const IMG_HEIGHT := 128 #px

const SUNLIGHT_HIGH := 0
const SUNLIGHT_MEDIUM := 1
const SUNLIGHT_LOW := 2

const COLOR_SUNLIGHT_HIGH := Color(52.0/255, 135.0/255, 220.0/255)
const COLOR_SUNLIGHT_MEDIUM := Color(52.0/255, 106.0/255, 220.0/255)
const COLOR_SUNLIGHT_LOW := Color(52.0/255, 53.0/255, 255.0/255)
#################################

var icon
export var sunlight := SUNLIGHT_HIGH
var x := 0
var y := 0
var color := Color()
export var flow := Vector2()

func setColor() -> void:
	var sunlight_color := Color()
	if sunlight == SUNLIGHT_HIGH:
		sunlight_color = COLOR_SUNLIGHT_HIGH
	elif sunlight == SUNLIGHT_MEDIUM:
		sunlight_color = COLOR_SUNLIGHT_MEDIUM
	elif sunlight == SUNLIGHT_LOW:
		sunlight_color = COLOR_SUNLIGHT_LOW
	
	color = sunlight_color
	icon.material.set("shader_param/col", color)

func static_map(x, y, type):
	return STATIC_MAP[x][y][type]

func complete_random_map(type, max_val):
	if type is float:
		return randf() * 2 * max_val - max_val
	elif type is int:
		return randi() % 2 * (max_val + 1) - (max_val + 1)

func Tile(x, y, sunlight = SUNLIGHT_HIGH, flow = Vector2()) -> void:
	icon = get_node("icon")
	self.x = x
	self.y = y
	self.sunlight = sunlight
	self.flow = flow
	transform.origin = Vector2(x*IMG_WIDTH, y*IMG_HEIGHT)
	icon.material = icon.material.duplicate()
	setColor()

func _on_Area2D_area_entered(area):
	area.controller.recieve_tile_attributes(self)
