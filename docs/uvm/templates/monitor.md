---
draft: false
date: 2025-01-05
description: >
  UVM Monitor 
authors: Ciro Bermudez
icon: material/monitor
hide: 
#  - navigation
#  - toc
---

# :material-monitor: UVM Monitor

## Summary

The **UVM Monitor** is


## Coding Guidelines

<div class="justify" markdown>

!!! tip "Coding Guidelines"

    - Use conditional compilation guards to avoid compiling the same include file more than once.
    ```verilog
    var_name = transaction_type::type_id::create("var_name");
    ```
</div>

## Code Example

``` sv linenums="1" title="monitor.sv"
--8<-- "docs/uvm/templates/codes/monitor.sv"
```

## Reference Material

**Accellera**

- [UVM 1.2 Class Reference `monitor`](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/files/comps/uvm_monitor-svh.html)
- [UVM 1.2 Class Reference Index](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/index.html)

**Verification Methodology Cookbooks**

- [UVM Monitor](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/uvm-monitor/)
- [Analysis Componets and Techniques](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/analysis/)
    - [Analysis Port](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/analysis-port/)
    - [Analysis Connections](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/analysis-connections/)

**Articles**

- [UVM Rapid Adoption: A Practical Subset of UVM](https://dvcon-proceedings.org/wp-content/uploads/uvm-rapid-adoption-a-practical-subset-of-uvm-paper.pdf) - 3.5 UVM Monitors

**Source code**

- [Source code `uvm_monitor.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/comps/uvm_monitor.svh)