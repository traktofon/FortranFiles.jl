FC     := gfortran
LINK   := gfortran
FFLAGS := -std=f2008 -fcheck=all -Wall -Wno-conversion
SUFFIX ?= 

RANDOMEXT := i1 i2 i4 i8 r4 r8 c8 c16 str
RANDOMSRC := $(RANDOMEXT:%=random%.f90)
RANDOMOBJ := $(RANDOMEXT:%=random%.o)

GENDATAOBJ := $(RANDOMOBJ) randutil.o gendata$(SUFFIX).o

JGENSRC := jwrite.jl jread.jl jskip.jl
FGENSRC := fdecl.f90 fwrite.f90

gendata$(SUFFIX).x: $(GENDATAOBJ)
	$(LINK) -o $@ $+

gendata$(SUFFIX).o: gendata.F90 $(FGENSRC)
	$(FC) $(FFLAGS) $(XFLAGS) -c -o $@ $<

$(RANDOMSRC): .random-stamp

.random-stamp: genrandom.jl random.ftl ftl-expand
	julia genrandom.jl
	touch $@

$(RANDOMOBJ): randutil.mod

$(FGENSRC) $(JGENSRC): .code-stamp

.code-stamp: gencode.jl
	julia gencode.jl
	touch $@

%.o: %.f90
	$(FC) $(FFLAGS) -c -o $@ $<

%.mod: %.o
	@true

clean:
	rm -f *.x *.o *.mod .*-stamp $(JGENSRC) $(FGENSRC) $(RANDOMSRC)
