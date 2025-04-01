`ifndef GPIO_UVC_AGENT_SV
`define GPIO_UVC_AGENT_SV

class gpio_uvc_agent extends uvm_agent;

  `uvm_component_utils(gpio_uvc_agent)

  uvm_analysis_port #(gpio_uvc_sequence_item) analysis_port;

  gpio_uvc_config    m_config;
  gpio_uvc_sequencer m_sequencer;
  gpio_uvc_driver    m_driver;
  gpio_uvc_monitor   m_monitor;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : gpio_uvc_agent


function gpio_uvc_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void gpio_uvc_agent::build_phase(uvm_phase phase);
  if (!uvm_config_db#(gpio_uvc_config)::get(this, "", "config", m_config)) begin
    `uvm_fatal(get_name(), "Could not retrieve gpio_uvc_config from config db")
  end

  if (m_config.is_active == UVM_ACTIVE) begin
    m_sequencer = gpio_uvc_sequencer::type_id::create("m_sequencer", this);
    m_driver    = gpio_uvc_driver   ::type_id::create("m_driver",    this);
  end

  m_monitor = gpio_uvc_monitor::type_id::create("m_monitor", this);
  analysis_port = new("analysis_port", this);
endfunction : build_phase


function void gpio_uvc_agent::connect_phase(uvm_phase phase);
  if (m_config.is_active == UVM_ACTIVE) begin
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  end

  m_monitor.analysis_port.connect(this.analysis_port);
endfunction : connect_phase

`endif // GPIO_UVC_AGENT_SV
