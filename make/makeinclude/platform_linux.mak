#
# Copyright (C) 2016-2020 南京北星极网络科技有限公司
#
debug ?= 1
optimize ?= 1
#profile ?= 1
exceptions ?= 1
threads ?= 0
static ?=1

OBJEXT ?= o
LIBEXT ?= a
DLLEXT ?= so
CC_OUTPUT_FLAG ?= -o
DLL_OUTPUT_FLAG ?= -o
LINK_OUTPUT_FLAG ?= -o
ARCH:=$(shell uname -m)

ifeq (,$(debug))
  debug = 1
endif
ifeq (,$(optimize))
  optimize = 0
endif

DEFFLAGS += -DCAW_LINUX -DCAW_UNIX -DVOS_LINUX
ifeq (,$(_MACHINE))
	DEFFLAGS += -D_CPU_TYPE=$(_CPU_TYPE) -D$(_CPU_TYPE) -DOS_LINUX_PC -DCPU=$(_CPU) -D_GNU_SOURCE
	ASFLAGS += -D_CPU_TYPE=$(_CPU_TYPE) -D$(_CPU_TYPE) -DOS_LINUX_PC -DCPU=$(_CPU) -D_GNU_SOURCE
else
	DEFFLAGS += -$(_MACHINE) -D_CPU_TYPE=$(_CPU_TYPE) -D$(_CPU_TYPE) -DOS_LINUX_PC -D_GNU_SOURCE
	ASFLAGS += -$(_MACHINE) -D_CPU_TYPE=$(_CPU_TYPE) -D$(_CPU_TYPE) -DOS_LINUX_PC -D_GNU_SOURCE
endif

ifeq (1,$(debug))
	DEFFLAGS += -DDEBUG_VERSION
	DEFFLAGS += -DCAW_DEBUG
	DEFFLAGS +=-fno-builtin  -pipe -Wall -fsigned-char -g -nostdlib -fno-defer-pop
	ASFLAGS +=-fno-builtin  -pipe -Wall -fsigned-char -g -P -x assembler-with-cpp -nostdlib -fno-defer-pop
else
	DEFFLAGS += -DRELEASE_VERSION
	DEFFLAGS += -DCAW_DISABLE_TRACE
	DEFFLAGS +=-fno-builtin  -pipe -Wall -O3 -fno-strict-aliasing -fno-schedule-insns2 -fsigned-char -fno-omit-frame-pointer -nostdlib -fno-defer-pop
	ASFLAGS +=-fno-builtin  -pipe -Wall -O3 -fno-strict-aliasing -fno-schedule-insns2 -fsigned-char -fno-omit-frame-pointer -P -x assembler-with-cpp -nostdlib -fno-defer-pop
endif


ifeq ($(threads),1)
  DEFFLAGS += -D_REENTRANT
endif # threads

ifeq ($(static),0)
DEFFLAGS +=-fPIC 
ASFLAGS +=-fPIC
endif


INCLDIRS +=
LIBPATH +=
DLLSINCLUDE +=-lm -lrt -lpthread


USER_LINK_FLAGS +=$(LIBPATH)
ASFLAGS +=

INCLDIRS += $(USER_INCLDIRS)	
C_INCLDIRS += $(USER_C_INCLDIRS)		
DEFFLAGS += $(USER_DEFFLAGS) 
LIBS += $(USER_LINK_LIBS)
DLLS += $(DLLSINCLUDE) $(USER_LINK_DLLS)


CPPFLAGS += -Wno-deprecated -std=c++11 $(DEFFLAGS) $(USER_C++_DEFFLAG) $(INCLDIRS)
CFLAGS += -std=c99 $(DEFFLAGS) $(USER_C_DEFFLAGS) $(C_INCLDIRS) 
LDFLAGS += $(DLLSINCLUDE) $(USER_LINK_DLLS)
DEFLINKFLAGS +=
LDFLAGS+= $(DEFLINKFLAGS)
#ASFLAGS +=$(DEFFLAGS)
NASMFLAG += $(ASFLAGS) $(INCLDIRS)

LINK_FLAGS += $(USER_LINK_FLAGS)

COMPILE.c  = $(CC) $(CFLAGS)
COMPILE.cc  = $(CXX) $(CPPFLAGS)
COMPILE.cpp = $(CXX) $(CPPFLAGS)
COMPILE.cxx = $(CXX) $(CPPFLAGS)
COMPILE.as = $(CC) $(NASMFLAG)


LINK.c  = $(CC) $(LINK_FLAGS) $(LDFLAGS) 
LINK.cc  = $(CXX) $(LINK_FLAGS) $(LDFLAGS) 
LINK.cpp = $(CXX) $(LINK_FLAGS) $(LDFLAGS)
LINK.cxx = $(CXX) $(LINK_FLAGS) $(LDFLAGS)

NULL_STDERR = 2>$(/dev/null) || true

