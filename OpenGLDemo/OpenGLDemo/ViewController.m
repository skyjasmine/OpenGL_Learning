//
//  ViewController.m
//  OpenGLDemo
//
//  Created by 张莉 on 2024/3/4.
//

#import "ViewController.h"

typedef struct {
    GLKVector3 positionoCoords;
}sceneVertex;

//三角形的三个顶点，默认的用户OpenGL上下文的可见坐标系是分别沿着x、y、z轴，从-1.0到1.0
static const sceneVertex vertices[] = {
    {{-0.5f,-0.5f,0.0}},
    {{0.5f,-0.5f,0.0}},
    {{-0.5f,0.1f,0.0}},
};

@interface ViewController ()

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, assign) GLuint vertextBufferID;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View is not a kind of GLKView");
    
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    //使用静态颜色绘制
    self.baseEffect.useConstantColor = GL_TRUE;
    //设置默认绘制颜色，参数分别是 RGBA
    self.baseEffect.constantColor = GLKVector4Make(1, 1, 1, 1); // RGBA
    //设置背景色为黑色
    glClearColor(0, 0, 0, 1);
    
    /// -----------生成并绑定缓存数据-----------
    // 1、glGenBuffers申请一个标识符
    glGenBuffers(1, &_vertextBufferID);
    // 2、绑定指定标识符的缓存为当前缓存
    glBindBuffer(GL_ARRAY_BUFFER, _vertextBufferID);
    // 3、缓存数据：glBufferData复制顶点数据从CPU到GPU
    glBufferData(GL_ARRAY_BUFFER, 
                 sizeof(vertices), // Number of bytes to copy
                 vertices,         // Address of bytes to copy
                 GL_STATIC_DRAW);
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.baseEffect prepareToDraw];
    
    //Clear Frame Buffer
    glClear(GL_COLOR_BUFFER_BIT);
    // 4、启用顶点属性数组
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    // 5、设置指针：告诉OpenGL 在缓存中的数据类型和所需要访问的数据的内存偏移值
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(sceneVertex),
                          NULL);
    // 6、绘制图形：使用当前缓存中的数据渲染
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

- (void)dealloc
{
    // 7、释放缓存数据
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    if (0 != _vertextBufferID) {
        glDeleteBuffers(1, &_vertextBufferID);
        _vertextBufferID = 0;
    }
    
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}


@end
