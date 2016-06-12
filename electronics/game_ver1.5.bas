'------------------------------------------------------------------
' 1. Title Block
' Author: Jason Schwarzenberger
' Date: 8 May 2006
' File Name: game_ver1.5.bas
'------------------------------------------------------------------
' 2. Program Description:
' All versions are currently demos
' Version 1.4 Has full Questions & Answers (10 Q + 10 A)
'---------
' **Changelog from Version 1.0 to 1.1:
'     * Version 1.1 includes a menu screen, so user can select either
'       Instructions or Quiz.
' **Changelog from Version 1.1 to 1.2:
'     * Version 1.2 includes actual instuctions that may be used.
'     * Version 1.2 Menu screen fixed. :D
' **Changelog from Version 1.2 to 1.3:
'     * Version 1.3 instructions fixed so all 5 show
'     * Version 1.3 added 6th instruction
'     * Added question+abswer schedule
' **Changelog from Version 1.3 to 1.4:
'     * Fixed Question/Answer printout so it doesn't
'       keep pinting new Qestion.
'     * Finished adding all Questions & Answers.
'     * Created 'Show score and continue' and 'Show score and end'
'       buttons - they work!
' **Changelog from Version 1.4 to 1.5:
'     * Rounded Score_per (percentage of Score) <Score_per = Round(score_per)>
'     * Version 1.5 is final version of DEMOs.
'---------
' 3. Hardware Features:
' LEDS
' LDR, Thermistor on ADC
' 5 switches
' LCD
' 4. Program Features
' do-loop to keep program going forever
' debounce to test switches
' if-then-endif to test variables
'------------------------------------------------------------------
' 5. Compiler Directives (these tell Bascom things about our hardware)
$crystal = 8000000                      'the speed of the micro
$regfile = "m16def.dat"                 'our micro, the ATMEGA8535-16PI
'------------------------------------------------------------------
' 6. Hardware Setups
' setup direction of all ports
Config Porta = Output                   'LEDs on portA
Config Portb = Output                   'LEDs on portB
Config Portc = Output                   'LEDs on portC
Config Portd = Output                   'LEDs on portD
'config inputs
Config Pina.0 = Input                   ' ldr
Config Pind.2 = Input                   'switch A
Config Pind.3 = Input                   'switch B
Config Pind.6 = Input                   'switch C
Config Pinb.1 = Input                   'switch D
Config Pinb.0 = Input                   'switch E
'LCD
Config Lcdpin = Pin , Db4 = Portc.4 , Db5 = Portc.5 , Db6 = Portc.6 , Db7 = Portc.7 , E = Portc.1 , Rs = Portc.0
Config Lcd = 40 * 2                     'configure lcd screen
'ADC
Config Adc = Single , Prescaler = Auto , Reference = Internal
Start Adc

' 7. Hardware Aliases
Led3 Alias Portd.4

Sw_e Alias Pinb.0
Sw_d Alias Pinb.1
Sw_a Alias Pind.2
Sw_b Alias Pind.3
Sw_c Alias Pind.6

Spkr Alias Portd.7                      'refer to spkr not PORTd.7

