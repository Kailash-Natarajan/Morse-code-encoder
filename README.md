# Morse-code-encoder
This is a 8051 Microcontroller based Morse Code encoder using 4x4 keypad. Output is provided using LED's. Three LED's are used although one LED is enough.
The MORSE LED is used for the morse code output where if it glows for one time unit, it signifies dot and if it glows for three time units, it signifies dash.
Now the other two LEDs namely DOT and DASH just glow whenever the MORSE LED glows for DOT and DASH respectively. Its purpose is to just help identify if the MORSE LED is indicating for DOT or DASH.

This project was simulated in proteus. First hex file was generated from Keil microvision IDE. Then the circuit was made in Proteus software and was simulated.
Here is the circuit. Ignore the words AT89S52 (it was just renamed)

![morsecodecircuit](https://user-images.githubusercontent.com/66203530/124294797-bb011900-db75-11eb-8f91-f8d7e8057bf4.jpg)

The uniqueness of this project is that, even though only 16 inputs are available using keypad, 26 alphabets and 10 decimal numbers can be given as input based on the position of the switch. Essentially the keypad configuration changes depending on the position of the three way rotary switch as shown below.

![image](https://user-images.githubusercontent.com/66203530/124295306-52ff0280-db76-11eb-92f6-88142f0427be.png)

This way all the characters that are possible to be output as Morse code can be used.
