//
//  NLOpenGLView.m
//  OpenGL
//
//  Created by Nick Lupinetti on 7/29/13.
//  Copyright (c) 2013 Nick Lupinetti. All rights reserved.
//

#import "NLOpenGLView.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

typedef struct {
    float position[3];
    float color[4];
} vertex;

const vertex vertex_list[] = {
    {{ 1, -1, 0}, {1, 0, 0, 1}},
    {{ 1,  1, 0}, {0, 1, 0, 1}},
    {{-1,  1, 0}, {0, 0, 1, 1}},
    {{-1, -1, 0}, {0, 0, 0, 1}}
};

const GLubyte vertex_indices[] = {
    0, 2, 1,
    0, 3, 2
};

@interface NLOpenGLView ()
@property (nonatomic, strong) CAEAGLLayer *glLayer;
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic) GLuint colorRenderBuffer;
@property (nonatomic) GLuint positionLocation;
@property (nonatomic) GLuint colorLocation;
@end

@implementation NLOpenGLView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self compileShaders];
        [self setupVertexBufferObjects];
        [self render];
    }
    return self;
}

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setupLayer {
    self.glLayer = (CAEAGLLayer *)self.layer;
    self.glLayer.opaque = YES;
}

- (void)setupContext {
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        [NSException raise:NSInternalInconsistencyException format:@"Could not create OpenGLES context"];
    }
    if (![EAGLContext setCurrentContext:self.context]) {
        [NSException raise:NSInternalInconsistencyException format:@"Could not make context %@ current", self.context];
    }
}

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, self.colorRenderBuffer);
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.glLayer];
}

- (void)setupFrameBuffer {
    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, self.colorRenderBuffer);
}

- (void)render {
    glClearColor(0.0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    glVertexAttribPointer(self.positionLocation, 3, GL_FLOAT, GL_FALSE, sizeof(vertex), 0);
    glVertexAttribPointer(self.colorLocation, 4, GL_FLOAT, GL_FALSE, sizeof(vertex), (GLvoid *)(sizeof(float) * 3));
    glDrawElements(GL_TRIANGLES, sizeof(vertex_indices)/sizeof(vertex_indices[0]), GL_UNSIGNED_BYTE, 0);
    
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (GLuint)compileShader:(NSString *)shaderName withType:(GLenum)shaderType {
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError *error = nil;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        [NSException raise:NSInternalInconsistencyException format:@"Could not load shader %@: %@",shaderName, error.localizedDescription];
    }
    
    GLuint shader = glCreateShader(shaderType);
    
    const char *shaderCString = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shader, 1, &shaderCString, &shaderStringLength);
    glCompileShader(shader);
    
    GLint success = GL_FALSE;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
    if (success == GL_FALSE) {
        [NSException raise:NSInternalInconsistencyException format:@"Could not compile shader %@", shaderName];
    }
    
    return shader;
}

- (GLuint)programWithVertexShader:(GLuint)vertexShader fragmentShader:(GLuint)fragmentShader {
    GLuint program = glCreateProgram();
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    glLinkProgram(program);
    
    GLint success = GL_FALSE;
    glGetProgramiv(program, GL_LINK_STATUS, &success);
    if (success == GL_FALSE) {
        GLchar message[256];
        glGetProgramInfoLog(program, sizeof(message), NULL, &message[0]);
        NSString *messageString = [NSString stringWithUTF8String:message];
        [NSException raise:NSInternalInconsistencyException format:@"Could not link shaders: %@", messageString];
    }
    
    return program;
}

- (void)compileShaders {
    GLuint vertexShader = [self compileShader:@"SimpleVertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment" withType:GL_FRAGMENT_SHADER];
    GLuint program = [self programWithVertexShader:vertexShader fragmentShader:fragmentShader];
    
    glUseProgram(program);
    
    self.positionLocation = glGetAttribLocation(program, "position");
    self.colorLocation = glGetAttribLocation(program, "inputColor");
    glEnableVertexAttribArray(self.positionLocation);
    glEnableVertexAttribArray(self.colorLocation);
}

- (void)setupVertexBufferObjects {
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertex_list), vertex_list, GL_STATIC_DRAW);
    
    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(vertex_indices), vertex_indices, GL_STATIC_DRAW);
}

@end
