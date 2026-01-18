#include "raylib.h"

int main(){
    InitWindow(900, 600, "Window");

    while(!WindowShouldClose()){
        BeginDrawing();

            ClearBackground(DARKGRAY);

        EndDrawing();
    }

    CloseWindow();

    return 0;
}