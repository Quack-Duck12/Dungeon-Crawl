#include "raylib.h"
#include "raymath.h"



#define GameWidth 800
#define GameHeight 450

int main(void) {
    SetConfigFlags(FLAG_VSYNC_HINT);

    InitWindow(800, 450, "Window");

    RenderTexture2D GameRenderTexture = LoadRenderTexture(GameWidth, GameHeight);
    const Rectangle GameRenderSrcRect = {0, 0, GameRenderTexture.texture.width, -GameRenderTexture.texture.height};


    const int MONITOR = GetCurrentMonitor();
    const int ScreenWidth = GetMonitorWidth(MONITOR);
    const int ScreenHeight = GetMonitorHeight(MONITOR);
    
    SetWindowSize(ScreenWidth, ScreenHeight);
    const Vector2 Scale = {(float)ScreenWidth / GameWidth, (float)ScreenHeight / GameHeight};

    ToggleBorderlessWindowed();
    
    Rectangle dst = {
        0,
        0,
        GameWidth * Scale.x,
        GameHeight * Scale.y
    };

    while (!WindowShouldClose()) {

        BeginTextureMode(GameRenderTexture);
            
            ClearBackground(OFFWHITE);
        
        EndTextureMode();
            
        BeginDrawing();
            ClearBackground(BLACK);
            
            DrawTexturePro(
                GameRenderTexture.texture,
                GameRenderSrcRect,
                dst,
                (Vector2){0, 0},
                0.0f,
                WHITE
            );
            
            #ifdef _DEBUG
                DrawText(TextFormat("%d, %d", ScreenWidth, ScreenHeight), 25, 45, 20, BLUE);
                DrawFPS(10, 10);
            #endif

        EndDrawing();
    }

    UnloadRenderTexture(GameRenderTexture);
    CloseWindow();

    return 0;
}
