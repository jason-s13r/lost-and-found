'(
 ====================================================================
 1. Title Block
 Author : Jason
 Date : 17 / October / 2006
 Version : 1.0
 File Name : Transmitter.bas
 ====================================================================
 2. Program Description:

 3. Hardware Features:
 * Ldr_enc ,(pinb.1) Is Connected To Encoder Pin 4 , Which Transmits
   To Decoder Pin 4,
 * Which Is Connected To Atmega8535 Pinb.0
 * Switch_enc ,(pinb.0) Is Connected To Encoder Pin 3 , Which Transmits
   To Decoder Pin 3,
 * Which Is Conected To Atmega8535 Pinb.1
 4. Software Features:
 ====================================================================
')
' 5. Compiler Directives (these tell Bascom things about our hardware)
$crystal = 1200000                      ' internal clock
$regfile = "attiny13.dat"               ' ATTINY13V
$hwstack = 16
$swstack = 8
$framesize = 24
'------------------------------------------------------------------
' 6. Hardware Setups
' setup direction of all ports
Config Portb = Output                   'portB
Config Pinb.3 = Input                   'LDR
Config Pinb.4 = Input                   'Uswitch
Config Adc = Single , Prescaler = Auto
Start Adc
' 7. Hardware Aliases
Switch_enc Alias Portb.0                'enc pin 3
Ldr_enc Alias Portb.1                   'enc pin 4
Te Alias Portb.2                        'enc te
Micro_switch Alias Pinb.4               'Microswitch/Milk-in
' 8. Initialise ports so hardware starts correctly
Portb = &B000100                        'turns off LEDs
'------------------------------------------------------------------
' 9. Declare Constants
Const Timedelay = 1
'------------------------------------------------------------------
' 10. Declare Variables
'variable lightlevel which will change
Dim Lightlevel As Word
' 11. Initialise Variables
'------------------------------------------------------------------
' 12. Program starts here

Do
'(
This Debounce Represents The Microswitch That Is Attached To The Back -door
Of The Letterbox.
When The Door Is Opened , The Microswitch Triggers The Attiny13v To Send A
Messege Of "Milk: Received" Which Is Received By The Receiver
[and Displayed On The Lcd].
')

   Debounce Micro_switch , 1 , Switch_te , Sub
'(
This Select -case Statement Is Used To Represent The Ldr...
When The Letterbox Mail -in Flap Is Opened , Light Will Beam Onto The Ldr
Which Will Sent A "Mail Received" Messege To The Receiver.
The Light Will Only Affect The Ldr If It Is Greater Than "128" On The Adc.
')

'number from 0 to 1023 represents the light level
   Lightlevel = Getadc(3)
   Select Case Lightlevel
'No Transmit (under NO/Dark light, transmit)
      Case 0 To 127 : Gosub No_te
'Transmit (under Bright light, no transmit)
      Case Else : Gosub Ldr_te
   End Select

Loop
End

'------------------------------------------------------------------
' 13. Subroutines

'(
This Subroutine Controls The Sending Of Ldr -mail Data , After The Lightlevel
Data Has Been Processed It Sends The Bit Which Is The "messege" That
The Receiver Is Waiting To Hear
')
Ldr_te:
   Set Ldr_enc                          'sends 'high' on encoder pin4
   Reset Te                             'sets TE as 'low'
   Waitms 20
   Set Te                               'sets TE as 'high'
   Waitms 50
   Reset Ldr_enc                        'resets 'low' on encoder pin4
Return

'(
This Subroutine Is To Cancel Out The Ldr Whenever It Is Not The Right
Lightlevel For The Data Required.
')
No_te:
   Waitus 1
Return

'(
This Subroutine Controls The Sending Of Switch -milk Data , After The
Microswitch Data Has Been Processed It Sends The Bit Which Is The "messege"
That The Receiver Is Waiting To Hear
')
Switch_te:
   Set Switch_enc                       'sends 'high' on encoder pin3
   Reset Te                             'sets TE as 'low'
   Waitms 20
   Set Te                               'sets TE as 'high'
   Waitms 50
   Reset Switch_enc                     'resets 'high' on encoder pin3
Return


'(
 * Ldr_enc ,(pinb.1) Is Connected To Encoder Pin 4 , Which Transmits
   To Decoder Pin 4,
 * Which Is Connected To Atmega8535 Pinb.0

 * Switch_enc ,(pinb.0) Is Connected To Encoder Pin 3 , Which Transmits
   To Decoder Pin 3,
 * Which Is Conected To Atmega8535 Pinb.1
')
