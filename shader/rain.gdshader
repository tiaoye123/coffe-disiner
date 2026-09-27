shader_type canvas_item;

// 斜向雨丝：横向密铺的噪声往下滚，就成了一根根短雨线
// 用法：挂到铺满屏幕的 ColorRect 上，一般放中上层

// 噪声纹理：repeat_enable 才能横向平铺
uniform sampler2D noise_texture : repeat_enable, filter_linear;

// 横向列数：越大雨丝越细越密
uniform float columns : hint_range(4.0, 120.0) = 40.0;
// 下落速度
uniform float fall_speed : hint_range(0.0, 6.0) = 1.6;
// 倾斜：正数往右斜
uniform float slant : hint_range(-1.0, 1.0) = 0.15;
// 纵向缩放，越小雨丝越长（1.0 是标准长度）
uniform float length_scale : hint_range(0.1, 4.0) = 0.7;
// 阈值，越靠近 1 雨丝越细越亮
uniform float threshold_lo : hint_range(0.0, 1.0) = 0.6;
uniform float threshold_hi : hint_range(0.0, 1.0) = 0.92;
// 近处那层的不透明度
uniform float near_alpha : hint_range(0.0, 1.0) = 0.55;
// 远处那层的不透明度
uniform float far_alpha : hint_range(0.0, 1.0) = 0.3;
// 雨丝颜色
uniform vec4 rain_tint : source_color = vec4(0.8, 0.86, 0.92, 1.0);

// uv_in 屏幕 UV，speed_mul 速度倍率，x_shift 横向错开，col_mul 列数倍率
float streak(vec2 uv_in, float speed_mul, float x_shift, float col_mul) {
	vec2 uv = uv_in * vec2(columns * col_mul, length_scale);
	uv.x += uv_in.y * slant + x_shift;
	// 减号才是往下落，加号会往上飘
	uv.y -= TIME * fall_speed * speed_mul;
	return smoothstep(threshold_lo, threshold_hi, texture(noise_texture, uv).r);
}

void fragment() {
	// 两层叠：快而亮的是近处，慢而淡的是远处，拉出纵深
	float near_layer = streak(UV, 1.4, 0.0, 1.0) * near_alpha;
	float far_layer = streak(UV, 0.7, 0.37, 0.6) * far_alpha;

	COLOR.rgb = rain_tint.rgb;
	COLOR.a *= clamp(near_layer + far_layer, 0.0, 1.0) * rain_tint.a;
}
