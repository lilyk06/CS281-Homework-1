// Widened from 3 to 7 elements specifically to amplify the -O1
// finding: x86-64 can fold each extra array term straight into the
// add itself (`add reg, [mem]`, one instruction per extra term,
// confirmed in a real run of buildandrunwcode_O1.sh), while RISC-V's
// ALU only ever operates on registers, so it pays two instructions per
// extra term (a separate `ld` plus a separate register-register
// `add`), no matter the optimization level. A 2-term sum showed this
// at roughly 3-vs-6 instructions; a 6-term sum should show it at
// roughly 7-vs-14, the same underlying cost scaled up to be more
// visually dramatic in a live demo.
long a[7] = {10,20,30,40,50,60,0};
long b;

long main(void)
{
    a[6] = a[0] + a[1] + a[2] + a[3] + a[4] + a[5];
    b = b + 5;

    return b;
}