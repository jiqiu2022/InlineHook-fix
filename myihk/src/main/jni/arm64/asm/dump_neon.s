.include "base.s"

//.extern _dump_start
//.extern _dump_end
//.extern _hk_info

//.set _dump_start, r_dump_start
//.set _dump_end, r__dump_end
//.set _hk_info, r__hk_info

//.global _dump_start
//.global _dump_end
//.global _hk_info

//.hidden _dump_start
//.hidden _dump_end
//.hidden _hk_info

//可用于标准的c/c++函数、非标准函数、函数的一部分(用于读写寄存器)，前提都是字节长度足够
//非标准函数即非c/c++编译的函数，那么手写汇编可能存在并不遵守约定的情况，比如我们使用了sp寄存器，并在未使用的栈上保存寄存器
//但是可能不是满递减而是反过来满递增，或者不遵守栈平衡，往栈上写数据，但是并不改变sp寄存器。当然应该是很少见的。

.data

_dump_start:                    //用于读写寄存器/栈，需要自己解析参数，不能读写返回值，不能阻止原函数(被hook函数)的执行
                                //从行为上来我觉得更偏向dump，所以起名为dump。
    sub     sp, sp, #0x20;      //跳板在栈上存储了x0、x1，但是未改变sp的值

    mrs     x0, NZCV
    str     x0, [sp, #0x10];    //覆盖跳板存储的x1，存储状态寄存器
    str     x30, [sp];          //存储x30
    add     x30, sp, #0x20
    str     x30, [sp, #0x8];    //存储真实的sp
    ldr     x0, [sp, #0x18];    //取出跳板存储的x0

save_x0_x29://保存寄存器x0-x29
    sub     sp, sp, #0xf0;      //分配栈空间
    stp     X0, X1, [SP];       //存储x0-x29
    stp     X2, X3, [SP,#0x10]
    stp     X4, X5, [SP,#0x20]
    stp     X6, X7, [SP,#0x30]
    stp     X8, X9, [SP,#0x40]
    stp     X10, X11, [SP,#0x50]
    stp     X12, X13, [SP,#0x60]
    stp     X14, X15, [SP,#0x70]
    stp     X16, X17, [SP,#0x80]
    stp     X18, X19, [SP,#0x90]
    stp     X20, X21, [SP,#0xa0]
    stp     X22, X23, [SP,#0xb0]
    stp     X24, X25, [SP,#0xc0]
    stp     X26, X27, [SP,#0xd0]
    stp     X28, X29, [SP,#0xe0]

save_v0_v31:
    sub     sp, sp, #0x200;      //分配栈空间
    #stp     D0, D1, [SP];      //理论上是不是只保存存储double的部分就可以？
    stp     Q0, Q1, [SP];       //不支持V0-V31,但是支持Q0-Q31，一致，每个寄存器占128位，低64位保存double，低32位float
    stp     Q2, Q3, [SP, #0x20];
    stp     Q4, Q5, [SP, #0x40];
    stp     Q6, Q7, [SP, #0x60];
    stp     Q8, Q9, [SP, #0x80];
    stp     Q10, Q11, [SP, #0xa0];
    stp     Q12, Q13, [SP, #0xc0];
    stp     Q14, Q15, [SP, #0xe0];

    stp     Q16, Q17, [SP, #0x100];
    stp     Q18, Q19, [SP, #0x120];
    stp     Q20, Q21, [SP, #0x140];
    stp     Q22, Q23, [SP, #0x160];
    stp     Q24, Q25, [SP, #0x180];
    stp     Q26, Q27, [SP, #0x1a0];
    stp     Q28, Q29, [SP, #0x1c0];
    stp     Q30, Q31, [SP, #0x1e0];

call_onPreCallBack://调用onPreCallBack函数，第一个参数是sp，第二个参数是STR_HK_INFO结构体指针
    mov     x0, sp;                 //x0作为第一个参数，那么操作x0=sp，即操作栈读写保存的寄存器
    ldr     x1, _hk_info;
    ldr     x3, [x1];               //onPreCallBack
    bl      get_lr_pc;              //lr为下条指令
    add     lr, lr, #8;              //lr为blr x3的地址
    str     lr, [sp, #0x308];        //lr当作pc，覆盖栈上的x0
    blr     x3

restore_regs://恢复寄存器
    #ldp     D0, D1, [SP];
    ldp     Q0, Q1, [SP];
    ldp     Q2, Q3, [SP, #0x20];
    ldp     Q4, Q5, [SP, #0x40];
    ldp     Q6, Q7, [SP, #0x60];
    ldp     Q8, Q9, [SP, #0x80];
    ldp     Q10, Q11, [SP, #0xa0];
    ldp     Q12, Q13, [SP, #0xc0];
    ldp     Q14, Q15, [SP, #0xe0];

    ldp     Q16, Q17, [SP, #0x100];
    ldp     Q18, Q19, [SP, #0x120];
    ldp     Q20, Q21, [SP, #0x140];
    ldp     Q22, Q23, [SP, #0x160];
    ldp     Q24, Q25, [SP, #0x180];
    ldp     Q26, Q27, [SP, #0x1a0];
    ldp     Q28, Q29, [SP, #0x1c0];
    ldp     Q30, Q31, [SP, #0x1e0];
    add     sp, sp, #0x200;

    ldr     x0, [sp, #0x100];       //取出状态寄存器
    msr     NZCV, x0

    ldp     X0, X1, [SP];           //恢复x0-x29寄存器
    ldp     X2, X3, [SP,#0x10]
    ldp     X4, X5, [SP,#0x20]
    ldp     X6, X7, [SP,#0x30]
    ldp     X8, X9, [SP,#0x40]
    ldp     X10, X11, [SP,#0x50]
    ldp     X12, X13, [SP,#0x60]
    ldp     X14, X15, [SP,#0x70]
    ldp     X16, X17, [SP,#0x80]
    ldp     X18, X19, [SP,#0x90]
    ldp     X20, X21, [SP,#0xa0]
    ldp     X22, X23, [SP,#0xb0]
    ldp     X24, X25, [SP,#0xc0]
    ldp     X26, X27, [SP,#0xd0]
    ldp     X28, X29, [SP,#0xe0]
    add     sp, sp, #0xf0

    ldr     x30, [sp];              //恢复x30
    add     sp, sp, #0x20;          //恢复为真实sp

call_oriFun:
    stp     X1, X0, [SP, #-0x10];   //因为跳转还要占用一个寄存器，所以保存
    ldr     x0, _hk_info;
    ldr     x0, [x0, #8];           //pOriFuncAddr
    br      x0

get_lr_pc:
    ret;                            //仅用于获取LR/PC

_hk_info:                           //结构体STR_HK_INFO
.quad 0xffffffffffffffff


_dump_end:

.end
