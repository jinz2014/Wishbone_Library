----------------------------------------------------------------------
-- Module name:     MEM0001a.VHD
--
-- Description:     An 8 x 32-bit memory interface with a WISHBONE
--                  SLAVE interface for a Xilinx distributed,
--                  synchronous RAM.  For more information, please
--                  refer to the WISHBONE Public Domain Library
--                  Technical Reference Manual.
--
--
-- History:         Project complete:           SEP 13, 2001
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

entity MEM0001a is
    port (
            ACK_O:  out std_logic;
            ADR_I:  in  std_logic_vector(  2 downto 0 );
            CLK_I:  in  std_logic;
            DAT_I:  in  std_logic_vector( 31 downto 0 );
            DAT_O:  out std_logic_vector( 31 downto 0 );
            STB_I:  in  std_logic;
            WE_I:   in  std_logic
        );

end entity MEM0001a;


----------------------------------------------------------------------
-- Architecture definition.
----------------------------------------------------------------------

architecture MEM0001a1 of MEM0001a is


    ------------------------------------------------------------------
    -- Define the memory component.
    ------------------------------------------------------------------

  component ram08x32
	port (
	a: IN std_logic_VECTOR(3 downto 0);
	d: IN std_logic_VECTOR(31 downto 0);
	clk: IN std_logic;
	we: IN std_logic;
	spo: OUT std_logic_VECTOR(31 downto 0));
end component;

    ------------------------------------------------------------------
    -- Define internal signals.
    ------------------------------------------------------------------

    signal  LACK_O:     std_logic;
    signal  LADR:       std_logic_vector(  3 downto 0 );
    signal  LDAT_O:     std_logic_vector( 31 downto 0 );
    signal  WE:         std_logic;


begin

    ------------------------------------------------------------------
    -- Connect up the signals on the individual components.
    ------------------------------------------------------------------

    U00: component ram08x32
    port map(
                a       =>  LADR,
                clk     =>  CLK_I,
                d       =>  DAT_I,
                we      =>  WE,
                spo     =>  LDAT_O
            );


    ------------------------------------------------------------------
    -- Form the internal address bus for connection to the RAM.
    -- Xilinx doesn't support an 8 x 32-bit RAM...only a 16 x 32-bit
    -- RAM. This means that the most significant address bit must
    -- be set to zero.
    ------------------------------------------------------------------

    FORM_ADDRESS: process( ADR_I )
    begin

        LADR( 2 downto 0 ) <= ADR_I( 2 downto 0 );
        LADR( 3 ) <= '0';

    end process FORM_ADDRESS;


    ------------------------------------------------------------------
    -- Generate the write enable signal.
    ------------------------------------------------------------------

    WRITE_ENABLE: process( STB_I, WE_I )
    begin
            WE <= STB_I and WE_I;

    end process WRITE_ENABLE;


    ------------------------------------------------------------------
    -- Generate the [ACK_O] acknowledge signal.  Since these memories
    -- will operate at zero wait states, the [ACK_O] signal can be
    -- asserted whenever the [STB_I] signal is asserted.
    ------------------------------------------------------------------

    ACKNOWLEDGE: process( STB_I )
    begin

        LACK_O <= STB_I;

    end process ACKNOWLEDGE;


    ------------------------------------------------------------------
    -- Make some of the local signals visible outside of the entity.
    ------------------------------------------------------------------

    MAKE_VISIBLE: process( LACK_O, LDAT_O )
    begin
    
        ACK_O <= LACK_O;
        DAT_O <= LDAT_O;
    
    end process MAKE_VISIBLE;


end architecture MEM0001a1;

