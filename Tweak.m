#include <mach-o/dyld.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <substrate.h>

#define DUCKOFF_LOG "/private/var/log/duckoff.log"

void (*orig_ins)();
int my_ins(void) { return 0; };

__attribute__((constructor)) static void __duckoff_main_construct(void) {
  MSImageRef img = MSGetImageByName("/System/Library/PrivateFrameworks/"
                                    "TextInputCore.framework/TextInputCore");
  if (!img) {
    FILE *err_file = fopen(DUCKOFF_LOG, "a");
    if (err_file) {
      fprintf(err_file, "kbd [DuckOff]: image `TextInputCore` not found.\n");
      fclose(err_file);
    }
    return;
  }
  /* TICandQualityFilterPolicy::is_never_suggestible(KB::Word const&) const */
  void *is_never_suggestible = MSFindSymbol(
      img,
      "__ZNK25TICandQualityFilterPolicy20is_never_suggestibleERKN2KB4WordE");
  if (!is_never_suggestible)
    is_never_suggestible =
        /* KB::WordSuggestionPolicy::is_never_suggestible(KB::Word const&, KB::String*) const */
        MSFindSymbol(img, "__ZNK2KB20WordSuggestionPolicy20is_never_suggestibleERKNS_4WordEPNS_6StringE");
  if (!is_never_suggestible) {
    FILE *err_file = fopen(DUCKOFF_LOG, "a");
    if (err_file) {
      fprintf(err_file, "kbd [DuckOff]: Failed to find required symbol.\n");
      fclose(err_file);
    }
    return;
  }
  MSHookFunction(is_never_suggestible, (void *)&my_ins, (void **)&orig_ins);
}
