'(
 ====================================================================
 1. Title Block
 Author : Jason S
 Date : 16 / Octobe / 2006
 Version : 1.0
 File Name : Receiver.bas
 ====================================================================
 2. Program Description:
 * This Receiver Will Take The Data Transmitted From The
   Letterbox / Transmitter
   and display either "Mail: Received" or "Milk: Received"
 * This Data Is Displayed On The Lcd Screen [a 16x By 2y Screen]
 * These Notifications Let The User Know When They Have Received
   Eiter Mail Or Milk Into Their Letter Box.
 ====================================================================
 3.. Hardware Features
 16 * 2 Lcd Display On Portc
 Holtek Ht12d Decoder
 4. Software Features:
  This Uses Polling To Receive The Transmitted Data And Then Displays
  The Data On The Lcd.
  ====================================================================
')
'5. Compiler Directives (these tell Bascom things about our hardware)
$crystal = 8000000                      ' internal clock
$regfile = "m8535.dat"                  ' ATMEGA16
'------------------------------------------------------------------
' 6. Hardware Setups
' setup direction of all ports
Config Porta = Input
Config Portb = Input                    ' Valid data is input on this port
Config Portc = Output                   ' Used for LED's and LCD
' PortD.2 is used for Data  Valid input
Config Portd = Input
' 7. Hardware Aliases
'pin from decoder that represents "LDR" on transmitter
Ldr_dec Alias Pinb.0
'pin from decoder that represents "Switch" on transmitter
Switch_dec Alias Pinb.1
Vt Alias Pind.2
' 8. initialise ports so hardware starts correctly
Portb = &H00                            '?needed?
Portc = &HFF                            ' turns off LED's
Portd = &HFF                            ' set Internal Pullup resistor
Config Lcdpin = Pin , Db4 = Portc.4 , Db5 = Portc.5 , Db6 = Portc.6 , Db7 = Portc.7 , E = Portc.3 , Rs = Portc.2
Config Lcd = 16 * 2
Portc = &HFF                            ' Turn off LED's on PortC.0 & PortC.1
                                        '&HFF = &B11111111
'------------------------------------------------------------------
' 9. Declare Constants
Const Vt_true = 1
Const Vt_false = 0
' 10. Declare Variables
'variable used to store the received value
Dim Rcvd_value As Byte
' 11. Initialise Variables
'get received value from pins we want to know about ;)
Rcvd_value = Pinb And &H03
Cursor Off
'------------------------------------------------------------------
' 12. Program starts here
Cls
'Do-loop to keep program running
Do
'(
Reverse -logic On While Statements Here:
While There Is False Transmittion Data , Loop Until There Is True Data.
and opposite for the second while-wend loop.
')
   While Vt = Vt_false                  ' Wait until a valid value
   Wend                                 ' has been decoded
'(
These Following 3 Lines Correspond To The Received Data From The Transmitter.
If The Value Of Portb / Is Correct To What Is Wanted Per Messege,
Then It Is Sent Through .. : S
')
'get received value from LDR and uSwitch pins...
   Rcvd_value = Pinb And &H03
'If Ldr pin...
   If Rcvd_value = &H01 Then Gosub Ldr
'if Uswitch Pin...
   If Rcvd_value = &H02 Then Gosub Switch
'wait until data no longer valid
   While Vt = Vt_true
   Wend

Loop                                    'Do-Loop
End                                     'end program

'-------------------------------------------------------------------
'Subroutines
'(
Subroutine For Displaying The "Mail: Received" Messege
')
Ldr:
   Cls
   Locate 1 , 1
   Lcd "Mail: Recieved"
   Waitms 50
   Rcvd_value = 0
Return

'(
Subroutine For Displaying The "Milk: Received" Messege
')
Switch:
   Cls
   Locate 2 , 1
   Lcd "Milk: Recieved"
   Waitms 50
   Rcvd_value = 0
Return
