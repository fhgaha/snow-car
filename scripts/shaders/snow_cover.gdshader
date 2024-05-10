shader_type spatial;

uniform sampler2D albedo_texture: source_color;
uniform sampler2D roughness_texture;
uniform sampler2D normal_texture;
uniform sampler2D snow_albedo_texture: source_color;
uniform sampler2D snow_roughness_texture;
uniform sampler2D snow_normal_texture;
uniform sampler2D snow_dynamic_mask;

uniform float snow_amount = 1.0;
uniform float snow_uv_scale = 1.0;
uniform float snow_softness = 10.0;
uniform float world_size = 16;

void fragment() {
	vec3 c = texture(albedo_texture, UV).rgb;
	float r = texture(roughness_texture, UV).r;
	vec3 n = texture(normal_texture, UV).rgb;
	vec3 n_unpacked = n * 2.0 - 1.0;
	
	vec3 n_t = -n_unpacked.x * TANGENT;
	vec3 n_b = n_unpacked.y * BINORMAL;
	vec3 vs_n = n_t + n_b; //viewspace normalmap vector
	
	vec3 n_blended = normalize(vec3(vs_n.xy + NORMAL.xy, NORMAL.z)); //UDN blending
	
	vec3 vs_up = mat3(VIEW_MATRIX) * vec3(0.0, 1.0, 0.0);
	float snow_mask = clamp(dot(n_blended, vs_up * snow_amount), 0.0, 1.0);
	snow_mask = pow(snow_mask, snow_softness);
	
	vec3 ws_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec2 ws_uv = ws_pos.xz * snow_uv_scale;
	
	vec3 snow_c = texture(snow_albedo_texture, ws_uv).rgb;
	float snow_r = texture(snow_roughness_texture, ws_uv).r;
	vec3 snow_n = texture(snow_normal_texture, ws_uv).rgb;
	
	//this block is for car interacting with this mesh
	vec2 snow_uv = (ws_pos.xz + world_size) / (2.0 * world_size);
	float dyn_mask = texture(snow_dynamic_mask, snow_uv).r;
	snow_mask *= dyn_mask;
	
	ALBEDO = mix(c, snow_c, snow_mask);
	ROUGHNESS = mix(r, snow_r, snow_mask);
	NORMAL_MAP = mix(n, snow_n, snow_mask);
}


