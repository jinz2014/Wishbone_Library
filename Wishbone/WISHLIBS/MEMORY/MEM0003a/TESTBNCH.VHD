----------------------------------------------------------------------
-- Module name:     TESTBNCH.VHD
--
-- Description:     Test bench for MEM0003a.
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

entity TESTBNCH is
end TESTBNCH;


----------------------------------------------------------------------
-- Architecture definition.
----------------------------------------------------------------------

architecture TESTBNCH1 of TESTBNCH is


    ------------------------------------------------------------------
    -- Define the module under test as a component.
    ------------------------------------------------------------------

    component MEM0003a
    port(
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
    -- Define some local signals to assign values and observe.
    ------------------------------------------------------------------

    signal  ACK_O:      std_logic;
    signal  ADR_I:      std_logic_vector(  2 downto 0 );
    signal  CLK_I:      std_logic;
    signal  DAT_I:      std_logic_vector( 31 downto 0 );
    signal  DAT_O:      std_logic_vector( 31 downto 0 );
    signal  STB_I:      std_logic;
    signal  WE_I:       std_logic;


begin

    ------------------------------------------------------------------
    -- Port map for the device under test.
    ------------------------------------------------------------------

    TBENCH: MEM0003a
    port map(
                ACK_O   =>  ACK_O,
                ADR_I   =>  ADR_I,
                CLK_I   =>  CLK_I,
                DAT_I   =>  DAT_I,
                DAT_O   =>  DAT_O,
                STB_I   =>  STB_I,
                WE_I    =>  WE_I
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
        -- Initialize all of the inputs.  Generate a single clock
        -- pulse, and verify that all of the outputs initialize.  The
        -- data out lines [DAT_O] are not checked because they are
        -- not defined yet.
        --------------------------------------------------------------

        ADR_I   <= B"000";
        CLK_I   <= '0';
        DAT_I   <= X"00000000";
        STB_I   <= '0';
        WE_I    <= '0';
        wait for (PERIOD / 2);
        CLK_I   <= '1';
        wait for (PERIOD / 4);
        assert( ACK_O = '0'          )  report "ACK_O FAILS ON RESET." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I   <= '0';


        --------------------------------------------------------------
        -- Preset all of the memory locations to zero.  Verify the
        -- results.
        --------------------------------------------------------------

        wait for (PERIOD / 4);      -- Register 0
        ADR_I <= B"000";
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 4);
        assert( ACK_O = '1'         )  report "ACK_O INITIALIZATION ERROR." severity ERROR;
        assert( DAT_O = X"00000000" )  report "REG 0 INITIALIZATION ERROR." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I <= '0';

        wait for (PERIOD / 4);      -- Register 1
        ADR_I <= B"001";
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 4);
        assert( ACK_O = '1'         )  report "ACK_O INITIALIZATION ERROR." severity ERROR;
        assert( DAT_O = X"00000000" )  report "REG 1 INITIALIZATION ERROR." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I <= '0';

        wait for (PERIOD / 4);      -- Register 2
        ADR_I <= B"010";
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 4);
        assert( ACK_O = '1'         )  report "ACK_O INITIALIZATION ERROR." severity ERROR;
        assert( DAT_O = X"00000000" )  report "REG 2 INITIALIZATION ERROR." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I <= '0';

        wait for (PERIOD / 4);      -- Register 3
        ADR_I <= B"011";
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 4);
        assert( ACK_O = '1'         )  report "ACK_O INITIALIZATION ERROR." severity ERROR;
        assert( DAT_O = X"00000000" )  report "REG 3 INITIALIZATION ERROR." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I <= '0';

        wait for (PERIOD / 4);      -- Register 4
        ADR_I <= B"100";
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 4);
        assert( ACK_O = '1'         )  report "ACK_O INITIALIZATION ERROR." severity ERROR;
        assert( DAT_O = X"00000000" )  report "REG 4 INITIALIZATION ERROR." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I <= '0';

        wait for (PERIOD / 4);      -- Register 5
        ADR_I <= B"101";
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 4);
        assert( ACK_O = '1'         )  report "ACK_O INITIALIZATION ERROR." severity ERROR;
        assert( DAT_O = X"00000000" )  report "REG 5 INITIALIZATION ERROR." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I <= '0';

        wait for (PERIOD / 4);      -- Register 6
        ADR_I <= B"110";
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 4);
        assert( ACK_O = '1'         )  report "ACK_O INITIALIZATION ERROR." severity ERROR;
        assert( DAT_O = X"00000000" )  report "REG 6 INITIALIZATION ERROR." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I <= '0';

        wait for (PERIOD / 4);      -- Register 7
        ADR_I <= B"111";
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 4);
        assert( ACK_O = '1'         )  report "ACK_O INITIALIZATION ERROR." severity ERROR;
        assert( DAT_O = X"00000000" )  report "REG 7 INITIALIZATION ERROR." severity ERROR;
        wait for (PERIOD / 4);
        CLK_I <= '0';


        --------------------------------------------------------------
        -- Verify that memory write operations can't take place
        -- if either [STB_I] or [WE_I] are negated.
        --------------------------------------------------------------

        wait for (PERIOD / 4);      -- Test [STB_I]
        ADR_I <= B"000";
        DAT_I <= X"01234567";
        STB_I <= '0';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=0 ADDR_I=000 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"001";
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=0 ADDR_I=001 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"010";
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=0 ADDR_I=010 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"011";
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=0 ADDR_I=011 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"100";
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=0 ADDR_I=100 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"101";
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=0 ADDR_I=101 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"110";
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=0 ADDR_I=110 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"111";
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=0 ADDR_I=111 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);
        CLK_I <= '0';

        wait for (PERIOD / 4);      -- Test [WE_I]
        ADR_I <= B"000";
        DAT_I <= X"01234567";
        STB_I <= '1';
        WE_I  <= '0';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=0 ADDR_I=000 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);                                    
        ADR_I <= B"001";                                           
        wait for (PERIOD / 32);                                    
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=0 ADDR_I=001 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);                                    
        ADR_I <= B"010";                                           
        wait for (PERIOD / 32);                                    
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=0 ADDR_I=010 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);                                   
        ADR_I <= B"011";                                          
        wait for (PERIOD / 32);                                   
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=0 ADDR_I=011 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);                                    
        ADR_I <= B"100";                                           
        wait for (PERIOD / 32);                                    
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=0 ADDR_I=100 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);                                    
        ADR_I <= B"101";                                           
        wait for (PERIOD / 32);                                    
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=0 ADDR_I=101 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);                                    
        ADR_I <= B"110";                                           
        wait for (PERIOD / 32);                                    
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=0 ADDR_I=110 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);                                    
        ADR_I <= B"111";                                           
        wait for (PERIOD / 32);                                    
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=0 ADDR_I=111 REG ERROR." severity ERROR;
        wait for (PERIOD / 32);
        CLK_I <= '0';


        --------------------------------------------------------------
        -- Verify that each memory location occupies a unique
        -- address.
        --------------------------------------------------------------

        wait for (PERIOD / 4);      -- Register 0
        ADR_I <= B"000";
        DAT_I <= X"01234567";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 32);
        assert( DAT_O = X"01234567" )  report "STB_I=1 WE_I=1 ADDR_I=000 REG0 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                   
        ------------------------------------------------------------------------------------------------
        -- For the Xilinx bram, ignore the errors of all the following errors if the check time (assert)
        -- is not PERIOD/32 after the rising edge of CLK_I
        ------------------------------------------------------------------------------------------------
        ADR_I <= B"001";                                          
        wait for (PERIOD / 32);                                   
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=001 REG0 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                   
        ADR_I <= B"010";                                          
        wait for (PERIOD / 32);                                   
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=010 REG0 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                  
        ADR_I <= B"011";                                         
        wait for (PERIOD / 32);                                  
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=011 REG0 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                   
        ADR_I <= B"100";                                          
        wait for (PERIOD / 32);                                   
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=100 REG0 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                   
        ADR_I <= B"101";                                          
        wait for (PERIOD / 32);                                   
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=101 REG0 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                   
        ADR_I <= B"110";                                          
        wait for (PERIOD / 32);                                   
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=110 REG0 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                   
        ADR_I <= B"111";                                          
        wait for (PERIOD / 32);                                   
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=111 REG0 ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"000";
        CLK_I <= '0';
        wait for (PERIOD / 4);
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 2);
        CLK_I <= '0';


        wait for (PERIOD / 4);      -- Register 1
        ADR_I <= B"001";
        DAT_I <= X"01234567";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 32);
        assert( DAT_O = X"01234567" )  report "STB_I=1 WE_I=1 ADDR_I=001 REG1 ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"000";
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=000 REG1 ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"010";
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=010 REG1 ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"011";
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=011 REG1 ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"100";
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=100 REG1 ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"101";
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=101 REG1 ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"110";
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=110 REG1 ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"111";
        wait for (PERIOD / 32);
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=111 REG1 ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"001";
        CLK_I <= '0';
        wait for (PERIOD / 4);
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 2);
        CLK_I <= '0';


        wait for (PERIOD / 4);      -- Register 2
        ADR_I <= B"010";
        DAT_I <= X"01234567";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 32);
        assert( DAT_O = X"01234567" )  report "STB_I=1 WE_I=1 ADDR_I=010 REG2 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                          
        ADR_I <= B"000";                                                 
        wait for (PERIOD / 32);                                          
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=000 REG2 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                          
        ADR_I <= B"001";                                                 
        wait for (PERIOD / 32);                                          
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=001 REG2 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                          
        ADR_I <= B"011";                                                 
        wait for (PERIOD / 32);                                          
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=011 REG2 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                          
        ADR_I <= B"100";                                                 
        wait for (PERIOD / 32);                                          
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=100 REG2 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                          
        ADR_I <= B"101";                                                 
        wait for (PERIOD / 32);                                          
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=101 REG2 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                          
        ADR_I <= B"110";                                                 
        wait for (PERIOD / 32);                                          
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=110 REG2 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                          
        ADR_I <= B"111";                                                 
        wait for (PERIOD / 32);                                          
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=111 REG2 ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"010";
        CLK_I <= '0';
        wait for (PERIOD / 4);
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 2);
        CLK_I <= '0';


        wait for (PERIOD / 4);      -- Register 3
        ADR_I <= B"011";
        DAT_I <= X"01234567";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 32);
        assert( DAT_O = X"01234567" )  report "STB_I=1 WE_I=1 ADDR_I=011 REG3 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"000";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=000 REG3 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"001";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=001 REG3 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"010";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=010 REG3 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"100";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=100 REG3 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"101";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=101 REG3 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"110";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=110 REG3 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"111";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=111 REG3 ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"011";
        CLK_I <= '0';
        wait for (PERIOD / 4);
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 2);
        CLK_I <= '0';


        wait for (PERIOD / 4);      -- Register 4
        ADR_I <= B"100";
        DAT_I <= X"01234567";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 32);
        assert( DAT_O = X"01234567" )  report "STB_I=1 WE_I=1 ADDR_I=100 REG4 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"000";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=000 REG4 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"001";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=001 REG4 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"010";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=010 REG4 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"011";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=011 REG4 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"101";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=101 REG4 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"110";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=110 REG4 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"111";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=111 REG4 ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"100";
        CLK_I <= '0';
        wait for (PERIOD / 4);
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 2);
        CLK_I <= '0';


        wait for (PERIOD / 4);      -- Register 5
        ADR_I <= B"101";
        DAT_I <= X"01234567";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 32);
        assert( DAT_O = X"01234567" )  report "STB_I=1 WE_I=1 ADDR_I=101 REG5 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"000";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=000 REG5 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"001";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=001 REG5 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"010";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=010 REG5 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"011";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=011 REG5 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"100";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=100 REG5 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"110";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=110 REG5 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"111";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=111 REG5 ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"101";
        CLK_I <= '0';
        wait for (PERIOD / 4);
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 2);
        CLK_I <= '0';


        wait for (PERIOD / 4);      -- Register 6
        ADR_I <= B"110";
        DAT_I <= X"01234567";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 32);
        assert( DAT_O = X"01234567" )  report "STB_I=1 WE_I=1 ADDR_I=110 REG6 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"000";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=000 REG6 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"001";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=001 REG6 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"010";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=010 REG6 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"011";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=011 REG6 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"100";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=100 REG6 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"101";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=101 REG6 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"111";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=111 REG6 ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"110";
        CLK_I <= '0';
        wait for (PERIOD / 4);
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 2);
        CLK_I <= '0';


        wait for (PERIOD / 4);      -- Register 7
        ADR_I <= B"111";
        DAT_I <= X"01234567";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 32);
        assert( DAT_O = X"01234567" )  report "STB_I=1 WE_I=1 ADDR_I=111 REG7 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"000";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=000 REG7 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"001";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=001 REG7 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"010";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=010 REG7 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"011";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=011 REG7 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"100";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=100 REG7 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"101";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=101 REG7 ERROR." severity ERROR;
        wait for (PERIOD / 32);                                               
        ADR_I <= B"110";                                                      
        wait for (PERIOD / 32);                                               
        assert( DAT_O = X"00000000" )  report "STB_I=1 WE_I=1 ADDR_I=110 REG7 ERROR." severity ERROR;
        wait for (PERIOD / 32);
        ADR_I <= B"111";
        CLK_I <= '0';
        wait for (PERIOD / 4);
        DAT_I <= X"00000000";
        STB_I <= '1';
        WE_I  <= '1';
        wait for (PERIOD / 4);
        CLK_I <= '1';
        wait for (PERIOD / 2);
        CLK_I <= '0';

        wait;
        
    end process TEST_PROCESS;

end architecture TESTBNCH1;

