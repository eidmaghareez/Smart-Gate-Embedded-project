#line 1 "C:/Users/falak/Desktop/EMBEDDED PROJECT FINAL/Smartgate.c"


char irtext[3];
char irchoice[3];
unsigned long ir_code;
unsigned short command;
char ir_saved_codes[8]={0x21,0x01,0xc1,0x81,0x61,0x41,0xe1,0xa1};
int speedlevel=3;
unsigned char speedtext[7];
unsigned char changespeedvariable;
char opencloseflag=0;


sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D4 at RD4_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D7 at RD7_bit;


sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD3_bit;
sbit LCD_D4_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D7_Direction at TRISD7_bit;

void clearrow(int a){Lcd_Out(a,1,"                ");}

void changespeed(int change){
changespeedvariable=change;
if(changespeedvariable==1 && CCPR2L!=250){
CCPR2L+=25;
speedlevel+=1;}
if(changespeedvariable==0 && CCPR2L!=0){
CCPR2L-=25;
speedlevel-=1;}
clearrow(1);
IntToStr(speedlevel,speedtext);
while(speedtext[0] == ' '){ memmove (speedtext,speedtext+1, strlen(speedtext));}
Lcd_Out(1,1,"Speed Level:");
Lcd_Out(1,13,speedtext);}

void motorcontrol(int choice){
switch (choice){
case 0: PORTE=0X00; break;
case 1: PORTE=0X01; break;
case 2: PORTE=0X02; break;
}
}
void openclose(){
clearrow(1);
Lcd_Out(1,1,"Gate stop");
opencloseflag=0;
}

short nec_read(){
unsigned long count = 0, i;

while (( RB1_bit  == 0) && (count <= 180)) {
 count++;
 delay_us(50);}

if ( (count > 179) || (count < 120)){return 0;}

count = 0;


while ( RB1_bit  && (count <= 90)) {
 count++;
 delay_us(50);}

if ( (count > 89) || (count < 40)){return 0;}


for (i = 0; i < 32; i++) {
 count = 0;
 while (( RB1_bit  == 0) && (count <= 23)) {
 count++;
 delay_us(50);}

 count = 0;
 while ( RB1_bit  && (count <= 45)) {
 count++;
 delay_us(50);}

 if ( count > 21){ir_code |= 1ul << (31 - i);}
 else {ir_code &= ~(1ul << (31 - i));}}

 return 1;
}

void save_ir_input(){
command = ir_code >> 8;
ByteToHex(command,irtext);}

void gatestart(){
ByteToHex(ir_saved_codes[1],irchoice);
while(strcmp(irchoice,irtext)!=0){
if(nec_read()){save_ir_input();}}
Lcd_Cmd(_LCD_CLEAR);
Lcd_Out(1,1,"Smart Gate On");
}

void irfunctions(){
clearrow(1);
ByteToHex(ir_saved_codes[0],irchoice);
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,"Gate Stop");
PORTE=0X00;}

ByteToHex(ir_saved_codes[1],irchoice);
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,"Gate On");
Lcd_Out(1,1,irchoice);}

ByteToHex(ir_saved_codes[2],irchoice);
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,irchoice);
changespeed(0);}

ByteToHex(ir_saved_codes[3],irchoice);
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,irchoice);
changespeed(1);}


ByteToHex(ir_saved_codes[4],irchoice);
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,"Gate Left");
Delay_ms(50);
PORTE=0X01;}

ByteToHex(ir_saved_codes[5],irchoice);
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,"Gate Right");
Delay_ms(50);
PORTE=0X02;}

ByteToHex(ir_saved_codes[6],irchoice);
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,irchoice);}


ByteToHex(ir_saved_codes[7],irchoice);
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,irchoice);}
}
void startup(){
Lcd_Init();
Lcd_Cmd(_LCD_CLEAR);
Lcd_Cmd(_LCD_CURSOR_OFF);

T2CON = 0x07;
CCP2CON = 0x0C;
PR2 = 250;
CCPR2L= 75;
Lcd_Out(1, 1, "Smart Gate Idle.");

ByteToHex(ir_saved_codes[1],irchoice);
while(strcmp(irchoice,irtext)!=0){
if(nec_read()){save_ir_input();}}
Lcd_Cmd(_LCD_CLEAR);
Lcd_Out(1,1,"Smart Gate On");
}
void interrupt(void){
PORTE=0X00;
opencloseflag=1;
INTCON=INTCON&0xFD;
}

void main(){
INTCON = INTCON | 0x90;
TRISB=0X0F;
PORTB=0X00;
TRISC=0;
TRISE=0X00;
PORTE=0X00;
startup();
while (1) {

 if (nec_read()) {
 save_ir_input();
 clearrow(2);
 Lcd_Out(2, 1, irtext);
 irfunctions();

 }
 if(opencloseflag){
 openclose();
 }
 }
 }
