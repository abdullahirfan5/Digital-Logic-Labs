-----------------------------------
-- Author: Shabbir Hussain
-- Email: shabbir.hussain@mail.mcgill.ca
-- Description: This entity is a dual port synchronous memory
--              it holds the values of each pixel
--              it is written to by the game controller
--              it is read by the VGA controller
-----------------------------------

-- Import the necessary libraries
library ieee;
use ieee.std_logic_1164.all;


-- Declare entity
entity video_draw is
    Port (
            clk         : in std_logic; -- Clk for the system
            rst         : in std_logic; -- Resets the buffer


            -- Inputs
            pix_x    : in integer;
				pix_y    : in integer;

            -- Outputs
            data_read       : out std_logic_vector(2 downto 0)
        );
end video_draw;

architecture behaviour of video_draw is
begin

    -- Read Process
    process(clk,rst)
    begin

        if(rst = '1') then
            -- Write zero to the data_out port
            data_read <= (others => '0');
        elsif rising_edge(clk) then
		  
				-- Use this area to draw something. Below is an example
				-- of how to show 5 verical color bars
				if(pix_x < 128) then
					data_read <= "000";
				elsif (pix_x < 256) then
					data_read <= "001";
				elsif (pix_x < 384) then
					data_read <= "010";
				elsif (pix_x < 512) then
					data_read <= "100";
				else 
					data_read <= "111";
				end if;
				
				
        end if;

    end process;


end behaviour;
