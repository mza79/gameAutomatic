#include <string.h>
#include <stdio.h>
#include <julia.h>
JULIA_DEFINE_FAST_TLS()
// compile using the following command
// gcc -o gameAuto -fPIC -I/opt/julia-1.4.2/include/julia -L/opt/julia-1.4.2/lib -Wl,-rpath,/opt/julia-1.4.2/lib main.c -ljulia

int main(){
    printf("Program Starts!\n");

    printf("Please ensure that sudoku board is on screen and not block by other window.\n");
    jl_init();

    // on sudoku page, run python saveBoardAsPNG()
    // python3 -c "import gameIO; gameIO.saveBoardAsPNG()"
    // run Julia sudokuSolver()
    // run python run()
    // sudo python3 -c "import gameIO; gameIO.run()"

    printf("Saving sudoku board into image file...");
    char* cmd = "sudo python3 -c \"import gameIO; gameIO.saveBoardAsPNG()\"";
    system(cmd);
    printf("Done! \n");
    printf("Loading Julia Component! Please Wait...\n");
    //import julia file. 
	jl_eval_string("Base.include(Main,\"imageCp.jl\")");
    jl_eval_string("using Main.imageCp");

    //import julia function
    jl_module_t* imageCp = (jl_module_t *)jl_eval_string("Main.imageCp");
    jl_function_t *sudokuSolver = jl_get_function(imageCp, "sudokuSolver");

	printf("Done!\nCalling function....\n");


    //call function
    jl_call0(sudokuSolver);


	printf("Sudoku Solved! will now operate on mouse\n");
    printf("Hold 'esc' to stop. \n");
    cmd = "sudo python3 -c \"import gameIO; gameIO.run()\"";
    system(cmd);


    jl_atexit_hook(0);
    return 0;

}
