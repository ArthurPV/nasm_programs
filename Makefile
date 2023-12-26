OBJ_DIR=obj
BIN_DIR=bin

NASM=@nasm -f elf64 -o ${OBJ_DIR}/$@
LD=@ld

${OBJ_DIR}:
	@mkdir -p ${OBJ_DIR}

hello_world.o: hello_world.asm
	${NASM} $<

input.o: input.asm
	${NASM} $<

loop.o: loop.asm
	${NASM} $<

objs: ${OBJ_DIR} hello_world.o input.o loop.o

${BIN_DIR}:
	@mkdir -p ${BIN_DIR}

hello_world: ${OBJ_DIR}/hello_world.o
	${LD} $< -o ${BIN_DIR}/$@

input: ${OBJ_DIR}/input.o
	${LD} $< -o ${BIN_DIR}/$@

loop: ${OBJ_DIR}/loop.o
	${LD} $< -o ${BIN_DIR}/$@

bins: ${BIN_DIR} hello_world input loop

all: objs bins

clean:
	rm -rf ${OBJ_DIR}
	rm -rf ${BIN_DIR}
