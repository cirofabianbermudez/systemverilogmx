---
draft: false
date: 2025-01-05
description: >
  UVM Test
authors: Ciro Bermudez
icon: material/connection
hide: 
#  - navigation
#  - toc
---

# :material-connection: Interface

## Summary

The **Interface** is

## Coding Guidelines

<div class="justify" markdown>

!!! tip "Coding Guidelines"

    - Use one SystemVerilog interface instance per DUT interface

</div>

## Code Example

<div class="justify" markdown>

The interface construct, enclosed between the keywords `interface...endinterface`, encapsulates
the communication between design blocks, and between design and verification blocks, allowing a smooth
migration from abstract system-level design through successive refinement down to lower level register-transfer
and structural views of the design. By encapsulating the communication between blocks, the
interface construct also facilitates design reuse.

</div>


``` sv linenums="1" title="interface.sv"
--8<-- "docs/uvm/templates/codes/interface.sv"
```

## Reference Material

**IEEE**

[SystemVerilog LRM - 3.5 Interfaces]()
