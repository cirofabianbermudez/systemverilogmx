---
draft: false
date: 2025-01-05
description: >
  UVM Sequence Item
authors: Ciro Bermudez
icon: octicons/package-16
hide: 
#  - navigation
#  - toc
---

# :octicons-package-16: UVM Sequence Item

## Summary

The **UVM Sequence Item** is the base class for user-defined transactions that leverage the stimulus generation and control capabilities of the sequence-sequencer mechanism.

## Coding Guidelines

<div class="justify" markdown>

!!! tip "Tip"

    - Use conditional compilation guards to avoid compiling the same include file more than once.
    - Create user-defined transaction classes by extending the class `uvm_sequence_item`.
    - Do not use field macros. (This comes at a heavy cost in terms of performance)
    - Use the `rand` qualifier in front of any class member variables that might need to be randomized, now or in the future.
    - After any member variables, define a constructor that includes a single string name argument with a default value of the empty string, a call to `super.new`, and is otherwise empty.
    - After the constructor, always override the `convert2string`, `do_copy`, `do_compare`, `do_print`, and `do_record` methods.
    - Always instantiate transaction objects using the factory.
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
- [UVM Sequences](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/uvm-sequences/)
- [Sequences](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/sequences/)
- [UVM Sequence Items](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/sequence-items/)
- [Transaction Methods](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/transaction-methods/)

**Source Code**

- [Source code `uvm_sequence_item.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/seq/uvm_sequence_item.svh)