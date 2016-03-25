ID_EX_stage: ID_EX
	PORT MAP(
         clk               => t_clk,
   
         --Data inputs
         Addr_in           => t_Addr_in
         RegData1_in       => t_RegData1_in
         RegData2_in       => t_RegData2_in,
         SignExtended_in   => t_SignExtended_in,
   
         --Register inputs (5 bits each)
         Rs_in             => t_Rs_in,
         Rt_in             => t_Rt_in,
         Rd_in             => t_Rd_in,
   
         --Control inputs (8 of them?)
         RegWrite_in       => t_RegWrite_in,
         MemToReg_in       => t_MemToReg_in,
         MemWrite_in       => t_MemWrite_in,
         MemRead_in        => t_MemRead_in
         Branch_in         => t_Branch_in,
         ALU_op_in         => t_ALU_op_in,
         ALU_src_in        => t_ALU_src_in,
         Reg_dest_in       => t_Reg_dest_in,
   
         --Data Outputs
         Addr_out          => t_Addr_out,
         RegData1_out      => t_RegData1_out,
         RegData2_out      => t_RegData2_out,
         SignExtended_out  => t_SignExtended_out,
   
         --Register outputs
         Rs_out            => t_Rs_out,
         Rt_out            => t_Rt_out,
         Rd_out            => t_Rd_out,
   
         --Control outputs
         RegWrite_out      => t_RegWrite_out,
         MemToReg_out      => t_MemToReg_out,
         MemWrite_out      => t_MemWrite_out,
         MemRead_out       => t_MemRead_out,
         Branch_out        => t_Branch_out,
         ALU_op_out        => t_ALU_op_out,
         ALU_src_out       => t_ALU_src_out,
         Reg_dest_out      => t_Reg_dest_out
	);
	  
EX_MEM_stage: EX_MEM
	PORT MAP(
		clk 				=> t_clk,

        Addr_in        		=> t_Addr_in,
         --ALU
         ALU_Result_in  	=> t_ALU_Result_in,
         ALU_HI_in      	=> t_ALU_HI_in,
         ALU_LO_in      	=> t_ALU_LO_in,
         ALU_zero_in   		=> t_ALU_zero_in,
         --Read Data
         Data_in			=> t_Data_in,
         --Register
         Rd_in          	=> t_Rd_in,

         Addr_out      		=> t_Addr_out,
         --ALU
         ALU_Result_out 	=> t_ALU_Result_out,
         ALU_HI_out     	=> t_ALU_HI_out,
         ALU_LO_out     	=> t_ALU_LO_out,
         ALU_zero_out   	=> t_ALU_zero_out,
         --Read Data
         Data_out       	=> t_Data_out,
         --Register
         Rd_out         	=> t_Rd_out
	);
	  
MEM_WB_stage: MEM_WB
	PORT MAP(
         clk				=> t_clk,

         --Data Memory
         wr_done_in     	=> t_wr_done_in,
         rd_ready_in    	=> t_rd_ready_in,
         Data_in        	=> t_Data_in,

         --ALU
         ALU_Result_in  	=> t_ALU_Result_in,
         ALU_HI_in      	=> t_ALU_HI_in,
         ALU_LO_in      	=> t_ALU_LO_in,
         ALU_zero_in    	=> t_ALU_zero_in,

         --Register
         Rd_in          	=> t_Rd_in,

         --Data Memory
         wr_done_out    	=> t_wr_done_out,
         rd_ready_out   	=> t_rd_ready_out,
         Data_out       	=> t_Data_out,

         --ALU
         ALU_Result_out 	=> t_ALU_Result_out,
         ALU_HI_out     	=> t_ALU_HI_out,
         ALU_LO_out     	=> t_ALU_LO_out,
         ALU_zero_out   	=> t_ALU_zero_out,

         --Register
         Rd_out         	=> t_Rd_out
	);