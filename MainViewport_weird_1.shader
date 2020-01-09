shader_type canvas_item;

vec2 rand(vec2 uv){
	vec2 c1 = vec2(uv.x, uv.y);
	vec2 c2 = vec2(uv.x + 1., uv.y);
	vec2 c3 = vec2(uv.x - 1., uv.y);
	vec2 c4 = vec2(uv.x, uv.y + 1.);
	vec2 c5 = vec2(uv.x, uv.y - 1.);
	
	vec2 a1 = vec2(dot(c2,c3), c1.x);
	vec2 a2 = vec2(dot(c4,c5), c1.y);
	
	vec2 b = vec2((a1).x + 5., (a2).x);
	
	return b;
}

void fragment(){
	vec4 c1 = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	vec4 c2 = textureLod(SCREEN_TEXTURE, rand(SCREEN_UV), 0.0);
	
	COLOR.rgb = cross(c1.rgb, c2.rgb) + vec3(.15);
}