' 8. initialise ports so hardware starts correctly
Porta = &B11111111                      'turns off LEDs
Portb = &B11111111                      'turns off LEDs ignores switches
Portc = &B11111111                      'turns off LEDs
Portd = &B11111111                      'turns off LEDs ignores switches
'because the speaker is driven thru a transistor in the uln2803
'to power it off we put the output low (this turns on the led)
Reset Spkr                              'important to power off the speaker
Cursor Off Noblink                      'clear lcd screen
Cls
'Lcd "Start:"
'Wait 5
'------------------------------------------------------------------
' 9. Declare Constants
Const Btndelay = 15
Const Welcome = 0
Const Menu = 1
Const Instructions = 2
Const Gpcls = 3
Const Gameplay = 4
Const Score_state = 5
'------------------------------------------------------------------
' 10. Declare Variables
Dim Ran As Byte
Dim State As Byte
Dim Instruc As String * 40
Dim Instruc_selec As Byte
Dim Score As Byte
Dim Score_per As Single
Dim Question_num As Byte
Dim Question_1 As String * 40
Dim Answer_1 As String * 40
Dim Question_num1 As Byte
Dim Q_ran As Byte
'Dim Var As Byte
' 11. Initialise Variables
Ran = 0
'Var = 6
State = Welcome
Instruc = "Instructions"
Instruc_selec = 0
Score = 0
Score_per = 0
Question_num = 11
Question_1 = "0"
Answer_1 = "0"
Question_num1 = 1
Q_ran = 11
'------------------------------------------------------------------
' 12. Program starts here
Cls
Do
   Ran = Rnd(10)
   Incr Ran
   Debounce Sw_a , 0 , Btn_a , Sub      'selects option A
   Debounce Sw_b , 0 , Btn_b , Sub      'selects option B
   Debounce Sw_c , 0 , Btn_c , Sub      'selects option C
   Debounce Sw_d , 0 , Btn_d , Sub      'shows score during game then ends game
   Debounce Sw_e , 0 , Score , Sub      'shows score during game, continues with game
   Select Case State
      Case Welcome : Gosub Disp_welcome
      Case Menu : Gosub Menu_home
      Case Instructions : Gosub Disp_instructions
      Case Gpcls : Gosub Gp_cls
      Case Gameplay : Gosub Game_play
      Case Score_state : Gosub Score
      'Case Var : Gosub Label
   End Select
Loop
'------------------------------------------------------------------
' 13. Subroutines
Disp_welcome:
   Cls
   Locate 1 , 15
   Lcd "Physics Quiz (demo)"
   Locate 2 , 2
   Lcd "Version 1.5 | By Jason Schwarzenberger"
   State = Menu
   Wait 5
   Cls
   Question_num1 = 1
   Score = 0
Return

Menu_home:
   Locate 1 , 1
   Lcd "Physics Quiz. Version 1.5 (Demo)"
   Locate 2 , 1
   Lcd "A: Instructions | B = quiz"
Return


'displays 1 of 6 lines of instruction on LCD
Disp_instructions:
   Cls
   Instruc_selec = 0
   Do
      Gosub Select_instruction
      Cls
      Locate 1 , 14
      Lcd "Instructions:"
      Locate 2 , 1
      Lcd Instruc
      Wait 3
      Incr Instruc_selec
      If Instruc_selec = 6 Then
         State = Menu
         Exit Do
      End If
   Loop
Return

'chooses the 1 of 6 instructions
Select_instruction:
   Select Case Instruc_selec
      Case 0 : Instruc = "Use Buttons A B C to select answer"
      Case 1 : Instruc = "Select correct answer to increase score"
      Case 2 : Instruc = "Game ends after 10 questions"
      Case 3 : Instruc = "You win when score is >6, loose if <6"
      Case 4 : Instruc = "Score shown as % and /10 when game over"
      Case 5 : Instruc = "HOME shows score then menu"
   End Select
Return

Gp_cls:
   Cls
   State = Gameplay
Return


'display a random question and 3 multichoice answers
'checks 3 switchs to see if one is pressed
'if correct, increase score, keeps track of number of questions answered
'if incorrect, track number of questions answered

Game_play:
   If Q_ran = Question_num Then         'Continues with old Question if unanswered & clears screen
      If Q_ran = 11 Then
         Q_ran = Ran
         Gosub Question
      End If
   Else
      Cls
      Gosub Question                    'selects new question
   End If
   Locate 1 , 1
   Lcd Question_1
   Gosub Answer
   Locate 2 , 1
   Lcd Answer_1
   Locate 1 , 38
   Lcd Question_num1
   Gosub Check_ques_end
Return

Btn_a:
   If State = Menu Then
      Cls
      State = Instructions
   End If
   If State = Gameplay Then
      Select Case Question_num
         Case 0 : Gosub Correct
         Case 1 To 3 : Gosub Wrong
         Case 4 : Gosub Correct
         Case 5 : Gosub Wrong
         Case 6 : Gosub Wrong
         Case 7 : Gosub Correct
         Case 8 : Gosub Wrong
         Case 9 : Gosub Correct
      End Select
   End If
Return

