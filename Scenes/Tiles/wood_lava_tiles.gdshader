shader_type canvas_item;

uniform sampler2D NOISE_PATTERN:repeat_enable;
uniform vec2 scroll = vec2(0.2, 0.4);
uniform vec2 scroll2 = vec2(0.1, 0.3);
uniform vec2 noiseScale1 = vec2(1,1);
uniform vec2 noiseScale2 = vec2(1,1);
uniform sampler2D TONE_MAPPING;
uniform float blur: hint_range(0, 7) = 3.0;
uniform float base_intensity: hint_range(0, 2) = 0.7;
uniform float intensity_factor: hint_range(0, 5.0) = 1.5;
uniform float progress: hint_range(0, 1) = 0.;

void fragment() {
	float tex_alpha = textureLod(TEXTURE, UV, blur).a;
	float pattern_intensity = texture(NOISE_PATTERN, UV * noiseScale1 + TIME * scroll).r;
	float pattern_intensity2 = texture(NOISE_PATTERN, UV * noiseScale2 + TIME * scroll2).r;
	float intensity = tex_alpha * intensity_factor * (pattern_intensity * pattern_intensity2 * base_intensity);
	COLOR = texture(TONE_MAPPING, vec2(intensity));
}