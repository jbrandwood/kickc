/// @file
/// MOS 6560/6561 VIDEO INTERFACE CHIP
/// Used in VIC 20
/// http://archive.6502.org/datasheets/mos_6560_6561_vic.pdf

struct MOS6561_VIC {
    /// Screen Origin X-coordinate
    ///   bits 0-6: horizontal centering
    ///   bit 7: sets interlace scan
    char ORIGIN_X;
    /// Screen Origin Y-coordinate
    ///   bit 0-7: vertical centering
    char ORIGIN_Y;
    /// Number of Screen Columns
    ///   bits 0-6: Number of columns
    ///   bit 7: Upper bit of video matrix address (also controls address of COLOR RAM)
    char MATRIX_COLUMNS;
    ///   Number of Screen Rows
    ///   bit 0: select 0) 8x8 chars or 1) 16x8 chars
    ///   bits 1-6: Number of rows
    ///   bit 7: Current TV raster mean line bit 0.
    char MATRIX_ROWS;
    ///   The Raster Line
    ///   bits 0-7: Current TV raster beam line (bit 8-1)
    char RASTER;
    /// Character and Screen Address
    ///   bits 0-3: start of character memory (default 0)
    ///             ROM: 0000: 0x8000, 0001: 0x8400, 0010: 0x8800, 0011: 0x8c00
    ///             RAM: 1000: 0x0000, 1001: unavail, 1010: unavail, 1011: unavail
    ///             RAM: 1100: 0x1000, 1101: 0x1400, 1110: 0x1800, 1111: 0x1c00
    ///   bits 4-7: is rest of video matrix address (default F)
    char MEMORY;
    /// Lightpen X position
    /// bits 0-7: horizontal position of light pen
    char LIGHTPEN_X;
    /// Lightpen Y position
    /// bits 0-7: vertical position of light pen
    char LIGHTPEN_Y;
    /// Paddle X position
    /// bit 0-7: Digitized value of paddle X
    char PADDLE_X;
    /// Paddle Y position
    /// bit 0-7: Digitized value oi paddle Y
    char PADDLE_Y;
    /// Sound Voice 1 (low) frequency
    /// Frequency for oscillator 1 (low) (on: 128-255)
    char CH1_FREQ;
    /// Sound Voice 2 (medium) frequency
    /// Frequency for oscillator 1 (medium) (on: 128-255)
    char CH2_FREQ;
    /// Sound Voice 3 (high) frequency
    /// Frequency for oscillator 1 (high) (on: 128-255)
    char CH3_FREQ;
    /// Sound Voice 4 (noise) frequency
    /// Frequency of noise source
    char CH4_FREQ;
    /// Sound Volume and auxiliary color information
    ///   bit 0-3: sets volume of all sound
    ///   bits 4-7: are auxiliary color information
    char VOLUME_COLOR;
    /// Screen and border color register
    ///   bits 4-7: background color
    ///   bit 3: inverted or normal mode
    ///   bits 0-2: border color
    char BORDER_BACKGROUND_COLOR;
};