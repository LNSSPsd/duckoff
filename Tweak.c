#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <substrate.h>
#include <mach-o/dyld.h>

void (*orig_ins)();
int my_ins(void) {
	return 0;
};

__attribute__((constructor))
static void __duckoff_main_construct(void) {
	MSImageRef img=MSGetImageByName("/System/Library/PrivateFrameworks/TextInputCore.framework/TextInputCore");
	if(!img) {
		FILE *err_file=fopen("/tmp/kbd.err.log", "a");
		if(err_file) {
			fprintf(err_file, "kbd [DuckOff]: image `TextInputCore` not found.\n");
			fclose(err_file);
		}
		return;
	}
	void *is_never_suggestible=MSFindSymbol(img, "__ZNK25TICandQualityFilterPolicy20is_never_suggestibleERKN2KB4WordE");
	if(!is_never_suggestible) {
		FILE *err_file=fopen("/tmp/kbd.err.log", "a");
		if(err_file) {
			fprintf(err_file, "kbd [DuckOff]: Failed to find symbol.\n");
			fclose(err_file);
		}
		return;
	}
	MSHookFunction(is_never_suggestible, (void *)&my_ins, (void**)&orig_ins);
	
}