Btn_b:
   If State = Menu Then
      Cls
      State = Gpcls
   End If
   If State = Gameplay Then
      Select Case Question_num
         Case 0 : Gosub Wrong
         Case 1 : Gosub Correct
         Case 2 : Gosub Wrong
         Case 3 : Gosub Correct
         Case 4 To 7 : Gosub Wrong
         Case 8 : Gosub Correct
         Case 9 : Gosub Wrong
      End Select
   End If
Return

Btn_c:
   If State = Gameplay Then
      Select Case Question_num
         Case 0 : Gosub Wrong
         Case 1 : Gosub Wrong
         Case 2 : Gosub Correct
         Case 3 : Gosub Wrong
         Case 4 : Gosub Wrong
         Case 5 : Gosub Correct
         Case 6 : Gosub Correct
         Case 7 To 9 : Gosub Wrong
      End Select
   End If
Return

Btn_d:
   Cls
   State = Welcome
   Gosub Score
Return

Score:
   Cls
   Gosub Calc_score_per
   Cls
   Locate 1 , 1
   Lcd "Your score is: " ; Score ; "/10 " ; Score_per ; "%"
   Locate 2 , 1
   Select Case Question_num1
      Case 1 To 10 :
         If State = Welcome Then
            Lcd "Leaving now?"
         Else
            Lcd "Nice score. Keep playing."
         End If
      Case 11 :
         If Score >= 6 Then
            Lcd "YOU WIN! Great job. Nice score."
         Elseif Score < 6 Then
            Lcd "Sorry. YOU LOOSE. Please Try again."
         End If
   End Select
   Wait 3
   Cls
   If State = Welcome Then Return
   Select Case Question_num1
      Case 1 To 10 : State = Gameplay
      Case 11 : State = Welcome
   End Select
Return

Calc_score_per:
   Score_per = Score / 10
   Score_per = Score_per * 100
   Score_per = Round(score_per)
Return

Question:
   'Question "string" must not exceed 40 (includes "?")
   Select Case Q_ran
      Case 1 :
         Cls
         Question_1 = "What is the S.I unit of Force?"
         Question_num = 0
      Case 2 :
         Cls
         Question_1 = "if F=50, and M=5, what is A in F=MA?"
         Question_num = 1
      Case 3 :
         Cls
         Question_1 = "What is the formula for Speed?"
         Question_num = 2
      Case 4 :
         Question_1 = "What is the S.I unit for time?"
         Question_num = 3
      Case 5 :
         Question_1 = "What is the unit for momentum?"
         Question_num = 4
      Case 6 :
         Question_1 = "what is the symbol for momentum?"
         Question_num = 5
      Case 7 :
         Question_1 = "what is earth's gravity?"
         Question_num = 6
      Case 8 :
         Question_1 = "torque=?"
         Question_num = 7
      Case 9 :
         Question_1 = "Kenetic Energy, Ek=?"
         Question_num = 8
      Case 10 :
         Question_1 = "Potential Energy, Ep=??"
         Question_num = 9
   End Select
Return

Answer:
   Select Case Question_num
      Case 0 : Answer_1 = "A. kgms^-2 B. N C. ms^-2"
      Case 1 : Answer_1 = "A. 25 B. 10 C. 30"
      Case 2 : Answer_1 = "A. s=(d/t)-(d/t) B. s=F*t C. s=d/t"
      Case 3 : Answer_1 = "A. hr, hour B. s, second C. t, time"
      Case 4 : Answer_1 = "A. kgms^-1 B. p C. m"
      Case 5 : Answer_1 = "A. t B. s C. p"
      Case 6 : Answer_1 = "A. 5N B. 10ms^-2 C. 10N"
      Case 7 : Answer_1 = "A. F*d B. mgh C. mg"
      Case 8 : Answer_1 = "A. mgh B. 1/2mv^2 C. v^2"
      Case 9 : Answer_1 = "A. mgh B. 1/2Fd^2/m C. d/t"
   End Select
Return

Check_ques_end:
   If Question_num1 = 11 Then State = Score_state
   Waitms 100
Return

Correct:
   Incr Question_num1
   Incr Score
   Q_ran = Ran
   Waitms 100
Return

Wrong:
   Incr Question_num1
   Q_ran = Ran
   Waitms 100
Return
'------------------------------------------------------------------
' 14. Interrupts
