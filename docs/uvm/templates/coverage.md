---
draft: false
date: 2025-01-05
description: >
  Coverage
authors: Ciro Bermudez
icon: fontawesome/solid/chart-pie
hide: 
#  - navigation
#  - toc
---

# :fontawesome-solid-chart-pie: Coverage

## Summary

To understand the verification progress you need to answer the following questions:

- Were all the design features and requirements identified in the testplan verified?
- Were there lines of code or structures in the design model that were never exercised?

**Coverage** is the metric we use during simulation to help us answer these questions,
in other words is a simulation metric we use to measure verification progress and completeness.


## Coding Guidelines

<div class="justify" markdown>

!!! tip "Tip"

    - Use conditional compilation guards to avoid compiling the same include file more than once.
    ```verilog
    var_name = transaction_type::type_id::create("var_name");
    ```

</div>

## Code Example

``` sv linenums="1" title="sequence_item.sv"
--8<-- "docs/uvm/templates/codes/sequence_item.sv"
```

## Reference Material

**Accellera**

- [UVM 1.2 Class Reference `uvm_sequence_item`](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/files/seq/uvm_sequence_item-svh.html)
- [UVM 1.2 Class Reference Index](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/index.html)

**Verification Methodology Cookbooks**

- [UVM Cookbook pdf](https://verificationacademy.com/resource/128026c9-49b3-3eb8-92a4-08373425cd36)
- [Coverage Cookbook pdf](https://verificationacademy.com/resource/8daf0863-7af2-3986-87f6-1062b7aac144)

**Source Code**

- [Source code `uvm_sequence_item.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/seq/uvm_sequence_item.svh)