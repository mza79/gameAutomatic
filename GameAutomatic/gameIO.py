#!/usr/bin/env python
# coding: utf-8

# In[1]:


# This program is developed for CMPT 383 project

# Python file for functions that handle screen reading, 
# recording and performing mouse operations
import numpy as np
from PIL import ImageGrab
from PIL import Image
import mouse
import keyboard
import time


# In[2]:


# save screen to file, can set delay for screen captrue
def save_screen(name,x1=0,y1=0,x2=1920,y2=1080,delay = 0):
    
    time.sleep(delay)
#     last_time = time.time()
    # whole screen
    screen =  ImageGrab.grab(bbox =(x1,y1,x2,y2))
#     print('screen read took {} seconds'.format(time.time()-last_time))
#     last_time = time.time()
    screen.save(name)

# read the current screen and returns as np_array
def read_current_screen(x1=0,y1=0,x2=1920,y2=1080):
    last_time = time.time()
    # whole screen
    screen =  np.array(ImageGrab.grab(bbox =(x1,y1,x2,y2)))
#     print('screen read took {} seconds'.format(time.time()-last_time))
    last_time = time.time()
    return screen

#read img from file
def read_img(name):
    return Image.open(name)


# In[3]:


# record mouse ops
def recordPath(frameNum):
    frameName = str(frameNum) + ".txt"
    #record mouse procedure
    path = []
    while True:
        if keyboard.is_pressed('r'):
            time.sleep(0.5)
            print("begin record mouse movements")
            while(not keyboard.is_pressed('r')):
                if mouse.is_pressed():
                    pos = mouse.get_position()
                    path.append(pos)
                    print("mouse click:",pos[0],pos[1])
                    time.sleep(0.3)
            print("end record mouse movements")
            return path
            


# In[4]:


# write mouse ops recording to file
def writePath(name,path):
    f = open(name,"w")
    for i in range(len(path)):
        f.write(str(path[i][0]) + ',' + str(path[i][1]) + '\n')
    f.close()


# In[5]:


#read mouse ops recording from file
def readPath(name):
    pathr = []
    f = open(name,"r")
    for line in f:
        xy = line.split(',')
        x = int(xy[0])
        y = int(xy[1])
        pathr.append([x,y])
    f.close()
    return pathr


# In[6]:


#perform mouse procdure path
def performPath(path,animation = 1, delay = 0.3):
    for xy in path:
        mouse.move(xy[0], xy[1],duration=animation)
        mouse.click('right')
        time.sleep(0.3)


# In[7]:


# operations to perform when target frame match is found
def opAtMatch(opsNum):
    path = readPath(str(opsNum) + ".txt")
    performPath(path,animation = 1, delay = 0.3)


# In[8]:


#record stages phase
# record target frame and sequential mouse ops
# and writes into file <framenum>.png & <framenum>.txt
def recordStage(frameNum,x1=0,y1=0,x2=1920,y2=1080):
    print("press 'p' to start recording target stage")
    while True:
        if keyboard.is_pressed('p'):
            print("begin record target stages")
            time.sleep(0.5)
            
            save_screen(str(frameNum)+".png",x1,y1,x2,y2)
            print("target frame saved")

            print("press 'r' to record mouse movements")
            print("press 'r' agian to end recording mouse movements")
            while True:
                path = recordPath(frameNum)
                break
            print("done recording target stage")
            break
    writePath(str(frameNum)+".txt",path)



def cellAtMatch(row,col):
    # inital 625, 230
    # width = 82
    width = 82
    x = 625 + (col-1)*width + width/2
    y = 230 + (row-1)*width + width/2
    path = []
    path.append([x,y])
    performPath(path,animation = 1, delay = 0.3)

    
# with careful measure, coordinate system of sudoku in sudoku.game is:

# first border 625, 230
# width = 82

def saveBoardAsPNG():
    x = 625
    y = 230
    width = 82

    b = 0 
    time.sleep(2.4)
    for j in range(9):
        for i in range(9):
            x1 = x + width * i
            y1 = y + width * j
            x2 = x + width * (i+1)
            y2 = y + width * (j+1)
            save_screen(str(b)+".png",x1,y1,x2,y2)
            b+=1

# index begin with 1
# cellAtMatch(row,col)

# 1-9 : 101 - 109 .txt file
# opAtMatch(10x)

# hold esc to stop
def run():
    f = open("boardSolution.txt","r")
    for line in f:
        if keyboard.is_pressed('esc'):
            return
        xyz = line.split(',')
        x = int(xyz[0]) # row
        y = int(xyz[1]) # col
        z = int(xyz[2]) # number to place
        cellAtMatch(x,y)
        opAtMatch(100 + int(z))
    f.close()
    


