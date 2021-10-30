This is the Graphical User Interface (GUI) for the Sense2GoL kit based on 
Micrium µC/Probe™.

Please ensure that the GUI project file (*.wpsx) and the FW file (*.elf) are 
always located in the same folder. Otherwise GUI will not work.

After building a project, object files and an application binary file
(typically in ELF format) exist under DAVE project/S2GL_Doppler/Build folder.

Please ensure to import the S2GL_Doppler.elf file into your GUI Micrium-based 
project each time you modify and build your S2GL_Doppler Project.

Note: This GUI will not work for the FW version 1.0.0 which comes by default 
      with most of the S2GL boards. 
      In case you see strange time domain signals when using this GUI, the FW 
      on your kit is most probably not matching. Thus, please update the FW of
      your board as described in the Sense2GoL Kit, Getting started section.

Infineon Toolbox also offers the Micro Inspector Tool that could be used as 
alternative to Micrium µC/Probe™.
  

  
