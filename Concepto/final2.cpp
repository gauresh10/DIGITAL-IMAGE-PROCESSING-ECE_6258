// Calculate and display the Mandelbrot set
// ECE4893/8893 final project, Fall 2011

#include <iostream>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>

#include <GL/glut.h>
#include <GL/glext.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include "complex.h"
//#include<cmath>

using namespace std;

// Min and max complex plane values
Complex  minC(-2.0, -1.2);
Complex  maxC( 1.0, 1.8);
int      maxIt = 2000;     // Max iterations for the set computations
int Winw = 512;
int Winh = 512;
static GLfloat rotX = 0.0;
static GLfloat rotY = 0.0;
static GLfloat rotZ = 0.0;
static GLfloat dX = 1.0;
static GLfloat dY = 0.8;
static GLfloat dZ = 0.6;
static GLfloat updateRate = 10.0;
static const float DEG2RAD = M_PI/180;
static GLuint maxDepth =4;
int max_iter_val=2000;

double G[2000];
double R[2000];
double B[2000];



void static_color(){
// srand(time(NULL));
  for(int i=0;i<2000;i++){
    R[i]=drand48();
    G[i]=drand48();
    B[i]=drand48();

  }

}

void drawCircle()
{
  // Draw a circle by drawing 360 small lines
  GLfloat radius = 1.0;
  glColor3f(1.0, 1.0, 1.0);
  glLineWidth(2.0);
  glBegin(GL_LINE_LOOP);
  for (int i = 0; i < 360; i++)
    {
      float degInRad = i*DEG2RAD;
      glVertex2f(cos(degInRad)*radius,sin(degInRad)*radius);
   }
  glEnd();
}

void mandelbrot(void){
   // Complex Zo = minC;//Complex(0,0);
    double stepx = (maxC.real - minC.real)/Winw;
    double stepy = (maxC.imag - minC.imag)/Winh;
    int iter_val;

    Complex c,Zn;
    Complex temp = minC * minC;
    c = minC;
    //glLineWidth(1.0);
    for(int i=0; i < Winw ; i++){
          bool flag=false;
       c.real=c.real+stepx;
        c.imag=maxC.imag;
       for(int j = 0;j<Winh ;j++){
          c.imag=c.imag-stepy;
          //c = Complex(c.real,c.imag);

          Zn = Complex(0,0);
          Complex c_val=Complex(c.real,c.imag);


          for (int k = 0; k < 2000 ; k++){

              Zn = Zn * Zn + c_val;

              if(Zn.Mag2() > 2.0){
                  //cout<<"reached greater than 2.0"<<endl;
                   glBegin(GL_POINTS);
                  glColor3f(R[k],G[k],B[k]);
                  glVertex2f(i,j);
                  glEnd();
                  iter_val=k;
                  flag=true;
                  break;

               }
               else{
                  //cout<<"reached less than 2.0"<<endl;
                    glBegin(GL_POINTS);
                  glColor3f(0.0,0.0,0.0);
                  glVertex2f(i,j);
                  glEnd();
               }



           }

      }

    }



}


void display(void)
{ // Your OpenGL display code


  glClear(GL_COLOR_BUFFER_BIT );

	glLoadIdentity();
	//set the viewing transformation
	gluLookAt(0.0, 0.0, 5.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
  glTranslatef(Winw/2.0, Winh/2.0, 0);
  glScalef(Winw/2.0, Winh/2.0, 10.0);
 	//glPushMatrix();


  //call function here

  mandelbrot();
  //drawCircle();
  //keglPopMatrix();

  //glFlush();

   glutSwapBuffers();
}

void init()
{ // Your OpenGL initialization code here
  glClearColor(0.0, 0.0, 0.0, 0.0);
  glShadeModel(GL_FLAT);

}

void reshape(int w, int h)
{ // Your OpenGL window reshape code here
  glViewport(0,0, (GLsizei)Winw, (GLsizei)Winh);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0.0, (GLdouble)Winw, (GLdouble)0.0, Winh, (GLdouble)-Winw, (GLdouble)Winw);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
}



void mouse(int button, int state, int x, int y)
{ // Your mouse click processing here
  // state == 0 means pressed, state != 0 means released
  // Note that the x and y coordinates passed in are in
  // PIXELS, with y = 0 at the top.
}

void motion(int x, int y)
{ // Your mouse motion here, x and y coordinates are as above

}

void keyboard(unsigned char c, int x, int y)
{ // Your keyboard processing here

}

void timer(int)
{
  glutPostRedisplay();
  glutTimerFunc(1000.0 / updateRate, timer, 0);
}
int main(int argc, char** argv)
{
  // Initialize OpenGL, but only on the "master" thread or process.
  // See the assignment writeup to determine which is "master"
  // and which is slave.
  int initx=100;
  int inity=100;
  static_color();
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB );

  glutInitWindowSize(Winw, Winh);
  glutInitWindowPosition(initx, inity);
  glutCreateWindow("MandelBrot");
  init();

  glutDisplayFunc(display);
  glutReshapeFunc(reshape);
 // glutTimerFunc(1000.0 / updateRate, timer, 0);
  glutMainLoop();
  return 0;

}
