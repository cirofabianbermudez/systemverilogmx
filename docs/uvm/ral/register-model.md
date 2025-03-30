---
draft: false
date: 2025-01-05
description: >
  Register Model
authors: Ciro Bermudez
icon: material/database
hide: 
#  - navigation
#  - toc
---

# :material-database: Register Model

## Summary

The **UVM Sequence Item** is the base class for user-defined transact

<div class="justify" markdown>

</div>

## Coding Guidelines

<div class="justify" markdown>

!!! tip "Tip"

    - Use conditional compilation guards to avoid compiling the same include file more than once.
    - Create user-defined transaction classes by extending the class `uvm_sequence_item`.
    - Do not use field macros. (This comes at a heavy cost in terms of performance)
    - Use the `rand` qualifier in front of any class member variables that might need to be randomized, now or in the future.
    - After any member variables, define a constructor that includes a single string name argument with a default value of the empty string, a call to `super.new`, and is otherwise empty.

## Reference Material

**Accellera**

- [UVM 1.2 Class Reference - Global Declarations for the Register Layer](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/files/reg/uvm_reg_model-svh.html)
- [UVM 1.2 Class Reference `uvm_reg_block`](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/files/reg/uvm_reg_block-svh.html)
    - [UVM 1.2 Class Reference `uvm_reg`](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/files/reg/uvm_reg-svh.html)
        - [UVM 1.2 Class Reference `uvm_reg_field`](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/files/reg/uvm_reg_field-svh.html)
    - [UVM 1.2 Class Reference `uvm_mem`](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/files/reg/uvm_mem-svh.html)
- [UVM 1.2 Class Reference Index](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/index.html)

**Verification Methodology Cookbooks**

- [UVM Cookbook pdf](https://verificationacademy.com/resource/128026c9-49b3-3eb8-92a4-08373425cd36)
- [Register Package](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/register-package/)
- [Register Model and Structure](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/register-model-and-structure/)

**Source Code**

- [Source code `uvm_reg_model.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/reg/uvm_reg_model.svh)
- [Source code `uvm_reg_block.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/reg/uvm_reg_block.svh)
    - [Source code `uvm_reg.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/reg/uvm_reg.svh)
        - [Source code `uvm_reg_field.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/reg/uvm_reg_field.svh)
    - [Source code `uvm_mem.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/reg/uvm_mem.svh)

- [Sourece code `uvm_reg_sequence.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/reg/uvm_reg_sequence.svh)

**Tools**

- [PeakRDL Github Repository](https://github.com/SystemRDL)
- [PeakRDL-uvm GitHub Repository](https://github.com/SystemRDL/PeakRDL-uvm)