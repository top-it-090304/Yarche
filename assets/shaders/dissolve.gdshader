shader_type canvas_item;

uniform vec4 modulate_color : source_color = vec4(1.0);
uniform float strength: hint_range(0.0, 1.0);
uniform float seed: hint_range(0.01, 1.0) = 0.5;
uniform vec2 direction = vec2(-0.5, 0.);
uniform float mask_vignette_strength: hint_range(0.0, 1.0) = 0.5;
uniform vec2 mask_vignette_center = vec2(0.5, 0.3);

float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    vec2 center = vec2(0.5);
    float circle_grad = 1. - distance(UV, center) * 3.;
    vec2 offset = vec2(random(UV * seed), random(UV * seed));
    offset.x = clamp(offset.x, 0., 0.5);
    offset.y = clamp(offset.y, 0., 1.5);
    
    vec2 offset_uv = offset;
    offset_uv = offset_uv * strength + UV + direction * strength;
    
    float circle_clip = distance(UV, mask_vignette_center);
    
    vec4 tex_color = texture(TEXTURE, offset_uv);
    float alpha = (tex_color.a - clamp(offset.x * strength, 0.0, 3.0) - strength) 
                  - circle_clip * strength * mask_vignette_strength * 3.0;
    
    // 🔥 КЛЮЧЕВОЕ ИЗМЕНЕНИЕ - используем MODULATE (ВСЕ ЗАГЛАВНЫЕ)
    COLOR = tex_color * modulate_color;
    COLOR.a = alpha * modulate_color.a;
}