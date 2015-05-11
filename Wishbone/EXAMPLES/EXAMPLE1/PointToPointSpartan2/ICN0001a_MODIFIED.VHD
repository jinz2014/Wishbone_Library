----------------------------------------------------------------------
-- Module name:     ICN0001a.VHD (MODIFIED - SEP 21, 2001)
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
-- Entity declaration.  This is the ICN0001a point-to-point inter-
-- connection.
----------------------------------------------------------------------

entity ICN0001a is
    port (
            -- External (non-WISHBONE) inputs

            EXTCLK:    in   std_logic;
            -- EXTTST:    in   std_logic;  -- MODIFIED: THIS BIT NOT NEEDED AND REMOVED


            -- External signals for simulation purposes

            EACK:       out std_logic;
            EADR:       out std_logic_vector(  2 downto 0 );
            EDRD:       out std_logic_vector( 31 downto 0 );
            EDWR:       out std_logic_vector( 31 downto 0 );
            ESTB:       out std_logic;
            EWE:        out std_logic
        );

end entity ICN0001a;


----------------------------------------------------------------------
-- Architecture definition.
----------------------------------------------------------------------

architecture ICN0001a1 of ICN0001a is


    ------------------------------------------------------------------
    -- Define the SYSCON interface as a SYC0001a.  This generates
    -- the system clock and reset signals.
    ------------------------------------------------------------------

    component SYC0001a
    port(
            -- WISHBONE Interface

            CLK_O:  out std_logic;
            RST_O:  out std_logic;


            -- NON-WISHBONE Signals

            EXTCLK: in  std_logic;
            EXTTST: in  std_logic
         );
    end component SYC0001a;


    ------------------------------------------------------------------
    -- Define the MASTER interface as a DMA0001a.  This is a simple
    -- 32-bit DMA that is used for test purposes.
    ------------------------------------------------------------------

    component DMA0001a
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

            DMODE:  in  std_logic;
            IA:     in  std_logic_vector(  4 downto 3 );
            ID:     in  std_logic_vector( 31 downto 0 )
         );
    end component DMA0001a;


    ------------------------------------------------------------------
    -- Define the SLAVE interface as a MEM0002a.  This is a generic,
    -- register based, 8 x 32-bit RAM memory.
    ------------------------------------------------------------------
    -- NOTE: MEM0002a WAS CHANGED TO MEM0001a TO SUPPORT SYNTHESIS
    -- ON A XILINX SPARTAN 2 FPGA.
    ------------------------------------------------------------------

    component MEM0001a
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
    end component MEM0001a;


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

    U00: component SYC0001a
    port map(
                CLK_O   =>  CLK,
                RST_O   =>  RST,
                EXTCLK  =>  EXTCLK,
                EXTTST  =>  '0'
         );


    U01: component DMA0001a
    port map(
                ACK_I   =>  ACK,
                ADR_O   =>  ADR,
                CLK_I   =>  CLK,
                DAT_I   =>  DRD,
                DAT_O   =>  DWR,
                RST_I   =>  RST,
                STB_O   =>  STB,
                WE_O    =>  WE,
                DMODE   =>  '1',
                IA      =>  B"00",
                ID      =>  X"01234567"
         );


    U02: component MEM0001a
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

end architecture ICN0001a1;

