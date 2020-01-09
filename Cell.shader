shader_type canvas_item;

uniform vec2 movement_force = vec2(0.);
uniform vec2 collision_force = vec2(0.);
uniform vec2 idle_move_speed = vec2(0.);

uniform vec4 color : hint_color;
uniform vec4 color_border : hint_color;
uniform float c_radius_1 = .2;
uniform float c_radius_2 = .255;
uniform float c_radius_3 = .3;

float circle(vec2 c_coord){
	float dist = distance(vec2(.5), c_coord);
	float result1 = (1.-smoothstep(c_radius_1, c_radius_2, dist));
	float result2 = (1.-smoothstep(c_radius_2, c_radius_3, dist));
	return result1 + result2;
}

void fragment(){
	//COLOR = circle(UV); circle
	//UV+(sin(TIME)*.02) little movement on single axis
	//COLOR = circle(sin(UV-vec2(-sin(force.x+TIME), cos(force.y+TIME))*.1)) * color; moves in a small circle
	
	vec2 force = movement_force;
	COLOR = circle(sin(UV-vec2(-sin(force.x+TIME*idle_move_speed.x), cos(force.y+TIME*idle_move_speed.y))*.05)) * color;
}