shader_type canvas_item;
render_mode blend_mix;

uniform vec4 color: source_color = vec4(1,1,1,0.5);

void fragment() {
	vec4 tint_color = color;
	vec4 texture_color = texture(TEXTURE, UV);
	if (AT_LIGHT_PASS) {
		COLOR = texture_color;
	} else {
		COLOR = texture_color * tint_color;
	}
}