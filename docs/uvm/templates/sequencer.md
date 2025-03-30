---
draft: false
date: 2025-01-05
description: >
  UVM Sequencer
authors: Ciro Bermudez
icon: octicons/package-dependents-16
hide: 
#  - navigation
#  - toc
---

# :octicons-package-dependents-16: UVM Sequencer

## Summary

The **UVM Sequencer** is

## Coding Guidelines

<div class="justify" markdown>


!!! tip "Coding Guidelines"

    - Use conditional compilation guards to avoid compiling the same include file more than once.
    ```verilog
    var_name = transaction_type::type_id::create("var_name");
    ```
</div>

## Code Example

``` sv linenums="1" title="example_uvc_sequence_item.sv"
--8<-- "docs/uvm/templates/codes/sequencer.sv"
```

## Reference Material

**Accellera**

- [UVM 1.2 Class Reference `uvm_sequencer`](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/files/seq/uvm_sequencer-svh.html)
- [UVM 1.2 Class Reference Index](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/index.html)

**Verification Methodology Cookbooks**

- [UVM Cookbook pdf](https://verificationacademy.com/resource/128026c9-49b3-3eb8-92a4-08373425cd36)
- [UVM Sequences](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/uvm-sequences/)
- [Sequences](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/sequences/)
- [UVM Sequence Items](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/sequence-items/)
- [Transaction Methods](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/transaction-methods/)

**Source Code**

- [Source code `uvm_sequencer.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/seq/uvm_sequencer.svh)