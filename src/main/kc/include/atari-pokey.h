/// @file
/// ATARI Graphic Television Interface Adaptor (GTIA)
///
/// Used in Atari 5200 and the 8-bit series (400, 800, XL, XE)
/// https://en.wikipedia.org/wiki/CTIA_and_GTIA

/// ATARI Graphic Television Interface Adaptor (GTIA)
struct ATARI_POKEY_READ {
    /// Potentiometer (Paddle) 0	Read	$D200	53760	PADDL0	$0270	624
    char POT0;
    /// Potentiometer (Paddle) 1	Read	$D201	53761	PADDL1	$0271	625
    char POT1;
    /// Potentiometer (Paddle) 2	Read	$D202	53762	PADDL2	$0272	626
    char POT2;
    /// Potentiometer (Paddle) 3	Read	$D203	53763	PADDL3	$0273	627
    char POT3;
    /// Potentiometer (Paddle) 4	Read	$D204	53764	PADDL4	$0274	628
    char POT4;
    /// Potentiometer (Paddle) 5	Read	$D205	53765	PADDL5	$0275	629
    char POT5;
    /// Potentiometer (Paddle) 6	Read	$D206	53766	PADDL6	$0276	630
    char POT6;
    /// Potentiometer (Paddle) 7	Read	$D207	53767	PADDL7	$0277	631
    char POT7;
    /// Read 8 Line POT Port State	Read	$D208	53768
    char ALLPOT;
    /// Keyboard Code	Read	$D209	53769	CH	$02FC	764
    char KBCODE;
    /// Random Number Generator	Read	$D20A	53770
    char RANDOM;
    /// Unused read registers $D20B-C
    char UNUSED[2];
    /// Serial Port Data Input	Read	$D20D	53773
    char SERIN;
    /// IRQ Status	Read	$D20E	53774
    char IRQST;
    /// Serial Port Status	Read	$D20F	53775
    char SKSTAT;
};

/// ATARI Graphic Television Interface Adaptor (GTIA)
struct ATARI_POKEY_WRITE {
    /// Audio Channel 1 Frequency	Write	$D200	53760
    char AUDF1;
    /// Audio Channel 1 Control	Write	$D201	53761
    char AUDC1;
    /// Audio Channel 2 Frequency	Write	$D202	53762
    char AUDF2;
    /// Audio Channel 2 Control	Write	$D203	53763
    char AUDC2;
    /// Audio Channel 3 Frequency	Write	$D204	53764
    char AUDF3;
    /// Audio Channel 3 Control	Write	$D205	53765
    char AUDC3;
    /// Audio Channel 4 Frequency	Write	$D206	53766
    char AUDF4;
    /// Audio Channel 4 Control	Write	$D207	53767
    char AUDC4;
    /// Audio Control	Write	$D208	53768
    char AUDCTL;
    /// Start Timers	Write	$D209	53769
    char STIMER;
    /// Reset Serial Status (SKSTAT)	Write	$D20A	53770
    char SKREST;
    /// Start POT Scan Sequence	Write	$D20B	53771
    char POTGO;
    /// Unused write register $D20C
    char UNUSED;
    /// Serial Port Data Output	Write	$D20D	53773
    char SEROUT;
    /// Interrupt Request Enable	Write	$D20E	53774	POKMSK	$10	16
    char IRQEN;
    /// Serial Port Control	Write	$D20F	53775	SSKCTL	$0232	562
    char SKCTL;
};
