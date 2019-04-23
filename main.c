#include <stdlib.h>

extern int lab7(void);
extern void printf(char*);
extern void uart_init(void);
extern void itoa(int x, char* string);
extern void draw_board(void);
extern void timer0_init(void);
extern void test(void);

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
char isUserMotion = 0;

struct entity {
    struct entity* prev;
    signed char xpos, ypos, xdir, ydir, length, stop;
    char *color, *text;
    struct entity* next;
};

void move_cursor(signed char x, signed char y) {
    printf(escape);
    char xstring[3];
    char ystring[3];
    itoa(x+1, xstring);
    itoa(y+1, ystring);
    printf(xstring);
    printf(";");
    printf(ystring);
    printf("H");
}

void draw_entity(struct entity* e) {
    move_cursor(e->ypos, e->xpos);
    printf(e->color);
    printf(e->text);
    printf(white);
}

void print_entity(struct entity* e){
    //printf("xpos = %i\n", e->xpos);
    //printf("ypos = %i\n", e->ypos);
    //printf("xdir = %i\n", e->xdir);
    //printf("ydir = %i\n", e->ydir);
    //printf(e->color);
    //printf(e->text);
    //printf(white);
    //printf("\n");
}

struct entity* create_entity(signed char xpos, signed char ypos, signed char xdir, signed char ydir, signed char length, signed char stop, char* color, char *text) {
    struct entity* e = malloc(sizeof(struct entity));
    if (e == NULL)
        return NULL;
    e->prev = NULL,
    e->xpos = xpos,
    e->ypos = ypos,
    e->xdir = xdir,
    e->ydir = ydir,
    e->length = length,
    e->stop = stop,
    e->color = color,
    e->text = text,
    e->next = NULL;
    return e;
}

void draw_entities() {
    struct entity* h = head;
    while (h) {
        draw_entity(h);
        h = h->next;
    }
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
    while(h!=NULL){
        if(!isHalfTick) { // move everything
            h->xpos += h->xdir;
            h->ypos += h->ydir;
        }
        else if(h->text[0]='&' && isUserMotion){ // it was a half tick and isUserMotion
            h->xpos += h->xdir;
            h->ypos += h->ydir;
        }
        if(h->stop) {
            h->xdir = 0;
            h->ydir = 0;
            h->stop = 0;
        }
        struct entity* next = h->next;
//        if(h->xpos < 1){
//            if(h->text[0]==0){
//                pop_entity(h);
//                delete_entity(h);
//            }
//            h->xpos = 1;
//            h->text++;
//        }
//        if(h->xpos + h->length > 45){
//            *(h->text + h->length - 1) = 0;
//            h->length -= 1;
//            if(h->length == 0){
//                pop_entity(h);
//                delete_entity(h);
//            }
//
        if(h->xpos<1 || (h->xpos+h->length)>45 || h->ypos<1 || h->ypos>14){
            pop_entity(h);
            delete_entity(h);
        }
        h = next;
    }
    isUserMotion = 0;
    isHalfTick = !isHalfTick; // next timer is the opposite of this
    return;
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
    isUserMotion = 1;
}

int main(void)
{
    uart_init();
    printf(clear_screen);
    printf(home_cursor);
    printf(hide_cursor);
    //draw_board();
    struct entity* gator = create_entity(40, 5, -1, 0, 6, 0, green, "Aaaaaa");
    struct entity* l = create_entity(12, 10, 1, 0, 6, 0, brown, "LLLLLL");
    struct entity* frog = create_entity(10, 10, 1, 0, 1, 0, "", "&");
    push_back(gator);
    push_back(l);
    push_back(frog);
    //test();
    timer0_init();
    while(1){}
    //clear_entities();
    //move_cursor(10,10);
	return 0;
}
