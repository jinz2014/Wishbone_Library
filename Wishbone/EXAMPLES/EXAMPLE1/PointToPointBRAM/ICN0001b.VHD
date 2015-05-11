----------------------------------------------------------------------
-- Module name:     ICN0001b.VHD (MODIFIED - SEP 21, 2001)
--
-- Description:     WISHBONE point-to-point interconnection.  For
--                  more information, please refer to the WISHBONE
--                  Public Domain Library Technical Reference Manual.
--
-- History:         Project complete:           SEP 20, 2001
--                                              WD Peterson
--                                              Silicore Corporation
--
-- Release:         Notice is hereby given that this document is not
--                  copyrighted, and has been placed into the public
--                  domain.  It may be freely copied and distributed
--                  by any means.
--
-- Disclaimer:      In no event shall Silicore Corporation be liable
--                  for incidental, consequential, indirect or special
--                  damages resulting from the use of this file.  The
--                  user assumes all responsibility for its use.
--
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Load the IEEE 1164 library and make it visible.
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


----------------------------------------------------------------------
-- Entity declaration.  This is the ICN0001b point-to-point inter-
-- connection.
----------------------------------------------------------------------

entity ICN0001b is
    port (
            -- External (non-WISHBONE) inputs

            EXTCLK:    in   std_logic;
            EXTTST:    in   std_logic;


            -- External signals for simulation purposes

            EACK:       out std_logic;
            EADR:       out std_logic_vector(  2 downto 0 );
            EDRD:       out std_logic_vector( 31 downto 0 );
            EDWR:       out std_logic_vector( 31 downto 0 );
            ESTB:       out std_logic;
            EWE:        out std_logic
        );

end entity ICN0001b;


----------------------------------------------------------------------
-- Architecture definition.
----------------------------------------------------------------------

architecture ICN0001b1 of ICN0001b is


    ------------------------------------------------------------------
    -- Define the SYSCON interface as a SYC0001b.  This generates
    -- the system clock and reset signals.
    ------------------------------------------------------------------

    component SYC0001b
    port(
            -- WISHBONE Interface

            CLK_O:  out std_logic;
            RST_O:  out std_logic;


            -- NON-WISHBONE Signals

            EXTCLK: in  std_logic;
            EXTTST: in  std_logic
         );
    end component SYC0001b;


    ------------------------------------------------------------------
    -- Define the MASTER interface as a DMA0001b (verilog).  
    -- This is a simple 32-bit DMA that is used for test purposes.
    ------------------------------------------------------------------

    component DMA0001b
    port(
            -- WISHBONE Interface:

            ACK_I:  in  std_logic;
            ADR_O:  out std_logic_vector( 4  downto 0 );
            CLK_I:  in  std_logic;
            CYC_O:  out std_logic;
            DAT_I:  in  std_logic_vector( 31 downto 0 );
            DAT_O:  out std_logic_vector( 31 downto 0 );
            RST_I:  in  std_logic;
            SEL_O:  out std_logic;
            STB_O:  out std_logic;
            WE_O:   out std_logic;


            -- NON-WISHBONE Signals:

            IA:     in  std_logic_vector(  4 downto 3 );
            ID:     in  std_logic_vector( 31 downto 0 )
         );
    end component DMA0001b;


    ------------------------------------------------------------------
    -- Define the SLAVE interface as a MEM0003a.  This is a generic
    -- 8 x 32-bit Block RAM memory.
    ------------------------------------------------------------------

    component MEM0003a
    port(
            -- WISHBONE inteface:

            ACK_O:  out std_logic;
            ADR_I:  in  std_logic_vector(  2 downto 0 );
            CLK_I:  in  std_logic;
            DAT_I:  in  std_logic_vector( 31 downto 0 );
            DAT_O:  out std_logic_vector( 31 downto 0 );
            STB_I:  in  std_logic;
            WE_I:   in  std_logic
         );
    end component MEM0003a;


    ------------------------------------------------------------------
    -- Define internal signals.
    ------------------------------------------------------------------

    signal  ACK:        std_logic;
    signal  ADR:        std_logic_vector(  4 downto 0 );
    signal  CLK:        std_logic;
    signal  DRD:        std_logic_vector( 31 downto 0 );
    signal  DWR:        std_logic_vector( 31 downto 0 );
    signal  RST:        std_logic;
    signal  STB:        std_logic;
    signal  WE:         std_logic;


begin

    ------------------------------------------------------------------
    -- Connect up the signals on the individual components.
    ------------------------------------------------------------------
    -- NOTE: THE 'EXTTST' BIT IS NOT NEEDED, AND HAS BEEN TIED LOW.
    ------------------------------------------------------------------

    U00: component SYC0001b
    port map(
                CLK_O   =>  CLK,
                RST_O   =>  RST,
                EXTCLK  =>  EXTCLK,
                EXTTST  =>  EXTTST
         );


    U01: component DMA0001b
    port map(
                ACK_I   =>  ACK,
                ADR_O   =>  ADR,
                CLK_I   =>  CLK,
                DAT_I   =>  DRD,
                DAT_O   =>  DWR,
                RST_I   =>  RST,
                STB_O   =>  STB,
                WE_O    =>  WE,
                IA      =>  B"00",
                ID      =>  X"01234567"
         );


    U02: component MEM0003a
    port map(
                ACK_O   =>  ACK,
                ADR_I   =>  ADR( 2 downto 0 ),
                CLK_I   =>  CLK,
                DAT_I   =>  DWR,
                DAT_O   =>  DRD,
                STB_I   =>  STB,
                WE_I    =>  WE
         );


    ------------------------------------------------------------------
    -- Make selected internal signals visible for simulation.
    ------------------------------------------------------------------

    MAKE_VISIBLE: process( ACK, ADR, DRD, DWR, STB, WE )
    begin

        EACK    <=  ACK;
        EADR    <=  ADR( 2 downto 0 );
        EDRD    <=  DRD;
        EDWR    <=  DWR;
        ESTB    <=  STB;
        EWE     <=  WE;

    end process MAKE_VISIBLE;

end architecture ICN0001b1;

