FC     := gfortran
LINK   := gfortran
FFLAGS := -std=f2008 -Wall -fcheck=all

RANDOMEXT := i1 i2 i4 i8 r4 r8 c8 c16 str
RANDOMSRC := $(RANDOMEXT:%=random%.f90)
RANDOMOBJ := $(RANDOMEXT:%=random%.o)

GENDATAOBJ := $(RANDOMOBJ) gendata.o

JGENSRC := jwrite.jl jread.jl jskip.jl
FGENSRC := fdecl.f90 fwrite.f90

gendata: $(GENDATAOBJ)
	$(LINK) -o $@ $+

gendata.o: gendata.F90 $(FGENSRC)
	$(FC) $(FFLAGS) -c -o $@ $<

$(RANDOMSRC): .random-stamp

.random-stamp: random.ftl genrandom.jl ftl-expand
	julia genrandom.jl
	touch $@

$(FGENSRC) $(JGENSRC): .code-stamp

.code-stamp:
	julia gencode.jl
	touch $@

%.o: %.f90
	$(FC) $(FFLAGS) -c -o $@ $<

clean:
	rm -f gendata *.o *.mod .*-stamp $(JGENSRC) $(FGENSRC) $(RANDOMSRC)
