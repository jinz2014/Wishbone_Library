----------------------------------------------------------------------
-- Module name:     TESTBNCH.VHD
--
-- Description:     Test bench for the ICN0002a entity.
--
-- History:         Project complete:           OCT 03, 2001
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
--                  damages resulting from the use of this file.
--                  The user assumes all responsibility for its use.
--
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Load the IEEE 1164 library and make it visible.
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;


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

    component ICN0002a
    port(
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

    end component ICN0002a;


    ------------------------------------------------------------------
    -- Define some local signals to assign values and observe.
    ------------------------------------------------------------------

    signal  EXTCLK:     std_logic;
    signal  EXTTST:     std_logic;
    signal  EACK:       std_logic;
    signal  EADR:       std_logic_vector(  4 downto 0 );
    signal  ECYC:       std_logic;
    signal  EDRD:       std_logic_vector( 31 downto 0 );
    signal  EDWR:       std_logic_vector( 31 downto 0 );
    signal  EGNT:       std_logic_vector(  1 downto 0 );
    signal  ESTB:       std_logic;
    signal  EWE:        std_logic;

begin

    ------------------------------------------------------------------
    -- Port map for the device under test.
    ------------------------------------------------------------------

    TBENCH: ICN0002a
    port map(
                EXTCLK  =>  EXTCLK,
                EXTTST  =>  EXTTST,
                EACK    =>  EACK,
                EADR    =>  EADR,
                ECYC    =>  ECYC,
                EDRD    =>  EDRD,
                EDWR    =>  EDWR,
                EGNT    =>  EGNT,
                ESTB    =>  ESTB,
                EWE     =>  EWE
            );


    ------------------------------------------------------------------
    -- Test process.
    ------------------------------------------------------------------

    TEST_PROCESS: process

        --------------------------------------------------------------
        -- Specify the test vector filename and other file parameters.
        --------------------------------------------------------------

        file tvfile:    text;
        variable L:     line;
        variable C:     character;


        --------------------------------------------------------------
        -- Specify the time duration for constant PERIOD.
        --------------------------------------------------------------

        constant PERIOD: time := 100 ns;


    begin

        --------------------------------------------------------------
        -- Open the file that contains the test vectors.
        --------------------------------------------------------------

        assert( false ) report "RUNNING TEST VECTORS FROM FILE TESTVECT.TXT" severity NOTE;
        file_open( tvfile, "TESTVECT.TXT", read_mode );


        --------------------------------------------------------------
        -- Initialize the system by asserting the 'EXTTST' signal.
        -- This forces the simulation into a power-up condition.
        -- During actual operation the circuit will automatically
        -- find this state.
        --------------------------------------------------------------

        EXTCLK <= '0';
        EXTTST <= '1';
        wait for (PERIOD / 2);
        EXTCLK <= '1';
        wait for (PERIOD / 4);
        EXTTST <= '0';
        wait for (PERIOD / 4);
        EXTCLK <= '0';

        wait for (PERIOD / 2);
        EXTCLK <= '1';
        wait for (PERIOD / 2);
        EXTCLK <= '0';


        --------------------------------------------------------------
        -- Read the test vectors from the file.  Loop through all of
        -- the test vectors and apply them to the entity.
        --
        -- The test vectors are organized so that this program
        -- reads the inputs and applies them to the entity.  When
        -- a rising clock edge is encountered ('R'), then a rising
        -- edge is applied to the clock line and the output are
        -- compared to the test vector.
        --------------------------------------------------------------

        READ_VECTORS: loop

            ----------------------------------------------------------
            -- If we're at the end of the file, then close the file
            -- and fall to the bottom of the loop.
            ----------------------------------------------------------

            if endfile( tvfile ) then
                file_close( tvfile );
                assert( false ) report "TEST VECTORS COMPLETE." severity NOTE;
                exit;
            end if;


            ----------------------------------------------------------
            -- Read the next line in the test vector file.
            ----------------------------------------------------------

            readline( tvfile, L );


            ----------------------------------------------------------
            -- Determine if the line is a test vector line or a
            -- comment (or empty) line.  Ignore the line if it's a
            -- comment or empty line.  The first character in a
            -- test vector line must be a colon (':').
            ----------------------------------------------------------

            read( L, C );               -- Read the first character

            if( C = ':' ) then

                ------------------------------------------------------
                -- Negate the clock line.
                ------------------------------------------------------

                EXTCLK    <= '0';
                wait for (PERIOD / 4);


                ------------------------------------------------------
                -- Read and apply the input test vectors.
                ------------------------------------------------------

                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;
                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;


                ------------------------------------------------------
                -- Configure the 'EXTCLK' input.
                ------------------------------------------------------

                wait for (PERIOD / 4);
                read( L, C );
                if( C = 'R' ) then
                    EXTCLK <= '1';
                else
                    assert( false ) report "ILLEGAL TEST VECTOR, INPUT: 'EXTCLK'." severity ERROR;
                end if;
                wait for (PERIOD / 4);

 
                ------------------------------------------------------
                -- Check the 'ECYC' output.
                ------------------------------------------------------

                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;

                read( L, C );
                if(    C = '0' ) then assert( EACK = '0' ) report "EACK ERROR." severity ERROR;
                elsif( C = '1' ) then assert( EACK = '1' ) report "EACK ERROR." severity ERROR;
                else                  assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EACK'." severity ERROR;
                end if;


                ------------------------------------------------------
                -- Check the 'EADR()' output.
                ------------------------------------------------------

                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;

                read( L, C );
                if(    C = '0' ) then assert( EADR(4) = '0' ) report "EADR() ERROR." severity ERROR;
                elsif( C = '1' ) then assert( EADR(4) = '1' ) report "EADR() ERROR." severity ERROR;
                else                  assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EADR()'." severity ERROR;
                end if;

                read( L, C );
                case C is
                    when '0' => assert( EADR( 3 downto 0 ) = B"0000" ) report "EADR() ERROR." severity ERROR;
                    when '1' => assert( EADR( 3 downto 0 ) = B"0001" ) report "EADR() ERROR." severity ERROR;
                    when '2' => assert( EADR( 3 downto 0 ) = B"0010" ) report "EADR() ERROR." severity ERROR;
                    when '3' => assert( EADR( 3 downto 0 ) = B"0011" ) report "EADR() ERROR." severity ERROR;
                    when '4' => assert( EADR( 3 downto 0 ) = B"0100" ) report "EADR() ERROR." severity ERROR;
                    when '5' => assert( EADR( 3 downto 0 ) = B"0101" ) report "EADR() ERROR." severity ERROR;
                    when '6' => assert( EADR( 3 downto 0 ) = B"0110" ) report "EADR() ERROR." severity ERROR;
                    when '7' => assert( EADR( 3 downto 0 ) = B"0111" ) report "EADR() ERROR." severity ERROR;
                    when '8' => assert( EADR( 3 downto 0 ) = B"1000" ) report "EADR() ERROR." severity ERROR;
                    when '9' => assert( EADR( 3 downto 0 ) = B"1001" ) report "EADR() ERROR." severity ERROR;
                    when 'A' => assert( EADR( 3 downto 0 ) = B"1010" ) report "EADR() ERROR." severity ERROR;
                    when 'B' => assert( EADR( 3 downto 0 ) = B"1011" ) report "EADR() ERROR." severity ERROR;
                    when 'C' => assert( EADR( 3 downto 0 ) = B"1100" ) report "EADR() ERROR." severity ERROR;
                    when 'D' => assert( EADR( 3 downto 0 ) = B"1101" ) report "EADR() ERROR." severity ERROR;
                    when 'E' => assert( EADR( 3 downto 0 ) = B"1110" ) report "EADR() ERROR." severity ERROR;
                    when 'F' => assert( EADR( 3 downto 0 ) = B"1111" ) report "EADR() ERROR." severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EADR()'." severity ERROR;
                end case;


                ------------------------------------------------------
                -- Check the 'ECYC' output.
                ------------------------------------------------------

                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;

                read( L, C );
                if(    C = '0' ) then assert( ECYC = '0' ) report "ECYC ERROR." severity ERROR;
                elsif( C = '1' ) then assert( ECYC = '1' ) report "ECYC ERROR." severity ERROR;
                else                  assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'ECYC'." severity ERROR;
                end if;


                ------------------------------------------------------
                -- Check the 'EDRD()' output.
                ------------------------------------------------------

                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;

                read( L, C );
                case C is
                    when '0' => assert( EDRD( 31 downto 28 ) = B"0000" ) report "EDRD() ERROR." severity ERROR;
                    when '1' => assert( EDRD( 31 downto 28 ) = B"0001" ) report "EDRD() ERROR." severity ERROR;
                    when '2' => assert( EDRD( 31 downto 28 ) = B"0010" ) report "EDRD() ERROR." severity ERROR;
                    when '3' => assert( EDRD( 31 downto 28 ) = B"0011" ) report "EDRD() ERROR." severity ERROR;
                    when '4' => assert( EDRD( 31 downto 28 ) = B"0100" ) report "EDRD() ERROR." severity ERROR;
                    when '5' => assert( EDRD( 31 downto 28 ) = B"0101" ) report "EDRD() ERROR." severity ERROR;
                    when '6' => assert( EDRD( 31 downto 28 ) = B"0110" ) report "EDRD() ERROR." severity ERROR;
                    when '7' => assert( EDRD( 31 downto 28 ) = B"0111" ) report "EDRD() ERROR." severity ERROR;
                    when '8' => assert( EDRD( 31 downto 28 ) = B"1000" ) report "EDRD() ERROR." severity ERROR;
                    when '9' => assert( EDRD( 31 downto 28 ) = B"1001" ) report "EDRD() ERROR." severity ERROR;
                    when 'A' => assert( EDRD( 31 downto 28 ) = B"1010" ) report "EDRD() ERROR." severity ERROR;
                    when 'B' => assert( EDRD( 31 downto 28 ) = B"1011" ) report "EDRD() ERROR." severity ERROR;
                    when 'C' => assert( EDRD( 31 downto 28 ) = B"1100" ) report "EDRD() ERROR." severity ERROR;
                    when 'D' => assert( EDRD( 31 downto 28 ) = B"1101" ) report "EDRD() ERROR." severity ERROR;
                    when 'E' => assert( EDRD( 31 downto 28 ) = B"1110" ) report "EDRD() ERROR." severity ERROR;
                    when 'F' => assert( EDRD( 31 downto 28 ) = B"1111" ) report "EDRD() ERROR." severity ERROR;
                    when 'U' => assert( true ) report "NOP" severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDRD()'." severity ERROR;
                end case;


                read( L, C );
                case C is
                    when '0' => assert( EDRD( 27 downto 24 ) = B"0000" ) report "EDRD() ERROR." severity ERROR;
                    when '1' => assert( EDRD( 27 downto 24 ) = B"0001" ) report "EDRD() ERROR." severity ERROR;
                    when '2' => assert( EDRD( 27 downto 24 ) = B"0010" ) report "EDRD() ERROR." severity ERROR;
                    when '3' => assert( EDRD( 27 downto 24 ) = B"0011" ) report "EDRD() ERROR." severity ERROR;
                    when '4' => assert( EDRD( 27 downto 24 ) = B"0100" ) report "EDRD() ERROR." severity ERROR;
                    when '5' => assert( EDRD( 27 downto 24 ) = B"0101" ) report "EDRD() ERROR." severity ERROR;
                    when '6' => assert( EDRD( 27 downto 24 ) = B"0110" ) report "EDRD() ERROR." severity ERROR;
                    when '7' => assert( EDRD( 27 downto 24 ) = B"0111" ) report "EDRD() ERROR." severity ERROR;
                    when '8' => assert( EDRD( 27 downto 24 ) = B"1000" ) report "EDRD() ERROR." severity ERROR;
                    when '9' => assert( EDRD( 27 downto 24 ) = B"1001" ) report "EDRD() ERROR." severity ERROR;
                    when 'A' => assert( EDRD( 27 downto 24 ) = B"1010" ) report "EDRD() ERROR." severity ERROR;
                    when 'B' => assert( EDRD( 27 downto 24 ) = B"1011" ) report "EDRD() ERROR." severity ERROR;
                    when 'C' => assert( EDRD( 27 downto 24 ) = B"1100" ) report "EDRD() ERROR." severity ERROR;
                    when 'D' => assert( EDRD( 27 downto 24 ) = B"1101" ) report "EDRD() ERROR." severity ERROR;
                    when 'E' => assert( EDRD( 27 downto 24 ) = B"1110" ) report "EDRD() ERROR." severity ERROR;
                    when 'F' => assert( EDRD( 27 downto 24 ) = B"1111" ) report "EDRD() ERROR." severity ERROR;
                    when 'U' => assert( true ) report "NOP" severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDRD()'." severity ERROR;
                end case;


                read( L, C );
                case C is
                    when '0' => assert( EDRD( 23 downto 20 ) = B"0000" ) report "EDRD() ERROR." severity ERROR;
                    when '1' => assert( EDRD( 23 downto 20 ) = B"0001" ) report "EDRD() ERROR." severity ERROR;
                    when '2' => assert( EDRD( 23 downto 20 ) = B"0010" ) report "EDRD() ERROR." severity ERROR;
                    when '3' => assert( EDRD( 23 downto 20 ) = B"0011" ) report "EDRD() ERROR." severity ERROR;
                    when '4' => assert( EDRD( 23 downto 20 ) = B"0100" ) report "EDRD() ERROR." severity ERROR;
                    when '5' => assert( EDRD( 23 downto 20 ) = B"0101" ) report "EDRD() ERROR." severity ERROR;
                    when '6' => assert( EDRD( 23 downto 20 ) = B"0110" ) report "EDRD() ERROR." severity ERROR;
                    when '7' => assert( EDRD( 23 downto 20 ) = B"0111" ) report "EDRD() ERROR." severity ERROR;
                    when '8' => assert( EDRD( 23 downto 20 ) = B"1000" ) report "EDRD() ERROR." severity ERROR;
                    when '9' => assert( EDRD( 23 downto 20 ) = B"1001" ) report "EDRD() ERROR." severity ERROR;
                    when 'A' => assert( EDRD( 23 downto 20 ) = B"1010" ) report "EDRD() ERROR." severity ERROR;
                    when 'B' => assert( EDRD( 23 downto 20 ) = B"1011" ) report "EDRD() ERROR." severity ERROR;
                    when 'C' => assert( EDRD( 23 downto 20 ) = B"1100" ) report "EDRD() ERROR." severity ERROR;
                    when 'D' => assert( EDRD( 23 downto 20 ) = B"1101" ) report "EDRD() ERROR." severity ERROR;
                    when 'E' => assert( EDRD( 23 downto 20 ) = B"1110" ) report "EDRD() ERROR." severity ERROR;
                    when 'F' => assert( EDRD( 23 downto 20 ) = B"1111" ) report "EDRD() ERROR." severity ERROR;
                    when 'U' => assert( true ) report "NOP" severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDRD()'." severity ERROR;
                end case;

                read( L, C );
                case C is
                    when '0' => assert( EDRD( 19 downto 16 ) = B"0000" ) report "EDRD() ERROR." severity ERROR;
                    when '1' => assert( EDRD( 19 downto 16 ) = B"0001" ) report "EDRD() ERROR." severity ERROR;
                    when '2' => assert( EDRD( 19 downto 16 ) = B"0010" ) report "EDRD() ERROR." severity ERROR;
                    when '3' => assert( EDRD( 19 downto 16 ) = B"0011" ) report "EDRD() ERROR." severity ERROR;
                    when '4' => assert( EDRD( 19 downto 16 ) = B"0100" ) report "EDRD() ERROR." severity ERROR;
                    when '5' => assert( EDRD( 19 downto 16 ) = B"0101" ) report "EDRD() ERROR." severity ERROR;
                    when '6' => assert( EDRD( 19 downto 16 ) = B"0110" ) report "EDRD() ERROR." severity ERROR;
                    when '7' => assert( EDRD( 19 downto 16 ) = B"0111" ) report "EDRD() ERROR." severity ERROR;
                    when '8' => assert( EDRD( 19 downto 16 ) = B"1000" ) report "EDRD() ERROR." severity ERROR;
                    when '9' => assert( EDRD( 19 downto 16 ) = B"1001" ) report "EDRD() ERROR." severity ERROR;
                    when 'A' => assert( EDRD( 19 downto 16 ) = B"1010" ) report "EDRD() ERROR." severity ERROR;
                    when 'B' => assert( EDRD( 19 downto 16 ) = B"1011" ) report "EDRD() ERROR." severity ERROR;
                    when 'C' => assert( EDRD( 19 downto 16 ) = B"1100" ) report "EDRD() ERROR." severity ERROR;
                    when 'D' => assert( EDRD( 19 downto 16 ) = B"1101" ) report "EDRD() ERROR." severity ERROR;
                    when 'E' => assert( EDRD( 19 downto 16 ) = B"1110" ) report "EDRD() ERROR." severity ERROR;
                    when 'F' => assert( EDRD( 19 downto 16 ) = B"1111" ) report "EDRD() ERROR." severity ERROR;
                    when 'U' => assert( true ) report "NOP" severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDRD()'." severity ERROR;
                end case;

                read( L, C );
                case C is
                    when '0' => assert( EDRD( 15 downto 12 ) = B"0000" ) report "EDRD() ERROR." severity ERROR;
                    when '1' => assert( EDRD( 15 downto 12 ) = B"0001" ) report "EDRD() ERROR." severity ERROR;
                    when '2' => assert( EDRD( 15 downto 12 ) = B"0010" ) report "EDRD() ERROR." severity ERROR;
                    when '3' => assert( EDRD( 15 downto 12 ) = B"0011" ) report "EDRD() ERROR." severity ERROR;
                    when '4' => assert( EDRD( 15 downto 12 ) = B"0100" ) report "EDRD() ERROR." severity ERROR;
                    when '5' => assert( EDRD( 15 downto 12 ) = B"0101" ) report "EDRD() ERROR." severity ERROR;
                    when '6' => assert( EDRD( 15 downto 12 ) = B"0110" ) report "EDRD() ERROR." severity ERROR;
                    when '7' => assert( EDRD( 15 downto 12 ) = B"0111" ) report "EDRD() ERROR." severity ERROR;
                    when '8' => assert( EDRD( 15 downto 12 ) = B"1000" ) report "EDRD() ERROR." severity ERROR;
                    when '9' => assert( EDRD( 15 downto 12 ) = B"1001" ) report "EDRD() ERROR." severity ERROR;
                    when 'A' => assert( EDRD( 15 downto 12 ) = B"1010" ) report "EDRD() ERROR." severity ERROR;
                    when 'B' => assert( EDRD( 15 downto 12 ) = B"1011" ) report "EDRD() ERROR." severity ERROR;
                    when 'C' => assert( EDRD( 15 downto 12 ) = B"1100" ) report "EDRD() ERROR." severity ERROR;
                    when 'D' => assert( EDRD( 15 downto 12 ) = B"1101" ) report "EDRD() ERROR." severity ERROR;
                    when 'E' => assert( EDRD( 15 downto 12 ) = B"1110" ) report "EDRD() ERROR." severity ERROR;
                    when 'F' => assert( EDRD( 15 downto 12 ) = B"1111" ) report "EDRD() ERROR." severity ERROR;
                    when 'U' => assert( true ) report "NOP" severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDRD()'." severity ERROR;
                end case;

                read( L, C );
                case C is
                    when '0' => assert( EDRD( 11 downto  8 ) = B"0000" ) report "EDRD() ERROR." severity ERROR;
                    when '1' => assert( EDRD( 11 downto  8 ) = B"0001" ) report "EDRD() ERROR." severity ERROR;
                    when '2' => assert( EDRD( 11 downto  8 ) = B"0010" ) report "EDRD() ERROR." severity ERROR;
                    when '3' => assert( EDRD( 11 downto  8 ) = B"0011" ) report "EDRD() ERROR." severity ERROR;
                    when '4' => assert( EDRD( 11 downto  8 ) = B"0100" ) report "EDRD() ERROR." severity ERROR;
                    when '5' => assert( EDRD( 11 downto  8 ) = B"0101" ) report "EDRD() ERROR." severity ERROR;
                    when '6' => assert( EDRD( 11 downto  8 ) = B"0110" ) report "EDRD() ERROR." severity ERROR;
                    when '7' => assert( EDRD( 11 downto  8 ) = B"0111" ) report "EDRD() ERROR." severity ERROR;
                    when '8' => assert( EDRD( 11 downto  8 ) = B"1000" ) report "EDRD() ERROR." severity ERROR;
                    when '9' => assert( EDRD( 11 downto  8 ) = B"1001" ) report "EDRD() ERROR." severity ERROR;
                    when 'A' => assert( EDRD( 11 downto  8 ) = B"1010" ) report "EDRD() ERROR." severity ERROR;
                    when 'B' => assert( EDRD( 11 downto  8 ) = B"1011" ) report "EDRD() ERROR." severity ERROR;
                    when 'C' => assert( EDRD( 11 downto  8 ) = B"1100" ) report "EDRD() ERROR." severity ERROR;
                    when 'D' => assert( EDRD( 11 downto  8 ) = B"1101" ) report "EDRD() ERROR." severity ERROR;
                    when 'E' => assert( EDRD( 11 downto  8 ) = B"1110" ) report "EDRD() ERROR." severity ERROR;
                    when 'F' => assert( EDRD( 11 downto  8 ) = B"1111" ) report "EDRD() ERROR." severity ERROR;
                    when 'U' => assert( true ) report "NOP" severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDRD()'." severity ERROR;
                end case;

                read( L, C );
                case C is
                    when '0' => assert( EDRD(  7 downto  4 ) = B"0000" ) report "EDRD() ERROR." severity ERROR;
                    when '1' => assert( EDRD(  7 downto  4 ) = B"0001" ) report "EDRD() ERROR." severity ERROR;
                    when '2' => assert( EDRD(  7 downto  4 ) = B"0010" ) report "EDRD() ERROR." severity ERROR;
                    when '3' => assert( EDRD(  7 downto  4 ) = B"0011" ) report "EDRD() ERROR." severity ERROR;
                    when '4' => assert( EDRD(  7 downto  4 ) = B"0100" ) report "EDRD() ERROR." severity ERROR;
                    when '5' => assert( EDRD(  7 downto  4 ) = B"0101" ) report "EDRD() ERROR." severity ERROR;
                    when '6' => assert( EDRD(  7 downto  4 ) = B"0110" ) report "EDRD() ERROR." severity ERROR;
                    when '7' => assert( EDRD(  7 downto  4 ) = B"0111" ) report "EDRD() ERROR." severity ERROR;
                    when '8' => assert( EDRD(  7 downto  4 ) = B"1000" ) report "EDRD() ERROR." severity ERROR;
                    when '9' => assert( EDRD(  7 downto  4 ) = B"1001" ) report "EDRD() ERROR." severity ERROR;
                    when 'A' => assert( EDRD(  7 downto  4 ) = B"1010" ) report "EDRD() ERROR." severity ERROR;
                    when 'B' => assert( EDRD(  7 downto  4 ) = B"1011" ) report "EDRD() ERROR." severity ERROR;
                    when 'C' => assert( EDRD(  7 downto  4 ) = B"1100" ) report "EDRD() ERROR." severity ERROR;
                    when 'D' => assert( EDRD(  7 downto  4 ) = B"1101" ) report "EDRD() ERROR." severity ERROR;
                    when 'E' => assert( EDRD(  7 downto  4 ) = B"1110" ) report "EDRD() ERROR." severity ERROR;
                    when 'F' => assert( EDRD(  7 downto  4 ) = B"1111" ) report "EDRD() ERROR." severity ERROR;
                    when 'U' => assert( true ) report "NOP" severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDRD()'." severity ERROR;
                end case;

                read( L, C );
                case C is
                    when '0' => assert( EDRD(  3 downto  0 ) = B"0000" ) report "EDRD() ERROR." severity ERROR;
                    when '1' => assert( EDRD(  3 downto  0 ) = B"0001" ) report "EDRD() ERROR." severity ERROR;
                    when '2' => assert( EDRD(  3 downto  0 ) = B"0010" ) report "EDRD() ERROR." severity ERROR;
                    when '3' => assert( EDRD(  3 downto  0 ) = B"0011" ) report "EDRD() ERROR." severity ERROR;
                    when '4' => assert( EDRD(  3 downto  0 ) = B"0100" ) report "EDRD() ERROR." severity ERROR;
                    when '5' => assert( EDRD(  3 downto  0 ) = B"0101" ) report "EDRD() ERROR." severity ERROR;
                    when '6' => assert( EDRD(  3 downto  0 ) = B"0110" ) report "EDRD() ERROR." severity ERROR;
                    when '7' => assert( EDRD(  3 downto  0 ) = B"0111" ) report "EDRD() ERROR." severity ERROR;
                    when '8' => assert( EDRD(  3 downto  0 ) = B"1000" ) report "EDRD() ERROR." severity ERROR;
                    when '9' => assert( EDRD(  3 downto  0 ) = B"1001" ) report "EDRD() ERROR." severity ERROR;
                    when 'A' => assert( EDRD(  3 downto  0 ) = B"1010" ) report "EDRD() ERROR." severity ERROR;
                    when 'B' => assert( EDRD(  3 downto  0 ) = B"1011" ) report "EDRD() ERROR." severity ERROR;
                    when 'C' => assert( EDRD(  3 downto  0 ) = B"1100" ) report "EDRD() ERROR." severity ERROR;
                    when 'D' => assert( EDRD(  3 downto  0 ) = B"1101" ) report "EDRD() ERROR." severity ERROR;
                    when 'E' => assert( EDRD(  3 downto  0 ) = B"1110" ) report "EDRD() ERROR." severity ERROR;
                    when 'F' => assert( EDRD(  3 downto  0 ) = B"1111" ) report "EDRD() ERROR." severity ERROR;
                    when 'U' => assert( true ) report "NOP" severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDRD()'." severity ERROR;
                end case;


                ------------------------------------------------------
                -- Check the 'EDWR()' output.
                ------------------------------------------------------

                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;

                read( L, C );
                case C is
                    when '0' => assert( EDWR( 31 downto 28 ) = B"0000" ) report "EDWR() ERROR." severity ERROR;
                    when '1' => assert( EDWR( 31 downto 28 ) = B"0001" ) report "EDWR() ERROR." severity ERROR;
                    when '2' => assert( EDWR( 31 downto 28 ) = B"0010" ) report "EDWR() ERROR." severity ERROR;
                    when '3' => assert( EDWR( 31 downto 28 ) = B"0011" ) report "EDWR() ERROR." severity ERROR;
                    when '4' => assert( EDWR( 31 downto 28 ) = B"0100" ) report "EDWR() ERROR." severity ERROR;
                    when '5' => assert( EDWR( 31 downto 28 ) = B"0101" ) report "EDWR() ERROR." severity ERROR;
                    when '6' => assert( EDWR( 31 downto 28 ) = B"0110" ) report "EDWR() ERROR." severity ERROR;
                    when '7' => assert( EDWR( 31 downto 28 ) = B"0111" ) report "EDWR() ERROR." severity ERROR;
                    when '8' => assert( EDWR( 31 downto 28 ) = B"1000" ) report "EDWR() ERROR." severity ERROR;
                    when '9' => assert( EDWR( 31 downto 28 ) = B"1001" ) report "EDWR() ERROR." severity ERROR;
                    when 'A' => assert( EDWR( 31 downto 28 ) = B"1010" ) report "EDWR() ERROR." severity ERROR;
                    when 'B' => assert( EDWR( 31 downto 28 ) = B"1011" ) report "EDWR() ERROR." severity ERROR;
                    when 'C' => assert( EDWR( 31 downto 28 ) = B"1100" ) report "EDWR() ERROR." severity ERROR;
                    when 'D' => assert( EDWR( 31 downto 28 ) = B"1101" ) report "EDWR() ERROR." severity ERROR;
                    when 'E' => assert( EDWR( 31 downto 28 ) = B"1110" ) report "EDWR() ERROR." severity ERROR;
                    when 'F' => assert( EDWR( 31 downto 28 ) = B"1111" ) report "EDWR() ERROR." severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDWR()'." severity ERROR;
                end case;


                read( L, C );
                case C is
                    when '0' => assert( EDWR( 27 downto 24 ) = B"0000" ) report "EDWR() ERROR." severity ERROR;
                    when '1' => assert( EDWR( 27 downto 24 ) = B"0001" ) report "EDWR() ERROR." severity ERROR;
                    when '2' => assert( EDWR( 27 downto 24 ) = B"0010" ) report "EDWR() ERROR." severity ERROR;
                    when '3' => assert( EDWR( 27 downto 24 ) = B"0011" ) report "EDWR() ERROR." severity ERROR;
                    when '4' => assert( EDWR( 27 downto 24 ) = B"0100" ) report "EDWR() ERROR." severity ERROR;
                    when '5' => assert( EDWR( 27 downto 24 ) = B"0101" ) report "EDWR() ERROR." severity ERROR;
                    when '6' => assert( EDWR( 27 downto 24 ) = B"0110" ) report "EDWR() ERROR." severity ERROR;
                    when '7' => assert( EDWR( 27 downto 24 ) = B"0111" ) report "EDWR() ERROR." severity ERROR;
                    when '8' => assert( EDWR( 27 downto 24 ) = B"1000" ) report "EDWR() ERROR." severity ERROR;
                    when '9' => assert( EDWR( 27 downto 24 ) = B"1001" ) report "EDWR() ERROR." severity ERROR;
                    when 'A' => assert( EDWR( 27 downto 24 ) = B"1010" ) report "EDWR() ERROR." severity ERROR;
                    when 'B' => assert( EDWR( 27 downto 24 ) = B"1011" ) report "EDWR() ERROR." severity ERROR;
                    when 'C' => assert( EDWR( 27 downto 24 ) = B"1100" ) report "EDWR() ERROR." severity ERROR;
                    when 'D' => assert( EDWR( 27 downto 24 ) = B"1101" ) report "EDWR() ERROR." severity ERROR;
                    when 'E' => assert( EDWR( 27 downto 24 ) = B"1110" ) report "EDWR() ERROR." severity ERROR;
                    when 'F' => assert( EDWR( 27 downto 24 ) = B"1111" ) report "EDWR() ERROR." severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDWR()'." severity ERROR;
                end case;


                read( L, C );
                case C is
                    when '0' => assert( EDWR( 23 downto 20 ) = B"0000" ) report "EDWR() ERROR." severity ERROR;
                    when '1' => assert( EDWR( 23 downto 20 ) = B"0001" ) report "EDWR() ERROR." severity ERROR;
                    when '2' => assert( EDWR( 23 downto 20 ) = B"0010" ) report "EDWR() ERROR." severity ERROR;
                    when '3' => assert( EDWR( 23 downto 20 ) = B"0011" ) report "EDWR() ERROR." severity ERROR;
                    when '4' => assert( EDWR( 23 downto 20 ) = B"0100" ) report "EDWR() ERROR." severity ERROR;
                    when '5' => assert( EDWR( 23 downto 20 ) = B"0101" ) report "EDWR() ERROR." severity ERROR;
                    when '6' => assert( EDWR( 23 downto 20 ) = B"0110" ) report "EDWR() ERROR." severity ERROR;
                    when '7' => assert( EDWR( 23 downto 20 ) = B"0111" ) report "EDWR() ERROR." severity ERROR;
                    when '8' => assert( EDWR( 23 downto 20 ) = B"1000" ) report "EDWR() ERROR." severity ERROR;
                    when '9' => assert( EDWR( 23 downto 20 ) = B"1001" ) report "EDWR() ERROR." severity ERROR;
                    when 'A' => assert( EDWR( 23 downto 20 ) = B"1010" ) report "EDWR() ERROR." severity ERROR;
                    when 'B' => assert( EDWR( 23 downto 20 ) = B"1011" ) report "EDWR() ERROR." severity ERROR;
                    when 'C' => assert( EDWR( 23 downto 20 ) = B"1100" ) report "EDWR() ERROR." severity ERROR;
                    when 'D' => assert( EDWR( 23 downto 20 ) = B"1101" ) report "EDWR() ERROR." severity ERROR;
                    when 'E' => assert( EDWR( 23 downto 20 ) = B"1110" ) report "EDWR() ERROR." severity ERROR;
                    when 'F' => assert( EDWR( 23 downto 20 ) = B"1111" ) report "EDWR() ERROR." severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDWR()'." severity ERROR;
                end case;

                read( L, C );
                case C is
                    when '0' => assert( EDWR( 19 downto 16 ) = B"0000" ) report "EDWR() ERROR." severity ERROR;
                    when '1' => assert( EDWR( 19 downto 16 ) = B"0001" ) report "EDWR() ERROR." severity ERROR;
                    when '2' => assert( EDWR( 19 downto 16 ) = B"0010" ) report "EDWR() ERROR." severity ERROR;
                    when '3' => assert( EDWR( 19 downto 16 ) = B"0011" ) report "EDWR() ERROR." severity ERROR;
                    when '4' => assert( EDWR( 19 downto 16 ) = B"0100" ) report "EDWR() ERROR." severity ERROR;
                    when '5' => assert( EDWR( 19 downto 16 ) = B"0101" ) report "EDWR() ERROR." severity ERROR;
                    when '6' => assert( EDWR( 19 downto 16 ) = B"0110" ) report "EDWR() ERROR." severity ERROR;
                    when '7' => assert( EDWR( 19 downto 16 ) = B"0111" ) report "EDWR() ERROR." severity ERROR;
                    when '8' => assert( EDWR( 19 downto 16 ) = B"1000" ) report "EDWR() ERROR." severity ERROR;
                    when '9' => assert( EDWR( 19 downto 16 ) = B"1001" ) report "EDWR() ERROR." severity ERROR;
                    when 'A' => assert( EDWR( 19 downto 16 ) = B"1010" ) report "EDWR() ERROR." severity ERROR;
                    when 'B' => assert( EDWR( 19 downto 16 ) = B"1011" ) report "EDWR() ERROR." severity ERROR;
                    when 'C' => assert( EDWR( 19 downto 16 ) = B"1100" ) report "EDWR() ERROR." severity ERROR;
                    when 'D' => assert( EDWR( 19 downto 16 ) = B"1101" ) report "EDWR() ERROR." severity ERROR;
                    when 'E' => assert( EDWR( 19 downto 16 ) = B"1110" ) report "EDWR() ERROR." severity ERROR;
                    when 'F' => assert( EDWR( 19 downto 16 ) = B"1111" ) report "EDWR() ERROR." severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDWR()'." severity ERROR;
                end case;

                read( L, C );
                case C is
                    when '0' => assert( EDWR( 15 downto 12 ) = B"0000" ) report "EDWR() ERROR." severity ERROR;
                    when '1' => assert( EDWR( 15 downto 12 ) = B"0001" ) report "EDWR() ERROR." severity ERROR;
                    when '2' => assert( EDWR( 15 downto 12 ) = B"0010" ) report "EDWR() ERROR." severity ERROR;
                    when '3' => assert( EDWR( 15 downto 12 ) = B"0011" ) report "EDWR() ERROR." severity ERROR;
                    when '4' => assert( EDWR( 15 downto 12 ) = B"0100" ) report "EDWR() ERROR." severity ERROR;
                    when '5' => assert( EDWR( 15 downto 12 ) = B"0101" ) report "EDWR() ERROR." severity ERROR;
                    when '6' => assert( EDWR( 15 downto 12 ) = B"0110" ) report "EDWR() ERROR." severity ERROR;
                    when '7' => assert( EDWR( 15 downto 12 ) = B"0111" ) report "EDWR() ERROR." severity ERROR;
                    when '8' => assert( EDWR( 15 downto 12 ) = B"1000" ) report "EDWR() ERROR." severity ERROR;
                    when '9' => assert( EDWR( 15 downto 12 ) = B"1001" ) report "EDWR() ERROR." severity ERROR;
                    when 'A' => assert( EDWR( 15 downto 12 ) = B"1010" ) report "EDWR() ERROR." severity ERROR;
                    when 'B' => assert( EDWR( 15 downto 12 ) = B"1011" ) report "EDWR() ERROR." severity ERROR;
                    when 'C' => assert( EDWR( 15 downto 12 ) = B"1100" ) report "EDWR() ERROR." severity ERROR;
                    when 'D' => assert( EDWR( 15 downto 12 ) = B"1101" ) report "EDWR() ERROR." severity ERROR;
                    when 'E' => assert( EDWR( 15 downto 12 ) = B"1110" ) report "EDWR() ERROR." severity ERROR;
                    when 'F' => assert( EDWR( 15 downto 12 ) = B"1111" ) report "EDWR() ERROR." severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDWR()'." severity ERROR;
                end case;

                read( L, C );
                case C is
                    when '0' => assert( EDWR( 11 downto  8 ) = B"0000" ) report "EDWR() ERROR." severity ERROR;
                    when '1' => assert( EDWR( 11 downto  8 ) = B"0001" ) report "EDWR() ERROR." severity ERROR;
                    when '2' => assert( EDWR( 11 downto  8 ) = B"0010" ) report "EDWR() ERROR." severity ERROR;
                    when '3' => assert( EDWR( 11 downto  8 ) = B"0011" ) report "EDWR() ERROR." severity ERROR;
                    when '4' => assert( EDWR( 11 downto  8 ) = B"0100" ) report "EDWR() ERROR." severity ERROR;
                    when '5' => assert( EDWR( 11 downto  8 ) = B"0101" ) report "EDWR() ERROR." severity ERROR;
                    when '6' => assert( EDWR( 11 downto  8 ) = B"0110" ) report "EDWR() ERROR." severity ERROR;
                    when '7' => assert( EDWR( 11 downto  8 ) = B"0111" ) report "EDWR() ERROR." severity ERROR;
                    when '8' => assert( EDWR( 11 downto  8 ) = B"1000" ) report "EDWR() ERROR." severity ERROR;
                    when '9' => assert( EDWR( 11 downto  8 ) = B"1001" ) report "EDWR() ERROR." severity ERROR;
                    when 'A' => assert( EDWR( 11 downto  8 ) = B"1010" ) report "EDWR() ERROR." severity ERROR;
                    when 'B' => assert( EDWR( 11 downto  8 ) = B"1011" ) report "EDWR() ERROR." severity ERROR;
                    when 'C' => assert( EDWR( 11 downto  8 ) = B"1100" ) report "EDWR() ERROR." severity ERROR;
                    when 'D' => assert( EDWR( 11 downto  8 ) = B"1101" ) report "EDWR() ERROR." severity ERROR;
                    when 'E' => assert( EDWR( 11 downto  8 ) = B"1110" ) report "EDWR() ERROR." severity ERROR;
                    when 'F' => assert( EDWR( 11 downto  8 ) = B"1111" ) report "EDWR() ERROR." severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDWR()'." severity ERROR;
                end case;

                read( L, C );
                case C is
                    when '0' => assert( EDWR(  7 downto  4 ) = B"0000" ) report "EDWR() ERROR." severity ERROR;
                    when '1' => assert( EDWR(  7 downto  4 ) = B"0001" ) report "EDWR() ERROR." severity ERROR;
                    when '2' => assert( EDWR(  7 downto  4 ) = B"0010" ) report "EDWR() ERROR." severity ERROR;
                    when '3' => assert( EDWR(  7 downto  4 ) = B"0011" ) report "EDWR() ERROR." severity ERROR;
                    when '4' => assert( EDWR(  7 downto  4 ) = B"0100" ) report "EDWR() ERROR." severity ERROR;
                    when '5' => assert( EDWR(  7 downto  4 ) = B"0101" ) report "EDWR() ERROR." severity ERROR;
                    when '6' => assert( EDWR(  7 downto  4 ) = B"0110" ) report "EDWR() ERROR." severity ERROR;
                    when '7' => assert( EDWR(  7 downto  4 ) = B"0111" ) report "EDWR() ERROR." severity ERROR;
                    when '8' => assert( EDWR(  7 downto  4 ) = B"1000" ) report "EDWR() ERROR." severity ERROR;
                    when '9' => assert( EDWR(  7 downto  4 ) = B"1001" ) report "EDWR() ERROR." severity ERROR;
                    when 'A' => assert( EDWR(  7 downto  4 ) = B"1010" ) report "EDWR() ERROR." severity ERROR;
                    when 'B' => assert( EDWR(  7 downto  4 ) = B"1011" ) report "EDWR() ERROR." severity ERROR;
                    when 'C' => assert( EDWR(  7 downto  4 ) = B"1100" ) report "EDWR() ERROR." severity ERROR;
                    when 'D' => assert( EDWR(  7 downto  4 ) = B"1101" ) report "EDWR() ERROR." severity ERROR;
                    when 'E' => assert( EDWR(  7 downto  4 ) = B"1110" ) report "EDWR() ERROR." severity ERROR;
                    when 'F' => assert( EDWR(  7 downto  4 ) = B"1111" ) report "EDWR() ERROR." severity ERROR;
                    when 'X' => assert( EDWR(  7 downto  4 ) = B"XXXX" ) report "EDWR() ERROR." severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDWR()'." severity ERROR;
                end case;

                read( L, C );
                case C is
                    when '0' => assert( EDWR(  3 downto  0 ) = B"0000" ) report "EDWR() ERROR." severity ERROR;
                    when '1' => assert( EDWR(  3 downto  0 ) = B"0001" ) report "EDWR() ERROR." severity ERROR;
                    when '2' => assert( EDWR(  3 downto  0 ) = B"0010" ) report "EDWR() ERROR." severity ERROR;
                    when '3' => assert( EDWR(  3 downto  0 ) = B"0011" ) report "EDWR() ERROR." severity ERROR;
                    when '4' => assert( EDWR(  3 downto  0 ) = B"0100" ) report "EDWR() ERROR." severity ERROR;
                    when '5' => assert( EDWR(  3 downto  0 ) = B"0101" ) report "EDWR() ERROR." severity ERROR;
                    when '6' => assert( EDWR(  3 downto  0 ) = B"0110" ) report "EDWR() ERROR." severity ERROR;
                    when '7' => assert( EDWR(  3 downto  0 ) = B"0111" ) report "EDWR() ERROR." severity ERROR;
                    when '8' => assert( EDWR(  3 downto  0 ) = B"1000" ) report "EDWR() ERROR." severity ERROR;
                    when '9' => assert( EDWR(  3 downto  0 ) = B"1001" ) report "EDWR() ERROR." severity ERROR;
                    when 'A' => assert( EDWR(  3 downto  0 ) = B"1010" ) report "EDWR() ERROR." severity ERROR;
                    when 'B' => assert( EDWR(  3 downto  0 ) = B"1011" ) report "EDWR() ERROR." severity ERROR;
                    when 'C' => assert( EDWR(  3 downto  0 ) = B"1100" ) report "EDWR() ERROR." severity ERROR;
                    when 'D' => assert( EDWR(  3 downto  0 ) = B"1101" ) report "EDWR() ERROR." severity ERROR;
                    when 'E' => assert( EDWR(  3 downto  0 ) = B"1110" ) report "EDWR() ERROR." severity ERROR;
                    when 'F' => assert( EDWR(  3 downto  0 ) = B"1111" ) report "EDWR() ERROR." severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EDWR()'." severity ERROR;
                end case;

                ------------------------------------------------------
                -- Check the 'ESTB' output.
                ------------------------------------------------------

                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;

                read( L, C );
                if(    C = '0' ) then assert( ESTB = '0' ) report "ESTB ERROR." severity ERROR;
                elsif( C = '1' ) then assert( ESTB = '1' ) report "ESTB ERROR." severity ERROR;
                else                  assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'ESTB'." severity ERROR;
                end if;


                ------------------------------------------------------
                -- Check the 'EWE' output.
                ------------------------------------------------------

                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;

                read( L, C );
                if(    C = '0' ) then assert( EWE = '0' ) report "EWE ERROR." severity ERROR;
                elsif( C = '1' ) then assert( EWE = '1' ) report "EWE ERROR." severity ERROR;
                else                  assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EWE'." severity ERROR;
                end if;


                ------------------------------------------------------
                -- Check the 'EGNT()' output.
                ------------------------------------------------------

                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;

                read( L, C );
                case C is
                    when '0' => assert( EGNT( 1 downto 0 ) = B"00" ) report "EGNT() ERROR." severity ERROR;
                    when '1' => assert( EGNT( 1 downto 0 ) = B"01" ) report "EGNT() ERROR." severity ERROR;
                    when '2' => assert( EGNT( 1 downto 0 ) = B"10" ) report "EGNT() ERROR." severity ERROR;
                    when '3' => assert( EGNT( 1 downto 0 ) = B"11" ) report "EGNT() ERROR." severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'EGNT()'." severity ERROR;
                end case;


                wait for (PERIOD / 4);

            end if;
                
        end loop READ_VECTORS;

        wait;
        
    end process TEST_PROCESS;

end architecture TESTBNCH1;

