from time import time
import cv2


t1 = time()
vid = cv2.VideoCapture(0)
t2 = time()
print(t2-t1)

for i in range(10):
    t2 = time()
    ret,frame = vid.read()
    t3 = time()
    print(t3-t2)
