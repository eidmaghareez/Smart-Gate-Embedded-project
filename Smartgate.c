//////////////////////////////////////VARIABLES///////////////////////////////////////////////////////////////////////////
#define IR_PIN RB1_bit//IR Signal Reception Pin
char irtext[3];//store ir signal decoded to hex
char irchoice[3];//store ir choice
unsigned long ir_code;//store raw ir signal
unsigned short command;//store 8 bits of ir sicnal
char ir_saved_codes[8]={0x21,0x01,0xc1,0x81,0x61,0x41,0xe1,0xa1}; //IR remote button signals from left to right top to bottom
int speedlevel=3;//default speed level ->> speed = 75 // speed values (0->250) // speed levels (0->10)
unsigned char speedtext[7];//store speed level text to display on lcd
unsigned char changespeedvariable;
char opencloseflag=0;
//////////////////////////////////////LCD RELATED/////////////////////////////////////////////////////////////////////////////////////////////
// LCD pins connections
sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D4 at RD4_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D7 at RD7_bit;
///////////////////////
//LCD pins directions
sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD3_bit;
sbit LCD_D4_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D7_Direction at TRISD7_bit;
///////////////////////////////////////
void clearrow(int a){Lcd_Out(a,1,"                ");}  //Clear specified row
////////////////////////////////////////////////////////MOTOR/////////////////////////////////////////////////////////////////////////////////////////////
void changespeed(int change){//change speed of motor
changespeedvariable=change;//check if we want to speed up or slow down
if(changespeedvariable==1 && CCPR2L!=250){//speed up motor and increment speedlevel
CCPR2L+=25;
speedlevel+=1;}
if(changespeedvariable==0 && CCPR2L!=0){//slow down motor and decrement speedlevel
CCPR2L-=25;
speedlevel-=1;}
clearrow(1);//clear first row
IntToStr(speedlevel,speedtext);//store speed level in speedtext
while(speedtext[0] == ' '){ memmove (speedtext,speedtext+1, strlen(speedtext));}//remove empty spaces from speedtext
Lcd_Out(1,1,"Speed Level:");
Lcd_Out(1,13,speedtext);}//print speed level on lcd
//////////////////////////////////////////////
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
////////////////////////////////////////////////////////IR RELATED//////////////////////////////////////////////////////////////////////////////
short nec_read(){
unsigned long count = 0, i;

while ((IR_PIN == 0) && (count <= 180)) {// Check 9ms pulse (remote control sends logic high)
      count++;
      delay_us(50);}

if ( (count > 179) || (count < 120)){return 0;}//Not NEC protocol

count = 0;


while (IR_PIN && (count <= 90)) {// Check 4.5ms space (remote control sends logic low)
      count++;
      delay_us(50);}

if ( (count > 89) || (count < 40)){return 0;}//Not NEC protocol


for (i = 0; i < 32; i++) {    // Read code message (32-bit)
    count = 0;
    while ((IR_PIN == 0) && (count <= 23)) {
          count++;
          delay_us(50);}

    count = 0;
    while (IR_PIN && (count <= 45)) {
          count++;
          delay_us(50);}

    if ( count > 21){ir_code |= 1ul << (31 - i);} // If space width > 1ms    Write 1 to bit (31 - i)
    else {ir_code &= ~(1ul << (31 - i));}}        // If space width < 1ms  Write 0 to bit (31 - i)

  return 1;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void save_ir_input(){// saves input from remote into text variable
command = ir_code >> 8;//get ir command
ByteToHex(command,irtext);}// Save command in  irtext with hex format
////////////////////////////////////////////////////////////////////////
void gatestart(){ //loop until user starts gate (2nd button) then print "smart gate on"
ByteToHex(ir_saved_codes[1],irchoice);
while(strcmp(irchoice,irtext)!=0){//loop until on button is pressed
if(nec_read()){save_ir_input();}}// check ir signal
Lcd_Cmd(_LCD_CLEAR);
Lcd_Out(1,1,"Smart Gate On");
}
////////////////////////////////////////////////////////////////////////
void irfunctions(){
clearrow(1);
ByteToHex(ir_saved_codes[0],irchoice);//stop motor
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,"Gate Stop");
PORTE=0X00;}

ByteToHex(ir_saved_codes[1],irchoice);  //turn gate on
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,"Gate On");
Lcd_Out(1,1,irchoice);}

ByteToHex(ir_saved_codes[2],irchoice);  //change speed
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,irchoice);
changespeed(0);}

ByteToHex(ir_saved_codes[3],irchoice);     //change speed
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,irchoice);
changespeed(1);}


ByteToHex(ir_saved_codes[4],irchoice);    //gate left
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,"Gate Left");
Delay_ms(50);
PORTE=0X01;}

ByteToHex(ir_saved_codes[5],irchoice); //gate right
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,"Gate Right");
Delay_ms(50);
PORTE=0X02;}

ByteToHex(ir_saved_codes[6],irchoice);     //unemplemented
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,irchoice);}


ByteToHex(ir_saved_codes[7],irchoice);      //unemplemented
if(strcmp(irtext,irchoice)==0){
Lcd_Out(1,1,irchoice);}
}
void startup(){
Lcd_Init();//LCD initialization
Lcd_Cmd(_LCD_CLEAR);//Clear display
Lcd_Cmd(_LCD_CURSOR_OFF);//Cursor off
//////////////////////////pwm setup//////
T2CON = 0x07;//enable Timer2 at Fosc/4 with 1:16 prescaler (8 uS percount 2000uS to count 250 counts)
CCP2CON = 0x0C;//enable PWM for CCP2
PR2 = 250;// 250 counts =8uS *250 =2ms period
CCPR2L= 75;
Lcd_Out(1, 1, "Smart Gate Idle.");//print gate idle

ByteToHex(ir_saved_codes[1],irchoice);//check if on button is pressed
while(strcmp(irchoice,irtext)!=0){
if(nec_read()){save_ir_input();}}
Lcd_Cmd(_LCD_CLEAR);
Lcd_Out(1,1,"Smart Gate On");
}
void interrupt(void){//if interrupt STOP GATE
PORTE=0X00;
opencloseflag=1;
INTCON=INTCON&0xFD;//Clear INTF(External Interrupt Flag)
}

void main(){
INTCON = INTCON | 0x90;// enable global and external interrupt
TRISB=0X0F;// PORTB first 4 bits INPUT
PORTB=0X00;//portb = 0
TRISC=0;// portc output
TRISE=0X00;//PORTE0 AND PORTE1 OUTPUT
PORTE=0X00;//port e =0
startup();//setup lcd and wait for user to start gate//
while (1) {// infinite loop

  if (nec_read()) {//if ir signal is sent by remote
  save_ir_input();//save the value of ir signal
  clearrow(2);//clear second row of lcd
  Lcd_Out(2, 1, irtext);//show command on lcd
  irfunctions();//do a function of the project

  }
  if(opencloseflag){// if interrupt occured flag will be 1 and gate will stop
  openclose();
  }
  }
  }