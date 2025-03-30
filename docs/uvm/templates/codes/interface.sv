`ifndef GPIO_UVC_IF_SV
`define GPIO_UVC_IF_SV
interface gpio_uvc_if (
    input logic clk
);
  import gpio_uvc_pkg::*;
  gpio_uvc_data_t gpio_pin;
  gpio_uvc_data_t gpio_pin_passive;
  clocking cb_drv @(posedge clk);
    default output #1ns;
    output gpio_pin;
  endclocking : cb_drv
  clocking cb_mon @(posedge clk);
    default input #1ns;
    input gpio_pin;
    input gpio_pin_passive;
  endclocking : cb_mon
endinterface : gpio_uvc_if
`endif // GPIO_UVC_IF_SV