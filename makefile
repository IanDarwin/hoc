YFLAGS = -d
#CFLAGS = -g

SRC = hoc.y hoc.h code.c init.c math.c symbol.c
OBJS = hoc.o code.o init.o math.o symbol.o

hoc:	$(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -lm -o hoc

hoc.o code.o init.o symbol.o:	hoc.h

code.o init.o symbol.o:	x.tab.h

.if ${MACHINE_ARCH} == "i386"
code.o: code.c
	$(CC) $(CFLAGS) -O0 -c code.c 
.endif

x.tab.h:	y.tab.h
	-cmp -s x.tab.h y.tab.h || cp y.tab.h x.tab.h

install:	hoc
	cp hoc /usr/bin
	strip /usr/bin/hoc

y.tab.h y.tab.c: hoc.y
	yacc ${YFLAGS} hoc.y

clean:
	rm -f $(OBJS) [xy].tab.[ch]  hoc

bundle:
	@bundle $(SRC) makefile README

# a few basic tests
regress:
	echo 2/3 | hoc | grep '^0.66666666*7$$' >/dev/null
	echo 'x=22/7\nprint x' | hoc | grep '^3.142857' >/dev/null
