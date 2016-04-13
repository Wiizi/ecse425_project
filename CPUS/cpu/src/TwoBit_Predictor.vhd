LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

--TO BE COMPLETE

entity TwoBit_Predictor is
	port(
		clk			 	 : in std_logic;
		reset 			 : in std_logic;
		OpCode			 : in std_logic_vector(5 downto 0);
		--actual result corresponding to the last prediction that was computed
		last_pred 		 : in integer range 0 to 3;
		actual_taken	 : in std_logic; -- 0 for not taken, 1 for taken

		branch_outcome   : out std_logic := '0';
		pred_validate	 : out integer range 0 to 3
		);
end TwoBit_Predictor;

architecture Behavioural of TwoBit_Predictor is

begin
	process(clk, reset, OpCode, last_pred, actual_taken)
	begin
		pred_validate <= 0;
		branch_outcome <= '0';

		--only predict when the instruction is beq "000100" or bne "000101"
		if ((OpCode = "000100") or (OpCode = "000101")) then
			case last_pred is
				when 0 =>
					if (actual_taken = '0') then
						pred_validate <= 0;
					elsif (actual_taken = '1') then
						pred_validate <= 1;
					end if;
					branch_outcome <= '0';
				when 1 =>
					if (actual_taken = '0') then
						pred_validate <= 0;
					elsif (actual_taken = '1') then
						pred_validate <= 3;
					end if;
					branch_outcome <= '0';
				when 2 =>
					if (actual_taken = '0') then
						pred_validate <= 0;
					elsif (actual_taken = '1') then
						pred_validate <= 3;
					end if;
					branch_outcome <= '1';
				when 3 =>
					if (actual_taken = '0') then
						pred_validate <= 2;
					elsif (actual_taken = '1') then
						pred_validate <= 3;
					end if;
					branch_outcome <= '1';
				when others => null;
			end case;
		else
			pred_validate <= last_pred;
			branch_outcome <= actual_taken;
		end if;
	end process;

end Behavioural;