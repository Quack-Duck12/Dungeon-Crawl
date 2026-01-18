#include "raylib.h"
#include "raymath.h"

#define GameWidth 640
#define GameHeight 360

int main() {
    SetConfigFlags(FLAG_VSYNC_HINT | FLAG_WINDOW_HIGHDPI);

    InitWindow(100, 100, "Window");

    RenderTexture2D GameRenderTexture = LoadRenderTexture(GameWidth, GameHeight);

    const Rectangle GameRenderTextureSrcRect = {
        0.0f,
        0.0f,
        (float)GameRenderTexture.texture.width,
        -(float)GameRenderTexture.texture.height
    };

    ToggleFullscreen();

    const int ScreenWidth = GetScreenWidth();
    const int ScreenHeight = GetScreenHeight();

    const Rectangle GameRenderTextureDstRect = {
        0.0f,
        0.0f,
        (float)ScreenWidth,
        (float)ScreenHeight
    };

    while (!WindowShouldClose()) {

        BeginTextureMode(GameRenderTexture);
            ClearBackground(OFFWHITE);
        EndTextureMode();

        BeginDrawing();

            DrawTexturePro(
                GameRenderTexture.texture,
                GameRenderTextureSrcRect,
                GameRenderTextureDstRect,
                Vector2{ 0.0f, 0.0f },
                0.0f,
                WHITE
            );

            #ifdef _DEBUG
                DrawFPS(10, 10);
            #endif

        EndDrawing();
    }

    UnloadRenderTexture(GameRenderTexture);
    CloseWindow();

    return 0;
}
