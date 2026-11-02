// Theme.qml - Central color and font definitions for the dashboard
//
// ============================================================
// 🎨 EASY THEME SWITCHING: Choose Your Color Scheme!
// ============================================================
// Every QML component references Theme.xxx for its colors.
// To switch themes, simply comment out the active theme section
// and uncomment a different one below.
//
// Available themes:
//   1. DARK BLUE PURPLE (Default) - Original dark theme
//   2. PURPLE BRANDING - Vibrant purple theme
//   3. OCEAN BREEZE - Cool blue/cyan professional
//   4. NORD DARK - Muted, soft Nord palette
//   5. CYBERPUNK - Neon futuristic with high contrast
//   6. FOREST - Earthy green nature theme
//
// NOTE: Only ONE theme block should be uncommented at a time!
// ============================================================

pragma Singleton
import QtQuick

QtObject {
    // ========================================
    // THEME 1: DARK BLUE PURPLE (Default)
    // ========================================
    /*
    readonly property color background:    "#1a1a2e"
    readonly property color sidebarTop:    "#1e1e2e"
    readonly property color sidebarBottom: "#252537"
    readonly property color card:          "#242437"
    readonly property color hover:         "#2d2d3f"
    readonly property color border:        "#2a2a3e"
    readonly property color textPrimary:   "#ffffff"
    readonly property color textSecondary: "#b8b8c8"
    readonly property color accentBlue:    "#3498db"
    readonly property color accentGreen:   "#2ecc71"
    readonly property color accentRed:     "#e74c3c"
    readonly property color accentOrange:  "#f39c12"
    readonly property color accentPurple:  "#9b59b6"
    */

    // ========================================
    // THEME 2: PURPLE BRANDING
    // ========================================
    // Vibrant, modern theme with purple/violet branding
    // TO USE: Comment out THEME 1 above and uncomment this section
    /*
    readonly property color background:    "#1a1625"
    readonly property color sidebarTop:    "#221833"
    readonly property color sidebarBottom: "#2a1f3d"
    readonly property color card:          "#2a1f3d"
    readonly property color hover:         "#3d2656"
    readonly property color border:        "#2e2440"
    readonly property color textPrimary:   "#ffffff"
    readonly property color textSecondary: "#c4b8d8"
    readonly property color accentBlue:    "#9b59b6"    // Purple primary
    readonly property color accentGreen:   "#00bcd4"    // Teal
    readonly property color accentRed:     "#e91e63"    // Pink
    readonly property color accentOrange:  "#ff9800"    // Orange
    readonly property color accentPurple:  "#9b59b6"    // Purple
    */

    // ========================================
    // THEME 3: OCEAN BREEZE (Blue/Cyan)
    // ========================================
    // Cool, professional theme with ocean-inspired blues and teals
    // TO USE: Comment out THEME 1 above and uncomment this section
    /*
    readonly property color background:    "#0d1b2a"
    readonly property color sidebarTop:    "#1b263b"
    readonly property color sidebarBottom: "#243447"
    readonly property color card:          "#1f2d3d"
    readonly property color hover:         "#2d3e50"
    readonly property color border:        "#2c3e50"
    readonly property color textPrimary:   "#e0f4ff"
    readonly property color textSecondary: "#a8d8ea"
    readonly property color accentBlue:    "#00b4d8"    // Bright cyan
    readonly property color accentGreen:   "#06ffa5"    // Aqua green
    readonly property color accentRed:     "#ff6b9d"    // Coral pink
    readonly property color accentOrange:  "#ffaa00"    // Warm orange
    readonly property color accentPurple:  "#c77dff"    // Lavender
    */

    // ========================================
    // THEME 4: NORD DARK (Muted Professional)
    // ========================================
    // Based on the popular Nord palette — soft, easy on the eyes
    // TO USE: Comment out THEME 1 above and uncomment this section
    /*
    readonly property color background:    "#2e3440"
    readonly property color sidebarTop:    "#3b4252"
    readonly property color sidebarBottom: "#434c5e"
    readonly property color card:          "#3b4252"
    readonly property color hover:         "#434c5e"
    readonly property color border:        "#4c566a"
    readonly property color textPrimary:   "#eceff4"
    readonly property color textSecondary: "#d8dee9"
    readonly property color accentBlue:    "#81a1c1"    // Frost blue
    readonly property color accentGreen:   "#a3be8c"    // Aurora green
    readonly property color accentRed:     "#bf616a"    // Soft red
    readonly property color accentOrange:  "#d08770"    // Peachy orange
    readonly property color accentPurple:  "#b48ead"    // Muted purple
    */

    // ========================================
    // THEME 5: CYBERPUNK (Neon Futuristic)
    // ========================================
    // Vibrant, futuristic with neon accents and dark backgrounds
    // TO USE: Comment out THEME 1 above and uncomment this section
    readonly property color background:    "#0a0e27"
    readonly property color sidebarTop:    "#1a1a2e"
    readonly property color sidebarBottom: "#16213e"
    readonly property color card:          "#1a1a2e"
    readonly property color hover:         "#2d2d3f"
    readonly property color border:        "#4a148c"    // Purple border
    readonly property color textPrimary:   "#ffffff"
    readonly property color textSecondary: "#b0b0d0"
    readonly property color accentBlue:    "#00d9ff"    // Electric cyan
    readonly property color accentGreen:   "#39ff14"    // Neon green
    readonly property color accentRed:     "#ff0080"    // Hot magenta
    readonly property color accentOrange:  "#ffcc00"    // Electric yellow
    readonly property color accentPurple:  "#bd00ff"    // Neon purple

    // ========================================
    // THEME 6: FOREST (Green Nature)
    // ========================================
    // Earthy, calming theme with forest greens and natural tones
    // TO USE: Comment out THEME 1 above and uncomment this section
    /*
    readonly property color background:    "#1a2421"
    readonly property color sidebarTop:    "#233329"
    readonly property color sidebarBottom: "#2d3e37"
    readonly property color card:          "#2a3d34"
    readonly property color hover:         "#3a4f44"
    readonly property color border:        "#3d5a4c"
    readonly property color textPrimary:   "#e8f5e9"
    readonly property color textSecondary: "#a5d6a7"
    readonly property color accentBlue:    "#4dd0e1"    // Light teal
    readonly property color accentGreen:   "#66bb6a"    // Vibrant green
    readonly property color accentRed:     "#ef5350"    // Earthy red
    readonly property color accentOrange:  "#ffa726"    // Autumn orange
    readonly property color accentPurple:  "#7e57c2"    // Lavender
    */

    // --- Fonts ---
    readonly property string fontFamily: "Segoe UI"
}
