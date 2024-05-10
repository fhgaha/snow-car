shader_type spatial;

uniform sampler2D base : source_color;
uniform sampler2D snow_albedo : source_color;
uniform sampler2D snow_normal;
uniform sampler2D snow_roughness;
uniform sampler2D dirt_albedo : source_color;
uniform sampler2D dirt_normal;
uniform sampler2D dirt_roughness;
uniform sampler2D dynamic_snow_mask;
uniform float     uv_scale    = 1.0;
uniform float     snow_height = 0.0;

bool is_white(vec3 color_map, float whiteThreshold){
	return color_map.r >= whiteThreshold 
		&& color_map.g >= whiteThreshold 
		&& color_map.b >= whiteThreshold;
}

void fragment() {
    vec4 base_color = texture(base, UV);
    if (is_white(base_color.rgb, 0.5)) {
        vec2 uv = UV * uv_scale;
        vec3 snow_a  = texture(snow_albedo,    uv).rgb;
        vec3 snow_n  = texture(snow_normal,    uv).rgb;
        float snow_r = texture(snow_roughness, uv).r;
        vec3 dirt_a  = texture(dirt_albedo,    uv).rgb;
        vec3 dirt_n  = texture(dirt_normal,    uv).rgb;
        float dirt_r = texture(dirt_roughness, uv).r;
        
		float snow_mask = COLOR.r;
		snow_mask *= texture(dynamic_snow_mask, UV).r;
        
        ALBEDO     = mix(dirt_a, snow_a, snow_mask);
        NORMAL_MAP = mix(dirt_n, snow_n, snow_mask);
        ROUGHNESS  = mix(dirt_r, snow_r, snow_mask);
    } else {
        ALBEDO = base_color.rgb;
        NORMAL_MAP = base_color.rgb;
        ROUGHNESS = 1.0;
    }
}

void vertex() {
	vec4 base_color = texture(base, UV);
	//if (is_white(base_color.rgb, 0.5)){
	if (true){
		float snow_mask = COLOR.r;
		snow_mask *= texture(dynamic_snow_mask, UV).r;
		VERTEX.y += snow_mask * snow_height;
	}
}
