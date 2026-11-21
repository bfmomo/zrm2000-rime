// boost.thread expects this hook when the TSS cleanup implementation is
// provided by the win32 tss_pe.cpp path (libs/thread/src/tss_null.cpp does the
// same). Kept as a separate TU so the upstream sources stay untouched.
namespace boost {
void tss_cleanup_implemented(void) {}
}  // namespace boost
