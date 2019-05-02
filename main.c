#include <stdlib.h> // only being used for malloc, free, and NULL. Approved by Arody. Baud Rate 115200 :)
// NOTE: this file is in fact less than 200 lines of C, but has lots of white space, comments, and end brackets. See https://drive.google.com/open?id=1rt-s5Q6sotzEU_Bt9wlYujS137NNYOzc for more compact version
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

extern char board[], welcome_screen[], pause_screen[]; // large character arrays used as strings
struct entity *head = NULL, *tail = NULL, *frog = NULL; // points for linked list and frog
char isHalfTick = 0, playing = 0, started = 0; // game state variables
signed char lives = 4, level = 0, levelTime, frogsHome=0; // level 0 is pregame mode
unsigned int timerInterval[20] = {8000000,8000000,7600000,7200000,6800000,6400000,6000000,5600000,5200000,4800000,4400000,4000000,3600000,3200000,2800000,2400000,2000000,1600000,1200000,800000}; // number that timer0 should count to before interrupting
signed char levelTicks[20] = {60,60,53,44,35,25,13,14,15,17,18,20,22,25,29,33,40,50,67,100}; // number of timer interrupts in a given level
signed char levelSeconds[20] = {60,60,50,40,30,20,10,10,10,10,10,10,10,10,10,10,10,10,10,10}; // number of real world seconds these ticks correspond to
long unsigned int sysTime=0, r, a = 22695477, m = 4294967295, score = 0; // variables for pseudo random number generator, score

struct entity { // Definition of entity class, this is how all game sprites are stored and located
    struct entity *prev, *next; // note prev and next pointers, the entities are arranged in a doubly linked list
    signed char xpos, ypos, xdir, ydir, length, doHalfTick, stop; // location and movement info, doHalfTick stores if entity should move every timer0 interrupt, only the frog does this so that is moves twice as fast as other entities
    char *text; // characters that represnt the entity
};

long unsigned int mrand(){          // returns a large psuedo random number
    r = (a*r+1)%m;                  // linear congruential generator (see wikipedia) values selected to match Borland C/C++ rand()
    return r;                       // this function has a very large repetition period and is seeded randomly by the time of user input
}

struct entity* create_entity(signed char xpos, signed char ypos, signed char xdir, signed char ydir, signed char length, signed char doHalfTick, signed char stop, char *text) {
    struct entity* e = malloc(sizeof(struct entity)); // constructor for entity "class", allocates memory and initializes members
    if (e == NULL) return NULL;
    e->prev = NULL, e->xpos = xpos, e->ypos = ypos, e->xdir = xdir, e->ydir = ydir, e->length = length, e->doHalfTick = doHalfTick, e->stop = stop, e->text = text, e->next = NULL;
    return e;
}

void push_back(struct entity* e) {                  // function to add an entity to the doubly linked list
    if (!tail) {                                    // updates head and tail pointers appropriately
        head = e, tail = e;
        return;
    }
    tail->next = e, e->prev = tail, tail = e;
}

void pop_entity(struct entity* e){                  // removes the given entity from the doubly linked list
    if(e->prev) e->prev->next = e->next;            // and updates head+tail pointers
    if(e->next) e->next->prev = e->prev;
    if(e==head) head = e->next;
    if(e==tail) tail = e->prev;
}

void delete_entity(struct entity* e) {              // deallocates an entity
    free(e);
    e = NULL;
}

void board_add_entities(){                          // this function iterates through the linked list of entities
    struct entity* h = head;                        // and adds each of them to the board string
    while (h) {                                     // Only the portion of an entity which falls within the game
        if(h==frog){                                // borders is added to the board
            h = h->next;                            // entities which are completely off the board are removed and deallocated
            continue;
        }
        if(h->xpos > 45 || (h->xpos + h->length - 1) < 1){ // is entirely off right edge or entirely off left edge
            struct entity* next = h->next;   // save next pointer
            pop_entity(h);                  // remove entity
            delete_entity(h);               // deallocate memory
            h = next;                       // restore next pointer
            continue;                       // skip drawing removed entity
        }
        char *textbase = h->text; // start address of the entity's string
        signed char i, textlength = h->length; // how long the string is
        int base = h->ypos*49 + h->xpos; // where the entity would start in the board string
        if((h->xpos + h->length - 1) > 45) textlength -= (h->xpos + h->length - 1 - 45); // if the entity's length runs outside the right border, skip these characters
        if(h->xpos < 1) textbase += (0 - h->xpos + 1), textlength -= (0 - h->xpos + 1), base = h->ypos*49 + 1; // if the entity starts to the left of the left border, skip these characters
        for(i=0; i<textlength; i++) board[base+i] = textbase[i]; // save the remaining characters into the board
        h = h->next;
    }
}

