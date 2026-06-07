module aes_core (
    input   wire                clk, 
    input   wire                rst_n, 
    
    input   wire                aes_start, 
    output  wire                aes_ready, 
    output  wire                aes_valid, 
    
    input   wire    [127:0]     aes_plaintext, 
    input   wire    [127:0]     aes_key, 
    output  wire    [127:0]     aes_ciphertext
);

wire    [3:0]   rnd_idx;
wire            plaintext_en;
wire            ciphertext_en;
wire            key_en;
wire            rndkey_en;
wire            sb_mux_ctrl;
wire            keygen_mux_ctrl;
wire            skip_mux_ctrl;


// AES Datapath
aes_dp u_dp (
    .clk                (clk), 
    .rst_n              (rst_n), 
                      
    // External Interface
    .plaintext_in       (aes_plaintext), 
    .key_in             (aes_key),
                      
    
    // Round Index from Controller
    .rnd_idx            (rnd_idx),  

    // Register Enable Signals from Controller
    .plaintext_en       (plaintext_en), 
    .key_en             (key_en), 
    .ciphertext_en      (ciphertext_en), 
    .rndkey_en          (rndkey_en), 
                      
    // MUX Control Signals from Controller
    .sb_mux_ctrl        (sb_mux_ctrl), 
    .keygen_mux_ctrl    (keygen_mux_ctrl), 
    .skip_mux_ctrl      (skip_mux_ctrl),
                      

    // External Interface
    .ciphertext_out     (aes_ciphertext)

);


// AES Controller
// Provides 
// 1) Rnd Index
// 2) MUX Control Signals
// 3) Register Enable
aes_ctrl u_ctrl (
    .clk                (clk), 
    .rst_n              (rst_n), 
                      
    // IP I/O Interface
    .aes_start          (aes_start), 
    .aes_ready          (aes_ready),
    .aes_valid          (aes_valid),

    // Round Index
    .rnd_idx            (rnd_idx),   
                      
    // Register Enable
    .plaintext_en       (plaintext_en), 
    .key_en             (key_en), 
    .ciphertext_en      (ciphertext_en), 
    .rndkey_en          (rndkey_en), 
                      
    // MUX Control Signals
    .sb_mux_ctrl        (sb_mux_ctrl), 
    .keygen_mux_ctrl    (keygen_mux_ctrl), 
    .skip_mux_ctrl      (skip_mux_ctrl)
);


endmodule
