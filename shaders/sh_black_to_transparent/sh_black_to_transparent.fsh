// Fragment Shader
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 texColour = texture2D( gm_BaseTexture, v_vTexcoord );
    float test = max(max(texColour.r, texColour.g), texColour.b);
    if (test > 0.0) {
        gl_FragColor = v_vColour * texColour;
    } else {
        gl_FragColor = vec4(0.0);
    }
}
