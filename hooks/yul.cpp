#include "runtime/header.h"
#include <cryptopp/keccak.h>

extern "C" {
    const mpz_ptr hook_YUL_keccak256(string *input) {
        CryptoPP::Keccak_256 h;
        unsigned char digest[32];

        h.CalculateDigest(digest, (unsigned char *)input->data, len(input));

        mpz_t result;
        mpz_init(result);
        mpz_import(result, 32, 1, sizeof(digest[0]), 0, 0, digest);
        return move_int(result);
    }
}