----------------------------------------------------------------------
-- Module name:     ICN0002a.VHD
--
-- Description:     WISHBONE 4 X 4 shared bus interconnection.  For
--                  more information, please refer to the WISHBONE
--                  Public Domain Library Technical Reference Manual.
--
-- History:         Project complete:           SEP 20, 2001
--                                              WD Peterson
--                                              Silicore Corporation
--
--                  Fix minor typos:            10 JUN 2003
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
-- Entity declaration.  The input and output signals from the system
-- are declared here.
----------------------------------------------------------------------

entity ICN0002a is
    port (
            -- External (non-WISHBONE) inputs

            EXTCLK:    in   std_logic;
            EXTTST:    in   std_logic;


            -- External signals for simulation purposes

            EACK:       out std_logic;
            EADR:       out std_logic_vector(  4 downto 0 );
            ECYC:       out std_logic;
            EDRD:       out std_logic_vector( 31 downto 0 );
            EDWR:       out std_logic_vector( 31 downto 0 );
            EGNT:       out std_logic_vector(  1 downto 0 );
            ESTB:       out std_logic;
            EWE:        out std_logic
        );

end entity ICN0002a;



----------------------------------------------------------------------
-- Architecture definition.
----------------------------------------------------------------------

architecture ICN0002a1 of ICN0002a is


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
    -- Define the MASTER interfaces as type DMA0001a.  This is a
    -- simple 32-bit DMA that is used for test purposes.
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

    component MEM0002a
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
    end component MEM0002a;


    ------------------------------------------------------------------
    -- Define the Arbiter as an ARB0001a.  This is a four level
    -- round-robin arbiter.
    ------------------------------------------------------------------

    component ARB0001a
    port(
            CLK:        in  std_logic;
            COMCYC:     out std_logic;
            CYC3:       in  std_logic;
            CYC2:       in  std_logic;
            CYC1:       in  std_logic;
            CYC0:       in  std_logic;
            GNT:        out std_logic_vector( 1 downto 0 );
            GNT3:       out std_logic;
            GNT2:       out std_logic;
            GNT1:       out std_logic;
            GNT0:       out std_logic;
            RST:        in  std_logic
         );
    end component ARB0001a;


    ------------------------------------------------------------------
    -- Define internal signals.
    ------------------------------------------------------------------

    signal  ACK:        std_logic;
    signal  ACK_I_M0:   std_logic;
    signal  ACK_I_M1:   std_logic;
    signal  ACK_I_M2:   std_logic;
    signal  ACK_I_M3:   std_logic;
    signal  ACK_O_S0:   std_logic;
    signal  ACK_O_S1:   std_logic;
    signal  ACK_O_S2:   std_logic;
    signal  ACK_O_S3:   std_logic;
    signal  ACMP0:      std_logic;
    signal  ACMP1:      std_logic;
    signal  ACMP2:      std_logic;
    signal  ACMP3:      std_logic;
    signal  ADR:        std_logic_vector( 4 downto 0 );
    signal  ADR_O_M0:   std_logic_vector( 4 downto 0 );
    signal  ADR_O_M1:   std_logic_vector( 4 downto 0 );
    signal  ADR_O_M2:   std_logic_vector( 4 downto 0 );
    signal  ADR_O_M3:   std_logic_vector( 4 downto 0 );
    signal  CLK:        std_logic;
    signal  CYC:        std_logic;
    signal  CYC_O_M0:   std_logic;
    signal  CYC_O_M1:   std_logic;
    signal  CYC_O_M2:   std_logic;
    signal  CYC_O_M3:   std_logic;
    signal  DAT_O_M0:   std_logic_vector( 31 downto 0 );
    signal  DAT_O_M1:   std_logic_vector( 31 downto 0 );
    signal  DAT_O_M2:   std_logic_vector( 31 downto 0 );
    signal  DAT_O_M3:   std_logic_vector( 31 downto 0 );
    signal  DAT_O_S0:   std_logic_vector( 31 downto 0 );
    signal  DAT_O_S1:   std_logic_vector( 31 downto 0 );
    signal  DAT_O_S2:   std_logic_vector( 31 downto 0 );
    signal  DAT_O_S3:   std_logic_vector( 31 downto 0 );
    signal  DRD:        std_logic_vector( 31 downto 0 );
    signal  DWR:        std_logic_vector( 31 downto 0 );
    signal  GNT:        std_logic_vector(  1 downto 0 );
    signal  GNT0:       std_logic;
    signal  GNT1:       std_logic;
    signal  GNT2:       std_logic;
    signal  GNT3:       std_logic;
    signal  RST:        std_logic;
    signal  STB:        std_logic;
    signal  STB_I_S0:   std_logic;
    signal  STB_I_S1:   std_logic;
    signal  STB_I_S2:   std_logic;
    signal  STB_I_S3:   std_logic;
    signal  STB_O_M0:   std_logic;
    signal  STB_O_M1:   std_logic;
    signal  STB_O_M2:   std_logic;
    signal  STB_O_M3:   std_logic;
    signal  WE:         std_logic;
    signal  WE_O_M0:    std_logic;
    signal  WE_O_M1:    std_logic;
    signal  WE_O_M2:    std_logic;
    signal  WE_O_M3:    std_logic;


