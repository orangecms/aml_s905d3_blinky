#![no_std]
#![no_main]
#![allow(unused)]

use core::panic::PanicInfo;
use core::ptr::{read_volatile, write_volatile};

const WATCHDOG: usize = 0xffd0_f0d0;
const GPIO2_EN: usize = 0xff63_4458;
const GPIO2_OUT: usize = 0xff63_445c;

#[export_name = "start"]
#[link_section = ".text.entry"]
unsafe fn start() -> ! {
    let v = read_volatile(WATCHDOG as *mut u32);
    write_volatile(WATCHDOG as *mut u32, v & (!((1 << 18) | (1 << 25))));
    write_volatile(GPIO2_EN as *mut u32, 0xffff_ff37);
    loop {
        for _i in 0..0x00c00000 {
            write_volatile(GPIO2_OUT as *mut u32, 0xffff_ffff);
        }
        for _i in 0..0x00c00000 {
            write_volatile(GPIO2_OUT as *mut u32, 0xffff_ff37);
        }
    }
}

#[cfg_attr(not(test), panic_handler)]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
