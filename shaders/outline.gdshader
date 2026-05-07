shader_type spatial;
render_mode unshaded, cull_front, depth_draw_opaque;

uniform vec3 outline_color : source_color = vec3(1.0, 0.85, 0.0);
uniform float width = 0.02;
uniform bool active = false;

void vertex() {
	float sx = length(MODEL_MATRIX[0].xyz);
	float sy = length(MODEL_MATRIX[1].xyz);
	float sz = length(MODEL_MATRIX[2].xyz);
	float len = length(VERTEX);
	vec3 dir = len > 0.001 ? VERTEX / len : NORMAL;
	VERTEX += dir * width * vec3(1.0 / sx, 1.0 / sy, 1.0 / sz);
}

void fragment() {
	if (!active) {
		discard;
	}
	ALBEDO = outline_color;
}
