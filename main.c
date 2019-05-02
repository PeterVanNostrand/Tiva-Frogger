#include <stdlib.h>

extern int lab7(void);
extern void printf(char*);
extern void uart_init();
extern void itoa(int x, char* string);
extern void itoa_pad(int x, char* string, int length);
extern void timer0_init(unsigned int timerInterval);
extern void draw_board(void);
extern void clear_board(void);
extern void end_game(void);
extern void init_rgb_led(void);
extern void illuminate_RGB_LED(char LED_color);
extern void ready_screen(void);
extern void timer1_init(unsigned int timerInterval);
extern void timer1_stop(void);
extern void init_keypad(void);
extern void timer0_stop(void);
extern void init_leds(void);
extern illuminate_LEDs(char val);
extern char board[], welcome_screen[], pause_screen[];

struct entity* head = NULL;
struct entity* tail = NULL;
struct entity* frog = NULL;
char isHalfTick = 0, playing = 0, started = 0;
signed char lives = 4, level = 0, levelTime, frogsHome=0; // level 0 is pregame mode
unsigned int timerInterval[20] = {8000000,8000000,7600000,7200000,6800000,6400000,6000000,5600000,5200000,4800000,4400000,4000000,3600000,3200000,2800000,2400000,2000000,1600000,1200000,800000};
signed char levelTicks[20] = {60,60,53,44,35,25,13,14,15,17,18,20,22,25,29,33,40,50,67,100};
signed char levelSeconds[20] = {60,60,50,40,30,20,10,10,10,10,10,10,10,10,10,10,10,10,10,10};
long unsigned int sysTime=0, r, a = 22695477, m = 4294967295, score = 0;

struct entity {
    struct entity *prev, *next;
    signed char xpos, ypos, xdir, ydir, length, doHalfTick, stop;
    char *text;
};

long unsigned int mrand(){
    r = (a*r+1)%m;
    return r;
}

struct entity* create_entity(signed char xpos, signed char ypos, signed char xdir, signed char ydir, signed char length, signed char doHalfTick, signed char stop, char *text) {
    struct entity* e = malloc(sizeof(struct entity));
    if (e == NULL) return NULL;
    e->prev = NULL, e->xpos = xpos, e->ypos = ypos, e->xdir = xdir, e->ydir = ydir, e->length = length, e->doHalfTick = doHalfTick, e->stop = stop, e->text = text, e->next = NULL;
    return e;
}

void push_back(struct entity* e) {
    if (!tail) {
        head = e, tail = e;
        return;
    }
    tail->next = e, e->prev = tail, tail = e;
}

void pop_entity(struct entity* e){
    if(e->prev) e->prev->next = e->next;
    if(e->next) e->next->prev = e->prev;
    if(e==head) head = e->next;
    if(e==tail) tail = e->prev;
}

void delete_entity(struct entity* e) {
    free(e);
    e = NULL;
}

void board_add_entities(){
    struct entity* h = head;
    while (h) {
        if(h==frog){
            h = h->next;
            continue;
        }
        if(h->xpos > 45 || (h->xpos + h->length - 1) < 1){
            struct entity* next = h->next;
            pop_entity(h);
            delete_entity(h);
            h = next;
            continue;
        }
        char *textbase = h->text;
        signed char i, textlength = h->length;
        int base = h->ypos*49 + h->xpos;
        if((h->xpos + h->length - 1) > 45) textlength -= (h->xpos + h->length - 1 - 45);
        if(h->xpos < 1) textbase += (0 - h->xpos + 1), textlength -= (0 - h->xpos + 1), base = h->ypos*49 + 1;
        for(i=0; i<textlength; i++) board[base+i] = textbase[i];
        h = h->next;
    }
}

char getTimeSeconds(){
    float flevelTime = levelTime, flevelSeconds=levelSeconds[level], flevelTicks = levelTicks[level];
    return (char)(flevelTime*flevelSeconds/flevelTicks);
}

void loose_life(){
    lives--, frog->xpos = (rand()%44 + 1), frog->ypos = 14, frog->xdir = 0, illuminate_LEDs(lives);;
    if(lives==0) end_game();
}

void clear_entities() {
    struct entity* e = tail;
    while (e) {
        struct entity* prev = e->prev;
        pop_entity(e);
        delete_entity(e);
        e = prev;
    }
    head = NULL, tail = NULL, frog = NULL;
}

void move_entities(){
    struct entity* h = head;
    while(h){
        if(!isHalfTick || (isHalfTick && h->doHalfTick)){
            h->xpos += h->xdir, h->ypos += h->ydir;
            if(h->stop) h->xdir = 0, h->ydir = 0;
        }
        h = h->next;
    }
    isHalfTick = !isHalfTick;
}

void remove_entity_by_char(char c){
    struct entity* h = head;
    while(h){
        if(h->text[0] == c){
           struct entity* next = h->next;
           pop_entity(h);
           delete_entity(h);
           h = next;
        }
        else h = h->next;
    }
}

void change_level(){
    timer0_stop();
    level += 1, levelTime = levelTicks[level], frogsHome=0, score+=250;
    remove_entity_by_char('H');
    timer0_init(timerInterval[level]);
}

