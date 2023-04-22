K_RELEASE := $(dir $(shell which kompile))..
K_BIN := $(K_RELEASE)/bin
K_LIB := $(K_RELEASE)/lib/kframework

export K_RELEASE

HOOK_NAMESPACES := YUL
CPP_FILES := hooks/yul.cpp

LLVM_KOMPILE_OPTS += -I$(K_RELEASE)/include/kllvm \
                     $(abspath $(CPP_FILES))      \
                     -std=c++14

all:
	kompile --backend llvm							\
		--hook-namespaces "$(HOOK_NAMESPACES)"		\
		$(addprefix -ccopt ,$(LLVM_KOMPILE_OPTS))	\
		yul.k