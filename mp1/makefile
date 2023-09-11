# The makefile for MP1.

lab1 : aplist.c lab1.c aplist.h
	gcc -Wall -g aplist.c lab1.c -o lab1

#  @ prefix suppresses output of shell command
#  - prefix ignore errors
#  @command || true to avoid Make's error
#  : is shorthand for true
design :
	@grep "apl_array_size" lab1.c ||:
	@grep "apl_entries" lab1.c ||:
	@grep -e "-> *apl_ptr" lab1.c ||:
	@grep "ip_address" aplist.c ||:
	@grep "time_received" aplist.c ||:

clean :
	rm -f *.o lab1 core 


