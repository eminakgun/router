// Generated by PeakRDL-regblock - A free and open-source SystemVerilog generator
//  https://github.com/SystemRDL/PeakRDL-regblock

package router_regs_pkg;

    localparam ROUTER_REGS_DATA_WIDTH = 32;
    localparam ROUTER_REGS_MIN_ADDR_WIDTH = 4;

    typedef struct {
        logic [7:0] next;
    } router_regs__PACKET_COUNT__ch0_count__in_t;

    typedef struct {
        logic [7:0] next;
    } router_regs__PACKET_COUNT__ch1_count__in_t;

    typedef struct {
        logic [7:0] next;
    } router_regs__PACKET_COUNT__ch2_count__in_t;

    typedef struct {
        logic [7:0] next;
    } router_regs__PACKET_COUNT__ch3_count__in_t;

    typedef struct {
        router_regs__PACKET_COUNT__ch0_count__in_t ch0_count;
        router_regs__PACKET_COUNT__ch1_count__in_t ch1_count;
        router_regs__PACKET_COUNT__ch2_count__in_t ch2_count;
        router_regs__PACKET_COUNT__ch3_count__in_t ch3_count;
    } router_regs__PACKET_COUNT__in_t;

    typedef struct {
        router_regs__PACKET_COUNT__in_t PACKET_COUNT;
    } router_regs__in_t;

    typedef struct {
        logic [1:0] value;
    } router_regs__CHANNEL_ENABLE__ch0_en__out_t;

    typedef struct {
        logic [1:0] value;
    } router_regs__CHANNEL_ENABLE__ch1_en__out_t;

    typedef struct {
        logic [1:0] value;
    } router_regs__CHANNEL_ENABLE__ch2_en__out_t;

    typedef struct {
        logic [1:0] value;
    } router_regs__CHANNEL_ENABLE__ch3_en__out_t;

    typedef struct {
        router_regs__CHANNEL_ENABLE__ch0_en__out_t ch0_en;
        router_regs__CHANNEL_ENABLE__ch1_en__out_t ch1_en;
        router_regs__CHANNEL_ENABLE__ch2_en__out_t ch2_en;
        router_regs__CHANNEL_ENABLE__ch3_en__out_t ch3_en;
    } router_regs__CHANNEL_ENABLE__out_t;

    typedef struct {
        logic [1:0] value;
    } router_regs__MODE__mode__out_t;

    typedef struct {
        router_regs__MODE__mode__out_t mode;
    } router_regs__MODE__out_t;

    typedef struct {
        logic [1:0] value;
    } router_regs__PRIORITY__ch0_priority__out_t;

    typedef struct {
        logic [1:0] value;
    } router_regs__PRIORITY__ch1_priority__out_t;

    typedef struct {
        logic [1:0] value;
    } router_regs__PRIORITY__ch2_priority__out_t;

    typedef struct {
        logic [1:0] value;
    } router_regs__PRIORITY__ch3_priority__out_t;

    typedef struct {
        router_regs__PRIORITY__ch0_priority__out_t ch0_priority;
        router_regs__PRIORITY__ch1_priority__out_t ch1_priority;
        router_regs__PRIORITY__ch2_priority__out_t ch2_priority;
        router_regs__PRIORITY__ch3_priority__out_t ch3_priority;
    } router_regs__PRIORITY__out_t;

    typedef struct {
        logic [7:0] value;
    } router_regs__PACKET_COUNT__ch0_count__out_t;

    typedef struct {
        logic [7:0] value;
    } router_regs__PACKET_COUNT__ch1_count__out_t;

    typedef struct {
        logic [7:0] value;
    } router_regs__PACKET_COUNT__ch2_count__out_t;

    typedef struct {
        logic [7:0] value;
    } router_regs__PACKET_COUNT__ch3_count__out_t;

    typedef struct {
        router_regs__PACKET_COUNT__ch0_count__out_t ch0_count;
        router_regs__PACKET_COUNT__ch1_count__out_t ch1_count;
        router_regs__PACKET_COUNT__ch2_count__out_t ch2_count;
        router_regs__PACKET_COUNT__ch3_count__out_t ch3_count;
    } router_regs__PACKET_COUNT__out_t;

    typedef struct {
        router_regs__CHANNEL_ENABLE__out_t CHANNEL_ENABLE;
        router_regs__MODE__out_t MODE;
        router_regs__PRIORITY__out_t PRIORITY;
        router_regs__PACKET_COUNT__out_t PACKET_COUNT;
    } router_regs__out_t;
endpackage
