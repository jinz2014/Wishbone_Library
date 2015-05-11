----------------------------------------------------------------------
-- Module name:     TESTBNCH.VHD
--
-- Description:     Test bench for DMA0001a.
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

entity TESTBNCH is
end TESTBNCH;


----------------------------------------------------------------------
-- Architecture definition.
----------------------------------------------------------------------

architecture TESTBNCH1 of TESTBNCH is


    ------------------------------------------------------------------
    -- Define the module under test as a component.
    ------------------------------------------------------------------

    component DMA0001a
    port(
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
            DMODE:  in  std_logic;
            IA:     in  std_logic_vector(  4 downto 3 );
            ID:     in  std_logic_vector( 31 downto 0 )
         );

    end component DMA0001a;

    component DMA0001b
    port(
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
            DMODE:  in  std_logic;
            IA:     in  std_logic_vector(  4 downto 3 );
            ID:     in  std_logic_vector( 31 downto 0 )
         );

    end component DMA0001b;


    ------------------------------------------------------------------
    -- Define some local signals to assign values and observe.
    ------------------------------------------------------------------

    signal  ACK_I:  std_logic;
    signal  ADR_O:  std_logic_vector( 4  downto 0 );
    signal  CLK_I:  std_logic;
    signal  CYC_O:  std_logic;
    signal  DAT_I:  std_logic_vector( 31 downto 0 );
    signal  DAT_O:  std_logic_vector( 31 downto 0 );
    signal  RST_I:  std_logic;
    signal  SEL_O:  std_logic;
    signal  STB_O:  std_logic;
    signal  WE_O:   std_logic;
    signal  DMODE:  std_logic;
    signal  IA:     std_logic_vector(  4 downto 3 );
    signal  ID:     std_logic_vector( 31 downto 0 );

    -- Verilog DUT
    signal  ADR_O_vlog:  std_logic_vector( 4  downto 0 );
    signal  CYC_O_vlog:  std_logic;
    signal  DAT_O_vlog:  std_logic_vector( 31 downto 0 );
    signal  SEL_O_vlog:  std_logic;
    signal  STB_O_vlog:  std_logic;
    signal  WE_O_vlog:   std_logic;

