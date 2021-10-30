# LoL-Training-Tool
League of Legends fan project created by Andy Chang\
If you're an admission officer reading this you are very cool :) 

## Shaders
I wrote a custom shader to create river bushes that sway back and forth in the wind. 
```
float worley2(vec2 p) {
	float dist = 1.0;
	vec2 i_p = floor(p);
	vec2 f_p = fract(p);
	for(int y = -1; y <= 1; y++) {
		for(int x = -1; x <= 1; x++) {
			vec2 n = vec2(float(x), float(y));
			vec2 diff = n + random2(i_p + n) - f_p;
			dist = min(dist, length(diff));
		}
	}
	return dist;
}

void vertex() {
	NORMAL = UP;
	vec3 vertex = VERTEX;
	vec3 wind_direction_normalized = normalize(wind_direction);
	float time = TIME * wind_speed;
	vec2 uv = (WORLD_MATRIX * vec4(vertex, -1.0)).xz * wind_scale;
	uv += wind_direction_normalized.xz * time;
	wind = pow(worley2(uv), 2.0) * UV2.y;
	mat3 to_model = inverse(mat3(WORLD_MATRIX));
	vec3 wind_forward = to_model * wind_direction_normalized;
	vec3 wind_right = normalize(cross(wind_forward, UP));
	float sway_pitch = ((deg_sway_pitch * DEG2RAD) * wind) + INSTANCE_CUSTOM.z;
	float sway_yaw = ((deg_sway_yaw * DEG2RAD) * sin(time) * wind) + INSTANCE_CUSTOM.z;
	mat3 rot_right = mat3_from_axis_angle(sway_pitch, wind_right);
	mat3 rot_forward = mat3_from_axis_angle(sway_yaw, wind_forward);
	vertex.xz *= INSTANCE_CUSTOM.x;
	vertex.y *= INSTANCE_CUSTOM.y;
	vertex = mat3_from_axis_angle(TIME, UP) * vertex;
	VERTEX = rot_right * rot_forward * vertex;
	COLOR = mix(color_bot, color_top, UV2.y);
	//COLOR = vec4(wind, wind, wind, 1.0);
}
```

3d Model Credit:
- https://sketchfab.com/3d-models/for-study-only-summoner-rift-3d-export-ac0a9c6676e34d1ebb184d8e93443c77
- https://github.com/Jochem-W/LeagueBulkConvert/releases

UI:
- https://www.facebook.com/raylarkdesign
