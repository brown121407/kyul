#include "runtime/header.h"

extern "C" {
    const mpz_ptr hook_YUL_keccak256(string *input) {
        mpz_t result;
        mpz_init_set_ui(result, 13);
        return move_int(result);
    }
}