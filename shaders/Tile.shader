shader_type canvas_item;

uniform vec4 col : hint_color;

void fragment()
{
	COLOR = col;
}