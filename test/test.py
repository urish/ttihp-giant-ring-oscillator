# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 1 us (1 MHz)
    clock = Clock(dut.clk, 1, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test inverters")

    # Test for input 0
    dut.ui_in.value = 0

    # Wait for one clock cycle to see the result
    await ClockCycles(dut.clk, 1)

    # We expect all the inverter outputs to be 1
    assert dut.uo_out.value == 0xff
    assert dut.uio_out.value & 0x3f == 0x3f

    # Test for input 1
    dut.ui_in.value = 1

    # Wait for one clock cycle to see the result
    await ClockCycles(dut.clk, 1)

    # We expect all the inverter outputs to be 1
    assert dut.uo_out.value == 0x00
    assert dut.uio_out.value & 0x3f == 0x00
