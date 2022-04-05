What is the overall goal of the project (i.e. what does it do, or what problem is it solving)?
	
	The project gameAutomatic performs tasks(mouse or keyboard 
	IO) based on screen states. Target state and operations are 
	saved, then whenever the current state matches the target 
	state, coresponding operations will be performed by the 
	system.

	The program aims to solve problems of repetetive operations 
	which are heavily needed for state based games. Many naive 
	and repetitive operations can be taken over by the 
	gameAutomatic system.

	For example, in League of leagend TFT mode, user may want 
	to constantly play to get tokens for prestige skin, but the 
	ranking in game is not a concern. The system can handle 
	automatically start a game once a game finishes.

	Another example, in mobile games Rise of kingdoms, user may 
	want to send troops to gather resources around every 2 
	hours. Or send scouts to explore a region of the map (1 
	operation needed) for all regions of the map. Which 
	requires the same steps of opertaions each time. 
	gameAutomatic can keep track of the screen state and when 
	such operations are needed, they are performed 
	automatically.

	!!!For the sake of demonstration, the system will be 
	configured to automaitcally solve a sudoku game on the 
	website: https://sudoku.game
	
	However, the subject of application for this system can be 
	changed easily by changing the target state, and 
	corresponding operations.

Which languages did you use, and what parts of the system are implemented in each?
	
	C :   	main.c, System management. Flow control, core 
			logic.

	Python: gameIO.py, for screen capture, keyborad and mouse 
			IO, and Keyboard or mouse operation recording.

	Julia:  screen reading and screen comparing with target 
			state. Sudoku solver functions.

What methods did you use to communicate between languages?

    	pycall: between Julia and Python
    	
    	system: beween C and Python
    	
    	<FileIo>: between C and Julia


Exactly what steps should be taken to get the project working, after getting your code? [This should start with vagrant up and can include one or two commands to start components after that.]

	make sure the required libray is installed.

	    package:
		python:
			pillow 		// pip install pillow
			mouse 		//...
			keyboard 	//...
		
			for program to function on whole screen on windows:
				-> Goto Python installed directory and Right-click on python.exe

				-> Properties -> Compatibility tab -> check 'Disable display scaling on high DPI settings'.

				-> repeat the same procedure with pythonw.exe

		Julia:
			pycall  // Pkg.add("pycall")


	compile using the following command: 
		gcc -o gameAuto -fPIC -I/opt/julia-1.4.2/include/julia -L/opt/julia-1.4.2/lib -Wl,-rpath,/opt/julia-1.4.2/lib main.c -ljulia


	goto https://sudoku.game/

		the program will automatically play the game by moving your mouse

		(if nothing happend, its very likely because the 
		coorinates of the screen, or the webpage, is not the 
		same as what I configured.)

		(or topleft corner of the sudoku board is at pixel 
		(625,230) and each cell is 82 pixels in width)


			(operating System 	: Ubuntu 18.04.3 LTS
			Browser 			: Mozilla Firefox 79.0 
			Screen resolution	: 1920*1080)

	Run the program by command line: ./gameAuto
	(the program may ask you for root privilage, because 
	python mouse and keyboard library requires root privilage)

	known issue: The click() function in Python mouse library 
	does not work when I test on my Ubuntu system. I tried to 
	search for a solution but cannot find any. However, click()
	works when I test on windows system (but need to adjust 
	pixel coordinate configuration). I hope its just my Ubuntu
	system that is causing this error. 

What features should we be looking for when marking your project?

	automatic mouse opertaions.
	
	screen reading & comparing with target screen.
	
	sudoku solver.
	
	system interaction using keyboard.
	
	language interaction and communication.
	