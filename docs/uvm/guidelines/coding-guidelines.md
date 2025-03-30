---
draft: false
date: 2025-01-05
description: >
  UVM Guidelines
authors: Ciro Bermudez
icon: fontawesome/solid/ruler
hide: 
#  - navigation
#  - toc
---

# :fontawesome-solid-ruler: UVM Coding Guidelines

This UVM Coding Guidelines are heavily influenced by:

- [Easier UVM Coding Guidelines](https://www.doulos.com/media/1277/easier-uvm-coding-guidelines-2016-06-24.pdf)
- [Verification Academy - UVM Coding Guidelines](https://verificationacademy.com/cookbook/uvm-universal-verification-methodology/uvm-guidelines/)

We encourage users to follow these recommendations so that the code becomes more readable and easier to maintain. By doing so, you will also benefit from better performance and simpler integration.

## Lexical Guidelines and Naming Conventions

<div class="justify" markdown>

- Have only one declaration or statement per line.

- When creating user-defined names for SystemVerilog variables and classes,
use lower-case words separated by underscores (as opposed to camelBackStyle).

- When creating user-defined names for SystemVerilog enum literals, constants,
and parameters, use upper-case words separated by underscores.

- Restrict all user-defined UVM instance names (that is, strings such as
component instance names) to the character set a-z, A-Z, 0-9 and _ (underscore).

- Use shorter names for local variables and longer, more descriptive names for global items such as
class names and package names.

- Use the prefix `m_` before the names of user-defined class member variables (officially known as class
properties in SystemVerilog)

- Use the names `m_sequencer`, `m_driver`, and `m_monitor` as the instance names of the sequencer,
driver, and monitor respectively within every agent.

- Use the suffixes `_env` and `_agent` after the instance names of every env and agent, respectively.

- Use the name `m_config` as the instance name of the configuration object within any component or
sequence that has one.

- Use the suffix `_config` after user-defined configuration class names.

- Use the suffix `_port` after user-defined port names

- Use the suffix `_export` after user-defined export names.

- Use the suffix `_vif` after user-defined virtual interface names.

- Use the suffix `_t` after user-defined type definitions introduced using the keyword typedef.

- Use the suffix `_pkg` after user-defined package names.

- Write comments wherever they add value to the source code and help the reader to understand the
purpose of the code.

- Include white space (blank lines, indentation) wherever it helps to make the code more readable.

- When overriding built-in UVM virtual methods, do not insert the `virtual` keyword at the start of the
overridden method definition.

</div>

## General Code Structure

<div class="justify" markdown>

- Use a consistent file structure and a consistent file naming convention throughout.

- Each class should be defined within a package (as opposed to defining classes within modules or at
file scope).

- Use ``include` directives within a package to allow each class to be placed in a separate file

- Use conditional compilation guards to avoid compiling the same include file more than once.

    ``` verilog
    `ifndef BUS_PKG_SV
    `define BUS_PKG_SV
    ...
    `endif // BUS_PKG_SV
    ```

- Include `uvm_macros.svh` and `import uvm_pkg::*` inside each package or module that refers to the
UVM base class library.

    ``` verilog
    `ifndef BUS_PKG_SV
    `define BUS_PKG_SV

    package bus_pkg;
      `include "uvm_macros.svh"
      import uvm_pkg::*;
      
      `include "bus_tx.sv"
      `include "bus_config.sv"
      `include "bus_driver.sv"
      `include "bus_monitor.sv"
      `include "bus_sequencer.sv"
      `include "bus_agent.sv"
      `include "bus_coverage.sv"
      `include "bus_seq_lib.sv"
    endpackage

    `endif // BUS_PKG_SV
    ```

- Use one agent per interface, with a passive monitor and optional sequencer and driver whose
existence is determined by the value of the `get_is_active` method of class `uvm_agent`.

- An agent should not instantiate components other than the canonical agent structure of one
sequencer, one driver, and one monitor.

- Use virtual sequences to co-ordinate the stimulus generation activities of multiple parallel agents

- Checking and functional coverage collection should be performed in checkers, scoreboards, coverage
collectors, and other ad hoc subscriber components that are instantiated external to any agent and
connected to the analysis port of the monitor.

- In general, connect agents, checkers, scoreboards, and coverage collectors using analysis ports and
exports.

- UVM envs should be written such that they can be used as top-level envs or reused as sub-envs in
other larger verification environments.

- Use factory overrides and/or the configuration database to adapt the behavior of repurposed UVM
components to the needs of a new verification environment.

</div>

## Clocks, Timing, Synchronization, and Interfaces

<div class="justify" markdown>

- Generate clocks and resets in a SystemVerilog module, never in the UVM class-based verification
environment and never in a SystemVerilog program.

- Use SystemVerilog modules in preference to SystemVerilog programs.

- Use clocking blocks within a SystemVerilog interface in order to sense and drive a synchronous DUT
interface.

- Use modports to enforce the use of clocking blocks where those clocking blocks are accessed through
a virtual interface from the UVM verification environment.

- Use modports that combine a clocking block with asynchronous signals in order to access an interface
that combines synchronous and asynchronous signals.

- In the verification environment, try where possible to confine synchronization to signals in the DUT
interface and explicit delays to drivers and monitors, with other UVM components being untimed.

- If a driver needs to insert variable delays within or between transactions when driving the pins of an
interface, this should be handled by storing delays in the transaction passed to the driver.

- A driver should pull transactions from a sequencer using the non-blocking `try_*` methods in order to
maximize reusability in the scenario where the author cannot know whether the sequence will block the
execution of the driver.

- A driver should only pull down transactions from the sequencer when it needs them.

- Use the `uvm_event` or `uvm_barrier` for ad hoc synchronization between sequences and/or analysis
components such as scoreboards.

- A monitor should not assign values to variables or wires in the SystemVerilog interface.

- Use concurrent assertions and cover property in interfaces for protocol checking and related
coverage collection.

</div>

## Transactions

<div class="justify" markdown>

- Create user-defined transaction classes by extending the class `uvm_sequence_item`.

- Try to minimize the number of distinct transaction classes.

- Register the transaction class with the factory using the macro ``uvm_object_utils` as the first line
within the class.

- Do not use field macros.

- After the factory registration macro, declare any member variables (using the prefix `m_` as a naming
convention).

- Use the `rand` qualifier in front of any class member variables that might need to be randomized, now
or in the future.

- After any member variables, define a constructor that includes a single string name argument with a
default value of the empty string, a call to `super.new`, and is otherwise empty.

    ``` verilog
    function new (string name = "");
      super.new(name);
    endfunction
    ```

- After the constructor, always override the `convert2string`, `do_copy`, `do_compare`, `do_print`, and
`do_record` methods.

- Consider overriding the `do_pack` and `do_unpack` methods.

- When overriding `do_pack` and `do_unpack`, use the packing and unpacking macros (e.g.
``uvm_pack_int`) where they will simplify the code.

- When overriding do_record, use the recording macros (e.g. ``uvm_record_attribute` and
``uvm_record_field`) where they will simplify the code.

- When overriding the `do_print`, `do_record`, `do_compare`, and do_pack methods methods, do not
make use of the printer, recorder, comparer, and packer policy object arguments to those methods
within the body of the overridden method.

- Always instantiate transaction objects using the factory.

    ``` verilog
    var_name = transaction_type::type_id::create("var_name");
    ```

- In general, the string name of the transaction should be the same as the variable name.

</div>

## Sequences

<div class="justify" markdown>

- Create user-defined sequence classes by extending the class `uvm_sequence`, parameterized with the
type of the transaction to be generated by the sequence.

- Register the sequence class with the factory using the macro ``uvm_object_utils` as the first line
within the class.

- After the factory registration macro, declare any member variables (using the prefix `m_` as a naming
convention).

- Use the `rand` qualifier in front of any class member variables that might need to be randomized, now
or in the future.

- After the member variables (if any), define a constructor that includes a single string name argument
with a default value of the empty string, a call to `super.new`, and is otherwise empty.

    ``` verilog
    function new (string name = "");
      super.new(name);
    endfunction
    ```

- Any housekeeping code associated with the execution of a sequence, such as raising and lowering
objections, should be placed in the `pre_start` and `post_start` methods of the sequence.

- When generating transactions from the body task of a sequence, do so using procedural code with
the following general pattern:

    ``` verilog
    req = tx_type::type_id::create("req");
    start_item(req);
    if ( !req.randomize() ) begin
    ...
    end
    finish_item(req);
    ```

- Do not use the ``uvm_do` family of macros.

- Use the built-in transaction variables `req` and `rsp` within a sequence, unless there is a specific reason
to choose different variable names.

- Only generate sequence items (transactions) from UVM sequences, not from ad hoc classes and not
from UVM components.

- Always instantiate sequence objects using the factory. Instantiations should take the form:

    ```verilog
    seq_name = sequence_type::type_id::create("seq_name");
    ```

- The string name of each sequence object should be the same as the variable name.

- When creating a sequence object, always call the randomize method of the sequence object before
starting the sequence.

- Start sequences procedurally by calling their start method.

    ```verilog
    seq_name = sequence_type::type_id::create("seq_name");
    if ( !seq_name.randomize() with { ... } )
      `uvm_error( ... )
    seq_name.start(sequencer);
    ```

- Only override the `pre_do`, `mid_do`, and/or `post_do` callbacks of a sequence class as a way to modify
the behavior of a pre-existing "immutable" sequence class.

- Use the macro `uvm_declare_p_sequencer` to declare a variable `p_sequencer` in situations where a
sequence needs access to the sequencer on which it is running.

- Where a sequence needs access to a sequencer other than the sequencer on which it is itself running,
add a member variable to the sequence object and assign that variable to refer to the other sequencer
before starting the sequence.

</div>

## Stimulus and Phasing

<div class="justify" markdown>

- Use a virtual sequence to coordinate the behavior of multiple agents.

- Virtual sequences should be started on the null sequencer.

- Have a top-level sequence running on each agent that selects between all permissible child
sequences at random.

- Keep sequences as generic as possible. Avoid writing directed sequences except where absolutely
necessary.

- Sequences should not be phase-aware.

- Do override the run-time phase methods `reset_phase`, `configure_phase`, `main_phase`,
`shutdown_phase` to generate stimulus, typically by starting sequences, but never in a driver, monitor,
subscriber, or scoreboard component.

- Do introduce user-defined run-time phases where the above predefined run-time phase methods are
inappropriately named or would cause confusion.

- When integrating multiple environments that each override the predefined or user-defined run-time
phase methods, take care to order the phases correctly by introducing phase domains and synchronizing
phases across domains.

- Do not override the predefined pre- and post- phase methods (e.g. `pre_reset_phase`), but reserve
these phase for use when synchronizing phases across domains.

</div>

## Objections

<div class="justify" markdown>

- Determine when to end the test by raising and dropping objections in any classes that may need to
extend the test while they complete some processing. (This rule has changed significantly since the first
preliminary release of these guidelines.)

- Call the `set_propagate_mode(0)` method of every objection (UVM 1.2 onward) to disable the
hierarchical propagation of that objection

- Consider the simulation speed impact of raising and dropping objections in inner loops, e.g. for
individual transactions. Remove objections from inner loops if the simulation speed penalty is
significant.

- Where a sequence is to raise and drop objections, it should call `raise_objection` in its `pre_start`
method and `drop_objection` in its `post_start` method.

- Always perform the test if `(starting_phase != null)` before calling `raise_objection` or `drop_objection`
within a sequence.

- When starting a sequence that can raise and drop objections, if you want the sequence to raise and
drop objections, set the `starting_phase` member of the sequence object before starting the sequence.

- When calling `raise_objection` or `drop_objection`, always pass a string as a 2nd argument to describe
the objection to help with debug.

- If the kill method of a sequence is called and the sequence can raise an objection, ensure that the
`do_kill` method of the sequence is overridden to drop the objection.

</div>

## Components

<div class="justify" markdown>

- Create user-defined component classes by extending the appropriate subclass of class
`uvm_component` in order to indicate intent.

- Register the component class with the factory using the macro ``uvm_component_utils` as the first
line within the class.

- After the factory registration macro, declare any ports, exports and virtual interfaces

- After the ports, exports, and virtual interfaces, declare any member variables (using the prefix `m_` as
a naming convention).

- After any member variables, define a constructor that includes string name and parent arguments
with no default values and a call to `super.new`.

    ```verilog
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    ```

- Instantiate any components from the `build_phase` method.

- Always instantiate components using the factory.

    ```verilog
    var_name = component_type::type_id::create("var_name", this);
    ```

- The string name of the component should be the same as the variable name.

- The second argument to create should be the reserved word `this`.

- Where a user-defined component class extends another user-defined component class, care should
be taken to insert calls of the form `super.<phase_name>_phase` wherever appropriate, that is, where
the corresponding base class phase method performs some action.

- Where a user-defined component class directly extends a class from the UVM base class library and
overrides the standard `build_phase` method, do not call `super.build_phase`.

</div>

## Connection to the DUT

<div class="justify" markdown>

- Use one SystemVerilog interface instance per DUT interface.

- Use virtual interfaces to access the SystemVerilog interface instances from the UVM verification
environment.

- Encapsulate virtual interfaces inside a configuration object in the configuration database.

- Copy virtual interfaces from the top-level configuration object to the configuration objects associated
with agents or lower-level envs in the `build_phase` method of the top-level env.

- An agent should check that its virtual interface has been set.

</div>

## TLM

<div class="justify" markdown>

- Make TLM port/export connections and assign virtual interfaces in the `connect_phase` method.

- Communicate between UVM components using ports and exports, including analysis ports and
exports where appropriate.

- Use analysis ports and analysis exports (or objects of class `uvm_subscriber`) when making one-to-
many connections between UVM components.

- When making peer-to-peer connections between components, connect a port (or analysis port)
directly to an export (or analysis export) without any intervening FIFO.

- Communicate with an agent in one of two ways: either connect the analysis port of the agent to a
subscriber or access the sequencer within the agent using a direct object reference from outside.

</div>

## Configurations

<div class="justify" markdown>

- Use the configuration database uvm_config_db rather than the resource database
`uvm_resource_db`.

- Group the configuration parameters for a given component into a configuration object and set that
configuration object into the configuration database.

- The top-level configuration object should contain references to any lower-level configuration objects.

- Create user-defined configuration classes by extending the class `uvm_object`.

- Use the class name `<component_class>_config` or `<sequence_class>_config` for the configuration
class associated with a component or a sequence, respectively, where `<component_class>` is the class
name of the component and `<sequence_class>` is the class name of the sequence.

- Use the field name `"config"` for the configuration object in the configuration database.

- Do not register user-defined configuration classes with the factory.

- A component should typically get and set configuration parameters (typically configuration objects)
in its `build_phase` method, as opposed to any other phase methods.

- Always check the bit returned from `uvm_config_db#(T)::get` to ensure that the configuration
parameter exists in the configuration database.

- A sensible default value should be chosen if `uvm_config_db#(T)::get` returns 0.

- Each component should get the configuration object associated with that specific component
instance, and should not get the configuration object of any other component instance.

- The configuration object associated with any given component instance should be set by its parent or
by some other direct ancestor of that component instance, and not by any other component instance.

- Avoid using an absolute hierarchical path name as the 2nd argument to `uvm_config_db#T(T)::set`, and
provide the shortest possible unique path name.

- A component instance may be associated with one configuration object or with no configuration
object, and several component instances may be associated with the same configuration object.

- For an agent, include a variable is_active in the configuration object to determine whether the agent
is active or passive. Override the virtual `get_is_active` method to return this value. Check `get_is_active`
before creating and connecting the sequencer and driver within the agent.

- If a sequence is to be parameterized, the parameters for the sequence should be put into a
configuration object in the configuration database. The configuration object should be associated with
the sequencer on which the sequence is to run.

- Any configuration object associated with a sequence should be got from the configuration database
at the start of the sequence and a variable in the sequence object should be assigned to refer to that
configuration object.

- If a component directly assigns the values of variables (including virtual interfaces) in its child
components, it should do so in its build_phase method after creating those child components.

</div>

## The Factory

<div class="justify" markdown>

- Always instantiate transaction, sequence, and component objects using the factory.

    ```verilog
    // Objects
    var_name = type_name::type_id::create("var_name");

    // Components
    var_name = type_name::type_id::create("var_name", this);
    ```

- When using a factory override to substitute a transaction, sequence, or component object with
another object whose class extends the class of the original, the factory override should take one of
these forms:

    ```verilog
    old_type_name::type_id::set_type_override( new_type_name::get_type() );
    old_type_name::type_id::set_inst_override( new_type_name::get_type() ... );
    ```

- Call the static method `uvm_factory::get()` when you need access to the factory.

</div>

## Tests

<div class="justify" markdown>

- Do not generate stimulus directly from the test, but use the test to set configuration parameters and
factory overrides.

- Set up the fixed aspects of the verification environment and generate default stimulus in the env
class, not the test class, so that the env will run even with an empty test.

- Where appropriate, use test base classes to define structure and behavior that is common across a
set of tests, and create individual tests by extending these base classes.

- For reuse, avoid making tests dependent on the specific details of the verification environment.

- For reuse, avoid making tests dependent on the specific details of the verification environment.

</div>

## Messaging

<div class="justify" markdown>

- To report a message, always use one of the eight standard report macros ``uvm_info`,
``uvm_info_context`, and so forth, rather than ad hoc $display statements or similar.

- Set the message id either to a static string or to `get_type_name()`.

- Set message verbosity levels thoughtfully, methodically, and consistently throughout the code to
avoid unnecessary data in the simulation log file and to differentiate between messages intended for
use during the development and debug of the verification environment itself and messages intended for
use when running tests and debugging the DUT.

- By default, set the verbosity level of each message to a high number such that the message is less
likely to be reported, rather than to a low number such that the message is always reported.

- Set message severity levels thoughtfully to differentiate between messages that are purely
informational, messages that may represent errors, and messages that are certainly errors.

</div>

## Register Layer

<div class="justify" markdown>

- If you use a generator to create the SystemVerilog code for the register model, do not modify the
generated code.

- The top-level UVM environment should instantiate the register block using the factory and should call
the build method of the register model.

- In the case of a hierarchically organized UVM environment where child environments use register
models, there should be a single top-level register block that instantiates the register blocks associated
with the child environments, and so on down the hierarchy.

- Any UVM environment that uses a register model should have a variable named `regmodel` that stores
a reference to the register block for that specific environment.

- A UVM environment that has a register model should set the `regmodel` variable of any child
component that also uses a register model to the corresponding sub-block of its register block.

- A UVM environment should only instantiate a register block if the value of the environment's
`regmodel` variable is `null`.

- The variable name and the UVM instance name of each child register block in the register model itself
should correspond to the name of the associated agent.

- A register block should only model DUT registers that are accessible by the UVM sequences
associated with the immediately enclosing UVM environment.

- A UVM environment that uses a register model and that instantiates an agent should instantiate and
connect a register adapter and a register predictor for that agent.

- A register model should use explicit prediction to keep its mirror values synchronized with the
register values in the DUT.

- A register sequence that reads or write registers in a register model should extend uvm_sequence
and should have a variable named `regmodel` that stores a reference to the corresponding register block.

- Before starting a sequence that reads or writes registers, set the regmodel variable of that sequence.

</div>

## Functional Coverage

<div class="justify" markdown>

- Collect functional coverage in the UVM verification environment using the SystemVerilog `covergroup`
construct.

- Where appropriate, collect functional coverage information in SystemVerilog interfaces using the
cover property statement.

- Either place a covergroup in a class as an embedded covergroup or place a covergroup in a package
and parameterize the covergroup so that it can be instantiated from classes in that package.

- Covergroups should be instantiated within UVM component classes as opposed to within transaction
or sequence classes.

- Covergroups should be instantiated within UVM subscribers or scoreboards that are themselves
instantiated within a UVM environment class and are connected to the analysis ports of
monitors/agents.

- Instantiate the covergroup in the constructor of the coverage collector class.

- In order to collect functional coverage information for internal signals within the DUT, encapsulate
references to hierarchical paths to the DUT in a single SystemVerilog module (or interface), then access
that module from the UVM environment using a virtual interface and SystemVerilog interface in the
usual way.

- Where coverage collection spans multiple DUT interfaces and thus depends on analysis transactions
received from more than one agent, use the ``uvm_analysis_imp_decl` macro to provide multiple
analysis exports in the coverage collector class.

- Group coverpoints into multiple covergroups in order to separate coverage of specification
features from coverage of implementation features.

- Use a variable coverage_enable within the configuration object of the coverage collector to
enable or disable coverage collection.

- Sample covergroups by calling their sample method as opposed to specifying a clocking
event for the covergroup.

- Do not sample covergroups more frequently than necessary. Consider using a conditional
expression iff (expression) with each coverpoint to reduce the sampling frequency.

- Sample values within the DUT or at the outputs of the DUT. Do not sample the stimulus
applied to the inputs of the DUT. Sample DUT registers when the register value is changed by
the DUT, not when it is changed directly by the stimulus.

- Consider setting the `option.at_least` of each covergroup and coverpoint to some value other
than the default value of 1.

- Do not set `option.weight` or `option.goal` of a covergroup or coverpoint.

- Design coverpoint bins carefully to ensure that functionally significant cases are covered.

- When designing coverpoints, specify any illegal values or values to be excluded for coverage
as `ignore_bins`. Do not use `illegal_bins`.

</div>
