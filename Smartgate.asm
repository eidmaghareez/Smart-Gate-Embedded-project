
_clearrow:

;Smartgate.c,29 :: 		void clearrow(int a){Lcd_Out(a,1,"                ");}  //Clear specified row
	MOVF       FARG_clearrow_a+0, 0
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Smartgate+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
L_end_clearrow:
	RETURN
; end of _clearrow

_changespeed:

;Smartgate.c,31 :: 		void changespeed(int change){//change speed of motor
;Smartgate.c,32 :: 		changespeedvariable=change;//check if we want to speed up or slow down
	MOVF       FARG_changespeed_change+0, 0
	MOVWF      _changespeedvariable+0
;Smartgate.c,33 :: 		if(changespeedvariable==1 && CCPR2L!=250){//speed up motor and increment speedlevel
	MOVF       FARG_changespeed_change+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_changespeed2
	MOVF       CCPR2L+0, 0
	XORLW      250
	BTFSC      STATUS+0, 2
	GOTO       L_changespeed2
L__changespeed65:
;Smartgate.c,34 :: 		CCPR2L+=25;
	MOVLW      25
	ADDWF      CCPR2L+0, 1
;Smartgate.c,35 :: 		speedlevel+=1;}
	INCF       _speedlevel+0, 1
	BTFSC      STATUS+0, 2
	INCF       _speedlevel+1, 1
L_changespeed2:
;Smartgate.c,36 :: 		if(changespeedvariable==0 && CCPR2L!=0){//slow down motor and decrement speedlevel
	MOVF       _changespeedvariable+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_changespeed5
	MOVF       CCPR2L+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_changespeed5
L__changespeed64:
;Smartgate.c,37 :: 		CCPR2L-=25;
	MOVLW      25
	SUBWF      CCPR2L+0, 1
;Smartgate.c,38 :: 		speedlevel-=1;}
	MOVLW      1
	SUBWF      _speedlevel+0, 1
	BTFSS      STATUS+0, 0
	DECF       _speedlevel+1, 1
L_changespeed5:
;Smartgate.c,39 :: 		clearrow(1);//clear first row
	MOVLW      1
	MOVWF      FARG_clearrow_a+0
	MOVLW      0
	MOVWF      FARG_clearrow_a+1
	CALL       _clearrow+0
;Smartgate.c,40 :: 		IntToStr(speedlevel,speedtext);//store speed level in speedtext
	MOVF       _speedlevel+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _speedlevel+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _speedtext+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Smartgate.c,41 :: 		while(speedtext[0] == ' '){ memmove (speedtext,speedtext+1, strlen(speedtext));}//remove empty spaces from speedtext
L_changespeed6:
	MOVF       _speedtext+0, 0
	XORLW      32
	BTFSS      STATUS+0, 2
	GOTO       L_changespeed7
	MOVLW      _speedtext+0
	MOVWF      FARG_strlen_s+0
	CALL       _strlen+0
	MOVF       R0+0, 0
	MOVWF      FARG_memmove_n+0
	MOVF       R0+1, 0
	MOVWF      FARG_memmove_n+1
	MOVLW      _speedtext+0
	MOVWF      FARG_memmove_to+0
	MOVLW      _speedtext+1
	MOVWF      FARG_memmove_from+0
	CALL       _memmove+0
	GOTO       L_changespeed6
L_changespeed7:
;Smartgate.c,42 :: 		Lcd_Out(1,1,"Speed Level:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Smartgate+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Smartgate.c,43 :: 		Lcd_Out(1,13,speedtext);}//print speed level on lcd
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _speedtext+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
L_end_changespeed:
	RETURN
; end of _changespeed

_motorcontrol:

;Smartgate.c,45 :: 		void motorcontrol(int choice){
;Smartgate.c,46 :: 		switch (choice){
	GOTO       L_motorcontrol8
;Smartgate.c,47 :: 		case 0: PORTE=0X00; break;
L_motorcontrol10:
	CLRF       PORTE+0
	GOTO       L_motorcontrol9
;Smartgate.c,48 :: 		case 1: PORTE=0X01; break;
L_motorcontrol11:
	MOVLW      1
	MOVWF      PORTE+0
	GOTO       L_motorcontrol9
;Smartgate.c,49 :: 		case 2: PORTE=0X02; break;
L_motorcontrol12:
	MOVLW      2
	MOVWF      PORTE+0
	GOTO       L_motorcontrol9
;Smartgate.c,50 :: 		}
L_motorcontrol8:
	MOVLW      0
	XORWF      FARG_motorcontrol_choice+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__motorcontrol75
	MOVLW      0
	XORWF      FARG_motorcontrol_choice+0, 0
L__motorcontrol75:
	BTFSC      STATUS+0, 2
	GOTO       L_motorcontrol10
	MOVLW      0
	XORWF      FARG_motorcontrol_choice+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__motorcontrol76
	MOVLW      1
	XORWF      FARG_motorcontrol_choice+0, 0
L__motorcontrol76:
	BTFSC      STATUS+0, 2
	GOTO       L_motorcontrol11
	MOVLW      0
	XORWF      FARG_motorcontrol_choice+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__motorcontrol77
	MOVLW      2
	XORWF      FARG_motorcontrol_choice+0, 0
L__motorcontrol77:
	BTFSC      STATUS+0, 2
	GOTO       L_motorcontrol12
L_motorcontrol9:
;Smartgate.c,51 :: 		}
L_end_motorcontrol:
	RETURN
; end of _motorcontrol

_openclose:

;Smartgate.c,52 :: 		void openclose(){
;Smartgate.c,53 :: 		clearrow(1);
	MOVLW      1
	MOVWF      FARG_clearrow_a+0
	MOVLW      0
	MOVWF      FARG_clearrow_a+1
	CALL       _clearrow+0
;Smartgate.c,54 :: 		Lcd_Out(1,1,"Gate stop");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Smartgate+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Smartgate.c,55 :: 		opencloseflag=0;
	CLRF       _opencloseflag+0
;Smartgate.c,56 :: 		}
L_end_openclose:
	RETURN
; end of _openclose

_nec_read:

;Smartgate.c,58 :: 		short nec_read(){
;Smartgate.c,59 :: 		unsigned long count = 0, i;
	CLRF       nec_read_count_L0+0
	CLRF       nec_read_count_L0+1
	CLRF       nec_read_count_L0+2
	CLRF       nec_read_count_L0+3
;Smartgate.c,61 :: 		while ((IR_PIN == 0) && (count <= 180)) {// Check 9ms pulse (remote control sends logic high)
L_nec_read13:
	BTFSC      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_nec_read14
	MOVF       nec_read_count_L0+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read80
	MOVF       nec_read_count_L0+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read80
	MOVF       nec_read_count_L0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read80
	MOVF       nec_read_count_L0+0, 0
	SUBLW      180
L__nec_read80:
	BTFSS      STATUS+0, 0
	GOTO       L_nec_read14
L__nec_read71:
;Smartgate.c,62 :: 		count++;
	MOVF       nec_read_count_L0+0, 0
	MOVWF      R0+0
	MOVF       nec_read_count_L0+1, 0
	MOVWF      R0+1
	MOVF       nec_read_count_L0+2, 0
	MOVWF      R0+2
	MOVF       nec_read_count_L0+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      nec_read_count_L0+0
	MOVF       R0+1, 0
	MOVWF      nec_read_count_L0+1
	MOVF       R0+2, 0
	MOVWF      nec_read_count_L0+2
	MOVF       R0+3, 0
	MOVWF      nec_read_count_L0+3
;Smartgate.c,63 :: 		delay_us(50);}
	MOVLW      33
	MOVWF      R13+0
L_nec_read17:
	DECFSZ     R13+0, 1
	GOTO       L_nec_read17
	GOTO       L_nec_read13
L_nec_read14:
;Smartgate.c,65 :: 		if ( (count > 179) || (count < 120)){return 0;}//Not NEC protocol
	MOVF       nec_read_count_L0+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read81
	MOVF       nec_read_count_L0+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read81
	MOVF       nec_read_count_L0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read81
	MOVF       nec_read_count_L0+0, 0
	SUBLW      179
L__nec_read81:
	BTFSS      STATUS+0, 0
	GOTO       L__nec_read70
	MOVLW      0
	SUBWF      nec_read_count_L0+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read82
	MOVLW      0
	SUBWF      nec_read_count_L0+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read82
	MOVLW      0
	SUBWF      nec_read_count_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read82
	MOVLW      120
	SUBWF      nec_read_count_L0+0, 0
L__nec_read82:
	BTFSS      STATUS+0, 0
	GOTO       L__nec_read70
	GOTO       L_nec_read20
L__nec_read70:
	CLRF       R0+0
	GOTO       L_end_nec_read
L_nec_read20:
;Smartgate.c,67 :: 		count = 0;
	CLRF       nec_read_count_L0+0
	CLRF       nec_read_count_L0+1
	CLRF       nec_read_count_L0+2
	CLRF       nec_read_count_L0+3
;Smartgate.c,70 :: 		while (IR_PIN && (count <= 90)) {// Check 4.5ms space (remote control sends logic low)
L_nec_read21:
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_nec_read22
	MOVF       nec_read_count_L0+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read83
	MOVF       nec_read_count_L0+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read83
	MOVF       nec_read_count_L0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read83
	MOVF       nec_read_count_L0+0, 0
	SUBLW      90
L__nec_read83:
	BTFSS      STATUS+0, 0
	GOTO       L_nec_read22
L__nec_read69:
;Smartgate.c,71 :: 		count++;
	MOVF       nec_read_count_L0+0, 0
	MOVWF      R0+0
	MOVF       nec_read_count_L0+1, 0
	MOVWF      R0+1
	MOVF       nec_read_count_L0+2, 0
	MOVWF      R0+2
	MOVF       nec_read_count_L0+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      nec_read_count_L0+0
	MOVF       R0+1, 0
	MOVWF      nec_read_count_L0+1
	MOVF       R0+2, 0
	MOVWF      nec_read_count_L0+2
	MOVF       R0+3, 0
	MOVWF      nec_read_count_L0+3
;Smartgate.c,72 :: 		delay_us(50);}
	MOVLW      33
	MOVWF      R13+0
L_nec_read25:
	DECFSZ     R13+0, 1
	GOTO       L_nec_read25
	GOTO       L_nec_read21
L_nec_read22:
;Smartgate.c,74 :: 		if ( (count > 89) || (count < 40)){return 0;}//Not NEC protocol
	MOVF       nec_read_count_L0+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read84
	MOVF       nec_read_count_L0+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read84
	MOVF       nec_read_count_L0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read84
	MOVF       nec_read_count_L0+0, 0
	SUBLW      89
L__nec_read84:
	BTFSS      STATUS+0, 0
	GOTO       L__nec_read68
	MOVLW      0
	SUBWF      nec_read_count_L0+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read85
	MOVLW      0
	SUBWF      nec_read_count_L0+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read85
	MOVLW      0
	SUBWF      nec_read_count_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read85
	MOVLW      40
	SUBWF      nec_read_count_L0+0, 0
L__nec_read85:
	BTFSS      STATUS+0, 0
	GOTO       L__nec_read68
	GOTO       L_nec_read28
L__nec_read68:
	CLRF       R0+0
	GOTO       L_end_nec_read
L_nec_read28:
;Smartgate.c,77 :: 		for (i = 0; i < 32; i++) {    // Read code message (32-bit)
	CLRF       R5+0
	CLRF       R5+1
	CLRF       R5+2
	CLRF       R5+3
L_nec_read29:
	MOVLW      0
	SUBWF      R5+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read86
	MOVLW      0
	SUBWF      R5+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read86
	MOVLW      0
	SUBWF      R5+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read86
	MOVLW      32
	SUBWF      R5+0, 0
L__nec_read86:
	BTFSC      STATUS+0, 0
	GOTO       L_nec_read30
;Smartgate.c,78 :: 		count = 0;
	CLRF       nec_read_count_L0+0
	CLRF       nec_read_count_L0+1
	CLRF       nec_read_count_L0+2
	CLRF       nec_read_count_L0+3
;Smartgate.c,79 :: 		while ((IR_PIN == 0) && (count <= 23)) {
L_nec_read32:
	BTFSC      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_nec_read33
	MOVF       nec_read_count_L0+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read87
	MOVF       nec_read_count_L0+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read87
	MOVF       nec_read_count_L0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read87
	MOVF       nec_read_count_L0+0, 0
	SUBLW      23
L__nec_read87:
	BTFSS      STATUS+0, 0
	GOTO       L_nec_read33
L__nec_read67:
;Smartgate.c,80 :: 		count++;
	MOVF       nec_read_count_L0+0, 0
	MOVWF      R0+0
	MOVF       nec_read_count_L0+1, 0
	MOVWF      R0+1
	MOVF       nec_read_count_L0+2, 0
	MOVWF      R0+2
	MOVF       nec_read_count_L0+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      nec_read_count_L0+0
	MOVF       R0+1, 0
	MOVWF      nec_read_count_L0+1
	MOVF       R0+2, 0
	MOVWF      nec_read_count_L0+2
	MOVF       R0+3, 0
	MOVWF      nec_read_count_L0+3
;Smartgate.c,81 :: 		delay_us(50);}
	MOVLW      33
	MOVWF      R13+0
L_nec_read36:
	DECFSZ     R13+0, 1
	GOTO       L_nec_read36
	GOTO       L_nec_read32
L_nec_read33:
;Smartgate.c,83 :: 		count = 0;
	CLRF       nec_read_count_L0+0
	CLRF       nec_read_count_L0+1
	CLRF       nec_read_count_L0+2
	CLRF       nec_read_count_L0+3
;Smartgate.c,84 :: 		while (IR_PIN && (count <= 45)) {
L_nec_read37:
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_nec_read38
	MOVF       nec_read_count_L0+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read88
	MOVF       nec_read_count_L0+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read88
	MOVF       nec_read_count_L0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read88
	MOVF       nec_read_count_L0+0, 0
	SUBLW      45
L__nec_read88:
	BTFSS      STATUS+0, 0
	GOTO       L_nec_read38
L__nec_read66:
;Smartgate.c,85 :: 		count++;
	MOVF       nec_read_count_L0+0, 0
	MOVWF      R0+0
	MOVF       nec_read_count_L0+1, 0
	MOVWF      R0+1
	MOVF       nec_read_count_L0+2, 0
	MOVWF      R0+2
	MOVF       nec_read_count_L0+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      nec_read_count_L0+0
	MOVF       R0+1, 0
	MOVWF      nec_read_count_L0+1
	MOVF       R0+2, 0
	MOVWF      nec_read_count_L0+2
	MOVF       R0+3, 0
	MOVWF      nec_read_count_L0+3
;Smartgate.c,86 :: 		delay_us(50);}
	MOVLW      33
	MOVWF      R13+0
L_nec_read41:
	DECFSZ     R13+0, 1
	GOTO       L_nec_read41
	GOTO       L_nec_read37
L_nec_read38:
;Smartgate.c,88 :: 		if ( count > 21){ir_code |= 1ul << (31 - i);} // If space width > 1ms    Write 1 to bit (31 - i)
	MOVF       nec_read_count_L0+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read89
	MOVF       nec_read_count_L0+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read89
	MOVF       nec_read_count_L0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__nec_read89
	MOVF       nec_read_count_L0+0, 0
	SUBLW      21
L__nec_read89:
	BTFSC      STATUS+0, 0
	GOTO       L_nec_read42
	MOVLW      31
	MOVWF      R0+0
	CLRF       R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       R5+0, 0
	SUBWF      R0+0, 1
	MOVF       R5+1, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R5+1, 0
	SUBWF      R0+1, 1
	MOVF       R5+2, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R5+2, 0
	SUBWF      R0+2, 1
	MOVF       R5+3, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R5+3, 0
	SUBWF      R0+3, 1
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVLW      1
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      0
	MOVWF      R0+2
	MOVLW      0
	MOVWF      R0+3
	MOVF       R4+0, 0
L__nec_read90:
	BTFSC      STATUS+0, 2
	GOTO       L__nec_read91
	RLF        R0+0, 1
	RLF        R0+1, 1
	RLF        R0+2, 1
	RLF        R0+3, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__nec_read90
L__nec_read91:
	MOVF       R0+0, 0
	IORWF      _ir_code+0, 1
	MOVF       R0+1, 0
	IORWF      _ir_code+1, 1
	MOVF       R0+2, 0
	IORWF      _ir_code+2, 1
	MOVF       R0+3, 0
	IORWF      _ir_code+3, 1
	GOTO       L_nec_read43
L_nec_read42:
;Smartgate.c,89 :: 		else {ir_code &= ~(1ul << (31 - i));}}        // If space width < 1ms  Write 0 to bit (31 - i)
	MOVLW      31
	MOVWF      R0+0
	CLRF       R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       R5+0, 0
	SUBWF      R0+0, 1
	MOVF       R5+1, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R5+1, 0
	SUBWF      R0+1, 1
	MOVF       R5+2, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R5+2, 0
	SUBWF      R0+2, 1
	MOVF       R5+3, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R5+3, 0
	SUBWF      R0+3, 1
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVLW      1
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      0
	MOVWF      R0+2
	MOVLW      0
	MOVWF      R0+3
	MOVF       R4+0, 0
L__nec_read92:
	BTFSC      STATUS+0, 2
	GOTO       L__nec_read93
	RLF        R0+0, 1
	RLF        R0+1, 1
	RLF        R0+2, 1
	RLF        R0+3, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__nec_read92
L__nec_read93:
	COMF       R0+0, 1
	COMF       R0+1, 1
	COMF       R0+2, 1
	COMF       R0+3, 1
	MOVF       R0+0, 0
	ANDWF      _ir_code+0, 1
	MOVF       R0+1, 0
	ANDWF      _ir_code+1, 1
	MOVF       R0+2, 0
	ANDWF      _ir_code+2, 1
	MOVF       R0+3, 0
	ANDWF      _ir_code+3, 1
L_nec_read43:
;Smartgate.c,77 :: 		for (i = 0; i < 32; i++) {    // Read code message (32-bit)
	MOVF       R5+0, 0
	MOVWF      R0+0
	MOVF       R5+1, 0
	MOVWF      R0+1
	MOVF       R5+2, 0
	MOVWF      R0+2
	MOVF       R5+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      R5+0
	MOVF       R0+1, 0
	MOVWF      R5+1
	MOVF       R0+2, 0
	MOVWF      R5+2
	MOVF       R0+3, 0
	MOVWF      R5+3
;Smartgate.c,89 :: 		else {ir_code &= ~(1ul << (31 - i));}}        // If space width < 1ms  Write 0 to bit (31 - i)
	GOTO       L_nec_read29
L_nec_read30:
;Smartgate.c,91 :: 		return 1;
	MOVLW      1
	MOVWF      R0+0
;Smartgate.c,92 :: 		}
L_end_nec_read:
	RETURN
; end of _nec_read

_save_ir_input:

;Smartgate.c,94 :: 		void save_ir_input(){// saves input from remote into text variable
;Smartgate.c,95 :: 		command = ir_code >> 8;//get ir command
	MOVF       _ir_code+1, 0
	MOVWF      R0+0
	MOVF       _ir_code+2, 0
	MOVWF      R0+1
	MOVF       _ir_code+3, 0
	MOVWF      R0+2
	CLRF       R0+3
	MOVF       R0+0, 0
	MOVWF      _command+0
;Smartgate.c,96 :: 		ByteToHex(command,irtext);}// Save command in  irtext with hex format
	MOVF       R0+0, 0
	MOVWF      FARG_ByteToHex_input+0
	MOVLW      _irtext+0
	MOVWF      FARG_ByteToHex_output+0
	CALL       _ByteToHex+0
L_end_save_ir_input:
	RETURN
; end of _save_ir_input

_gatestart:

;Smartgate.c,98 :: 		void gatestart(){ //loop until user starts gate (2nd button) then print "smart gate on"
;Smartgate.c,99 :: 		ByteToHex(ir_saved_codes[1],irchoice);
	MOVF       _ir_saved_codes+1, 0
	MOVWF      FARG_ByteToHex_input+0
	MOVLW      _irchoice+0
	MOVWF      FARG_ByteToHex_output+0
	CALL       _ByteToHex+0
;Smartgate.c,100 :: 		while(strcmp(irchoice,irtext)!=0){//loop until on button is pressed
L_gatestart44:
	MOVLW      _irchoice+0
	MOVWF      FARG_strcmp_s1+0
	MOVLW      _irtext+0
	MOVWF      FARG_strcmp_s2+0
	CALL       _strcmp+0
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__gatestart96
	MOVLW      0
	XORWF      R0+0, 0
L__gatestart96:
	BTFSC      STATUS+0, 2
	GOTO       L_gatestart45
;Smartgate.c,101 :: 		if(nec_read()){save_ir_input();}}// check ir signal
	CALL       _nec_read+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_gatestart46
	CALL       _save_ir_input+0
L_gatestart46:
	GOTO       L_gatestart44
L_gatestart45:
;Smartgate.c,102 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Smartgate.c,103 :: 		Lcd_Out(1,1,"Smart Gate On");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Smartgate+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Smartgate.c,104 :: 		}
L_end_gatestart:
	RETURN
; end of _gatestart

_irfunctions:

;Smartgate.c,106 :: 		void irfunctions(){
;Smartgate.c,107 :: 		clearrow(1);
	MOVLW      1
	MOVWF      FARG_clearrow_a+0
	MOVLW      0
	MOVWF      FARG_clearrow_a+1
	CALL       _clearrow+0
;Smartgate.c,108 :: 		ByteToHex(ir_saved_codes[0],irchoice);//stop motor
	MOVF       _ir_saved_codes+0, 0
	MOVWF      FARG_ByteToHex_input+0
	MOVLW      _irchoice+0
	MOVWF      FARG_ByteToHex_output+0
	CALL       _ByteToHex+0
;Smartgate.c,109 :: 		if(strcmp(irtext,irchoice)==0){
	MOVLW      _irtext+0
	MOVWF      FARG_strcmp_s1+0
	MOVLW      _irchoice+0
	MOVWF      FARG_strcmp_s2+0
	CALL       _strcmp+0
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__irfunctions98
	MOVLW      0
	XORWF      R0+0, 0
L__irfunctions98:
	BTFSS      STATUS+0, 2
	GOTO       L_irfunctions47
;Smartgate.c,110 :: 		Lcd_Out(1,1,"Gate Stop");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_Smartgate+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Smartgate.c,111 :: 		PORTE=0X00;}
	CLRF       PORTE+0
L_irfunctions47:
;Smartgate.c,113 :: 		ByteToHex(ir_saved_codes[1],irchoice);  //turn gate on
	MOVF       _ir_saved_codes+1, 0
	MOVWF      FARG_ByteToHex_input+0
	MOVLW      _irchoice+0
	MOVWF      FARG_ByteToHex_output+0
	CALL       _ByteToHex+0
;Smartgate.c,114 :: 		if(strcmp(irtext,irchoice)==0){
	MOVLW      _irtext+0
	MOVWF      FARG_strcmp_s1+0
	MOVLW      _irchoice+0
	MOVWF      FARG_strcmp_s2+0
	CALL       _strcmp+0
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__irfunctions99
	MOVLW      0
	XORWF      R0+0, 0
L__irfunctions99:
	BTFSS      STATUS+0, 2
	GOTO       L_irfunctions48
;Smartgate.c,115 :: 		Lcd_Out(1,1,"Gate On");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_Smartgate+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Smartgate.c,116 :: 		Lcd_Out(1,1,irchoice);}
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _irchoice+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
L_irfunctions48:
;Smartgate.c,118 :: 		ByteToHex(ir_saved_codes[2],irchoice);  //change speed
	MOVF       _ir_saved_codes+2, 0
	MOVWF      FARG_ByteToHex_input+0
	MOVLW      _irchoice+0
	MOVWF      FARG_ByteToHex_output+0
	CALL       _ByteToHex+0
;Smartgate.c,119 :: 		if(strcmp(irtext,irchoice)==0){
	MOVLW      _irtext+0
	MOVWF      FARG_strcmp_s1+0
	MOVLW      _irchoice+0
	MOVWF      FARG_strcmp_s2+0
	CALL       _strcmp+0
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__irfunctions100
	MOVLW      0
	XORWF      R0+0, 0
L__irfunctions100:
	BTFSS      STATUS+0, 2
	GOTO       L_irfunctions49
;Smartgate.c,120 :: 		Lcd_Out(1,1,irchoice);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _irchoice+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Smartgate.c,121 :: 		changespeed(0);}
	CLRF       FARG_changespeed_change+0
	CLRF       FARG_changespeed_change+1
	CALL       _changespeed+0
L_irfunctions49:
;Smartgate.c,123 :: 		ByteToHex(ir_saved_codes[3],irchoice);     //change speed
	MOVF       _ir_saved_codes+3, 0
	MOVWF      FARG_ByteToHex_input+0
	MOVLW      _irchoice+0
	MOVWF      FARG_ByteToHex_output+0
	CALL       _ByteToHex+0
;Smartgate.c,124 :: 		if(strcmp(irtext,irchoice)==0){
	MOVLW      _irtext+0
	MOVWF      FARG_strcmp_s1+0
	MOVLW      _irchoice+0
	MOVWF      FARG_strcmp_s2+0
	CALL       _strcmp+0
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__irfunctions101
	MOVLW      0
	XORWF      R0+0, 0
L__irfunctions101:
	BTFSS      STATUS+0, 2
	GOTO       L_irfunctions50
;Smartgate.c,125 :: 		Lcd_Out(1,1,irchoice);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _irchoice+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Smartgate.c,126 :: 		changespeed(1);}
	MOVLW      1
	MOVWF      FARG_changespeed_change+0
	MOVLW      0
	MOVWF      FARG_changespeed_change+1
	CALL       _changespeed+0
L_irfunctions50:
;Smartgate.c,129 :: 		ByteToHex(ir_saved_codes[4],irchoice);    //gate left
	MOVF       _ir_saved_codes+4, 0
	MOVWF      FARG_ByteToHex_input+0
	MOVLW      _irchoice+0
	MOVWF      FARG_ByteToHex_output+0
	CALL       _ByteToHex+0
;Smartgate.c,130 :: 		if(strcmp(irtext,irchoice)==0){
	MOVLW      _irtext+0
	MOVWF      FARG_strcmp_s1+0
	MOVLW      _irchoice+0
	MOVWF      FARG_strcmp_s2+0
	CALL       _strcmp+0
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__irfunctions102
	MOVLW      0
	XORWF      R0+0, 0
L__irfunctions102:
	BTFSS      STATUS+0, 2
	GOTO       L_irfunctions51
;Smartgate.c,131 :: 		Lcd_Out(1,1,"Gate Left");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_Smartgate+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Smartgate.c,132 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_irfunctions52:
	DECFSZ     R13+0, 1
	GOTO       L_irfunctions52
	DECFSZ     R12+0, 1
	GOTO       L_irfunctions52
	NOP
	NOP
;Smartgate.c,133 :: 		PORTE=0X01;}
	MOVLW      1
	MOVWF      PORTE+0
L_irfunctions51:
;Smartgate.c,135 :: 		ByteToHex(ir_saved_codes[5],irchoice); //gate right
	MOVF       _ir_saved_codes+5, 0
	MOVWF      FARG_ByteToHex_input+0
	MOVLW      _irchoice+0
	MOVWF      FARG_ByteToHex_output+0
	CALL       _ByteToHex+0
;Smartgate.c,136 :: 		if(strcmp(irtext,irchoice)==0){
	MOVLW      _irtext+0
	MOVWF      FARG_strcmp_s1+0
	MOVLW      _irchoice+0
	MOVWF      FARG_strcmp_s2+0
	CALL       _strcmp+0
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__irfunctions103
	MOVLW      0
	XORWF      R0+0, 0
L__irfunctions103:
	BTFSS      STATUS+0, 2
	GOTO       L_irfunctions53
;Smartgate.c,137 :: 		Lcd_Out(1,1,"Gate Right");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_Smartgate+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Smartgate.c,138 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_irfunctions54:
	DECFSZ     R13+0, 1
	GOTO       L_irfunctions54
	DECFSZ     R12+0, 1
	GOTO       L_irfunctions54
	NOP
	NOP
;Smartgate.c,139 :: 		PORTE=0X02;}
	MOVLW      2
	MOVWF      PORTE+0
L_irfunctions53:
;Smartgate.c,141 :: 		ByteToHex(ir_saved_codes[6],irchoice);     //unemplemented
	MOVF       _ir_saved_codes+6, 0
	MOVWF      FARG_ByteToHex_input+0
	MOVLW      _irchoice+0
	MOVWF      FARG_ByteToHex_output+0
	CALL       _ByteToHex+0
;Smartgate.c,142 :: 		if(strcmp(irtext,irchoice)==0){
	MOVLW      _irtext+0
	MOVWF      FARG_strcmp_s1+0
	MOVLW      _irchoice+0
	MOVWF      FARG_strcmp_s2+0
	CALL       _strcmp+0
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__irfunctions104
	MOVLW      0
	XORWF      R0+0, 0
L__irfunctions104:
	BTFSS      STATUS+0, 2
	GOTO       L_irfunctions55
;Smartgate.c,143 :: 		Lcd_Out(1,1,irchoice);}
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _irchoice+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
L_irfunctions55:
;Smartgate.c,146 :: 		ByteToHex(ir_saved_codes[7],irchoice);      //unemplemented
	MOVF       _ir_saved_codes+7, 0
	MOVWF      FARG_ByteToHex_input+0
	MOVLW      _irchoice+0
	MOVWF      FARG_ByteToHex_output+0
	CALL       _ByteToHex+0
;Smartgate.c,147 :: 		if(strcmp(irtext,irchoice)==0){
	MOVLW      _irtext+0
	MOVWF      FARG_strcmp_s1+0
	MOVLW      _irchoice+0
	MOVWF      FARG_strcmp_s2+0
	CALL       _strcmp+0
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__irfunctions105
	MOVLW      0
	XORWF      R0+0, 0
L__irfunctions105:
	BTFSS      STATUS+0, 2
	GOTO       L_irfunctions56
;Smartgate.c,148 :: 		Lcd_Out(1,1,irchoice);}
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _irchoice+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
L_irfunctions56:
;Smartgate.c,149 :: 		}
L_end_irfunctions:
	RETURN
; end of _irfunctions

_startup:

;Smartgate.c,150 :: 		void startup(){
;Smartgate.c,151 :: 		Lcd_Init();//LCD initialization
	CALL       _Lcd_Init+0
;Smartgate.c,152 :: 		Lcd_Cmd(_LCD_CLEAR);//Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Smartgate.c,153 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);//Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Smartgate.c,155 :: 		T2CON = 0x07;//enable Timer2 at Fosc/4 with 1:16 prescaler (8 uS percount 2000uS to count 250 counts)
	MOVLW      7
	MOVWF      T2CON+0
;Smartgate.c,156 :: 		CCP2CON = 0x0C;//enable PWM for CCP2
	MOVLW      12
	MOVWF      CCP2CON+0
;Smartgate.c,157 :: 		PR2 = 250;// 250 counts =8uS *250 =2ms period
	MOVLW      250
	MOVWF      PR2+0
;Smartgate.c,158 :: 		CCPR2L= 75;
	MOVLW      75
	MOVWF      CCPR2L+0
;Smartgate.c,159 :: 		Lcd_Out(1, 1, "Smart Gate Idle.");//print gate idle
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_Smartgate+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Smartgate.c,161 :: 		ByteToHex(ir_saved_codes[1],irchoice);//check if on button is pressed
	MOVF       _ir_saved_codes+1, 0
	MOVWF      FARG_ByteToHex_input+0
	MOVLW      _irchoice+0
	MOVWF      FARG_ByteToHex_output+0
	CALL       _ByteToHex+0
;Smartgate.c,162 :: 		while(strcmp(irchoice,irtext)!=0){
L_startup57:
	MOVLW      _irchoice+0
	MOVWF      FARG_strcmp_s1+0
	MOVLW      _irtext+0
	MOVWF      FARG_strcmp_s2+0
	CALL       _strcmp+0
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__startup107
	MOVLW      0
	XORWF      R0+0, 0
L__startup107:
	BTFSC      STATUS+0, 2
	GOTO       L_startup58
;Smartgate.c,163 :: 		if(nec_read()){save_ir_input();}}
	CALL       _nec_read+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_startup59
	CALL       _save_ir_input+0
L_startup59:
	GOTO       L_startup57
L_startup58:
;Smartgate.c,164 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Smartgate.c,165 :: 		Lcd_Out(1,1,"Smart Gate On");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr10_Smartgate+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Smartgate.c,166 :: 		}
L_end_startup:
	RETURN
; end of _startup

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Smartgate.c,167 :: 		void interrupt(void){//if interrupt STOP GATE
;Smartgate.c,168 :: 		PORTE=0X00;
	CLRF       PORTE+0
;Smartgate.c,169 :: 		opencloseflag=1;
	MOVLW      1
	MOVWF      _opencloseflag+0
;Smartgate.c,170 :: 		INTCON=INTCON&0xFD;//Clear INTF(External Interrupt Flag)
	MOVLW      253
	ANDWF      INTCON+0, 1
;Smartgate.c,171 :: 		}
L_end_interrupt:
L__interrupt109:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Smartgate.c,173 :: 		void main(){
;Smartgate.c,174 :: 		INTCON = INTCON | 0x90;// enable global and external interrupt
	MOVLW      144
	IORWF      INTCON+0, 1
;Smartgate.c,175 :: 		TRISB=0X0F;// PORTB first 4 bits INPUT
	MOVLW      15
	MOVWF      TRISB+0
;Smartgate.c,176 :: 		PORTB=0X00;//portb = 0
	CLRF       PORTB+0
;Smartgate.c,177 :: 		TRISC=0;// portc output
	CLRF       TRISC+0
;Smartgate.c,178 :: 		TRISE=0X00;//PORTE0 AND PORTE1 OUTPUT
	CLRF       TRISE+0
;Smartgate.c,179 :: 		PORTE=0X00;//port e =0
	CLRF       PORTE+0
;Smartgate.c,180 :: 		startup();//setup lcd and wait for user to start gate//
	CALL       _startup+0
;Smartgate.c,181 :: 		while (1) {// infinite loop
L_main60:
;Smartgate.c,183 :: 		if (nec_read()) {//if ir signal is sent by remote
	CALL       _nec_read+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main62
;Smartgate.c,184 :: 		save_ir_input();//save the value of ir signal
	CALL       _save_ir_input+0
;Smartgate.c,185 :: 		clearrow(2);//clear second row of lcd
	MOVLW      2
	MOVWF      FARG_clearrow_a+0
	MOVLW      0
	MOVWF      FARG_clearrow_a+1
	CALL       _clearrow+0
;Smartgate.c,186 :: 		Lcd_Out(2, 1, irtext);//show command on lcd
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _irtext+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Smartgate.c,187 :: 		irfunctions();//do a function of the project
	CALL       _irfunctions+0
;Smartgate.c,189 :: 		}
L_main62:
;Smartgate.c,190 :: 		if(opencloseflag){// if interrupt occured flag will be 1 and gate will stop
	MOVF       _opencloseflag+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main63
;Smartgate.c,191 :: 		openclose();
	CALL       _openclose+0
;Smartgate.c,192 :: 		}
L_main63:
;Smartgate.c,193 :: 		}
	GOTO       L_main60
;Smartgate.c,194 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
