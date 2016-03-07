help:
	@echo ""
	@echo "To compile all example programs "
	@echo ""
	@echo "    make all PLATFORM=<PLATFORM>"
	@echo ""
	@echo "where <PLATFORM> is one of 'copper', 'mlhpc'"

FC = mpifort
FC_copper = ftn
FC_mlhpc = mpif90
ifdef PLATFORM
    FC = ${FC_$(PLATFORM)}
endif

OMPFLAGS = -fopenmp
OMPFLAGS_copper = -mp=nonuma
OMPFLAGS_mlhpc = -fopenmp
ifdef PLATFORM
    OMPFLAGS = ${OMPFLAGS_$(PLATFORM)}
endif

PREFIX ?= $(HOME)

ALL = hello_hybrid hello_openmp hello_mpi

all: $(ALL)

install: all
	mkdir -p "$(PREFIX)/bin"
	cp $(ALL) "$(PREFIX)/bin"

uninstall:
	@for file in $(ALL); do rm -f "$(PREFIX)/bin/$file"; done

clean:
	@rm -f *.o
	@rm -f $(ALL)

hello_hybrid: hello_hybrid.f90
	$(FC) $(OMPFLAGS) -o $@ $<

hello_openmp: hello_openmp.f90
	$(FC) $(OMPFLAGS) -o $@ $<

hello_mpi: hello_mpi.f90
	$(FC) -o $@ $<

.PHONY: help all clean install uninstall
