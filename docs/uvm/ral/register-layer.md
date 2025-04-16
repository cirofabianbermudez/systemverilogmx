---
draft: false
date: 2025-01-05
description: >
  UVM RAL
authors: Ciro Bermudez
icon: material/layers-triple
hide: 
#  - navigation
#  - toc
---

# :material-layers-triple: Register  Layer

## Summary


<div class="justify" markdown>

The UVM _register layer_ classes are used to create a high-level, object-oriented model for memory-mapped
registers and memories in a design under verification (DUV). The UVM _register layer_ defines several base
classes that, when properly extended, abstract the read/write operations to registers and memories in a DUV.
This abstraction mechanism allows the migration of verification environments and tests from block to
system levels without any modifications.

A _register model_ is typically composed of a hierarchy of blocks that map to the design hierarchy. Blocks can
contain registers, register files and memories, as well as other blocks. The register layer classes support
front-door and back-door access to provide redundant paths to the register and memory implementation, and
verify the correctness of the decoding and access paths, as well as increased performance after the physical
access paths have been verified. Designs with multiple physical interfaces, as well as registers, register files,
and memories shared across multiple interfaces, are also supported.

Due to the large number of registers in a design
and the numerous small details involved in properly configuring the UVM register layer classes, this
specialization is normally done by a _model generator_. Model generators work from a specification of the
registers and memories in a design and thus are able to provide an up-to-date, correct-by-construction
register model.

The register model is implemented using five main building blocks - the **register field**; the **register**;
the **memory**; the **register block**; and the **register map**.

The **register field** models a collection of bits that are associated with a function within a register.
A field will have a width and a bit offset position within the register. A field can have different access
modes such as read/write, read only or write only. A **register** contains one or more fields.

A **register block** corresponds to a hardware block and contains one or more registers. A register block
also contains one or more register maps.

A **memory** region in the design is modeled by a `uvm_mem` which has a range, or size, and is contained
within a register block and has an offset determined by a register map. A memory region is modeled as
either read only, write only or read-write with all accesses using the full width of the data field.
A `uvm_memory` does not contain fields.

The **register map** defines the address space offsets of one or more registers or memories in its parent
block from the point of view of a specific bus interface. A group of registers may be accessible from
another bus interface by a different set of address offsets and this can be modeled by using another
address map within the parent block. The address map is also used to specify which bus agent is used
when a register access takes place and which adapter is used to convert generic register transfers
to/from target bus transfer `sequence_items`.

| Layer    | Register base class | Purpose                                                                                                                                                      |
| -------- | ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Fields   | `uvm_reg_field`     | Bit(s) grouped according to function with a register                                                                                                         |
| Register | `uvm_reg`           | Collection of fields at different bit offset                                                                                                                 |
| Memory   | `uvm_mem`           | Represent a block of memory which extends over a specified range                                                                                             |
| Block    | `uvm_block`         | Collection of registers (Hardware block level), or sub-blocks (Sub-system level) with one or more maps. May also include memories.                           |
| Map      | `uvm_map`           | Named address map which locates the offset address of registers, memories or sub-blocks. Also defines the target sequencer for register access from the map. |

</div>

## Register Fields

The bottom layer is the field which corresponds to one or more bits within a register. Each field
definition is an instantiation of the `uvm_reg_field` class. Fields are contained within an `uvm_reg`
class and they are constructed and then configured using the `configure()` method:

```verilog
//
// uvm_field configure method prototype
//
function void configure(
  uvm_reg        parent,                 // The containing register
  int unsigned   size,                   // How many bits wide
  int unsigned   lsb_pos,                // Bit offset within the register
  string         access,                 // "RW", "WRC", "WRS", "WO", "W1", or "WO1"
  bit            volatile,               // Volatile if bit is updated by hardware
  uvm_reg_data_t reset,                  // The reset value
  bit            has_reset,              // Whether the bit is reset
  bit            is_rand,                // Whether the bit can be randomized
  bit            individually_accessible // i.e. Totally contained within a byte lane
);                         
```

## Registers

