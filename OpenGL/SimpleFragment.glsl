varying lowp vec4 outputColor;
varying lowp vec2 texCoordOut;
uniform sampler2D tex;

void main(void) {
    gl_FragColor = texture2D(tex, texCoordOut);
}