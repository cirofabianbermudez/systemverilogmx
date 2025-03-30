---
draft: false
date: 2025-01-05
description: >
  UVM Agent
authors: Ciro Bermudez
icon: fontawesome/solid/user
hide: 
#  - navigation
#  - toc
---

# :fontawesome-solid-user: UVM Agent

## Summary

The **UVM Agent** is the base class for user-defined transactions that leverage the stimulus generation and control capabilities of the sequence-sequencer mechanism.

## Coding Guidelines

<div class="justify" markdown>

!!! tip "Tip"

    - Use conditional compilation guards to avoid compiling the same include file more than once.
    ```verilog
    var_name = transaction_type::type_id::create("var_name");
    ```

</div>

## Code Example

``` sv linenums="1" title="agent.sv"
--8<-- "docs/uvm/templates/codes/agent.sv"
```

## Reference Material

**Accellera**

- [UVM 1.2 Class Reference `uvm_agent`](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/files/comps/uvm_agent-svh.html)
- [UVM 1.2 Class Reference Index](https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.2/html/index.html)

**Verification Methodology Cookbooks**

- [UVM Cookbook pdf](https://verificationacademy.com/resource/128026c9-49b3-3eb8-92a4-08373425cd36)
- [UVM Sequences](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/uvm-sequences/)
- [Sequences](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/sequences/)
- [UVM Sequence Items](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/sequence-items/)
- [Transaction Methods](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/transaction-methods/)

**Source Code**

- [Source code `uvm_agent.svh`](https://github.com/edaplayground/eda-playground/blob/master/docs/_static/uvm-1.2/src/comps/uvm_agent.svh)