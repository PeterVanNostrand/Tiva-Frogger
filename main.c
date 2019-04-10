extern int lab7(void);
extern void printf(char*);
extern void uart_init(void);

int main(void)
{
    char test[3] = {'H', 'i', 0};
    uart_init();
    printf(test);
    //lab7();
	return 0;
}
