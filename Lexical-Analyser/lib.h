/* ANSI colour library codes
* {@link https://github.com/shiena/ansicolor/blob/master/README.md}
*
* Usage: printf(FORE_BLU "This is blue text" RESET);
*        printf(FORE_RED "This is %s text" RESET, "red");
* 
*/

// Resets All colour attributes to initial terminal state
#define RESET  "\x1B[0m"

// Foreground Colours
#define FORE_RED  "\x1B[31m"
#define FORE_GRN  "\x1B[32m"
#define FORE_YEL  "\x1B[33m"
#define FORE_BLU  "\x1B[34m"
#define FORE_MAG  "\x1B[35m"
#define FORE_CYN  "\x1B[36m"
#define FORE_WHT  "\x1B[37m"

// Background Colours


// Symbols
#define SYMBOL_TICK "\xE2\x9C\x93"
