---
draft: false
date: 2025-01-05
description: >
  UVM Driver
authors: Ciro Bermudez
icon: material/steering
hide: 
#  - navigation
#  - toc
---

# :material-steering: UVM Driver

## Summary

The **UVM Driver** is

## Coding Guidelines

<div class="justify" markdown>

!!! tip "Coding Guidelines"

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

``` sv linenums="1" title="driver.sv"
--8<-- "docs/uvm/templates/codes/driver.sv"
```

## Reference Material

**Accellera**

- [UVM 1.2 Class Reference `driver`](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/files/comps/uvm_driver-svh.html)
- [UVM 1.2 Class Reference Index](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/index.html)

**Verification Methodology Cookbooks**

- [Sequence API](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/sequence-api/)
- [Sequence Driver Connection](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/sequence-driver-connection/)
- [Driver Sequence API](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/driver-sequence-api/)
- [Sequence-Driver Use Models](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/sequence-driver-use-models/)
    - [Unidirectional Protocols](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/unidirectional-protocols/)
    - [Bidirectional Protocols](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/bidirectional-protocols/)
    - [Pipelined Protocols](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/pipelined-protocols/)

**Articles**

- [UVM Rapid Adoption: A Practical Subset of UVM](https://dvcon-proceedings.org/wp-content/uploads/uvm-rapid-adoption-a-practical-subset-of-uvm-paper.pdf) - 3.4.6 Driver/Sequence Synchronization

**Source code**

- [Source code `uvm_driver.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/comps/uvm_driver.svh)