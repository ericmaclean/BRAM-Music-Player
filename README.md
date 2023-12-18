# BRAM-Music-Player

The following is a project built on the Lattice ICE40HX1K FPGA board. The project uses a UART module to allow the user to select notes on their keyboard 
which are then read into a inferrred block RAM. The BRAM is then read sequentially and looped through continously sending the audio signals through the PMOD port. 
I attatched two 4 Ohm 2 Watt speakers to the PMOD port to hear the audio signals. 3 Pushbuttons are utlized, the first is used to increment through the BRAM to visualize 
the stored data on the 7 segment display. The second pushbutton allows the user to enable the read single on the BRAM, unpressed this does not allow the PMOD output or 7 segment 
display to use the stored data. The third pushbutton causes the BRAM to read sequentially and continously sends the corresponding signals to the PMOD. When the user is typing to fill up the BRAM, 
each keypress corresponds to an 8 bit ASCII value which is encoded to represent a note. abcdefg are encoded to represent A4-G4 notes. ACDFG are encoded to represent the sharps, the 
user can then store up to 16 notes of that octave in the BRAM. The UART stop bits cause the BRAM to increment, so as long as the user keeps pressing keys the BRAM will update that 
storage position and increment. 
