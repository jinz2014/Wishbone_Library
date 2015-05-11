----------------------------------------------------------------------
-- Module name:     TESTBNCH.VHD
--
-- Description:     Test bench for ARB0001a.VHD.
--
-- History:         Project complete:           SEP 14, 2001
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
    -- Define some local signals to assign values and observe.
    ------------------------------------------------------------------

    signal  CLK:        std_logic;
    signal  COMCYC:     std_logic;
    signal  CYC3:       std_logic;
    signal  CYC2:       std_logic;
    signal  CYC1:       std_logic;
    signal  CYC0:       std_logic;
    signal  GNT:        std_logic_vector( 1 downto 0 );
    signal  GNT3:       std_logic;
    signal  GNT2:       std_logic;
    signal  GNT1:       std_logic;
    signal  GNT0:       std_logic;
    signal  RST:        std_logic;

begin

    ------------------------------------------------------------------
    -- Port map for the device under test.
    ------------------------------------------------------------------

    TBENCH: ARB0001a
    port map(
                CLK     =>  CLK,
                COMCYC  =>  COMCYC,
                CYC3    =>  CYC3,
                CYC2    =>  CYC2,
                CYC1    =>  CYC1,
                CYC0    =>  CYC0,
                GNT     =>  GNT,
                GNT3    =>  GNT3,
                GNT2    =>  GNT2,
                GNT1    =>  GNT1,
                GNT0    =>  GNT0,
                RST     =>  RST
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

                CLK    <= '0';
                wait for (PERIOD / 4);


                ------------------------------------------------------
                -- Read and apply the input test vectors.
                ------------------------------------------------------

                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;
                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;


                ------------------------------------------------------
                -- Configure the 'RST' input.
                ------------------------------------------------------

                read( L, C );

                if( C = '0' ) then
                    RST <= '0';
                elsif( C = '1' ) then
                    RST <= '1';
                else
                    assert( false ) report "ILLEGAL TEST VECTOR, INPUT: 'RST'." severity ERROR;
                end if;


                ------------------------------------------------------
                -- Configure the 'CYCN' inputs.
                ------------------------------------------------------

                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;

                read( L, C );

                if( C = '0' ) then
                    CYC3 <= '0';
                elsif( C = '1' ) then
                    CYC3 <= '1';
                else
                    assert( false ) report "ILLEGAL TEST VECTOR, INPUT: 'CYC3'." severity ERROR;
                end if;

                read( L, C );

                if( C = '0' ) then
                    CYC2 <= '0';
                elsif( C = '1' ) then
                    CYC2 <= '1';
                else
                    assert( false ) report "ILLEGAL TEST VECTOR, INPUT: 'CYC3'." severity ERROR;
                end if;

                read( L, C );

                if( C = '0' ) then
                    CYC1 <= '0';
                elsif( C = '1' ) then
                    CYC1 <= '1';
                else
                    assert( false ) report "ILLEGAL TEST VECTOR, INPUT: 'CYC3'." severity ERROR;
                end if;

                read( L, C );

                if( C = '0' ) then
                    CYC0 <= '0';
                elsif( C = '1' ) then
                    CYC0 <= '1';
                else
                    assert( false ) report "ILLEGAL TEST VECTOR, INPUT: 'CYC3'." severity ERROR;
                end if;


                ------------------------------------------------------
                -- Configure the 'CLK' inputs.
                ------------------------------------------------------

                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;

                wait for (PERIOD / 4);

                read( L, C );

                if( C = 'R' ) then
                    CLK <= '1';
                else
                    assert( false ) report "ILLEGAL TEST VECTOR, INPUT: 'CLK'." severity ERROR;
                end if;

                wait for (PERIOD / 4);


                ------------------------------------------------------
                -- Check the 'COMCYC' output.
                ------------------------------------------------------

                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;

                read( L, C );
                if( C = '0' ) then
                    assert( COMCYC = '0' ) report "COMCYC ERROR." severity ERROR;
                elsif( C = '1' ) then
                    assert( COMCYC = '1' ) report "COMCYC ERROR." severity ERROR;
                else
                    assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'COMCYC'." severity ERROR;
                end if;


                ------------------------------------------------------
                -- Check the 'GNT()' outputs.
                ------------------------------------------------------

                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;

                read( L, C );
                case C is
                    when '0' => assert( GNT( 1 downto 0 ) = B"00" ) report "GNT() OUTPUT ERROR." severity ERROR;
                    when '1' => assert( GNT( 1 downto 0 ) = B"01" ) report "GNT() OUTPUT ERROR." severity ERROR;
                    when '2' => assert( GNT( 1 downto 0 ) = B"10" ) report "GNT() OUTPUT ERROR." severity ERROR;
                    when '3' => assert( GNT( 1 downto 0 ) = B"11" ) report "GNT() OUTPUT ERROR." severity ERROR;
                    when others =>
                        assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'GNT()'." severity ERROR;
                end case;


                ------------------------------------------------------
                -- Check the 'GNT3' output.
                ------------------------------------------------------

                read( L, C );
                assert( C = ' ' ) report "CHARACTER FOUND IN PLACE OF EXPECTED WHITE SPACE." severity ERROR;

                read( L, C );
                if( C = '0' ) then
                    assert( GNT3 = '0' ) report "GNT3 ERROR." severity ERROR;
                elsif( C = '1' ) then
                    assert( GNT3 = '1' ) report "GNT3 ERROR." severity ERROR;
                else
                    assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'GNT3'." severity ERROR;
                end if;


                ------------------------------------------------------
                -- Check the 'GNT2' output.
                ------------------------------------------------------

                read( L, C );
                if( C = '0' ) then
                    assert( GNT2 = '0' ) report "GNT2 ERROR." severity ERROR;
                elsif( C = '1' ) then
                    assert( GNT2 = '1' ) report "GNT2 ERROR." severity ERROR;
                else
                    assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'GNT2'." severity ERROR;
                end if;


                ------------------------------------------------------
                -- Check the 'GNT1' output.
                ------------------------------------------------------

                read( L, C );
                if( C = '0' ) then
                    assert( GNT1 = '0' ) report "GNT1 ERROR." severity ERROR;
                elsif( C = '1' ) then
                    assert( GNT1 = '1' ) report "GNT1 ERROR." severity ERROR;
                else
                    assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'GNT1'." severity ERROR;
                end if;


                ------------------------------------------------------
                -- Check the 'GNT0' output.
                ------------------------------------------------------

                read( L, C );
                if( C = '0' ) then
                    assert( GNT0 = '0' ) report "GNT0 ERROR." severity ERROR;
                elsif( C = '1' ) then
                    assert( GNT0 = '1' ) report "GNT0 ERROR." severity ERROR;
                else
                    assert( false ) report "ILLEGAL TEST VECTOR, OUTPUT: 'GNT0'." severity ERROR;
                end if;


                ------------------------------------------------------
                -- All of the outputs have been checked for this test
                -- vector.  Delay a quarter of a period.
                ------------------------------------------------------

                wait for (PERIOD / 4);

            end if;
                
        end loop READ_VECTORS;

        wait;
        
    end process TEST_PROCESS;

end architecture TESTBNCH1;

