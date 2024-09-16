// Fragment Shader
varying vec2 v_vTexcoord;
uniform float u_scale;
uniform float u_sharpness;
uniform vec2 u_offset;
uniform float u_tilt;
uniform float u_threshold;
uniform bool u_binary;

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

void main()
{
	float scale_factor = u_scale; 
    vec2 uv = v_vTexcoord * scale_factor + u_offset;			
    uv = vec2(uv.x + u_tilt * uv.y, uv.y + u_tilt * uv.x);		
    float n = noise(uv);
    n = pow(n, u_sharpness); 

    if (n < u_threshold) {
        n = 0.0;
    }

    if (u_binary) {
        n = step(0.5, n);
    }

    gl_FragColor = vec4(vec3(n), 1.0);
}