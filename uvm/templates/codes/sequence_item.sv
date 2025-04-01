`ifndef GPIO_UVC_SEQUENCE_ITEM_SV
`define GPIO_UVC_SEQUENCE_ITEM_SV

class gpio_uvc_sequence_item extends uvm_sequence_item;

  `uvm_object_utils(gpio_uvc_sequence_item)

  rand gpio_uvc_data_t       gpio_pin;
  rand gpio_uvc_item_type_e  trans_type;
  rand gpio_uvc_item_delay_e delay_enable;
  rand int unsigned          delay_duration_ps;

  extern function new(string name = "");

  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function string convert2string();

  // IMPORTANT -timescale=1ps/100fs to avoid Verdi errors
  constraint delay_c {
    soft delay_duration_ps inside {[1_000 : 10_000]};  // 1ns - 10ns
  }

endclass : gpio_uvc_sequence_item


function gpio_uvc_sequence_item::new(string name = "");
  super.new(name);
endfunction : new


function void gpio_uvc_sequence_item::do_copy(uvm_object rhs);
  gpio_uvc_sequence_item rhs_;
  if (!$cast(rhs_, rhs)) `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  super.do_copy(rhs);
  gpio_pin = rhs_.gpio_pin;
  trans_type = rhs_.trans_type;
  delay_enable = rhs_.delay_enable;
  delay_duration_ps = rhs_.delay_duration_ps;
endfunction : do_copy


function bit gpio_uvc_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  gpio_uvc_sequence_item rhs_;
  if (!$cast(rhs_, rhs)) `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  result = super.do_compare(rhs, comparer);
  result &= (gpio_pin == rhs_.gpio_pin);
  return result;
endfunction : do_compare


function void gpio_uvc_sequence_item::do_print(uvm_printer printer);
  if (printer.knobs.sprint == 0) `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
  else printer.m_string = convert2string();
endfunction : do_print


function string gpio_uvc_sequence_item::convert2string();
  string s;
  s = super.convert2string();
  $sformat(s, "gpio_pin = 'd%5d, 'h%4h", gpio_pin, gpio_pin);
  if (delay_enable == GPIO_UVC_ITEM_DELAY_ON) begin
    s = {s, $sformatf(", delay_enable: %5d, delay_duration_ps: %5d", delay_enable, delay_duration_ps)};
  end
  return s;
endfunction : convert2string

`endif // GPIO_UVC_SEQUENCE_ITEM_SV