char getTimeSeconds(){ // returns the number of realworld seconds remaining in the level
    float flevelTime = levelTime, flevelSeconds=levelSeconds[level], flevelTicks = levelTicks[level]; // done in C to allow float conversion for accurate division
    return (char)(flevelTime*flevelSeconds/flevelTicks);
}

void loose_life(){ // decrements the number of lives, randomly replace the frog on the should, updates LEDs,  and ends game if no lives remain
    lives--, frog->xpos = (mrand()%44 + 1), frog->ypos = 14, frog->xdir = 0, illuminate_LEDs(lives);
    if(lives==0) end_game();
}

void clear_entities() { // iterates backwards through the doubly linked list of entities, removing them all and deallocating all memory
    struct entity* e = tail;    // used to clear game for playing again
    while (e) {
        struct entity* prev = e->prev;  // store the node higher in the list
        pop_entity(e);                  // remove this node
        delete_entity(e);               // and delete it
        e = prev;
    }
    head = NULL, tail = NULL, frog = NULL;  // rest the list pointers and frog pointer
}

void move_entities(){                       // iterates through the linked list of entities and moves each by the value given
    struct entity* h = head;                // in its xdir and ydir field. On a full tick all entities are moved, on a half tick
    while(h){                               // only the entities with doHalfTick are mvoed, allows frog to move at 2x speed
        if(!isHalfTick || (isHalfTick && h->doHalfTick)){ // if its a full tick, or its a half tick and the entity should move on half ticks
            h->xpos += h->xdir, h->ypos += h->ydir;
            if(h->stop) h->xdir = 0, h->ydir = 0; // if the entity should only move once (frog moved by single keypress) zero out directions
        }
        h = h->next;
    }
    isHalfTick = !isHalfTick;               // mark next interrupt as halfTick/notHalfTick, interrupts fire at 2x speed of regular entity
}

void remove_entity_by_char(char c){         // iterates through the linked list of entities and removes every instance
    struct entity* h = head;                // that begins with the given character. Used to remove flies and "frog in home"
    while(h){                               // markers without having to explicitly keep reference to these
        if(h->text[0] == c){
           struct entity* next = h->next;
           pop_entity(h);
           delete_entity(h);
           h = next;
        }
        else h = h->next;
    }
}

void change_level(){                        // decrease the duration between timer intervals, resets the time to match the
    timer0_stop();                          // next level, clears homed frogs and gives the user a level bonus
    level += 1, levelTime = levelTicks[level], frogsHome=0, score+=250;
    remove_entity_by_char('H');
    timer0_init(timerInterval[level]);
}

void check_collisions(){                                    // checks to see if the frog has "collided" with another entity, by checking the character at its
    if(!frog) return;                                       // position on the board (what its "sitting on").  Fatal collisions (cars/trucks/water/gator mouths)
    char charAtFrog = board[frog->ypos*49 + frog->xpos];    // lead to lose of life. Collisions with "rideable" entities (logs, lily pads, etc) set the frogs speed and direction to match that entity's
    if(charAtFrog=='|' || charAtFrog=='-' || charAtFrog=='A' || charAtFrog=='C' || charAtFrog=='#'  || charAtFrog=='H' || (charAtFrog==' ' && frog->ypos>=3 && frog->ypos<=6)) loose_life(); // fatal collision results in death
    else if(charAtFrog=='a' || charAtFrog=='L' || charAtFrog=='O' || charAtFrog=='T'){
        frog->doHalfTick = 0;                               // fog is "on" an item, should only move at 1x speed
        if(frog->ypos%2 == 1) frog->xdir = -1;              // set the frog to move in the right direction for this row
        else frog->xdir = 1;
    }
    else if(frog->ypos==2){ // frog has reached the home row
        if(charAtFrog == '+') score+= 100; // apply fly bonus if applicable
        push_back(create_entity((((frog->xpos)/10)*10)+6, frog->ypos, 0, 0, 5, 0, 0, "HHHHH")); // put indicator in home position
        frog->xpos = (mrand()%44 + 1), frog->ypos = 14, frogsHome++, score+=50, score+=getTimeSeconds()*10; // randomly replace frog, apply home bonus, time bonus
        if(frogsHome>=2) change_level(); // if 2 frogs homed, go to next level
    }
    board[frog->ypos*49 + frog->xpos] = '&'; // add frog to board
}

