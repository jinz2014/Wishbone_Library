----------------------------------------------------------------------
-- Module name:     TESTBNCH.VHD
--
-- Description:     Test bench for SYC0001a.
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

    component SYC0001a
    port(
            CLK_O:  out std_logic;
            RST_O:  out std_logic;
            EXTCLK: in  std_logic;
            EXTTST: in  std_logic
         );

    end component SYC0001a;

    component SYC0001b
    port(
            CLK_O:  out std_logic;
            RST_O:  out std_logic;
            EXTCLK: in  std_logic;
            EXTTST: in  std_logic
         );

    end component SYC0001b;


    ------------------------------------------------------------------
    -- Define some local signals to assign values and observe.
    ------------------------------------------------------------------

    signal  CLK_O:  std_logic;
    signal  RST_O:  std_logic;
    signal  EXTCLK: std_logic;
    signal  EXTTST: std_logic;

    signal  CLK_O_vlog:  std_logic;
    signal  RST_O_vlog:  std_logic;

begin

    ------------------------------------------------------------------
    -- Port map for the device under test.
    ------------------------------------------------------------------

    TBENCH_VHDL: SYC0001a
    port map(
                CLK_O   =>  CLK_O,
                RST_O   =>  RST_O,
                EXTCLK  =>  EXTCLK,
                EXTTST  =>  EXTTST
            );

    TBENCH_VLOG: SYC0001b
    port map(
                CLK_O   =>  CLK_O_vlog,
                RST_O   =>  RST_O_vlog,
                EXTCLK  =>  EXTCLK,
                EXTTST  =>  EXTTST
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
        -- Initialize all of the inputs, including 'EXTTST'.  Generate
        -- a single clock pulse, and verify that everything initial-
        -- izes correctly.
        --------------------------------------------------------------

        EXTCLK  <= '0';
        EXTTST  <= '1';
        wait for (PERIOD / 2);
        EXTCLK  <= '1';
        wait for (PERIOD / 2);
        EXTCLK  <= '0';

        wait for (PERIOD / 4);
        EXTTST  <= '0';
        wait for (PERIOD / 4);
        EXTCLK  <= '1';
        wait for (PERIOD / 4);
        assert( CLK_O = '1' )  report "CLK_O FAILURE." severity ERROR;
        assert( RST_O = '1' )  report "RST_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        EXTCLK  <= '0';


        --------------------------------------------------------------
        -- Verify that the [CLK_O] and [RST_O] signals work correctly.
        --------------------------------------------------------------

        wait for (PERIOD / 4);
        assert( CLK_O = '0' )  report "CLK_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        EXTCLK  <= '1';
        wait for (PERIOD / 4);
        assert( CLK_O = '1' )  report "CLK_O FAILURE." severity ERROR;
        assert( RST_O = '0' )  report "RST_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        EXTCLK  <= '0';

        wait for (PERIOD / 2);
        EXTCLK  <= '1';
        wait for (PERIOD / 4);
        assert( RST_O = '0' )  report "RST_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        EXTCLK  <= '0';

        wait for (PERIOD / 2);
        EXTCLK  <= '1';
        wait for (PERIOD / 4);
        assert( RST_O = '0' )  report "RST_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        EXTCLK  <= '0';

        wait for (PERIOD / 2);
        EXTCLK  <= '1';
        wait for (PERIOD / 4);
        assert( RST_O = '0' )  report "RST_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        EXTCLK  <= '0';

        wait;
        
    end process TEST_PROCESS;

end architecture TESTBNCH1;

