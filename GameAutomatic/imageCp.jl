module imageCp
export sudokuSolver

    using PyCall
    using Images
    np = pyimport("numpy")
    Image = pyimport("PIL.Image")
    ImageGrab = pyimport("PIL.ImageGrab")

    # read image of current screen.
    function read_current_screen(x1=0,y1=0,x2=1920,y2=1080)
        screen =  ImageGrab.grab(bbox =(x1,y1,x2,y2))
        return screen
    end

    # read img file
    function read_img(name)
        return Image.open(name)
    end

    #calculate abs sum difference between two RGB pixels
    function pixelDiff(p1,p2)
        sumDiff = 0
        for (i,j) in zip(p1,p2)
            sumDiff += abs(i-j)
        end
    return sumDiff
    end


    # compute percentage difference of current screen versus saved image on specified coordinates
    function percentDiffvsCurrent(filecode,x1=0,y1=0,x2=1920,y2=1080)
        i1 = read_current_screen(x1,y1,x2,y2)
        i2 = read_img(string(filecode) * ".png")
        sumDif = 0
        #check compatibility of images
        if i1.mode != i2.mode
            error("different kinds of image")
        elseif i1.size != i2.size
            error("different image sizes")

        #main loop
        else
            pairs = zip(i1.getdata(),i2.getdata())
            if(length(i1.getbands())) == 1
                # image is grey scale 
                for (i,j) in pairs
                    sumDif += abs(i-j)
                end
            else
                # RGB image
                for (i,j) in pairs
                    sumDif += pixelDiff(i,j)
                end
            end
        end
        #number of pixels
        n = i1.size[1] * i1.size[2] * 3
        # calculate percentage diff
        percentDiff = sumDif/255 * 100 /n
        return Float32(percentDiff)

    end

    #compare percent diff of two files
    function percentDiffFiles(filename,filename2)
        i1 = read_img(filename2)
        i2 = read_img(filename)
        sumDif = 0
        #check compatibility of images
        if i1.mode != i2.mode
            error("different kinds of image")
        elseif i1.size != i2.size
            error("different image sizes")

        #main loop
        else
            p = zip(i1.getdata(),i2.getdata())
            if(length(i1.getbands())) == 1
                # image is grey scale 
                for (i,j) in p
                    sumDif += abs(i-j)
                end
            else
                # RGB image
                for (i,j) in p
                    sumDif += pixelDiff(i,j)
                end
            end
        end
        #number of pixels
        n = i1.size[1] * i1.size[2] * 3
        # calculate percentage diff
        percentDiff = sumDif/255 * 100 /n
        return Float32(percentDiff)

    end

    #calculate percent diff of two image file
    function percentDiffFiles(filename,filename2)
        i1 = read_img(filename2)
        i2 = read_img(filename)
        sumDif = 0
        #check compatibility of images
        if i1.mode != i2.mode
            error("different kinds of image")
        elseif i1.size != i2.size
            error("different image sizes")

        #main loop
        else
            p = zip(i1.getdata(),i2.getdata())
            if(length(i1.getbands())) == 1
                # image is grey scale 
                for (i,j) in p
                    sumDif += abs(i-j)
                end
            else
                # RGB image
                for (i,j) in p
                    sumDif += pixelDiff(i,j)
                end
            end
        end
        #number of pixels
        n = i1.size[1] * i1.size[2] * 3
        # calculate percentage diff
        percentDiff = sumDif/255 * 100 /n
        return Float32(percentDiff)

    end


    # load png files to memory
    # as game board
    function loadboard()
        print("Loading and Analyzing Image file into Sudoku board, Please Wait!\n")
        board = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0]]




        # set thresh hold to 3.3, it. if percentage diff < 3.3% then conclude that the image is the same as target

        thresh = 3.3
        for i in 1:81
            for j in 1:9
                template = string(j)*"_t.png"
                templateDark = string(j)*"_bt.png"
                block = string(i-1)* ".png"

                if percentDiffFiles(block,template)< thresh
                    row = (i-1)÷ 9 + 1
                    col = (i-1)%9 + 1
                    put(j,row,col,board)
                end
                if percentDiffFiles(block,templateDark)< thresh
                    row = (i-1)÷ 9 + 1
                    col = (i-1)%9 + 1
                    put(j,row,col,board)
                end
            end
        end
        print("done loading board\n")
        return board
    end

        # place a number on board
    function put(i,row,col,board)
        board[row][col] = i
    end

    # if placing the number does not cause confilct
    function causeConflict(inital_board,put,row,col)
        for i in 1:9
            if inital_board[row][i] == put
                return false
            end
        end
        for i in 1:9
            if inital_board[i][col] == put
                return false
            end
        end
        region_x = (row-1) ÷ 3
        region_y = (col-1) ÷ 3

        for i in 1:3
            for j in 1:3
                if inital_board[region_x*3 + i][region_y*3 + j] == put
                return false
                end
            end
        end
        return true
    end

    # if board is full
    function boardFull(board)
        for i in 1:9
            for j in 1:9
                if board[i][j] == 0
                    return false
                end
            end
        end
        return true
    end

    # return i-th empty cell of board
    function emptyCell(inital_board, i_th)
        row = 0
        col = 0
        num = 0
        done = false
        for i in 1:9
            if done
                break
            end
            for j in 1:9
                if inital_board[i][j] == 0
                    row = i
                    col = j
                    back_r = i
                    back_c = j

                    if i_th == num
                        done = true
                            break
                    end
                    num+=1
                end
            end
        end
        return row, col
    end





    # solve the sudoku and save to file
    function sudokuSolver()
        board = loadboard()
        board_inital = deepcopy(board)
        cell = 0

        print("begin Solving! \n")
        while !boardFull(board)
            @label start
            placed = false
            if cell < 0 
                break
            end
            row = emptyCell(board_inital,cell)[1]
            col = emptyCell(board_inital,cell)[2]
            val = board[row][col]
            val += 1
            #if value exceeds 9 then backtrack
            if val > 9
                cell -=1
                board[row][col] = 0
                @goto start
            end

            #check if cell can place value from 1-9 
            for i in val:9
                if causeConflict(board,i,row,col)
                    put(i,row,col,board)
                    placed = true
                    cell += 1
                    break
                end
            end

            if placed == false #nothing can be placed, then backtrack
                cell -= 1
                board[row][col] = 0
            end
        end

        print("done Solving! \n")
        print("Writing result to file! \n")
        # write solution to file for python file to read.
        i = 0
        io = open("boardSolution.txt", "w")
        while true
            row = emptyCell(board_inital,i)[1]
            col = emptyCell(board_inital,i)[2]
            #write row,col, i to file
            i +=1
            println(io, row,',',col,',',board[row][col])
            if row == 9 && col == 9
                break
            end
        end
        print("done writing! \n")
        close(io)
    end


end
