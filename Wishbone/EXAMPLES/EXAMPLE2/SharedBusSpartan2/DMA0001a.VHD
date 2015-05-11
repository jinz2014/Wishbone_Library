----------------------------------------------------------------------
-- Module name:     DMA0001a.VHD
--
-- Description:     A very simple 32-bit DMA unit.  For more infor-
--                  mation, please refer to the WISHBONE Public Domain
--                  Library Technical Reference Manual.
--
-- History:         Project complete:           SEP 19, 2001
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

entity DMA0001a is
    port(
            -- WISHBONE Signals

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


            -- NON-WISHBONE Signals

            DMODE:  in  std_logic;
            IA:     in  std_logic_vector(  4 downto 3 );
            ID:     in  std_logic_vector( 31 downto 0 )
         );

end DMA0001a;


----------------------------------------------------------------------
-- Architecture definition.
----------------------------------------------------------------------

architecture DMA0001a1 of DMA0001a IS

    signal      INC:    std_logic;
    signal      INP:    std_logic;
    signal      LADR_O: std_logic_vector(  4 downto 0 );
    signal      LBDAT:  std_logic_vector( 31 downto 0 );
    signal      LDAT_O: std_logic_vector( 31 downto 0 );
    signal      SAS:    std_logic;
    signal      TC:     std_logic;
    signal      WE:     std_logic;

begin

    ------------------------------------------------------------------
    -- ACNT (Address CouNTer)
    --
    -- Counter process.  This counter uses a 'discrete logic' impli-
    -- menation to make it portable.  [VHDL counters that use integers
    -- tend to be somewhat non-portable].
    --
    -- This counter design has been used in other projects, and
    -- represents a reasonable compromize between speed and complexity.
    ------------------------------------------------------------------

    ACNT: process( CLK_I )
    begin                                     

        if( rising_edge(CLK_I) ) then

            if( RST_I = '1' ) then
                LADR_O( 2 downto 0 ) <= B"000";

            elsif( INC = '1' ) then
    
                LADR_O(0) <= not(LADR_O(0));
    
                LADR_O(1) <= ( not(LADR_O(1)) and     LADR_O(0)  )
                          or (     LADR_O(1)  and not(LADR_O(0)) );
    
                LADR_O(2) <= ( not(LADR_O(2)) and     LADR_O(1)  and     LADR_O(0)  )
                          or (     LADR_O(2)  and not(LADR_O(1)) and not(LADR_O(0)) )
                          or (     LADR_O(2)  and not(LADR_O(1)) and     LADR_O(0)  )
                          or (     LADR_O(2)  and     LADR_O(1)  and not(LADR_O(0)) );
            else

                LADR_O( 2 downto 0 ) <= LADR_O( 2 downto 0 );

            end if;

        end if;

    end process ACNT;


    ------------------------------------------------------------------
    -- AREG (Address REGister)
    ------------------------------------------------------------------

    AREG: process( CLK_I )
    begin                                     

        if( rising_edge(CLK_I) ) then

            if( RST_I = '1' ) then
                LADR_O( 4 downto 3 ) <= IA( 4 downto 3 );
            else
                LADR_O( 4 downto 3 ) <= LADR_O( 4 downto 3 );
            end if;

        end if;

    end process AREG;


    ------------------------------------------------------------------
    -- CONTROL STATE MACHINE
    ------------------------------------------------------------------

    CONT_STATE_MACH: process( CLK_I )
    begin

        if( rising_edge(CLK_I) ) then

            SAS <= ( not(RST_I) and not(WE) and not(SAS)              )
                or ( not(RST_I) and     WE  and     SAS  and not(INP) )
                or ( not(RST_I) and     WE  and not(SAS)              )
                or ( not(RST_I) and not(WE) and     SAS  and not(INP) );

            WE  <= ( not(RST_I) and not(WE) and not(SAS) )
                or ( not(RST_I) and     WE  and     SAS  );

        end if;

    end process CONT_STATE_MACH;


    ------------------------------------------------------------------
    -- IDREG (Input Data REGister).
    ------------------------------------------------------------------

    IDREG: process(CLK_I)
    begin

        if( rising_edge( CLK_I ) ) then

            if( RST_I = '1' ) then
                LBDAT <= X"00000000";
            elsif( (INC and not(WE)) = '1' ) then
                LBDAT <= DAT_I;
            else
                LBDAT <= LBDAT;
            end if;

        end if;

    end process IDREG;


    ------------------------------------------------------------------
    -- INC gate.
    ------------------------------------------------------------------

    INC_GATE: process( ACK_I, SAS )
    begin

        INC <= ACK_I and SAS;

    end process INC_GATE;


    ------------------------------------------------------------------
    -- Make the outputs visible to the outside world.  Also connect
    -- up some of the miscellaneous signals.
    ------------------------------------------------------------------

    MAKE_VISIBLE: process( LADR_O, LDAT_O, SAS, WE )
    begin

        ADR_O <= LADR_O;
        CYC_O <= SAS;
        DAT_O <= LDAT_O;
        SEL_O <= '1';
        STB_O <= SAS;
        WE_O  <= WE;

    end process MAKE_VISIBLE;


    ------------------------------------------------------------------
    -- MODE CONTROL
    ------------------------------------------------------------------

    MODE_CONTROL: process( DMODE, INC, TC )
    begin

        INP <= ( not(DMODE) and INC )
            or (     DMODE  and TC  );

    end process MODE_CONTROL;


    ------------------------------------------------------------------
    -- ODREG (Output Data REGister).
    ------------------------------------------------------------------

    ODREG: process( CLK_I )
    begin

        if( rising_edge( CLK_I ) ) then

            if( RST_I = '1' ) then
                LDAT_O <= ID;
            elsif( (INC and not(WE)) = '1' ) then
                LDAT_O <= LBDAT;
            else
                LDAT_O <= LDAT_O;
            end if;

        end if;

    end process ODREG;


    ------------------------------------------------------------------
    -- Generate the terminal count (carry forward) logic from the
    -- counter.
    ------------------------------------------------------------------

    TERMINAL_COUNT: process( LADR_O )
    begin

        TC <= LADR_O(2) and LADR_O(1) and LADR_O(0);

    end process TERMINAL_COUNT;

end architecture DMA0001a1;
