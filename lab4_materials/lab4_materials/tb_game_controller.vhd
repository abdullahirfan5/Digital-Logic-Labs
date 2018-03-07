library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

entity tb_game_controller is
end tb_game_controller;

architecture behaviour of tb_game_controller is
	component game_controller is
		Generic(

			-----------GRAPHICS-----------------------
		
			LETTER_WIDTH		: integer := 8;
			SPRITE_WIDTH		: integer := 32;
			SPRITE_HEIGHT		: integer := 16;
			
			BULLET_SIZE		: integer := 8;
			
			SCORE_LETTER_HEIGHT	: integer := 16;
			SCORE_VALUE_HEIGHT	: integer := 32;
			
			
			ALIEN_HEIGHT_TOP  	: integer := 80;
			ALIEN_HEIGHT_BOTTOM	: integer := 432;
			
			
			SHIP_HEIGHT		: integer := 448;
			DIV_HEIGHT		: integer := 458;
			LIVES_HEIGHT		: integer := 480;	
			
			ROW_MSB			: integer := 3;
			ROW_LSB			: integer := 1;
			COL_MSB			: integer := 4;
			COL_LSB			: integer := 1;			

         		SCREEN_WIDTH		: integer := 640;
         		SCREEN_HEIGHT		: integer := 480;		


			---------------GAMEPLAY----------------------

			ADDRESS_WIDTH 		: integer := 3;				
			ALIEN_MOVE_DELAY 	: integer := 3;  ---originally 8
			ALIEN_DOWN_DELAY 	: integer := 8

		);
    	
		Port(
        		clk		: in std_logic; -- Clock for the system
        		rst             : in std_logic; -- Resets the state machine

        		-- Inputs
        		shoot           : in std_logic; -- User shoot
        		move_left       : in std_logic; -- User left
        		move_right      : in std_logic; -- User right
		  
			pixel_x		: in integer; -- X position of the cursor
			pixel_y		: in integer; -- Y position of the cursor
      
		 	--Outputs
        		pixel_color		: out std_logic_vector (2 downto 0)
         
         
         	);

	end component;

	type state is (init, pre_game, gameplay, game_over);
	signal current_state : state;

	--Inputs
	signal clk_in : std_logic;
	signal rst_in : std_logic;
	signal shoot_in : std_logic;
	signal move_left_in : std_logic;
	signal move_right_in : std_logic;
	signal pixel_x_in : integer;
	signal pixel_y_in : integer;

	--Outputs
	signal pixel_color_out : std_logic_vector (2 downto 0);
	
	--Helpers
	signal alien_ypos : integer :=0;
	signal score : integer := 0;
	signal ALIEN_HEIGHT_BOTTOM : integer := 432;
	signal NUM_ALIENS    	: integer := 60;

	--Constants
	constant clk_period : time := 10 ns;

begin

	clk_process: process
	begin
		
		clk_in <= '0';
		wait for clk_period/2;
		clk_in <= '1';
		wait for clk_period/2;
	end process;

	dut: game_controller
		port map (
			clk => clk_in,
			shoot => shoot_in,
			rst => rst_in,
			move_left=> move_left_in,
			move_right => move_right_in,
			pixel_x => pixel_x_in,
			pixel_y => pixel_y_in,
			pixel_color => pixel_color_out
		);

	FSM: process(rst_in, clk_in)
    	begin
		
		if(rst_in = '1') then
            		current_state <= init;
		elsif rising_edge(clk_in) then
			case current_state is
               			 when init  =>
                     			current_state <= pre_game;
               			 when  pre_game =>
					if (shoot_in = '1') then -- Goes from pre_game to gameplay when shoot button is pressed
						current_state <= gameplay;
					end if;
                		when gameplay =>

					if (alien_ypos >= ALIEN_HEIGHT_BOTTOM) then -- Goes to game_over when aliens reach the bottom (I imagined all the aliens to be one block here)
						current_state <= game_over;
					end if;
					
					if (score = NUM_ALIENS) then -- Goes to game_over when all aliens have been killed
						current_state <= game_over;
					end if;
					
				when game_over =>					
					if (shoot_in = '1') then -- Goes back to init when shoot is pressed
						current_state <= init;
					end if;            		
			end case;
       		 end if;
    	end process;
	


	test: process
		begin
			rst_in <='1';
			shoot_in <= '0';
			wait for 10ns;
			assert current_state = init report "Error1" severity Error;

			rst_in <= '0';
			wait for 10ns;
			assert current_state = pre_game report "Error2" severity Error;

			shoot_in <= '1';
			wait for 10ns;
			assert current_state = gameplay report "Error3" severity Error;

			score <= NUM_ALIENS;
			shoot_in <= '0';
			wait for 10ns;
			assert current_state = game_over report "error4" severity Error;

			shoot_in <= '1';
			score <=0;
			wait for 10ns;
			assert current_state = init report "error5" severity Error;

			shoot_in <= '0';
			wait for 10ns;
			assert current_state = pre_game report "Error6" severity Error;

			shoot_in <= '1';
			wait for 10 ns;
			assert current_state = gameplay report "Error7" severity Error;

			shoot_in <= '0';
			alien_ypos <= 500;
			wait for 10ns;
			assert current_state = game_over report "error8" severity Error;
			
			rst_in <= '1';
			alien_ypos <= 0;
			wait for 10ns;
			assert current_state <= init report "Error9" severity Error;

			assert false report "Success" severity Failure;
	end process;
end behaviour;
		
