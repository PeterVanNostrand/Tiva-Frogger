#include <stdlib.h>

extern int lab7(void);
extern void printf(char*);
extern void uart_init(void);
extern void itoa(int x, char* string);
extern void timer0_init(void);
extern void test(void);
extern void draw_board(void);
extern void clear_board(void);

char escape[3] = { 27, '[', 0 };
char white[8] = { 27, '[', '3', '7', ';', '0', 'm', 0 };
char green[8] = { 27, '[', '3', '2', ';', '1', 'm', 0 };
char brown[20] = {27,'[','3','8',';','2',';','1','3', '9', ';','0','6','9',';','0','1','9','m', 0};
char clear_screen[6] = {27, '[', '2' , 'J', 0};
char home_cursor[8] = {27, '[', '1', ';', '1', 'H', 0};
char hide_cursor[7] = {27, '[', '?', '2', '5', 'l', 0};
char* alligator = "Aaaaaa";
char* log = "LLLLLL";
struct entity* head = NULL;
struct entity* tail = NULL;
char isHalfTick = 0;

char board[] =  "|---------------------------------------------|\r\n"
                "|*********************************************|\r\n"
                "|*****     *****     *****     *****     *****|\r\n"
                "|                                             |\r\n"
                "|                                             |\r\n"
                "|                                             |\r\n"
                "|                                             |\r\n"
                "|.............................................|\r\n"
                "|                                             |\r\n"
                "|                                             |\r\n"
                "|                                             |\r\n"
                "|                                             |\r\n"
                "|                                             |\r\n"
                "|                                             |\r\n"
                "|.............................................|\r\n"
                "|---------------------------------------------|";


struct entity {
    struct entity *prev, *next;
    signed char xpos, ypos, xdir, ydir, length, doHalfTick, stop;
    char *text;
};

struct entity* create_entity(signed char xpos, signed char ypos, signed char xdir, signed char ydir, signed char length, signed char doHalfTick, signed char stop, char *text) {
    struct entity* e = malloc(sizeof(struct entity));
    if (e == NULL)
        return NULL;
    e->prev = NULL,
    e->xpos = xpos,
    e->ypos = ypos,
    e->xdir = xdir,
    e->ydir = ydir,
    e->length = length,
    e->doHalfTick = doHalfTick,
    e->stop = stop,
    e->text = text,
    e->next = NULL;
    return e;
}

void push_back(struct entity* e) {
    if (!tail) {
        head = e;
        tail = e;
        return;
    }
    tail->next = e;
    e->prev = tail;
    tail = e;
}

void pop_entity(struct entity* e){
    if(e->prev)
        e->prev->next = e->next;
    if(e->next)
        e->next->prev = e->prev;
    if(e==head)
        head = e->next;
    if(e==tail)
        tail = e->prev;
}

void delete_entity(struct entity* e) {
    free(e);
    e = NULL;
}

void board_add_entities(){
    struct entity* h = head;
    while (h) {
        if(h->xpos > 45 || (h->xpos + h->length - 1) < 1){
            struct entity* next = h->next;
            pop_entity(h);
            delete_entity(h);
            h = next;
            continue;
        }
        char *textbase = h->text;
        signed char textlength = h->length;
        int base = h->ypos*49 + h->xpos;
        if((h->xpos + h->length - 1) > 45)
            textlength -= (h->xpos + h->length - 1 - 45);
        if(h->xpos < 1){
            textbase += (0 - h->xpos + 1);
            textlength -= (0 - h->xpos + 1);
            base = h->ypos*49 + 1;
        }
        signed char i;
        for(i=0; i<textlength; i++){
            board[base+i] = textbase[i];
        }
        h = h->next;
    }
}

void clear_entities() {
    while (tail->prev) {
        struct entity* prev = tail->prev;
        delete_entity(tail);
        tail = prev;
    }
    delete_entity(tail);
    head = NULL;
    tail = NULL;
}

void move_entities(){
    struct entity* h = head;
    while(h){
        if(!isHalfTick || (isHalfTick && h->doHalfTick)){
            h->xpos += h->xdir;
            h->ypos += h->ydir;
            //h->doHalfTick = 0;
            if(h->stop){
                h->xdir = 0;
                h->ydir = 0;
            }
        }
        h = h->next;
    }
    isHalfTick = !isHalfTick;
}

void set_frog_dir(char c){
    struct entity* h = head;
    while(h && h->text[0]!='&') h = h->next;
    if(!h) return;
    if(c=='W' || c=='w'){
        h->xdir = 0;
        h->ydir = -1;
    }
    else if(c=='S' || c=='s'){
        h->xdir = 0;
        h->ydir = 1;
    }
    else if(c=='A' || c=='a'){
        h->xdir = -1;
        h->ydir = 0;
    }
    else if(c=='D' || c=='d'){
        h->xdir = 1;
        h->ydir = 0;
    }
    h->stop = 1;
}

int main(void)
{
    uart_init();
    printf(clear_screen);
    printf(home_cursor);
    printf(hide_cursor);
    timer0_init();
    struct entity* g1 = create_entity(20, 5, -1, 0, 6, 0, 0, "Aaaaaa");
    struct entity* g2 = create_entity(20, 6, 1, 0, 6, 0, 0, "Aaaaaa");
    struct entity* frog = create_entity(10, 6, 0, 0, 1, 1, 0, "&");
    push_back(g1);
    push_back(g2);
    push_back(frog);
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
