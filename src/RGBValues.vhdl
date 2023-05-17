library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

package RGBValues is
    constant PIPE_RGB : std_logic_vector(11 downto 0) := x"5E2";
    constant BACKGROUND_RGB : std_logic_vector(11 downto 0) := x"2AC";
    constant MOUSE_RGB : std_logic_vector(11 downto 0) := x"000";
    constant MENU_BACKGROUND_RGB : std_logic_vector(11 downto 0) := x"FFF";
    constant MENU_TRAIN_BUTTON_RGB : std_logic_vector(11 downto 0) := x"F00";
    constant MENU_PLAY_BUTTON_RGB : std_logic_vector(11 downto 0) := x"0F0";
    constant MENU_BUTTON_ONCLICK_RGB : std_logic_vector(11 downto 0) := x"AAA";
    constant HEART_SPRITE_RGB : std_logic_vector(11 downto 0) := x"F00";
    constant BIRD_RGB : std_logic_vector(11 downto 0) := x"93A";
    constant BIRD_EYE_RGB : std_logic_vector(11 downto 0) := x"000";
    constant BIRD_BEAK_RGB : std_logic_vector(11 downto 0) := x"FF0";

end package RGBValues;