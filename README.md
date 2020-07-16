# UART-T0_Standard
Digital Systems Design Course

The system's goal is transferring 8-bit data from one PC to another and Each UART module consists of 2 submodules: Transmitter(P2S) and Receiver(S2P)

Here we have a parity bit for error checking. also, both transferring and receiving have done in the same baud rate.

Another important thing about this system is the single shared bus for receiving and transferring that is defined as an INOUT signal in VHDL.

Other details about the system such as states of FSM and the way for handling shared bus are in the main code and we have some subtle scenarios in th test bench file to check the code's functionality.
