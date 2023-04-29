shader_type canvas_item;

uniform vec4 color : source_color;

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	if(c != color) {
		c.a = 0.0;
	}
	COLOR = c;
}