void check_collisions(){
    if(!frog) return;
    char charAtFrog = board[frog->ypos*49 + frog->xpos];
    if(charAtFrog=='|' || charAtFrog=='-' || charAtFrog=='A' || charAtFrog=='C' || charAtFrog=='#'  || charAtFrog=='H' || (charAtFrog==' ' && frog->ypos>=3 && frog->ypos<=6)) loose_life();
    else if(charAtFrog=='a' || charAtFrog=='L' || charAtFrog=='O' || charAtFrog=='T'){
        frog->doHalfTick = 0;
        if(frog->ypos%2 == 1) frog->xdir = -1;
        else frog->xdir = 1;
    }
    else if(frog->ypos==2){
        if(charAtFrog == '+') score+= 100;
        push_back(create_entity((((frog->xpos)/10)*10)+6, frog->ypos, 0, 0,  5, 0, 0, "HHHHH"));
        frog->xpos = (rand()%44 + 1), frog->ypos = 14, frogsHome++, score+=50, score+=getTimeSeconds()*10;
        if(frogsHome>=2) change_level();
    }
    board[frog->ypos*49 + frog->xpos] = '&';
}

signed char row_dir[] = {0, -1,1,-1,1,0,-1,1,-1,1,-1,1};
char *row_strings[] = {"", "LLLLLL","OO","Aaaaaa","TT","","####","C","####","C","####","C"};
signed char row_length[] = {0, 6, 2, 6, 2, 0, 4, 1, 4, 1, 4, 1};
signed char row_pos[] = {0, 45,0,45,0,0,45,1,45,1,45,1};
signed char check_pos[] = {0, 44,2,44,2,0,44,2,44,2,44,2};
signed char check_pos2[] = {0, 45,1,45,1,0,45,1,45,1,45,1};
signed char fly_pos[] = {0, 6, 16, 26, 36};

void generate_entities(){
    signed char i;
    for(i=2; i<15; i++){
        long unsigned int random = mrand();
        if(i==7) continue;
        if(i==2 && mrand()%19<3 && board[2*49 + fly_pos[random%4]]==' '){
            remove_entity_by_char('+');
            push_back(create_entity(fly_pos[random%4], i, 0, 0, 5, 0, 0, "+++++"));
        }
        else if(random%1000==1) remove_entity_by_char('+'); // fly is removed after a random duration of time
        if(random%19 < 2 && board[i*49 + check_pos[i-2]]==' ' && board[i*49 + check_pos2[i-2]]==' ') push_back(create_entity(row_pos[i-2], i, row_dir[i-2], 0, row_length[i-2], 0, 0, row_strings[i-2]));
    }
}

void clear_flies(){
    struct entity* h = head;
    while(h){

    }
}

void char_handler(char c){
    if(c==' '){ // char is 'SPACE'
        if(!started){
            timer1_stop();
            char i;
            r = sysTime, level=1;
            clear_entities();
            for(i=0; i<30; i++){
                generate_entities();
                board_add_entities();
                move_entities();
            }
            board_add_entities();
            started = 1, score=0, lives=4, levelTime=levelTicks[level], frogsHome=0, illuminate_LEDs(lives);
            frog = create_entity(22, 14, 0, 0, 1, 1, 0, "&");
            push_back(frog);
        }
        ready_screen();
        playing = 1;
        illuminate_RGB_LED(4);
    }
    else if(c==27){ // char is 'ESCAPE'
        playing = 0;
        illuminate_RGB_LED(1);
        ready_screen();
        printf(pause_screen);
    }

    // frog movement events
    if(!frog || !playing) return;
    if(c=='W' || c=='w') frog->xdir = 0, frog->ydir = -1, score += 10;
    else if(c=='S' || c=='s') {
        frog->xdir = 0, frog->ydir = 1;
        if(score>=10) score -= 10;
    }
    else if(c=='A' || c=='a') frog->xdir = -1, frog->ydir = 0;
    else if(c=='D' || c=='d') frog->xdir = 1, frog->ydir = 0;
    frog->doHalfTick = 1, frog->stop = 1;
}

int main(void)
{
    init_leds();
    uart_init();
    init_keypad();
    timer1_init(10000);
    levelTime = levelTicks[level];
    timer0_init(timerInterval[level]);
    init_rgb_led();
    illuminate_RGB_LED(7);
    ready_screen();
    printf(welcome_screen);
    while(1);
}

//void draw_entity(struct entity* e) {
//    move_cursor(e->ypos, e->xpos);
//    printf(e->text);
//}
//void draw_entities() {
//    struct entity* h = head;
//    while (h) {
//        draw_entity(h);
//        h = h->next;
//    }
//}
//void move_cursor(signed char x, signed char y) {
//    printf(escape);
//    char xstring[3];
//    char ystring[3];
//    itoa(x+1, xstring);
//    itoa(y+1, ystring);
//    printf(xstring);
//    printf(";");
//    printf(ystring);
//    printf("H");
//}
//void print_entity(struct entity* e){
//    printf("xpos = %i\n", e->xpos);
//    printf("ypos = %i\n", e->ypos);
//    printf("xdir = %i\n", e->xdir);
//    printf("ydir = %i\n", e->ydir);
//    printf(e->color);
//    printf(e->text);
//    printf(white);
//    printf("\n");
//}
