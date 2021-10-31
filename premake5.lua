
----------------------------
-- Project Generator
----------------------------
-- Environment vars
PSDK_DIR = os.getenv("PLUGIN_SDK_DIR")
GTASA_DIR = "F:/GTASanAndreas"
DX9SDK_DIR = os.getenv("DIRECTX9_SDK_DIR")

if (DX9SDK_DIR == nil) then
    error("DIRECTX9_SDK_DIR environment variable not set")
end

if (PSDK_DIR == nil) then
    error("PLUGIN_SDK_DIR environment variable not set")
end
----------------------------

workspace "MapEditorSA"
    configurations { "Debug", "Release" }
    architecture "x86"
    platforms "Win32"
    language "C++"
    cppdialect "C++20"
    characterset "MBCS"
    staticruntime "On"
    location "build"

    project "Depend"
        kind "StaticLib"
        targetdir "build/bin"

        files { 
            "depend/**",
            "depend/**.h", 
            "depend/**.hpp", 
            "depend/**.c", 
            "depend/**.cpp" 
        }
        libdirs (PSDK_DIR .. "/output/lib")

        filter "configurations:Debug"
            defines { "DEBUG", "IS_PLATFORM_WIN" }
            symbols "On"

        filter "configurations:Release"
            defines { "NDEBUG", "IS_PLATFORM_WIN" }
            optimize "On"


    project "MapEditor"
        kind "SharedLib"
        targetdir (GTASA_DIR)
        targetextension ".asi"
        
        files { 
            "src/**.h", 
            "src/**.hpp", 
            "src/**.cpp" 
        }
        includedirs {
            PSDK_DIR .. "/plugin_sa/",
            PSDK_DIR .. "/plugin_sa/game_sa/",
            PSDK_DIR .. "/shared/",
            PSDK_DIR .. "/shared/game/",
            DX9SDK_DIR .. "/Include"
        }
        libdirs (PSDK_DIR .. "/output/lib")
        
        defines { 
            "NDEBUG", 
            "IS_PLATFORM_WIN" ,
            "_CRT_SECURE_NO_WARNINGS",
            "_CRT_NON_CONFORMING_SWPRINTFS",
            "GTASA",
            "_DX9_SDK_INSTALLED",
            "PLUGIN_SGV_10US"
        }

        pchheader "pch.h"
        pchsource "src/pch.cpp"

        filter "configurations:Debug"
            symbols "On"
            links { 
                "Depend",
                "d3d9",
                "d3dx9",
                "d3d11",
                "urlmon",
                "XInput9_1_0",
                "plugin_d.lib" 
            }

        filter "configurations:Release"
            optimize "On"
            links { 
                "Depend",
                "d3d9",
                "d3dx9",
                "d3d11",
                "urlmon",
                "XInput9_1_0",
                "plugin.lib" 
            }
        