# LoL-Training-Tool
League of Legends fan project created by Andy Chang\
If you're an admission officer reading this you are very cool :) 

## Shaders
I wrote a custom shader to create river bushes that sway back and forth in the wind. The wind effect is created using the worley noise type. The effect is based on 
```
vec2 random2(vec2 p) {
	return fract(sin(vec2(
		dot(p, vec2(127.32, 231.4)),
		dot(p, vec2(12, 146))
	)));
}

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
```
The "grass" is created by 1500 triangle meshes that rotate according to the wind shader noise. The rebuild() function is called during initialization and every time any material or parameter is changed.
```
func rebuild():
	if !multimesh:
		multimesh = MultiMesh.new()
	multimesh.instance_count = 0
	multimesh.mesh = MeshFactory.simple_grass()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.set_custom_data_format(MultiMesh.CUSTOM_DATA_FLOAT)
	multimesh.set_color_format(MultiMesh.COLOR_NONE)
	multimesh.instance_count = count
	for index in (multimesh.instance_count):
		var pos = Vector3(rand_range(-span, span), 0.0, rand_range(-span, span))
		var basis = Basis(Vector3.UP, deg2rad(rand_range(0, 359)))
		multimesh.set_instance_transform(index, Transform(basis, pos))
		multimesh.set_instance_custom_data(index, Color(
			rand_range(width.x, width.y),
			rand_range(height.x, height.y),
			deg2rad(rand_range(sway_pitch.x, sway_pitch.y)),
			deg2rad(rand_range(sway_yaw.x, sway_yaw.y))
		))
```
Resources:
-[Godot Interactive Displacement](https://www.youtube.com/watch?v=D_G9ZFX69UQ)
-[Intro to Shader Programming](https://www.youtube.com/watch?v=xoyk_A0RSpI)
3d Model Credit:
- https://sketchfab.com/3d-models/for-study-only-summoner-rift-3d-export-ac0a9c6676e34d1ebb184d8e93443c77
- https://github.com/Jochem-W/LeagueBulkConvert/releases

UI:
- https://www.facebook.com/raylarkdesign
