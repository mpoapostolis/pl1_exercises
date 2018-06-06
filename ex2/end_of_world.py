import queue
import sys
from struct import * 

q = queue.Queue()
path = sys.argv[1]
end_of_world = "the world is saved"
file = open(path,"r")

lines = file.readlines()
width = len(lines[0].strip())
height = len(lines)

matrix = [
    ["" for x in range(0, width)]
        for y in range(0, height)] 

def printWorld(x,y,a,b):

    for line in matrix:
        for row in line:
            print(row, end="")
        print("")
    print("")

def move(p):
    # variables
    global end_of_world
    (y,x,value, time) = p
    #direction

    left = x - 1
    right = x + 1
    top = y - 1
    bot = y + 1

    #in bounds
    can_go_left = (left > -1)  
    can_go_top = (top > -1)  
    can_go_right = (right < width)  
    can_go_bot = (bot < height) 

    # is valid to go
    valid_left = can_go_left and matrix[y][left] != "X" and matrix[y][left] != value  
    valid_right = can_go_right and matrix[y][right] != "X" and matrix[y][right] != value  
    valid_top = can_go_top and matrix[top][x] != "X" and matrix[top][x] != value  
    valid_bot = can_go_bot and matrix[bot][x] != "X" and matrix[bot][x] != value  

    if(valid_left):
        if (matrix[y][left] != "."):
            matrix[y][left] = "*"
            end_of_world = time
        else:
            matrix[y][left] = value
            q.put((y, left, value, time + 1))
                # printWorld(value,"valid_left", y, left)


    if(valid_right):
        if (matrix[y][right] != "."):
            matrix[y][right] = "*"
            end_of_world = time
        else:
            matrix[y][right] = value
            q.put((y, right, value, time + 1))
                # printWorld(value,"valid_right",y, right)

    if(valid_top):
        if (matrix[top][x] != "."):
            matrix[top][x] = "*"
            end_of_world = time
        else:
            matrix[top][x] = value
            q.put((top, x, value, time + 1))
                # printWorld(value,"valid_top",top, x)

    if(valid_bot):
        if (matrix[bot][x] != "."):
            matrix[bot][x] = "*"
            end_of_world = time
        else:
            matrix[bot][x] = value
            q.put((bot, x, value, time + 1))
                # printWorld(value,"valid_bot",bot, x)        

# Read
for y, l in enumerate(lines):
    line = list(l.strip())
    for x, value in enumerate(line):
        matrix[y][x] = value
        if ((value == "+") or (value == "-")):
            q.put((y, x, value, 1))

while(not q.empty()):
    p = q.get()
    (_, _, _, t) = p
    if end_of_world != t-1:
        move(p)

print(end_of_world)
for line in matrix:
    for row in line:
        print(row, end="")
    print("")