extends KinematicBody2D
class_name Cell

###########################################################################
###Attribute constants#####################################################
###########################################################################
const ATT_LIMIT_POS := 0
const ATT_SPEED_POS := 1
const ATT_WEIGHT_POS := 2
const ATT_DAMAGE_POS := 3
const ATT_HEALTH_POS := 4
const attributes := {
	#<name>:[speed,weight,damge,health]
	"Tail":[1, 2, 20, 0, 0],
	"Cell Wall":[1, -10, 200, -10, 500]
}
###########################################################################
const MY_ATT_COUNT_POS := 0
const MY_ATT_COST_POS := 1
export var my_attribute_details := {
	#<name>:[num, cost]
	"Tail":[0, 2],
	"Cell Wall":[0, 10]
}

var icon
export var is_player := false
export var idle_move_speed := 5.0
export var cell_type := "Cell"
export var health := 100
export var damage := 10
export var value := 5
export var weight := 5000
export var points := 0
export var color := Color(0.0,0.0,0.0,1.0)

#movement
var movement := Vector2()
var movement_force := Vector2()
export var acceration_init := .06
export var deceration_init := .02
export var speed_init := 2.0
export var max_force_from_movement_init := 2.0
var acceration := acceration_init
var deceration := deceration_init
var speed := speed_init
var max_force_from_movement := max_force_from_movement_init
var tile_flow := Vector2()

#collision
var is_colliding := false
var collision_force := Vector2()

func add_attribute(name:String)->bool:
	if points >= my_attribute_details[name][MY_ATT_COST_POS]:
		my_attribute_details[name][MY_ATT_COUNT_POS] = my_attribute_details[name][MY_ATT_COUNT_POS] + 1
		points = points - my_attribute_details[name][MY_ATT_COST_POS]
		speed = speed + attributes[name][ATT_SPEED_POS]
		weight = weight + attributes[name][ATT_WEIGHT_POS]
		damage = damage + attributes[name][ATT_DAMAGE_POS]
		health = health + attributes[name][ATT_HEALTH_POS]
		return true
	return false

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_player:
		Globals.player = self
	icon = get_node("icon")
	rotate(randf() * 2*PI)
	icon.material = icon.material.duplicate()
	icon.material.set(
		"shader_param/idle_move_speed", 
		Vector2(randf() * idle_move_speed - idle_move_speed/2.0, randf() * idle_move_speed - idle_move_speed/2.0)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	moving()
	icon.material.set("shader_param/movement_force", movement_force)
	if is_colliding:
		icon.material.set("shader_param/collision_force", collision_force)

func moving():
	#update vars
	if Constants.close_to_zero(movement.y):
		movement.y = 0
	if Constants.close_to_zero(movement_force.y):
		movement_force.y = 0
	if Constants.close_to_zero(movement.x):
		movement.x = 0
	if Constants.close_to_zero(movement_force.x):
		movement_force.x = 0
	acceration = acceration_init
	deceration = deceration_init
	speed = speed_init
	max_force_from_movement = max_force_from_movement_init
	
	#movement_force
	#x
	if movement.x > 0:
		if movement_force.x == 0:
			movement_force.x = movement_force.x + acceration
		else:
			movement_force.x = movement_force.x + acceration 
	elif movement.x < 0:
		if movement_force.x == 0:
			movement_force.x = movement_force.x - acceration
		else:
			movement_force.x = movement_force.x - acceration 
	else:
		if movement_force.x < 0:
			movement_force.x = movement_force.x - deceration * movement_force.x
		elif movement_force.x > 0:
			movement_force.x = movement_force.x - deceration * movement_force.x
	movement_force.x = clamp(movement_force.x, -max_force_from_movement, max_force_from_movement)
	#y
	if movement.y > 0:
		if movement_force.y == 0:
			movement_force.y = movement_force.y + acceration
		else:
			movement_force.y = movement_force.y + acceration
	elif movement.y < 0:
		if movement_force.y == 0:
			movement_force.y = movement_force.y - acceration
		else:
			movement_force.y = movement_force.y - acceration
	else:
		if movement_force.y < 0:
			movement_force.y = movement_force.y - deceration * movement_force.y
		elif movement_force.y > 0:
			movement_force.y = movement_force.y - deceration * movement_force.y
	movement_force.y = clamp(movement_force.y, -max_force_from_movement, max_force_from_movement)
	
	#add other movement_forces
	movement_force = movement_force + tile_flow
	
	#finally move
	move_and_collide(movement_force * speed)

func _input(event):
	if not is_player:
		return
	if event.is_action_pressed("move_up"):
		movement.y = movement.y - 1
	elif event.is_action_released("move_up"):
		movement.y = movement.y + 1
	elif event.is_action_pressed("move_down"):
		movement.y = movement.y + 1
	elif event.is_action_released("move_down"):
		movement.y = movement.y - 1
	elif event.is_action_pressed("move_right"):
		movement.x = movement.x + 1
	elif event.is_action_released("move_right"):
		movement.x = movement.x - 1
	elif event.is_action_pressed("move_left"):
		movement.x = movement.x - 1
	elif event.is_action_released("move_left"):
		movement.x = movement.x + 1
	movement.y = clamp(movement.y, -1, 1)
	movement.x = clamp(movement.x, -1, 1)

func _on_Area2D_area_entered(area):
	is_colliding = true
	collision_force = global_transform.origin * area.global_transform.origin
	var area_parent = area.controller
	


func _on_Area2D_area_exited(area):
	is_colliding = false


func _on_Area2D_body_entered(body):
	if body.get_script() == get_script():
		if body.damage > 0 and is_player:
			Globals.emit_signal(Globals.signal_pain_string)
		if body.pain(damage):
			give_points(body.value)
			body.die()


func pain(damage:int) -> bool:
	if damage > 0:
		health = health - damage
		if health <= 0:
			return true
	return false

func give_points(value:int):
	points = points + value
	if is_player:
		Globals.emit_signal(Globals.signal_update_ui_string)

func die():
	queue_free()

func recieve_tile_attributes(tile):
	tile_flow = tile.flow / weight