signed char row_dir[] = {0, -1,1,-1,1,0,-1,1,-1,1,-1,1};                                        // values for randomly generated entities - direction
char *row_strings[] = {"", "LLLLLL","OO","Aaaaaa","TT","","####","C","####","C","####","C"};    // display string
signed char row_length[] = {0, 6, 2, 6, 2, 0, 4, 1, 4, 1, 4, 1};                                // length of display string
signed char row_pos[] = {0, 45,0,45,0,0,45,1,45,1,45,1};                                        // position to be placed at - only one character of ent on board
signed char check_pos[] = {0, 44,2,44,2,0,44,2,44,2,44,2};                                      // locations that need to be empty in order to place new entity
signed char check_pos2[] = {0, 45,1,45,1,0,45,1,45,1,45,1};                                     // place under entity, and ajacent to entity
signed char fly_pos[] = {0, 6, 16, 26, 36};                                                     // potential spots to place a fly

void generate_entities(){                                                           // randomly creates entities and places them at the edges of each
    signed char i;                                                                  // row so that they "enter" from up or down river
    for(i=2; i<15; i++){
        long unsigned int random = mrand();
        if(i==7) continue;
        if(i==2 && mrand()%19<3 && board[2*49 + fly_pos[random%4]]==' '){           // randomly generate a fly
            remove_entity_by_char('+');                                             // remove old fly
            push_back(create_entity(fly_pos[random%4], i, 0, 0, 5, 0, 0, "+++++")); // put fly in random home position
        }
        else if(random%1000==1) remove_entity_by_char('+'); // fly is removed after a random duration of time
        if(random%19 < 2 && board[i*49 + check_pos[i-2]]==' ' && board[i*49 + check_pos2[i-2]]==' ') push_back(create_entity(row_pos[i-2], i, row_dir[i-2], 0, row_length[i-2], 0, 0, row_strings[i-2])); // lines that randomly generates entity at appropriate location
    }
}

void char_handler(char c){              // function to process user input
    if(c==' '){                         // character is 'SPACE' start/unpause/restart game
        if(!started){
            timer1_stop();              // stop timer counting for random number
            char i;
            r = sysTime, level=1;       // seed random number generator with counted number
            clear_entities();           // remove all entities to clear previous game
            for(i=0; i<30; i++){
                generate_entities();    // randomly generate
                board_add_entities();   // add to board
                move_entities();        // and move entities so that board is populated for game to start
            }
            board_add_entities();       // finalize board before start
            started = 1, score=0, lives=4, levelTime=levelTicks[level], frogsHome=0, illuminate_LEDs(lives); // set all game state values to default
            frog = create_entity(mrand()%44 + 1, 14, 0, 0, 1, 1, 0, "&");   // randomly add a frog to the shoulder, set frog pointer
            push_back(frog);
        }
        ready_screen();                 // clear screen home cursor
        playing = 1;                    // set game playing, timer0 will handle screen updates
        illuminate_RGB_LED(4);          // update LED color
    }
    else if(c==27){                     // character is 'ESCAPE'
        playing = 0;                    // set game not playing to stop timer0 from updating the screen
        illuminate_RGB_LED(1);          // update LED color
        ready_screen();                 // clear screen, home cusor
        printf(pause_screen);           // display pause menu
    }
    if(!frog || !playing) return; // if the game is not paused/over handle frog movement events
    if(c=='W' || c=='w') frog->xdir = 0, frog->ydir = -1, score += 10;  // move up, update score
    else if(c=='S' || c=='s') { // move down update score
        frog->xdir = 0, frog->ydir = 1;
        if(score>=10) score -= 10;
    }
    else if(c=='A' || c=='a') frog->xdir = -1, frog->ydir = 0;  // move left
    else if(c=='D' || c=='d') frog->xdir = 1, frog->ydir = 0;   // move right
    frog->doHalfTick = 1, frog->stop = 1;   // mark frog to be moved in next timer interrupt
}

int main(void){
    init_leds();
    uart_init(); // configure UART for 11,5200 baud rate
    init_keypad();
    timer1_init(10000); // start timer1 counting quickly, used to get random number
    levelTime = levelTicks[level]; // load pregenerated level time
    timer0_init(timerInterval[level]); // start timer0, used for the game tick
    init_rgb_led();
    illuminate_RGB_LED(7); // start LED as white pregame
    ready_screen(); // clear screen, home cursor
    printf(welcome_screen); // give user instructions
    while(1);
}
