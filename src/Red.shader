shader_type canvas_item;

uniform vec4 col = vec4(1.,0.,0.,0.);
uniform float radius_1 = .2;
uniform float radius_2 = .85;

float circle(vec2 coord){
	float dist = distance(vec2(.5), coord);
	return (smoothstep(radius_1, radius_2, dist));
}

void fragment(){
	COLOR = circle(UV) * col;
}