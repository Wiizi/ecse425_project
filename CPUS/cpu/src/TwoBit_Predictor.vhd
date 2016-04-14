LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

--TO BE COMPLETE

entity TwoBit_Predictor is
	port(
		clk : in std_logic;
		branch : in std_logic;
		--actual result corresponding to the last prediction that was computed
		last_pred 		 : in integer range 0 to 3 := 0;
		actual_taken	 : in std_logic; -- 0 for not taken, 1 for taken

		branch_outcome   : out std_logic;
		pred_validate	 : out integer range 0 to 3 := 0
		);
end TwoBit_Predictor;

architecture Behavioural of TwoBit_Predictor is
signal state : integer range 0 to 3 := 0;
begin
	pred_validate <= state;

	-- assynchronous output
	process(state)
	begin
		--only predict when the instruction is beq "000100" or bne "000101"
		case state is
			when 0 =>
				branch_outcome <= '0';
			when 1 =>
				branch_outcome <= '0';
			when 2 =>
				branch_outcome <= '1';
			when 3 =>
				branch_outcome <= '1';
			when others => null;
		end case;
	end process;

	process(branch)
	begin
		--only predict when the instruction is beq "000100" or bne "000101"
		if (rising_edge(branch)) then
			case state is
				when 0 =>
					if (actual_taken = '0') then
						state <= 0;
					elsif (actual_taken = '1') then
						state <= 1;
					end if;
				when 1 =>
					if (actual_taken = '0') then
						state <= 0;
					elsif (actual_taken = '1') then
						state <= 3;
					end if;
				when 2 =>
					if (actual_taken = '0') then
						state <= 0;
					elsif (actual_taken = '1') then
						state <= 3;
					end if;
				when 3 =>
					if (actual_taken = '0') then
						state <= 2;
					elsif (actual_taken = '1') then
						state <= 3;
					end if;
				when others => null;
			end case;
		end if;
	end process;

end Behavioural;