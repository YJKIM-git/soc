/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2020 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
 #define IKI_DLLESPEC __declspec(dllimport)
#else
 #define IKI_DLLESPEC
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2020 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
 #define IKI_DLLESPEC __declspec(dllimport)
#else
 #define IKI_DLLESPEC
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
IKI_DLLESPEC extern void execute_9(char*, char *);
IKI_DLLESPEC extern void execute_10(char*, char *);
IKI_DLLESPEC extern void execute_11(char*, char *);
IKI_DLLESPEC extern void execute_15(char*, char *);
IKI_DLLESPEC extern void svlog_sampling_process_execute(char*, char*, char*);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_2(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_3(char*, char *);
IKI_DLLESPEC extern void vlog_sv_sequence_execute_0 (char*, char*, char*);
IKI_DLLESPEC extern void assertion_action_m_958b984072aa388d_584ec748_1(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_1(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_5(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_6(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_958b984072aa388d_584ec748_2(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_4(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_8(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_9(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_958b984072aa388d_584ec748_3(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_7(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_11(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_12(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_958b984072aa388d_584ec748_4(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_10(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_14(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_15(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_958b984072aa388d_584ec748_5(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_13(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_17(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_18(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_958b984072aa388d_584ec748_6(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_16(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_20(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_21(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_958b984072aa388d_584ec748_7(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_19(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_23(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_24(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_958b984072aa388d_584ec748_8(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_22(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_26(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_27(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_958b984072aa388d_584ec748_9(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_25(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_29(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_30(char*, char *);
IKI_DLLESPEC extern void assertion_action_m_958b984072aa388d_584ec748_10(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_958b984072aa388d_584ec748_28(char*, char *);
IKI_DLLESPEC extern void execute_69(char*, char *);
IKI_DLLESPEC extern void execute_70(char*, char *);
IKI_DLLESPEC extern void execute_71(char*, char *);
IKI_DLLESPEC extern void execute_3(char*, char *);
IKI_DLLESPEC extern void execute_5(char*, char *);
IKI_DLLESPEC extern void execute_7(char*, char *);
IKI_DLLESPEC extern void execute_17(char*, char *);
IKI_DLLESPEC extern void execute_18(char*, char *);
IKI_DLLESPEC extern void execute_19(char*, char *);
IKI_DLLESPEC extern void execute_20(char*, char *);
IKI_DLLESPEC extern void execute_72(char*, char *);
IKI_DLLESPEC extern void execute_73(char*, char *);
IKI_DLLESPEC extern void execute_74(char*, char *);
IKI_DLLESPEC extern void execute_75(char*, char *);
IKI_DLLESPEC extern void execute_76(char*, char *);
IKI_DLLESPEC extern void execute_77(char*, char *);
IKI_DLLESPEC extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
IKI_DLLESPEC extern void transaction_0(char*, char*, unsigned, unsigned, unsigned);
IKI_DLLESPEC extern void vlog_transfunc_eventcallback_2state(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[65] = {(funcp)execute_9, (funcp)execute_10, (funcp)execute_11, (funcp)execute_15, (funcp)svlog_sampling_process_execute, (funcp)sequence_expr_m_958b984072aa388d_584ec748_2, (funcp)sequence_expr_m_958b984072aa388d_584ec748_3, (funcp)vlog_sv_sequence_execute_0 , (funcp)assertion_action_m_958b984072aa388d_584ec748_1, (funcp)sequence_expr_m_958b984072aa388d_584ec748_1, (funcp)sequence_expr_m_958b984072aa388d_584ec748_5, (funcp)sequence_expr_m_958b984072aa388d_584ec748_6, (funcp)assertion_action_m_958b984072aa388d_584ec748_2, (funcp)sequence_expr_m_958b984072aa388d_584ec748_4, (funcp)sequence_expr_m_958b984072aa388d_584ec748_8, (funcp)sequence_expr_m_958b984072aa388d_584ec748_9, (funcp)assertion_action_m_958b984072aa388d_584ec748_3, (funcp)sequence_expr_m_958b984072aa388d_584ec748_7, (funcp)sequence_expr_m_958b984072aa388d_584ec748_11, (funcp)sequence_expr_m_958b984072aa388d_584ec748_12, (funcp)assertion_action_m_958b984072aa388d_584ec748_4, (funcp)sequence_expr_m_958b984072aa388d_584ec748_10, (funcp)sequence_expr_m_958b984072aa388d_584ec748_14, (funcp)sequence_expr_m_958b984072aa388d_584ec748_15, (funcp)assertion_action_m_958b984072aa388d_584ec748_5, (funcp)sequence_expr_m_958b984072aa388d_584ec748_13, (funcp)sequence_expr_m_958b984072aa388d_584ec748_17, (funcp)sequence_expr_m_958b984072aa388d_584ec748_18, (funcp)assertion_action_m_958b984072aa388d_584ec748_6, (funcp)sequence_expr_m_958b984072aa388d_584ec748_16, (funcp)sequence_expr_m_958b984072aa388d_584ec748_20, (funcp)sequence_expr_m_958b984072aa388d_584ec748_21, (funcp)assertion_action_m_958b984072aa388d_584ec748_7, (funcp)sequence_expr_m_958b984072aa388d_584ec748_19, (funcp)sequence_expr_m_958b984072aa388d_584ec748_23, (funcp)sequence_expr_m_958b984072aa388d_584ec748_24, (funcp)assertion_action_m_958b984072aa388d_584ec748_8, (funcp)sequence_expr_m_958b984072aa388d_584ec748_22, (funcp)sequence_expr_m_958b984072aa388d_584ec748_26, (funcp)sequence_expr_m_958b984072aa388d_584ec748_27, (funcp)assertion_action_m_958b984072aa388d_584ec748_9, (funcp)sequence_expr_m_958b984072aa388d_584ec748_25, (funcp)sequence_expr_m_958b984072aa388d_584ec748_29, (funcp)sequence_expr_m_958b984072aa388d_584ec748_30, (funcp)assertion_action_m_958b984072aa388d_584ec748_10, (funcp)sequence_expr_m_958b984072aa388d_584ec748_28, (funcp)execute_69, (funcp)execute_70, (funcp)execute_71, (funcp)execute_3, (funcp)execute_5, (funcp)execute_7, (funcp)execute_17, (funcp)execute_18, (funcp)execute_19, (funcp)execute_20, (funcp)execute_72, (funcp)execute_73, (funcp)execute_74, (funcp)execute_75, (funcp)execute_76, (funcp)execute_77, (funcp)vlog_transfunc_eventcallback, (funcp)transaction_0, (funcp)vlog_transfunc_eventcallback_2state};
const int NumRelocateId= 65;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/tb_rw_sync_fsm_behav/xsim.reloc",  (void **)funcTab, 65);

	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/tb_rw_sync_fsm_behav/xsim.reloc");
}

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/tb_rw_sync_fsm_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_xsimdir_location_if_remapped(argc, argv)  ;
    iki_set_sv_type_file_path_name("xsim.dir/tb_rw_sync_fsm_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/tb_rw_sync_fsm_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/tb_rw_sync_fsm_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, (void*)0, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
