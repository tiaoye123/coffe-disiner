shader_type canvas_item;

uniform vec2 center = vec2(0.5 , 0.5);
uniform float radius = 0.0;



void fragment() {
	//修正UV比例
	vec2 uv = UV;
	uv.x = (uv.x - 0.5) * (256.0/144.0) + 0.5;
	vec2 center_fixed = center;
	center_fixed.x = (center_fixed.x - 0.5) * (256.0/144.0) + 0.5;
	//圆形区域内透明，外为纯黑
	float dist = distance(uv , center_fixed);
	if (dist < radius)
	{
		COLOR = vec4(0.0);
	}
	else
	{
		COLOR = vec4( 0.0 , 0.0 , 0.0 , 1.0 );
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
