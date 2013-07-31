attribute vec4 position;
attribute vec4 inputColor;

varying vec4 outputColor;

attribute vec2 texCoordIn;
varying vec2 texCoordOut;

void main(void) {
    gl_Position = position;
    outputColor = inputColor;
    texCoordOut = texCoordIn;
}