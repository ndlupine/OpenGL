attribute vec4 position;
attribute vec4 inputColor;

varying vec4 endColor;

void main(void) {
    gl_Position = position;
    endColor = inputColor;
}