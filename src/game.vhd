library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Rectangle.all;
use work.RGBValues.BACKGROUND_RGB;

entity game is
    port (
        I_CLK : in std_logic;
        I_V_SYNC : in std_logic;
        I_PIXEL : in T_RECT;
        I_M_LEFT : in std_logic;
        O_RGB : out std_logic_vector(11 downto 0);
        O_LED : out std_logic
    );
end game;

architecture behavior of game is
    signal B_RGB : std_logic_vector(11 downto 0);
    signal B_ON : std_logic;
    signal B_BIRD : T_RECT;

    signal P_RGB : std_logic_vector(11 downto 0);
    signal P_ON : std_logic;
    signal P_COLLISION_ON : std_logic;
    signal P_PIPE_PASSED : std_logic;

    signal S_RGB : std_logic_vector(11 downto 0);
    signal S_ON : std_logic;

    signal LI_RGB : std_logic_vector(11 downto 0);
    signal LI_ON : std_logic;

    signal LF_RANDOM : std_logic_vector(7 downto 0);

    signal L_BACKGROUND_COLOUR : std_logic_vector(11 downto 0) := BACKGROUND_RGB;

    signal SCORE_ON : std_logic_vector(5 downto 0);

begin
    bird : entity work.bird
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL => I_PIXEL,
            I_CLICK => I_M_LEFT,
            O_BIRD => B_BIRD,
            O_RGB => B_RGB,
            O_ON => B_ON
        );

    obstacles : entity work.obstacles
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL => I_PIXEL,
            I_BIRD => B_BIRD,
            I_RANDOM => LF_RANDOM,
            O_RGB => P_RGB,
            O_ON => P_ON,
            O_COLLISION => P_COLLISION_ON,
            O_PIPE_PASSED => P_PIPE_PASSED
        );

    -- Define the Linear Feeback Shift Register
    lfsr : entity work.lfsr
        port map(
            I_CLK => I_V_SYNC,
            I_RVAL => I_M_LEFT,
            O_VAL => LF_RANDOM
        );

    score : entity work.score
        port map(
            i_pipePassed => P_PIPE_PASSED,
            i_collision => P_COLLISION_ON,
            o_screenScore => SCORE_ON
        );

    score_text : entity work.string
        generic map(
            X_CENTER => 639/2,
            Y_CENTER => 24,
            SCALE => 3,
            NUM_CHARS => 2,
            COLOR => x"FFF"
        )
        port map(
            I_CLK => I_CLK,
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X(9 downto 0),
            I_CHARS => o"60" & o"61",
            O_RGB => S_RGB,
            O_ON => S_ON
        );

    lives : entity work.string
        generic map(
            X_CENTER => 52,
            Y_CENTER => 24,
            SCALE => 3,
            NUM_CHARS => 3,
            COLOR => x"F00",
            GAP => 1
        )
        port map(
            I_CLK => I_CLK,
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X(9 downto 0),
            I_CHARS => o"33" & o"33" & o"33",
            O_RGB => LI_RGB,
            O_ON => LI_ON
        );

    O_RGB <= S_RGB when (S_ON = '1') else
        LI_RGB when (Li_ON) = '1' else
        B_RGB when (B_ON = '1') else
        P_RGB when (P_ON = '1') else
        L_BACKGROUND_COLOUR;

    O_LED <= P_PIPE_PASSED;
end architecture;