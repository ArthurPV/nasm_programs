OBJ_DIR=obj
BIN_DIR=bin

NASM=@nasm -f elf64 -o ${OBJ_DIR}/$@
LD=@ld -o ${BIN_DIR}/$@

${OBJ_DIR}:
	@mkdir -p ${OBJ_DIR}

hello_world.o: hello_world.asm
	${NASM} $<

input.o: input.asm
	${NASM} $<

loop.o: loop.asm
	${NASM} $<

read_file.o: read_file.asm
	${NASM} $<

objs: ${OBJ_DIR} hello_world.o input.o loop.o read_file.o

${BIN_DIR}:
	@mkdir -p ${BIN_DIR}

hello_world: ${OBJ_DIR}/hello_world.o
	${LD} $<

input: ${OBJ_DIR}/input.o
	${LD} $<

loop: ${OBJ_DIR}/loop.o
	${LD} $<

read_file: ${OBJ_DIR}/read_file.o
	${LD} $<

bins: ${BIN_DIR} hello_world input loop read_file

all: objs bins

clean:
	rm -rf ${OBJ_DIR}
	rm -rf ${BIN_DIR}