Registers are modeled by extending the `uvm_reg` class which is a container for field objects.
The overall characteristics of the register are defined in its constructor method:

```verilog
//
// uvm_reg constructor prototype:
//
function new (
  string name="",      // Register name
  int unsigned n_bits, // Register width in bits
  int has_coverage     // Coverage model supported by the register
);
```

The register class contains a `build()` method which is used to `create()` and `configure()` the fields.
Note that this build method is not called by the UVM build phase, since the register is an uvm_object rather than an `uvm_component`.

The following code example shows how a register model is put together.

```verilog
// Reg - tdc_reg
class tdc_reg extends uvm_reg;
    `uvm_object_utils(tdc_reg)
    rand uvm_reg_field ctrl1;
    rand uvm_reg_field adj1;
    rand uvm_reg_field pixon;
    rand uvm_reg_field feon;

    function new(string name = "tdc_reg");
        super.new(name, 8, UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
        this.ctrl1 = uvm_reg_field::type_id::create("ctrl1");
        this.ctrl1.configure(this, 4, 0, "RW", 0, 'hf, 1, 1, 0);
        this.adj1 = uvm_reg_field::type_id::create("adj1");
        this.adj1.configure(this, 2, 4, "RW", 0, 'h1, 1, 1, 0);
        this.pixon = uvm_reg_field::type_id::create("pixon");
        this.pixon.configure(this, 1, 6, "RW", 0, 'h0, 1, 1, 0);
        this.feon = uvm_reg_field::type_id::create("feon");
        this.feon.configure(this, 1, 7, "RW", 0, 'h0, 1, 1, 0);
    endfunction : build
endclass : tdc_reg
```

When a register is added to a block it is created, causing its fields to be created and configured,
and then it is configured before it is added to one or more `reg_maps` to define its memory offset.

The prototype for the register `configure()` method is as follows:

```verilog
//
// Register configure method prototype
//
function void configure (
  uvm_reg_block blk_parent,           // The containing reg block
  uvm_reg_file regfile_parent = null, // Optional, not used
  string hdl_path = ""                // Used if HW register can be specified in one
);                                    // hdl_path string
```

## Memories

Memories are modeled by extending the `uvm_mem` class. The register model treats memories as regions,
or memory address ranges where accesses can take place. Unlike registers, memory values are not
stored because of the workstation memory overhead involved.

The range and access type of the memory is defined via its constructor:

```verilog
//
// uvm_mem constructor prototype:
//
function new (
  string           name,                           // Name of the memory model
  longint unsigned size,                           // The address range
  int unsigned     n_bits,                         // The width of the memory in bits
  string           access = "RW",                  // Access - one of "RW" or "RO"
  int              has_coverage = UVM_NO_COVERAGE  // Functional coverage
);
```

An example of a memory class implementation:

```verilog
// Memory array 1 - Size 32'h2000;
class mem_model extends uvm_mem;
 
`uvm_object_utils(mem_model)
 
function new(string name = "mem_model");
  super.new(name, 32'h2000, 32, "RW", UVM_NO_COVERAGE);
endfunction
 
endclass: mem_model
```

## Register Maps

The purpose of the register map is two fold. The map provides information on the offset of the registers,
memories and/or register blocks contained within it. The map is also used to identify which bus agent
register based sequences will be executed on, however this part of the register maps functionality
is set up when integrating the register model into an UVM testbench.

In order to add a register or a memory to a map, the `add_reg()` or `add_mem()` methods are used.
The prototypes for these methods are very similar:

```verilog
//
// uvm_reg_map add_reg method prototype:
//
function void add_reg (
  uvm_reg           rg,             // Register object handle
  uvm_reg_addr_t    offset,         // Register address offset
  string            rights = "RW",  // Register access policy
  bit               unmapped=0,     // If true, register does not appear in the address
                                    // map and a frontdoor access needs to be defined
  uvm_reg_frontdoor frontdoor=null  // Handle to register frontdoor access object
);
```

```verilog
//
// uvm_reg_map add_mem method prototype:
//
function void add_mem (
  uvm_mem        mem,               // Memory object handle
  uvm_reg_addr_t offset,            // Memory address offset
  string         rights = "RW",     // Memory access policy
  bit            unmapped=0,        // If true, memory is not in the address map
                                    // and a frontdoor access needs to be defined
  uvm_reg_frontdoor frontdoor=null  // Handle to memory frontdoor access object
);
```

There can be several register maps within a block, each one can specify a different address map and a different target bus agent.

## Register Blocks

The next level of hierarchy in the UVM register structure is the `uvm_reg_block`.
This class can be used as a container for registers and memories at the block level,
representing the registers at the hardware functional block level, or as a container
for multiple blocks representing the registers in a hardware sub-system or a
complete SoC organized as blocks.

In order to define register and memory address offsets the block contains an
address map object derived from `uvm_reg_map`. A register map has to be created
within the register block using the create_map method:

```verilog
//
// Prototype for the create_map method
//
function uvm_reg_map create_map(
  string name,               // Name of the map handle
  uvm_reg_addr_t base_addr,  // The maps base address
  int unsigned n_bytes,      // Map access width in bytes
  uvm_endianness_e endian,   // The endianess of the map
  bit byte_addressing=1      // Whether byte_addressing is supported
);                         
 
//
// Example:
//
AHB_map = create_map("AHB_map", 'h0, 4, UVM_LITTLE_ENDIAN);
```

_Endianness_ refers to the order in which bytes of a multi-byte data value (such as a 32-bit or 64-bit number) are stored in memory.
There are two primary forms:

- **Little Endian**:

    In little endian systems, the least significant byte (the “smallest” part of the number) is stored at the lowest memory address
    (i.e., first in the sequence). For example, the hexadecimal number `0x12345678` would be stored in memory as:  `78 56 34 12`.

- **Big Endian**:

    In big endian systems, the most significant byte is stored at the lowest memory address (i.e., first in the sequence).
    In the same example, `0x12345678` would be stored as: `12 34 56 78`.

Endianness is critical when interfacing between systems (or hardware components) that might use different byte orders.
A misinterpretation of byte order may lead to incorrect data values being read or written, which is particularly relevant
in register mapping and hardware interfacing.

The `n_bytes` parameter is the word size (bus width) of the bus to which the map is associated. If a register's width exceeds
the bus width, more than one bus access is needed to read and write that register over that bus. The `byte_addressing` argument
affects how the address is incremented in these consecutive accesses.

For example, if `n_bytes=4` and `byte_addressing=0`, then an access to a register that is 64-bits wide and at offset 0 will
result in two bus accesses at addresses 0 and 1. With `byte_addressing=1`, that same access will result in two bus accesses
at addresses 0 and 4.

The first map to be created within a register block is assigned to the `default_map` member of the register block.

The following code example, this declares the register class handles for each of the registers, then the `build()` method
constructs and configures each of the registers before adding them to a map at the appropriate offset address:

```verilog
// Addrmap - design_reg_block
class design_reg_block extends uvm_reg_block;
    `uvm_object_utils(design_reg_block)
    rand tdc_reg SET_TDC_DCO1_00;
    rand tdc_reg SET_TDC_DCO1_01;
    rand tdc_reg SET_TDC_DCO1_02;
    rand tdc_reg SET_TDC_DCO1_03;

    function new(string name = "design_reg_block");
        super.new(name);
    endfunction : new

    virtual function void build();

        this.SET_TDC_DCO1_00 = tdc_reg::type_id::create("SET_TDC_DCO1_00");
        this.SET_TDC_DCO1_00.configure(this);
        this.SET_TDC_DCO1_00.build();

        this.SET_TDC_DCO1_01 = tdc_reg::type_id::create("SET_TDC_DCO1_01");
        this.SET_TDC_DCO1_01.configure(this);
        this.SET_TDC_DCO1_01.build();

        this.SET_TDC_DCO1_02 = tdc_reg::type_id::create("SET_TDC_DCO1_02");
        this.SET_TDC_DCO1_02.configure(this);
        this.SET_TDC_DCO1_02.build();

        this.SET_TDC_DCO1_03 = tdc_reg::type_id::create("SET_TDC_DCO1_03");
        this.SET_TDC_DCO1_03.configure(this);
        this.SET_TDC_DCO1_03.build();

        this.SET_TDC_DCO1_04 = tdc_reg::type_id::create("SET_TDC_DCO1_04");
        this.SET_TDC_DCO1_04.configure(this);
        this.SET_TDC_DCO1_04.build();

        // Map name, Offset, Number of bytes, Endianess
        this.default_map = create_map("reg_map", 0, 1, UVM_NO_ENDIAN);

        this.default_map.add_reg(this.SET_TDC_DCO1_00, 'h0);
        this.default_map.add_reg(this.SET_TDC_DCO1_01, 'h1);
        this.default_map.add_reg(this.SET_TDC_DCO1_02, 'h2);
        this.default_map.add_reg(this.SET_TDC_DCO1_03, 'h3);
        this.default_map.add_reg(this.SET_TDC_DCO1_04, 'h4);

    endfunction : build
endclass : mattonella_reg_block

```

## Hierarchical Register Blocks

The cluster block incorporates each sub-block and adds them to a new cluster level address map.
This process can be repeated and a full SoC register map might contain several nested layers of register blocks.

The procedure is similar to that used for a standard register block. However, in this case, you utilize a class member of type `uvm_reg_block` instead of `uvm_reg`,
and instead of using `add_reg()` you call `add_submap()`.

```verilog
//
// uvm_reg_map add_submap method prototype:
//
function void add_submap (
  uvm_reg_map    child_map, // Name of the child map
  uvm_reg_addr_t offset     // Offset in father reg_block
);
```

This is an example:

```verilog
package pss_reg_pkg;
 
  import uvm_pkg::*;
  `include "uvm_macros.svh"
   
  import spi_reg_pkg::*;
  import gpio_reg_pkg::*;
   
  class pss_reg_block extends uvm_reg_block;
   
  `uvm_object_utils(pss_reg_block)

  rand spi_reg_block spi;
  rand gpio_reg_block gpio;
   
  function new(string name = "pss_reg_block");
    super.new(name);
  endfunction
   
  function void build();
   
    spi = spi_reg_block::type_id::create("spi");
    spi.configure(this);
    spi.build();
   
    gpio = gpio_reg_block::type_id::create("gpio");
    gpio.configure(this);
    gpio.build();

    AHB_map = create_map("AHB_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map = AHB_map;
    AHB_map.add_submap(this.spi.default_map, 0);
    AHB_map.add_submap(this.gpio.default_map, 32'h100);
   
    lock_model();
  endfunction: build
   
  endclass: pss_reg_block
 
endpackage: pss_reg_pkg
```

## Functions

This are some functions you need to know:

```verilog
regmodel.lock_model();
regmodel.default_map.set_auto_predict(0);
```

## Mirroring




## Reference Material

**Accellera**

- [UVM 1.2 User Guide](https://www.accellera.org/images//downloads/standards/uvm/uvm_users_guide_1.2.pdf)
- [UVM 1.2 Class Reference `uvm_sequence_item`](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/files/seq/uvm_sequence_item-svh.html)
- [UVM 1.2 Class Reference Index](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/index.html)
- [UVM 1.2 Global Declarations for the Register Layer](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/files/reg/uvm_reg_model-svh.html)

**Verification Methodology Cookbooks**

- [UVM Cookbook pdf](https://verificationacademy.com/resource/128026c9-49b3-3eb8-92a4-08373425cd36)
- [Register Model and Structure](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/register-model-and-structure/)

**Source Code**

- [Source code `uvm_reg_field.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/reg/uvm_reg_field.svh)
- [Source code `uvm_reg.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/reg/uvm_reg.svh)
- [Source code `uvm_reg_block.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/reg/uvm_reg_block.svh)
- [Source code `uvm_mem.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/reg/uvm_mem.svh)
- [Source code `uvm_reg_map.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/reg/uvm_reg_map.svh)



- [Source code `uvm_reg_adapter.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/reg/uvm_reg_adapter.svh)
- [Source code `uvm_reg_predictor.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/reg/uvm_reg_predictor.svh)