begin

    ------------------------------------------------------------------
    -- Connect up the signals on the individual MASTER and SLAVE
    -- components.  They are wired thusly:
    --
    --   DMA MASTER       DMA's TO     AT ADDRESSES        USING
    -- --------------  --------------  -------------  ----------------
    --  U00: DMA0001a  U04: SLAVE U04   0x00 - 0x07   BLOCK READ/WRITE
    --  U01: DMA0001a  U05: SLAVE U05   0x08 - 0x0F   BLOCK READ/WRITE
    --  U02: DMA0001a  U06: SLAVE U06   0x10 - 0x17   BLOCK READ/WRITE
    --  U03: DMA0001a  U07: SLAVE U07   0x18 - 0x1F   SNGLE READ/WRITE
    --
    ------------------------------------------------------------------

    U00: component DMA0001a
    port map(
                ACK_I   =>  ACK_I_M0,
                ADR_O   =>  ADR_O_M0,
                CLK_I   =>  CLK,
                CYC_O   =>  CYC_O_M0,
                DAT_I   =>  DRD,
                DAT_O   =>  DAT_O_M0,
                RST_I   =>  RST,
                STB_O   =>  STB_O_M0,
                WE_O    =>  WE_O_M0,
                DMODE   =>  '1',
                IA      =>  B"00",
                ID      =>  X"A5A5A5A0"
         );


    U01: component DMA0001a
    port map(
                ACK_I   =>  ACK_I_M1,
                ADR_O   =>  ADR_O_M1,
                CLK_I   =>  CLK,
                CYC_O   =>  CYC_O_M1,
                DAT_I   =>  DRD,
                DAT_O   =>  DAT_O_M1,
                RST_I   =>  RST,
                STB_O   =>  STB_O_M1,
                WE_O    =>  WE_O_M1,
                DMODE   =>  '1',
                IA      =>  B"01",
                ID      =>  X"A5A5A5A1"
         );


    U02: component DMA0001a
    port map(
                ACK_I   =>  ACK_I_M2,
                ADR_O   =>  ADR_O_M2,
                CLK_I   =>  CLK,
                CYC_O   =>  CYC_O_M2,
                DAT_I   =>  DRD,
                DAT_O   =>  DAT_O_M2,
                RST_I   =>  RST,
                STB_O   =>  STB_O_M2,
                WE_O    =>  WE_O_M2,
                DMODE   =>  '1',
                IA      =>  B"10",
                ID      =>  X"A5A5A5A2"
         );


    U03: component DMA0001a
    port map(
                ACK_I   =>  ACK_I_M3,
                ADR_O   =>  ADR_O_M3,
                CLK_I   =>  CLK,
                CYC_O   =>  CYC_O_M3,
                DAT_I   =>  DRD,
                DAT_O   =>  DAT_O_M3,
                RST_I   =>  RST,
                STB_O   =>  STB_O_M3,
                WE_O    =>  WE_O_M3,
                DMODE   =>  '0',
                IA      =>  B"11",
                ID      =>  X"A5A5A5A3"
         );


    U04: component MEM0002a
    port map(
                ACK_O   =>  ACK_O_S0,
                ADR_I   =>  ADR( 2 downto 0 ),
                CLK_I   =>  CLK,
                DAT_I   =>  DWR,
                DAT_O   =>  DAT_O_S0,
                STB_I   =>  STB_I_S0,
                WE_I    =>  WE
         );


    U05: component MEM0002a
    port map(
                ACK_O   =>  ACK_O_S1,
                ADR_I   =>  ADR( 2 downto 0 ),
                CLK_I   =>  CLK,
                DAT_I   =>  DWR,
                DAT_O   =>  DAT_O_S1,
                STB_I   =>  STB_I_S1,
                WE_I    =>  WE
         );


    U06: component MEM0002a
    port map(
                ACK_O   =>  ACK_O_S2,
                ADR_I   =>  ADR( 2 downto 0 ),
                CLK_I   =>  CLK,
                DAT_I   =>  DWR,
                DAT_O   =>  DAT_O_S2,
                STB_I   =>  STB_I_S2,
                WE_I    =>  WE
            );

    U07: component MEM0002a
    port map(
                ACK_O   =>  ACK_O_S3,
                ADR_I   =>  ADR( 2 downto 0 ),
                CLK_I   =>  CLK,
                DAT_I   =>  DWR,
                DAT_O   =>  DAT_O_S3,
                STB_I   =>  STB_I_S3,
                WE_I    =>  WE
            );

    U08: component ARB0001a
    port map(
                CLK     =>  CLK,
                COMCYC  =>  CYC,
                CYC3    =>  CYC_O_M3,
                CYC2    =>  CYC_O_M2,
                CYC1    =>  CYC_O_M1,
                CYC0    =>  CYC_O_M0,
                GNT     =>  GNT,
                GNT3    =>  GNT3,
                GNT2    =>  GNT2,
                GNT1    =>  GNT1,
                GNT0    =>  GNT0,
                RST     =>  RST
             );


    U09: component SYC0001a
    port map(
                CLK_O   =>  CLK,
                RST_O   =>  RST,
                EXTCLK  =>  EXTCLK,
                EXTTST  =>  EXTTST
         );


    ------------------------------------------------------------------
    -- Generate the address comparator and SLAVE decoders.
    ------------------------------------------------------------------

    ADR_CMP: process( ADR )
    begin

        ACMP3 <=      ADR(4)   and      ADR(3)  ;
        ACMP2 <=      ADR(4)   and not( ADR(3) );
        ACMP1 <= not( ADR(4) ) and      ADR(3)  ;
        ACMP0 <= not( ADR(4) ) and not( ADR(3) );

    end process ADR_CMP;


    ADR_DEC: process( ACMP3, ACMP2, ACMP1, ACMP0, CYC, STB )
    begin

        STB_I_S3 <= CYC and STB and ACMP3;
        STB_I_S2 <= CYC and STB and ACMP2;
        STB_I_S1 <= CYC and STB and ACMP1;
        STB_I_S0 <= CYC and STB and ACMP0;
        
    end process ADR_DEC;


    ------------------------------------------------------------------
    -- Generate the ACK signals.
    ------------------------------------------------------------------

    ACK_GEN: process( ACK_O_S3, ACK_O_S2, ACK_O_S1, ACK_O_S0 )
    begin

        ACK <= ACK_O_S3 or ACK_O_S2 or ACK_O_S1 or ACK_O_S0;
        
    end process ACK_GEN;


    ACK_RCV: process( ACK, GNT3, GNT2, GNT1, GNT0 )
    begin

        ACK_I_M3 <= ACK and GNT3;
        ACK_I_M2 <= ACK and GNT2;
        ACK_I_M1 <= ACK and GNT1;
        ACK_I_M0 <= ACK and GNT0;

    end process ACK_RCV;


    ------------------------------------------------------------------
    -- Create the signal multiplexors.
    ------------------------------------------------------------------

    ADR_MUX: process( ADR_O_M3, ADR_O_M2, ADR_O_M1, ADR_O_M0, GNT )
    begin                                     

        case GNT is
            when B"00" =>  ADR <= ADR_O_M0;
            when B"01" =>  ADR <= ADR_O_M1;
            when B"10" =>  ADR <= ADR_O_M2;
            when others => ADR <= ADR_O_M3;
        end case;

    end process ADR_MUX;


    DRD_MUX: process( DAT_O_S3, DAT_O_S2, DAT_O_S1, DAT_O_S0, ADR )
    begin                                     

        case ADR( 4 downto 3 ) is
            when B"00" =>  DRD <= DAT_O_S0;
            when B"01" =>  DRD <= DAT_O_S1;
            when B"10" =>  DRD <= DAT_O_S2;
            when others => DRD <= DAT_O_S3;
        end case;

    end process DRD_MUX;


    DWR_MUX: process( DAT_O_M3, DAT_O_M2, DAT_O_M1, DAT_O_M0, GNT )
    begin                                     

        case GNT is
            when B"00" =>  DWR <= DAT_O_M0;
            when B"01" =>  DWR <= DAT_O_M1;
            when B"10" =>  DWR <= DAT_O_M2;
            when others => DWR <= DAT_O_M3;
        end case;

    end process DWR_MUX;


    STB_MUX: process( STB_O_M3, STB_O_M2, STB_O_M1, STB_O_M0, GNT )
    begin                                     

        case GNT is
            when B"00" =>  STB <= STB_O_M0;
            when B"01" =>  STB <= STB_O_M1;
            when B"10" =>  STB <= STB_O_M2;
            when others => STB <= STB_O_M3;
        end case;

    end process STB_MUX;


    WE_MUX: process( WE_O_M3, WE_O_M2, WE_O_M1, WE_O_M0, GNT )
    begin                                     

        case GNT is
            when B"00" =>  WE <= WE_O_M0;
            when B"01" =>  WE <= WE_O_M1;
            when B"10" =>  WE <= WE_O_M2;
            when others => WE <= WE_O_M3;
        end case;

    end process WE_MUX;


    ------------------------------------------------------------------
    -- Generate selected internal signals visible for simulation.
    ------------------------------------------------------------------

    MAKE_VISIBLE: process( ACK, ADR, CYC, DRD, DWR, GNT, STB, WE )
    begin

        EACK    <=  ACK;
        EADR    <=  ADR;
        ECYC    <=  CYC;
        EDRD    <=  DRD;
        EDWR    <=  DWR;
        EGNT    <=  GNT;
        ESTB    <=  STB;
        EWE     <=  WE;

    end process MAKE_VISIBLE;

end architecture ICN0002a1;

