----------------------- Digital Systems Design -----------------------
------------------- Designing UART T0-Standard System ----------------
----------------- By Shiva Zeymaran & Vahide Hanifzade ---------------
---------------------------- Spring 2020 -----------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL; 

ENTITY UART IS
	GENERIC(clk_freq  : integer);

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
END UART;

ARCHITECTURE uart_arc OF UART IS

	--FSM
	TYPE state_type IS (idle, start, bit0, bit1, bit2, bit3, bit4, bit5, bit6, bit7, parity, waiting, stop);
	SIGNAL t_state, r_state 				: state_type;
	SIGNAL t_next_state, r_next_state 		: state_type;

	SIGNAL t_data_reg, r_data_reg 			: std_logic_vector(7 DOWNTO 0);
	SIGNAL baud_rate    					: integer;
	SIGNAL tick 		  					: integer;
	SIGNAL t_tick_counter, r_tick_counter	: integer;
	SIGNAL tx_sig                           : std_logic := '1';
	
	TYPE mode IS (send, receive);
	SIGNAL uart_mode 						: mode := send;
	SIGNAL tx, rx							: std_logic;

BEGIN
	baud_rate <= to_integer(unsigned(baud));
	tick 	  <= (clk_freq / baud_rate); 
	
	io <= tx WHEN uart_mode = send ELSE 'Z';
	rx <= io;
	
	-- sequential
	seq: PROCESS (clk)
	BEGIN
		IF clk = '1' THEN
			IF nrst = '0' THEN
				t_tick_counter <= 0;
				r_tick_counter <= 0;
				t_state <= idle;
				r_state <= idle;
			ELSE
				t_data_reg <= data_in;
				t_state <= t_next_state;
				r_state <= r_next_state;

				----- tick counter logic for transmitter
				IF t_state = idle THEN
					t_tick_counter <= 0;
				ELSE
					IF t_tick_counter = tick THEN
						t_tick_counter <= 0;
					ELSE
						t_tick_counter <= t_tick_counter + 1;
					END IF;
				END IF;

				----- tick counter logic for receiver
				IF r_state = idle THEN
					r_tick_counter <= 0;
				ELSE
					IF r_tick_counter = tick THEN
						r_tick_counter <= 0;
					ELSE
						r_tick_counter <= r_tick_counter + 1;
					END IF;
				END IF;

			END IF;
		END IF;
	END PROCESS seq;

	------------------------------------------------ Transmitter -------------------------------------------
	comb_transmitter: PROCESS(tick, rx, t_tick_counter, start_bit, t_state, t_data_reg, tx_sig)
		VARIABLE parity_val : std_logic;
	BEGIN
		IF start_bit = '1' THEN                 -- transmitter should be reset before each transmission
			IF t_state = idle THEN
				uart_mode <= send;
				t_next_state <= start;
				tx <= '0';
			ELSE
				IF t_tick_counter = tick THEN
					IF t_state = start THEN
						t_next_state <= bit0;
						tx <= t_data_reg(0);

					ELSIF t_state = bit0 THEN
						t_next_state <= bit1;
						tx <= t_data_reg(1);

					ELSIF t_state = bit1 THEN
						t_next_state <= bit2;
						tx <= t_data_reg(2);

					ELSIF t_state = bit2 THEN
						t_next_state <= bit3;
						tx <= t_data_reg(3);

					ELSIF t_state = bit3 THEN
						t_next_state <= bit4;
						tx <= t_data_reg(4);

					ELSIF t_state = bit4 THEN
						t_next_state <= bit5;
						tx <= t_data_reg(5);

					ELSIF t_state = bit5 THEN
						t_next_state <= bit6;
						tx <= t_data_reg(6);

					ELSIF t_state = bit6 THEN
						t_next_state <= bit7;
						tx <= t_data_reg(7);

					ELSIF t_state = bit7 THEN
						parity_val := t_data_reg(0);
						FOR i IN 1 TO 7 LOOP
							parity_val := t_data_reg(i) XOR parity_val;
						END LOOP;
						t_next_state <= parity;
						tx <= parity_val;

					ELSIF t_state = parity THEN
						t_next_state <= waiting;
						uart_mode <= receive; -- change transmitter mode to receive for now

					ELSIF t_state = waiting THEN
						IF rx = '0' THEN  -- retransmit data
							t_next_state <= start;
							tx <= '0';
						ELSE  -- transmission end
							t_next_state <= stop;
							tx <= '1';
						END IF;
						uart_mode <= send; -- change transmitter mode back to send

					ELSE  -- state = stop
					END IF;
				END IF;
			END if;
		ELSIF start_bit ='0' THEN   -- transmitter should change start_bit to '0' when don't want to send
			tx <= '1';	
			uart_mode <= send;
		ELSE  -- receiving mode
			tx <= tx_sig;
			IF tx_sig = '0' THEN
				uart_mode <= send;
			ELSE
				uart_mode <= receive;
			END IF;
		END IF;
	END PROCESS comb_transmitter;
	

	---------------------------------------------- Receiver -----------------------------------------------
	comb_reciever: PROCESS (tick, start_bit, r_tick_counter, rx, r_state, r_data_reg)
		VARIABLE parity_val : std_logic;
		VARIABLE parity_chk	: std_logic;
	BEGIN
		IF start_bit /= '0' AND start_bit /= '1' THEN
			IF r_state = idle THEN
				tx_sig <= '1';  -- to change the receiver mode into receive
				IF rx = '0' THEN
					r_next_state <= start;
					r_data_reg <= (OTHERS => '0');
				END IF;
			ELSE
				IF r_tick_counter = tick THEN
					IF r_state = start THEN
						r_next_state <= bit0;
						r_data_reg(0) <= rx;

					ELSIF r_state = bit0 THEN
						r_next_state <= bit1;
						r_data_reg(1) <= rx;

					ELSIF r_state = bit1 THEN
						r_next_state <= bit2;
						r_data_reg(2) <= rx;
						
					ELSIF r_state = bit2 THEN
						r_next_state <= bit3;
						r_data_reg(3) <= rx;
						
					ELSIF r_state = bit3 THEN
						r_next_state <= bit4;
						r_data_reg(4) <= rx;
						
					ELSIF r_state = bit4 THEN
						r_next_state <= bit5;
						r_data_reg(5) <= rx;
						
					ELSIF r_state = bit5 THEN
						r_next_state <= bit6;
						r_data_reg(6) <= rx;
						
					ELSIF r_state = bit6 THEN
						r_next_state <= bit7;
						r_data_reg(7) <= rx;

					ELSIF r_state = bit7 THEN
						r_next_state <= parity;
						parity_chk := rx;				

					ELSIF r_state = parity THEN 
						parity_val := r_data_reg(0);
						FOR i IN 1 TO 7 LOOP
							parity_val := r_data_reg(i) XOR parity_val;
						END LOOP;	
						parity_val := '1';     -- to test retransmition
						IF parity_val = parity_chk THEN
							data_ready <= '1';
							r_next_state <= stop;
						ELSE
							r_next_state <= waiting;
							tx_sig <= '0';     -- also change receiver mode to send
						END IF;

					ELSIF r_state = waiting THEN
						IF rx = '0' THEN
							r_next_state <= idle;
						END IF;

					ELSE -- state = stop
						data_out <= r_data_reg;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS comb_reciever;

END uart_arc;