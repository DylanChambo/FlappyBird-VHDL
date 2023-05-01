library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game is
    port (
        I_CLK : in std_logic;

        IO_DATA : inout std_logic;
        IO_MCLK : inout std_logic;

        O_LED : out std_logic;

        O_RED : out std_logic_vector(3 downto 0);
        O_GREEN : out std_logic_vector(3 downto 0);
        O_BLUE : out std_logic_vector(3 downto 0);
        O_H_SYNC : out std_logic;
        O_V_SYNC : out std_logic
    );
end game;

architecture behavior of game is
    signal S_RGB : std_logic_vector(11 downto 0);
    signal S_ON : std_logic;

    signal P_RGB : std_logic_vector(11 downto 0);
    signal P_ON : std_logic;

    signal LF_PIPE_GAP : std_logic_vector(7 downto 0);

    signal C_ON : std_logic;

    signal V_V_SYNC : std_logic;
    signal V_PIXEL_ROW : std_logic_vector(9 downto 0);
    signal V_PIXEL_COL : std_logic_vector(9 downto 0);

    signal M_LEFT : std_logic;
    signal M_RIGHT : std_logic;
    signal M_CURSOR_ROW : std_logic_vector(9 downto 0);
    signal M_CURSOR_COL : std_logic_vector(9 downto 0);

    signal L_CLK : std_logic := '1';
    signal L_RGB : std_logic_vector(11 downto 0);

    signal B_COLOUR : std_logic_vector(11 downto 0) := x"2AC";

begin
    square : entity work.square
        port map(
            I_V_SYNC => V_V_SYNC,
            I_PIXEL_ROW => V_PIXEL_ROW,
            I_PIXEL_COL => V_PIXEL_COL,
            I_CLICK => M_LEFT,
            O_RGB => S_RGB,
            O_ON => S_ON
        );

    pipes : entity work.pipes
        port map(
            I_V_SYNC => V_V_SYNC,
            I_PIXEL_ROW => V_PIXEL_ROW,
            I_PIXEL_COL => V_PIXEL_COL,
            I_PIPE_GAP_POSITION => LF_PIPE_GAP,
            O_RGB => P_RGB,
            O_ON => P_ON
        );

    -- Define the Linear Feeback Shift Register
    lfsr : entity work.lfsr
        port map(
            I_CLK => I_CLK,
            O_VAL => LF_PIPE_GAP
        );

    collision : entity work.collision
        port map(
            I_CLK => I_CLK,
            I_S_ON => S_ON,
            I_P_ON => P_ON,
            O_COL => C_ON
        );

        video : entity work.VGA_SYNC
            port map(
                I_CLK_25Mhz => L_CLK,
                I_RGB => L_RGB,

                O_RED => O_RED,
                O_GREEN => O_GREEN,
                O_BLUE => O_BLUE,
                O_H_SYNC => O_H_SYNC,
                O_V_SYNC => V_V_SYNC,
                O_PIXEL_ROW => V_PIXEL_ROW,
                O_PIXEL_COL => V_PIXEL_COL
            );

    mouse : entity work.mouse
        port map(
            I_CLK_25Mhz => L_CLK,
            I_RST => '0',
            IO_DATA => IO_DATA,
            IO_MCLK => IO_MCLK,
            O_LEFT => M_LEFT,
            O_RIGHT => M_RIGHT,
            O_CURSOR_ROW => M_CURSOR_ROW,
            O_CURSOR_COL => M_CURSOR_COL
        );

    clk_div : process (I_CLK)
    begin
        if (rising_edge(I_CLK)) then
            L_CLK <= not L_CLK;
        end if;
    end process;

    L_RGB <= S_RGB when (S_ON = '1') else
        P_RGB when (P_ON = '1') else
        B_COLOUR;

    O_V_SYNC <= V_V_SYNC;
    O_LED <= M_LEFT or M_RIGHT;

end architecture;