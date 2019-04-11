#include <stdlib.h>

extern int lab7(void);
extern void printf(char*);
extern void uart_init(void);
extern void itoa(int x, char* string);

char escape[3] = { 27, '[', 0 };
char white[8] = { 27, '[', '3', '7', ';', '0', 'm', 0 };
char green[8] = { 27, '[', '3', '2', ';', '1', 'm', 0 };
char brown[20] = {27,'[','3','8',';','2',';','1','3', '9', ';','0','6','9',';','0','1','9','m', 0};
char* alligator = "Aaaaaa";
char* log = "LLLLLL";
struct entity* head = NULL;
struct entity* tail = NULL;

struct entity {
    struct entity* prev;
    unsigned char xpos, ypos, xdir, ydir;
    char *color, *text;
    struct entity* next;
};

void move_cursor(unsigned char x, unsigned char y) {
    printf(escape);
    char xstring[3];
    char ystring[3];
    itoa(x, xstring);
    itoa(y, ystring);
    printf(xstring);
    printf(ystring);
}

void draw_entity(struct entity* e) {
    move_cursor(e->xpos, e->ypos);
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

struct entity* create_entity(unsigned char xpos, unsigned char ypos, unsigned char xdir, unsigned char ydir, char* color, char *text) {
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

void draw_entites() {
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


int main(void)
{
    uart_init();

    move_cursor(10,10);
    char hi[3] = {'H', 'i', 0};
    printf(hi);
    //struct entity* gator = create_entity(2, 2, 0, 0, green, alligator);
    //push_back(gator);
    //draw_entites();
    //clear_entities();
    //int x = 2;
    //char* number[2];
    //itoa(x, number);
    //printf(number);
    //char* s = itod()
    //lab7();
	return 0;
}
