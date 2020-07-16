LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL; 

ENTITY UART_tb IS
END UART_tb;

ARCHITECTURE uart_arc OF UART_tb IS
	CONSTANT clk_f : integer := 40;
	COMPONENT UART IS
		GENERIC(clk_freq  : integer := clk_f);
	
		PORT (
			clk		    : IN  std_logic;
			nrst		: IN  std_logic;
			start_bit	: IN  std_logic;
			data_in		: IN  std_logic_vector(7 DOWNTO 0);
			baud		: IN  std_logic_vector(7 DOWNTO 0);
			io		    : INOUT  std_logic;
			data_out	: OUT std_logic_vector(7 DOWNTO 0);
			data_ready	: OUT std_logic
		);
	END COMPONENT;

	SIGNAL clk_tb			: std_logic := '0';
	SIGNAL nrst_tb			: std_logic;
	SIGNAL t_start_bit_tb	: std_logic;
	SIGNAL r_start_bit_tb	: std_logic;
	SIGNAL t_data_in_tb		: std_logic_vector(7 DOWNTO 0);
	SIGNAL r_data_in_tb		: std_logic_vector(7 DOWNTO 0);
	SIGNAL baud_tb			: std_logic_vector(7 DOWNTO 0) := "00000001";
	SIGNAL io_tb            : std_logic;
	SIGNAL t_data_out_tb	: std_logic_vector(7 DOWNTO 0);
	SIGNAL r_data_out_tb	: std_logic_vector(7 DOWNTO 0);
	SIGNAL t_data_ready_tb	: std_logic;
	SIGNAL r_data_ready_tb	: std_logic;

BEGIN
	UUT_T: UART GENERIC MAP (clk_f)
		  PORT MAP (
				clk_tb,
				nrst_tb,
				t_start_bit_tb,
				t_data_in_tb,
				baud_tb,
				io_tb,
				t_data_out_tb,
				t_data_ready_tb
			);
			
	UUT_R: UART GENERIC MAP (clk_f)
		  PORT MAP (
				clk_tb,
				nrst_tb,
				r_start_bit_tb,
				r_data_in_tb,
				baud_tb,
				io_tb,
				r_data_out_tb,
				r_data_ready_tb
			);
			
	-------- clock process ---------	
	PROCESS
		CONSTANT period : time := 10 ns;
	BEGIN
		clk_tb <= '0';
		WAIT FOR period;
		clk_tb <= '1';
		WAIT FOR period;
	END PROCESS;
	
	------- stimulus process --------
	PROCESS
	BEGIN
		nrst_tb <= '0', '1' AFTER 35 ns;
		baud_tb <= "00000001", "00010100" AFTER 10 ns;

		t_start_bit_tb <= '0', '1' AFTER 55 ns;
		t_data_in_tb <= "01101010";
		
		WAIT FOR 1400 ns;
		nrst_tb <= '0', '1' AFTER 35 ns;
		t_data_in_tb <= "11001000";
		
		WAIT FOR 800 ns;
		t_start_bit_tb <= 'Z';
		r_start_bit_tb <= '1';
		WAIT FOR 10 ns;
		nrst_tb <= '0', '1' AFTER 35 ns;
		r_data_in_tb <= "10000000";
		
		WAIT;
	END PROCESS;
	
END uart_arc;