----------------------------------------------------------------------
-- Module name:     MEM0002a.VHD
--
-- Description:     An 8 X 32-bit FASM compatible RAM.  This RAM is
--                  useful when creating generic test benches.  For
--                  more information, please refer to the WISHBONE
--                  Public Domain Library Technical Reference Manual.
--
-- History:         Project complete:           SEP 18, 2001
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
-- Entity declaration.
----------------------------------------------------------------------

entity MEM0002a is
    port (
            ACK_O:  out std_logic;
            ADR_I:  in  std_logic_vector(  2 downto 0 );
            CLK_I:  in  std_logic;
            DAT_I:  in  std_logic_vector( 31 downto 0 );
            DAT_O:  out std_logic_vector( 31 downto 0 );
            STB_I:  in  std_logic;
            WE_I:   in  std_logic
        );

end entity MEM0002a;


----------------------------------------------------------------------
-- Architecture definition.
----------------------------------------------------------------------

architecture MEM0002a1 of MEM0002a IS

    ------------------------------------------------------------------
    -- Local signals.
    ------------------------------------------------------------------

    signal      LDAT_O: std_logic_vector( 31 downto 0 );
    signal      LE:     std_logic;
    signal      Q0:     std_logic_vector( 31 downto 0 );
    signal      Q1:     std_logic_vector( 31 downto 0 );
    signal      Q2:     std_logic_vector( 31 downto 0 );
    signal      Q3:     std_logic_vector( 31 downto 0 );
    signal      Q4:     std_logic_vector( 31 downto 0 );
    signal      Q5:     std_logic_vector( 31 downto 0 );
    signal      Q6:     std_logic_vector( 31 downto 0 );
    signal      Q7:     std_logic_vector( 31 downto 0 );
    signal      WE0:    std_logic;
    signal      WE1:    std_logic;
    signal      WE2:    std_logic;
    signal      WE3:    std_logic;
    signal      WE4:    std_logic;
    signal      WE5:    std_logic;
    signal      WE6:    std_logic;
    signal      WE7:    std_logic;


begin

    ------------------------------------------------------------------
    -- Create a write enable line for each register.
    ------------------------------------------------------------------

    WE_ENCODE: process( ADR_I, LE, STB_I, WE_I )
    begin

        LE  <= WE_I and STB_I;

        WE7 <= LE and     ADR_I(2)  and     ADR_I(1)  and     ADR_I(0) ;
        WE6 <= LE and     ADR_I(2)  and     ADR_I(1)  and not(ADR_I(0));
        WE5 <= LE and     ADR_I(2)  and not(ADR_I(1)) and     ADR_I(0) ;
        WE4 <= LE and     ADR_I(2)  and not(ADR_I(1)) and not(ADR_I(0));
        WE3 <= LE and not(ADR_I(2)) and     ADR_I(1)  and     ADR_I(0) ;
        WE2 <= LE and not(ADR_I(2)) and     ADR_I(1)  and not(ADR_I(0));
        WE1 <= LE and not(ADR_I(2)) and not(ADR_I(1)) and     ADR_I(0) ;
        WE0 <= LE and not(ADR_I(2)) and not(ADR_I(1)) and not(ADR_I(0));

    end process WE_ENCODE;


    ------------------------------------------------------------------
    -- Create 8 registers.
    ------------------------------------------------------------------

    REGS: process( CLK_I )
    begin                                     

        if( rising_edge( CLK_I ) ) then if( WE7 = '1' ) then Q7 <= DAT_I; end if; end if;
        if( rising_edge( CLK_I ) ) then if( WE6 = '1' ) then Q6 <= DAT_I; end if; end if;
        if( rising_edge( CLK_I ) ) then if( WE5 = '1' ) then Q5 <= DAT_I; end if; end if;
        if( rising_edge( CLK_I ) ) then if( WE4 = '1' ) then Q4 <= DAT_I; end if; end if;
        if( rising_edge( CLK_I ) ) then if( WE3 = '1' ) then Q3 <= DAT_I; end if; end if;
        if( rising_edge( CLK_I ) ) then if( WE2 = '1' ) then Q2 <= DAT_I; end if; end if;
        if( rising_edge( CLK_I ) ) then if( WE1 = '1' ) then Q1 <= DAT_I; end if; end if;
        if( rising_edge( CLK_I ) ) then if( WE0 = '1' ) then Q0 <= DAT_I; end if; end if;

    end process REGS;


    ------------------------------------------------------------------
    -- Multiplex the register outputs.
    ------------------------------------------------------------------

    MUX_OUT: process( ADR_I, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7 )
    begin

        case ADR_I is

            when B"000" => LDAT_O <= Q0;
            when B"001" => LDAT_O <= Q1;
            when B"010" => LDAT_O <= Q2;
            when B"011" => LDAT_O <= Q3;
            when B"100" => LDAT_O <= Q4;
            when B"101" => LDAT_O <= Q5;
            when B"110" => LDAT_O <= Q6;
            when others => LDAT_O <= Q7;

        end case;

    end process MUX_OUT;


    ------------------------------------------------------------------
    -- Make local signals visible outside of the entity.  Also
    -- generate the acknowledge signal.  Since this memory operates
    -- at zero wait-states, we can tie [STB_I] back to [ACK_O].
    ------------------------------------------------------------------

    MAKE_VISIBLE: process( LDAT_O, STB_I )
    begin

        DAT_O <= LDAT_O;
        ACK_O <= STB_I;

    end process MAKE_VISIBLE;


end architecture MEM0002a1;
