`ifndef GPIO_UVC_SEQUENCER_SV
`define GPIO_UVC_SEQUENCER_SV

//typedef uvm_sequencer #(gpio_uvc_sequence_item) gpio_uvc_sequencer;

class gpio_uvc_sequencer extends uvm_sequencer #(gpio_uvc_sequence_item);

  `uvm_component_utils(gpio_uvc_sequencer)

  gpio_uvc_config m_config;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);

endclass : gpio_uvc_sequencer


function gpio_uvc_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void gpio_uvc_sequencer::build_phase(uvm_phase phase);
  if (!uvm_config_db#(gpio_uvc_config)::get(get_parent(), "", "config", m_config)) begin
    `uvm_fatal(get_name(), "Could not retrieve gpio_uvc_config from config db")
  end
endfunction : build_phase

`endif // GPIO_UVC_SEQUENCER_SV
