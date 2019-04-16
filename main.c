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

struct entity {
    struct entity* prev;
    signed char xpos, ypos, xdir, ydir;
    char *color, *text;
    struct entity* next;
};

void move_cursor(signed char x, signed char y) {
    printf(escape);
    char xstring[3];
    char ystring[3];
    itoa(x, xstring);
    itoa(y, ystring);
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

struct entity* create_entity(signed char xpos, signed char ypos, signed char xdir, signed char ydir, char* color, char *text) {
    struct entity* e = malloc(sizeof(struct entity));
    if (e == NULL)
        return NULL;
    e->prev = NULL,
    e->xpos = xpos,
    e->ypos = ypos,
    e->xdir = xdir,
    e->ydir = ydir,
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
        h->xpos += h->xdir;
        h->ypos += h->ydir;
        struct entity* next = h->next;
        if(h->xpos<1 || h->xpos>45 || h->ypos<1 || h->ypos>14){
            pop_entity(h);
            delete_entity(h);
        }
        h = next;
    }
    return;
}

int main(void)
{
    uart_init();
    printf(clear_screen);
    printf(home_cursor);
    printf(hide_cursor);
    //draw_board();
    struct entity* gator = create_entity(40, 7, -1, 0, green, alligator);
    struct entity* l = create_entity(12, 10, 1, 0, brown, log);
    push_back(l);
    push_back(gator);
    //test();
    timer0_init();
    while(1){}
    //clear_entities();
    //move_cursor(10,10);
	return 0;
}
