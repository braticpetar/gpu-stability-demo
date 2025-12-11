#include <GL/glx.h>
#include <unistd.h>
int main() {
    Display *d = XOpenDisplay(NULL);
    int attr[] = { GLX_RGBA, GLX_DEPTH_SIZE, 24, None };
    Window root = DefaultRootWindow(d);
    XVisualInfo *vi = glXChooseVisual(d, 0, attr);
    GLXContext ctx = glXCreateContext(d, vi, NULL, GL_TRUE);
    Window win = XCreateSimpleWindow(d, root, 0,0, 1920,1080, 0,0,0);
    glXMakeCurrent(d, win, ctx);
    // Allocate ~100 GB of GPU memory in 1 GB chunks until it screams
    for(;;) {
        GLuint tex; glGenTextures(1, &tex);
        glBindTexture(GL_TEXTURE_2D, tex);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, 16384, 16384, 0, GL_RGBA, GL_FLOAT, NULL);
        usleep(1000);
    }
}
