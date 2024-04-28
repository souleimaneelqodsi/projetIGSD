uniform mat4 transform;

attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord; 

varying vec4 vertColor;
varying vec2 vTexcoord; 
varying float interpolatedZ;

void main() {
    interpolatedZ = position.z;
    vertColor = color;
    vTexcoord = texCoord; 
    gl_Position = transform * position;
}
