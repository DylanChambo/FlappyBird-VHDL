library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use work.Rectangle.all;

entity obstacles is
    port (
        I_V_SYNC : in std_logic;
        I_PIXEL : in T_RECT;
        I_RANDOM : in std_logic_vector(7 downto 0);
        I_BIRD : in T_RECT;
        O_RGB : out std_logic_vector(11 downto 0);
        O_ON : out std_logic;
        O_COLLISION : out std_logic
    );
end obstacles;

architecture behavior of obstacles is
    signal A_RGB : std_logic_vector(11 downto 0);
    signal B_RGB : std_logic_vector(11 downto 0);
    signal A_COLLISION : std_logic;
    signal B_COLLISION : std_logic;
    signal A_ON : std_logic;
    signal B_ON : std_logic;
begin
    pipe_a : entity work.pipe
        generic map(
            X_START => CONV_STD_LOGIC_VECTOR(680, 11)
        )
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL => I_PIXEL,
            I_PIPE_GAP_POSITION => I_RANDOM,
            I_BIRD => I_BIRD,
            O_RGB => A_RGB,
            O_ON => A_ON,
            O_COLLISION => A_COLLISION
        );

    pipe_b : entity work.pipe
        generic map(
            X_START => CONV_STD_LOGIC_VECTOR(1020, 11)
        )
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL => I_PIXEL,
            I_PIPE_GAP_POSITION => I_RANDOM,
            I_BIRD => I_BIRD,
            O_RGB => B_RGB,
            O_ON => B_ON,
            O_COLLISION => B_COLLISION
        );

    O_RGB <= A_RGB when A_ON = '1' else
        B_RGB when B_ON = '1' else
        x"000";

    O_ON <= A_ON or B_ON;
    O_COLLISION <= B_COLLISION or A_COLLISION;
end architecture;