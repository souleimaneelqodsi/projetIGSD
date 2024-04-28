#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec2 vTexcoord;
varying float interpolatedZ;

void main() {
    vec4 texColor = texture2D(texture, vTexcoord);
    float zLine = mod(interpolatedZ, 2.0);
    if((interpolatedZ > -195) && (zLine >= 0.1 && zLine <= 0.2)){
        gl_FragColor = texColor * vec4(vec3(0.0), 0.9);
    }
    else if(interpolatedZ < -195.0){
        gl_FragColor = texColor * vec4(0, 0.6, 0, 1);
    }
    else{
        gl_FragColor = texColor * vertColor;
    } 
}
