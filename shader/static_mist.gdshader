shader_type canvas_item;

// 雨天环绕薄雾：不随时间流动，中间是湿气，四周是雨幕，越靠边越厚
// 用法：挂到铺满屏幕（或覆盖目标区域）的 ColorRect / TextureRect 上

// 噪声纹理：repeat_enable 让 UV 放大后能平铺，filter_linear 保持柔和
uniform sampler2D noise_texture : repeat_enable, filter_linear;
// 整片基础雾量：雨天这层就是"空气里的水汽"，别设为 0
uniform float base_fog : hint_range(0.0, 1.0) = 0.18;
// 边缘雾量峰值
uniform float density : hint_range(0.0, 1.0) = 0.55;
// 噪声平铺密度，越大颗粒越细
uniform float noise_scale : hint_range(1.0, 32.0) = 8.0;
// 雨幕起点与终点：距离小于 start 只有基础湿气，超过 end 到最浓
uniform float edge_start : hint_range(0.0, 1.5) = 0.1;
uniform float edge_end : hint_range(0.0, 1.5) = 0.72;
// 雾心位置，默认画面正中
uniform vec2 center = vec2(0.5, 0.5);
// 雾色：冷灰偏蓝，别用纯白，纯白看着像曝光炸了
uniform vec4 tint : source_color = vec4(0.7, 0.75, 0.8, 1.0);

void fragment() {
	// 到雾心的距离，纵向压一点，免得四角糊得太狠
	float d = length((UV - center) * vec2(1.0, 0.85));

	// 环绕权重：中心只有基础湿气，靠边渐浓成雨幕
	float ring = smoothstep(edge_start, edge_end, d);

	// 静态噪声：不叠 TIME，纹理原地不动，只负责打散渐变的死板感
	float n = texture(noise_texture, UV * noise_scale).r;
	n = smoothstep(0.3, 0.8, n);

	// 噪声抬一下底，让雨幕里也有疏密，不是一块死板的灰
	float fog = mix(base_fog, density, ring) * mix(0.6, 1.0, n);

	COLOR.rgb = mix(COLOR.rgb, tint.rgb, max(ring, base_fog + 0.2));
	COLOR.a *= fog * tint.a;
}
