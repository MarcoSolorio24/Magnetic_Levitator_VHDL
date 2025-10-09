# Magnetic_Levitator_VHDL

Develop a code to implement and control a magnetic levitator with Intel FPGA D10 Lite

#About the Project

The project is a Magnetic Levitator controller with a FPGA D10 LITE in VHDL, the fisical model 
of the Magentic Levitator contain a Hall sensor, electromagnet and a PCB with mosfets that will be controlled
with the FPGA through PWM (50KHz).
So the FPGA have the PWM output to controll the power of the MagneticLevitator, a Hall Sensor that give a voltage at 
the FPGA could read through a chip MCP3001 that is a ADC of 12 Bits with SPI. 

The file Magentic Levitator is the main Entity of all the project and the others entities
are important to develop specific functions.