begin

    ------------------------------------------------------------------
    -- Port map for the device under test.
    ------------------------------------------------------------------

    TBENCH_VHDL: DMA0001a
    port map(
                ACK_I   =>  ACK_I,
                ADR_O   =>  ADR_O,
                CLK_I   =>  CLK_I,
                CYC_O   =>  CYC_O,
                DAT_I   =>  DAT_I,
                DAT_O   =>  DAT_O,
                RST_I   =>  RST_I,
                SEL_O   =>  SEL_O,
                STB_O   =>  STB_O,
                WE_O    =>  WE_O,
                DMODE   =>  DMODE,
                IA      =>  IA,
                ID      =>  ID
            );

    TBENCH_VLOG: DMA0001b
    port map(
                ACK_I   =>  ACK_I,
                ADR_O   =>  ADR_O_vlog,
                CLK_I   =>  CLK_I,
                CYC_O   =>  CYC_O_vlog,
                DAT_I   =>  DAT_I,
                DAT_O   =>  DAT_O_vlog,
                RST_I   =>  RST_I,
                SEL_O   =>  SEL_O_vlog,
                STB_O   =>  STB_O_vlog,
                WE_O    =>  WE_O_vlog,
                DMODE   =>  DMODE,
                IA      =>  IA,
                ID      =>  ID
            );


    ------------------------------------------------------------------
    -- Test process.
    ------------------------------------------------------------------

    TEST_PROCESS: process

        --------------------------------------------------------------
        -- Specify the time duration for constant PERIOD.  This value
        -- is used only as a convienience for the simulation.  The
        -- actual value will be determined by the ASIC/FPGA router.
        --------------------------------------------------------------

        constant PERIOD: time := 100 ns;


    begin

        --------------------------------------------------------------
        -- Initialize all of the inputs.  Assert the reset input.
        -- Generate a single clock pulse, and verify that all of the
        -- outputs initialize.  
        --------------------------------------------------------------

        ACK_I   <= '0';
        CLK_I   <= '0';
        DAT_I   <= X"00000000";
        RST_I   <= '1';
        DMODE   <= '0';
        IA      <= B"00";
        ID      <= X"01234567";
        wait for (PERIOD / 2);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00000" )  report "ADR_O FAILS ON RESET." severity ERROR;
        assert( CYC_O = '0'      )  report "CYC_O FAILS ON RESET." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILS ON RESET." severity ERROR;
        assert( STB_O = '0'      )  report "STB_O FAILS ON RESET." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILS ON RESET." severity ERROR;
        assert( SEL_O = '1'      )  report "SEL_O FAILS ON RESET." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';


        --------------------------------------------------------------
        -- Since DMODE was initialized to zero, we can expect a
        -- series of single, write and read cycles.  Verify that this
        -- happends.
        --------------------------------------------------------------

        wait for (PERIOD / 4);      -- CYCLE #0: SINGLE WRITE
        RST_I   <= '0';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00000" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- SLAVE ACKNOWLEDGE
        DAT_I   <= X"01234567";
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        ACK_I   <= '0';
        assert( CYC_O = '0'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '0'      )  report "STB_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #1: SINGLE READ
        RST_I   <= '0';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00001" )  report "ADR_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- SLAVE ACKNOWLEDGE
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        ACK_I   <= '0';
        assert( CYC_O = '0'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '0'      )  report "STB_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #2: SINGLE WRITE
        RST_I   <= '0';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00010" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"00000000"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- SLAVE ACKNOWLEDGE
        DAT_I   <= X"01234567";
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        ACK_I   <= '0';
        assert( CYC_O = '0'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '0'      )  report "STB_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #3: SINGLE READ
        RST_I   <= '0';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00011" )  report "ADR_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- SLAVE ACKNOWLEDGE
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        ACK_I   <= '0';
        assert( CYC_O = '0'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '0'      )  report "STB_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #4: SINGLE WRITE
        RST_I   <= '0';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00100" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- SLAVE ACKNOWLEDGE
        DAT_I   <= X"01234567";
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        ACK_I   <= '0';
        assert( CYC_O = '0'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '0'      )  report "STB_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #5: SINGLE READ
        RST_I   <= '0';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00101" )  report "ADR_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- SLAVE ACKNOWLEDGE
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        ACK_I   <= '0';
        assert( CYC_O = '0'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '0'      )  report "STB_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #6: SINGLE WRITE
        RST_I   <= '0';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00110" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- SLAVE ACKNOWLEDGE
        DAT_I   <= X"01234567";
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        ACK_I   <= '0';
        assert( CYC_O = '0'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '0'      )  report "STB_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #7: SINGLE READ
        RST_I   <= '0';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00111" )  report "ADR_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- SLAVE ACKNOWLEDGE
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        ACK_I   <= '0';
        assert( CYC_O = '0'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '0'      )  report "STB_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';


        --------------------------------------------------------------
        -- Verify that the 3-bit address counter rolls over.  Also
        -- Verify the operation of both the read and write cycles
        -- when the SLAVE inserts a wait state.
        --------------------------------------------------------------

        wait for (PERIOD / 4);      -- CYCLE #0: SINGLE WRITE
        RST_I   <= '0';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00000" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 2);      -- SLAVE INSERTS WAIT STATE
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00000" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- SLAVE ACKNOWLEDGE
        DAT_I   <= X"01234567";
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        ACK_I   <= '0';
        assert( CYC_O = '0'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '0'      )  report "STB_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #1: SINGLE READ
        RST_I   <= '0';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00001" )  report "ADR_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 2);      -- SLAVE INSERTS WAIT STATE
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00001" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- SLAVE ACKNOWLEDGE
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        ACK_I   <= '0';
        assert( CYC_O = '0'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '0'      )  report "STB_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';


        --------------------------------------------------------------
        -- Reset the DMA0001a again, and assert DMODE.
        --------------------------------------------------------------

        wait for (PERIOD / 4);
        RST_I   <= '1';
        DMODE   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 2);
        CLK_I   <= '0';


        --------------------------------------------------------------
        -- Since DMODE is asserted, we can expect the DMA0001a to
        -- produce eight phases on a BLOCK WRITE, followed by eight
        -- phases of a BLOCK READ.
        --------------------------------------------------------------

        wait for (PERIOD / 4);      -- CYCLE #0: BLOCK WRITE, PHASE #0
        RST_I   <= '0';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00000" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #0: BLOCK WRITE, PHASE #1
        DAT_I   <= X"01234567";
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00001" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #0: BLOCK WRITE, PHASE #2
        DAT_I   <= X"01234567";
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00010" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #0: BLOCK WRITE, PHASE #3
        DAT_I   <= X"01234567";
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00011" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #0: BLOCK WRITE, PHASE #4
        DAT_I   <= X"01234567";
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00100" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #0: BLOCK WRITE, PHASE #5
        DAT_I   <= X"01234567";
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00101" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- SLAVE INSERTS WAIT STATE
        ACK_I   <= '0';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00101" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- SLAVE INSERTS WAIT STATE
        ACK_I   <= '0';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00101" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #0: BLOCK WRITE, PHASE #6
        DAT_I   <= X"01234567";
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00110" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #0: BLOCK WRITE, PHASE #7
        DAT_I   <= X"01234567";
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00111" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 2);      -- RELEASE THE BUS (INTERCYCLE)
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        ACK_I   <= '0';
        assert( CYC_O = '0'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '0'      )  report "STB_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 2);      -- CYCLE #1: BLOCK READ, PHASE #0
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00000" )  report "ADR_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILURE." severity ERROR;
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 2);      -- CYCLE #1: BLOCK READ, PHASE #1
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00001" )  report "ADR_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILURE." severity ERROR;
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 2);      -- CYCLE #1: BLOCK READ, PHASE #2
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00010" )  report "ADR_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILURE." severity ERROR;
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 2);      -- CYCLE #1: BLOCK READ, PHASE #3
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00011" )  report "ADR_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILURE." severity ERROR;
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 2);      -- CYCLE #1: BLOCK READ, PHASE #4
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00100" )  report "ADR_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILURE." severity ERROR;
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 2);      -- CYCLE #1: BLOCK READ, PHASE #5
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00101" )  report "ADR_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILURE." severity ERROR;
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- SLAVE INSERTS WAIT STATE
        ACK_I   <= '0';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00101" )  report "ADR_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #1: BLOCK READ, PHASE #6
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00110" )  report "ADR_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILURE." severity ERROR;
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 2);      -- CYCLE #1: BLOCK READ, PHASE #7
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00111" )  report "ADR_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '0'      )  report "WE_O  FAILURE." severity ERROR;
        ACK_I   <= '1';
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 2);      -- RELEASE THE BUS (INTERCYCLE)
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        ACK_I   <= '0';
        assert( CYC_O = '0'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '0'      )  report "STB_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait for (PERIOD / 4);      -- CYCLE #2: BLOCK WRITE, PHASE #0
        RST_I   <= '0';
        wait for (PERIOD / 4);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ADR_O = B"00000" )  report "ADR_O FAILURE." severity ERROR;
        assert( DAT_O = X"01234567"  )  report "DAT_O FAILURE." severity ERROR;
        assert( CYC_O = '1'      )  report "CYC_O FAILURE." severity ERROR;
        assert( STB_O = '1'      )  report "STB_O FAILURE." severity ERROR;
        assert( WE_O  = '1'      )  report "WE_O  FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';

        wait;
        
    end process TEST_PROCESS;

end architecture TESTBNCH1;

