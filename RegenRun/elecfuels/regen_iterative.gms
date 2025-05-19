* ----------------------
* regen_iterative.gms
* ----------------------
* REGEN Electric+Fuels Model
* Load iteratively updated sets and parameters

* * * Load shape and hourly profiles

* Read hourly load
$gdxin %elecdata%\endusescen\%endusescen%\segdata_8760_%endusescen%_it%enduseiter%
$load h=s, load_h=load_s
* If running in static mode with 8760 segments, read load, wind, and solar profile parameters with full hourly resolution
$ifthen %seg%==8760
$load s, sm, sw, ozs
$load peak, hours, load=load_s, load_ldv=load_ldv_s, load_kf=load_kf_s, load_flx=load_flx_s, af_s=vrsc, hyps
$gdxin
csapr_s(trdprg,s,t) = yes$(not trdprg_oz(trdprg) or ozs(s,t));
csapradj_s(trdprg,r,t) = 1;
$endif

* Otherwise, profile parameters are based on representative hours or segments defined in hour choice algorithm
* Default setting in hour choice algorithm is to use %seg%==120
* Change option %totalseg% in hourssub.bat to use a different number of segments
$ifthen not %seg%==8760
* %pssm% option refers to an approximation approach for chronology between representative hours using
* a probabilistic system-state matrix (PSSM) - see model documentation for more information
$if not %pssm%==yes $gdxin %elecdata%\endusescen\%endusescen%\segdata_%seg%_%endusescen%_it%enduseiter%
$if     %pssm%==yes $gdxin %elecdata%\endusescen\%endusescen%\segdata_%seg%_pssm_%endusescen%_it%enduseiter%
$load s, sm, sw, ozs, ozsadj_r
$load peak, hours, load=load_s, load_ldv=load_ldv_s, load_kf=load_kf_s, load_flx=load_flx_s, af_s=vrsc, hyps
$if %pssm%==yes $load ssm, p_ssm, pstay
$gdxin
csapr_s(trdprg,s,t) = yes$(not trdprg_oz(trdprg) or ozs(s,t));
csapradj_s(trdprg,r,t) = 1$(not trdprg_oz(trdprg)) + ozsadj_r(r,t)$trdprg_oz(trdprg);
$endif

* If storage is active, then allow existing pumped hydro to endogenously dispatch and zero out exogenous profile
$ifi not %storage%==no hyps(s,r,t) = 0;

* * * Other parameters from end-use model

* Endogenous T&D cost adders from end-use model (if specified and available, else use base year)
$ifthen %tdcost%==end
$gdxin %elecdata%\endusescen\%endusescen%\tdcost_%y_shp%_%endusescen%_it%enduseiter%
$load rtl_ptd_end
$gdxin
tdcost_kf(r,"mdhd",t) = rtl_ptd_end("%tdc_rtl%",r,"com",t);
tdcost_kf(r,"ind-sm",t) = rtl_ptd_end("%tdc_rtl%",r,"ind",t);
$else
tdcost_kf(r,"mdhd",t) = rtl_ptd(r,"com"); 
tdcost_kf(r,"ind-sm",t) = rtl_ptd(r,"ind"); 
$endif

* Distributed generation from end-use model
$gdxin %elecdata%\endusescen\%endusescen%\rfpv_%endusescen%_it%enduseiter%
$load rfpv_gw=pvrfcap_r
$gdxin

$gdxin %elecdata%\endusescen\%endusescen%\enduse_elecfuels_%endusescen%_it%enduseiter%
$load selfgen
$gdxin

rfpv_out(s,r,t)$tbase(t) = sum(vbase(v), af_s(s,"pvrf-xn",v,r,t) * rfpv_gw(r,t));
rfpv_out(s,r,t)$(not tbase(t)) = sum(tv(t,v), af_s(s,"pvrf-xn",v,r,t)) * rfpv_gw(r,t);
rfpv_twh(r,t) = 1e-3 * sum(s, hours(s,t) * rfpv_out(s,r,t));
netder(s,r,t) = rfpv_out(s,r,t) + selfgen(r,t) / 8.76;

* Zero out pvrf-x from xcap (all comes in from end-use model)
xcap("pvrf-xn",r) = 0;

* End-use model non-electric fuel demands and CO2 flows

* When solving REGEN electric-fuels and enduse models in iterative mode, damping option can be used to aid convergence
$gdxin %elecdata%\endusescen\%endusescen%\enduse_elecfuels_%endusescen%_it%enduseiter%
$if not %enduseq%==damp $load qd_enduse, qd_enduse_kf, co2_capt_ind, co2_proc_ind, co2_fne
$if     %enduseq%==damp $load qd_enduse=qd_enduse_damp, qd_enduse_kf=qd_enduse_kf_damp, co2_capt_ind=co2_capt_ind_damp, co2_proc_ind=co2_proc_ind_damp, co2_fne=co2_fne_damp
$gdxin

$gdxin %elecdata%\endusescen\%endusescen%\load_g_%y_shp%_%endusescen%_it%enduseiter%
$if not %enduseq%==damp $load load_gkw
$if     %enduseq%==damp $load load_gkw=load_gkw_damp
$gdxin

* Calculate weekly total end-use gas demand as a constraint on the segment-level flows of upstream blend constituents

qd_ppg_nele(w,r,t) =
* load_gkw is populated for kf = [res,com] with weather driven weekly shape
        sum(kf$sum(w.local, load_gkw(kf,"ppg",r,w,t)), load_gkw(kf,"ppg",r,w,t) * qd_enduse_kf(kf,"ppg",r,t)) / sum((kf,w.local), load_gkw(kf,"ppg",r,w,t)) +
* For other sectors, use flat profile
        sum(kf$(not sum(w.local, load_gkw(kf,"ppg",r,w,t))), (1/52) * qd_enduse_kf(kf,"ppg",r,t));

* * * Embedded end-use sector activities

* The current version of the REGEN allows certain end-use sector activity to be co-optimized with electric and fuels supply
* These sectors include medium- and heavy-duty (MDHD) on-road vehicles and non-road (NNRD) vehicle segments (aviation, rail, maritime, and
* industrial non-road vehicles in the construction, agriculture, and mining sectors)

$gdxin %elecdata%\endusescen\%endusescen%\enduse_elecfuels_%endusescen%_it%enduseiter%
$load k2,b,kfmap,u
$gdxin

* Read vehicle class sets and related parameters from MDHD and NNRD models
* use onmulti to merge common symbol names
$onmulti
$gdxin %elecdata%\endusescen\%endusescen%\mdhd_elecfuels_%endusescen%_it%enduseiter%
$load vc, vht
$load k2vc, vcht, newcap_cost, vom
$gdxin

$gdxin %elecdata%\endusescen\%endusescen%\nnrd_elecfuels_%endusescen%_it%enduseiter%
$load vc=opt_vc, vht
$load k2vc, vcht, newcap_cost, vom
$gdxin
$offmulti

* Read distinct symbol names separately
$gdxin %elecdata%\endusescen\%endusescen%\mdhd_elecfuels_%endusescen%_it%enduseiter%
$load vc_mdhd=vc, di, icevban, vc_di, mdhd0, mdhd_tot, vmti, epvmt_r, vt_life_mdhd=vt_life, di_shr, di_vmt, refuel_cost_mdhd=refuel_cost, mdhd_fuel_r
$gdxin

$if set icevban_mdhd icevban(t) = yes$(t.val ge %icevban_mdhd%);

$gdxin %elecdata%\endusescen\%endusescen%\nnrd_elecfuels_%endusescen%_it%enduseiter%
$load vc_nnrd=opt_vc, kfvc, incumb, incumbban, nnrd0, nnrd_tot, epsrv_r, vt_life, refuel_cost_nnrd=refuel_cost, crf_nnrd, nnrd_fuel_r
$gdxin

incumb(vc_mdhd(vc),"icev") = yes;

vt_life(vc_mdhd(vc),v_e,t_all) = vt_life_mdhd(v_e,t_all);

* Include refeuling costs for reporting (normalize per service unit for non-road vehicles)
refuel_cost(vc_mdhd(vc),vht,r,t) = refuel_cost_mdhd(vc,vht,t);
refuel_cost(vc_nnrd(vc),vht,r,t) = sum(sameas(v_e,t), refuel_cost_nnrd(vc,vht,t) * sum(df, epsrv_r(vc,vht,df,r,v_e,t))) / crf_nnrd(vc);


* If MDHD and NNRD models are endogenous (%eeusolve%==yes), remove associated fuel use from exogenous parameters
parameter
qd_enduse_kf_x(*,kf,f,r,t)      Comparison of exogenous and endogenous end-use fuel demands
;

qd_enduse_kf_x("kf_tot","mdhd",f,r,t) = qd_enduse_kf("mdhd",f,r,t);
qd_enduse_kf_x("kf_eeu","mdhd",f,r,t) = mdhd_fuel_r("mdhd_tot",f,r,t) + sum(kfvc("mdhd",vc), nnrd_fuel_r("opt",vc,f,r,t));
qd_enduse_kf_x("kf_tot","ind-sm",f,r,t) = qd_enduse_kf("ind-sm",f,r,t);
qd_enduse_kf_x("kf_eeu","ind-sm",f,r,t) = sum(kfvc("ind-sm",vc), nnrd_fuel_r("opt",vc,f,r,t));

* Identify any problem region/fuel/sector combinations where detailed vc-level energy sum exceeds total parameter
qd_enduse_kf_x("prob",kf,f,r,t) = max(0, qd_enduse_kf_x("kf_eeu",kf,f,r,t) - qd_enduse_kf_x("kf_tot",kf,f,r,t));

$ifthen not %eeusolve%==no
qd_enduse_kf(kf,f,r,t) = qd_enduse_kf(kf,f,r,t) - qd_enduse_kf_x("kf_eeu",kf,f,r,t);
qd_enduse(f,r,t) = qd_enduse(f,r,t) - sum(kf, qd_enduse_kf_x("kf_eeu",kf,f,r,t));
$endif

* Same calculation for hourly electric loads
parameter
load_eeu_x(*,s,r,t)             Comparison of exogenous and endogenous load components
;

load_eeu_x("tot",s,r,t) = load(s,r,t);
load_eeu_x("eeu",s,r,t) = (  load_kf(s,"mdhd",r,t) * (mdhd_fuel_r("mdhd_tot","ele",r,t) + sum(kfvc("mdhd",vc), nnrd_fuel_r("opt",vc,"ele",r,t))) 
                           + load_kf(s,"ind-sm",r,t) * sum(kfvc("ind-sm",vc), nnrd_fuel_r("opt",vc,"ele",r,t))) / 3.412 / 8.76;

load_eeu_x("prob",s,r,t) = max(0, load_eeu_x("eeu",s,r,t) - load_eeu_x("tot",s,r,t));

$ifthen not %eeusolve%==no
load(s,r,t) = load(s,r,t) - load_eeu_x("eeu",s,r,t);
$endif

* The current version of REGEN also allows certain end-use load shapes to be endogenously co-optimized with the electric system.
* For now this includes data center load but could also include vehicle charging or other loads.

* Calculate target energy and segment-level peak for flexible loads based on exogenous shape, then remove from load if switched on

flex_twh(flx,r,t) = 0;
flex_gw(flx,r,t) = 0;
caprent_flx(flx) = 0;

* Default is no, turn on by setting to a value between 0 and 1 referring to share of flexible load category available for flexible dispatch
$ifthen not %flexload%==no
flex_twh(flx,r,t) = sum(s, hours(s,t) * %flexload% * load_flx(s,flx,r,t));
flex_gw(flx,r,t) = smax(s, %flexload% * load_flx(s,flx,r,t));

load(s,r,t) = load(s,r,t) - sum(flx, %flexload% * load_flx(s,flx,r,t));
$endif

* Read end-use fuel, service demand, and efficiency data for ex post reporting
$gdxin %elecdata%\endusescen\%endusescen%\enduse_elecfuels_%endusescen%_it%enduseiter%
$load qdr_tot_x=qdr_tot,bio_ex,sindex,eindex,eff_scen,newhp_ele,ind_ccs_ele,gascap_eu,h2cap_eu,ldvrescom_shr,expend_ldvpubchrg,hu_total
$if not %enduseq%==damp $load fueluse_ind_ccs, qd_enduse_non, co2_capt_proc, co2_capt_full
$if     %enduseq%==damp $load fueluse_ind_ccs=fueluse_ind_ccs_damp, qd_enduse_non=qd_enduse_non_damp, co2_capt_proc=co2_capt_proc_damp, co2_capt_full=co2_capt_full_damp
$gdxin



* * * Parameters from upstream fuels model

* Set fossil fuel prices (read in from upstream fuels model if specified)
* Currently the upstream fuels production module is not active, and fuel prices are based on an exogenous parameter
$ifthen not set upsscen
pf_ups(f,r,t) = pf_alt("%baseline_pf%",f,t);
capt_ups(f,r,t) = 0;
$else
$gdxin %elecdata%\upsscen\%upsscen%\ups_elecfuels_%upsscen%
$if not %fuelpr%==damp $load pf_ups=pf, capt_ups, epups_fuels
$if     %fuelpr%==damp $load pf_ups=pf_damp, capt_ups, epups_fuels
$gdxin
$endif
* Add 2015 prices (and keep 2020 base year prices)
pf_ups(f,r,t)$(sameas(t,"2015") or sameas(t,"2020")) = pf_alt("%baseline_pf%",f,t);
* Adjust labels
pf_ups("gas",r,t) = pf_ups("ppg",r,t);
pf_ups("ppg",r,t) = 0;
pf_ups(rfp(f),r,t) = pf_ups("dsl",r,t);
pf_ups("dsl",r,t) = 0;
pf_ups("clm",r,t) = 2 * pf_ups("cls",r,t);
* Add uranium price, which is not yet included in upstream model
pf_ups("ura",r,t) = pf_alt("%baseline_pf%","ura",t);
* For now set international exports to zero
ntxintl_f(f,t) = 0;


* Check residual CO2 emissions associated with petroleum and coal demands with no substitutes in electric-fuels model
* This residual represents an effective lower feasible bound on the positive component of economy-wide CO2 emissions

* This calculation attempts to approximate irreducible emissions from exogenous demands for a subset of "unsubstitutable fuels"

set
fosfx(f)	Fossil fuels with no substitutes in model /
	        pck, rfo, aro, fds, mpp, hgl, cls, clm, cok/
;

alias(fosfx,fosfx_);

co2_resid(kf,r,t) =   sum(fosfx(f), qd_enduse_kf(kf,f,r,t) * cc_ff(f))  
                    + co2_proc_ind(r,t)$sameas(kf,"ind-lg")
                    - co2_capt_ind(r,t)$sameas(kf,"ind-lg")
                    - co2_fne(kf,r,t)
;

* This term covers the associated upstream use of this subset of "unsubstitutable fuels"

co2_resid("ups",r,t) = sum((fosfx_,fosfx(f),rr), epups_fuels(fosfx_,r,f,rr,t) * qd_enduse(f,rr,t) * cc_ff(fosfx_))
* Placeholder for capture in upstream fuels model
*	            - co2_capt_ups(r,t)
;

co2_resid("sec_tot",r,t) = sum(kf, co2_resid(kf,r,t)) + co2_resid("ups",r,t);

co2_resid(kf,"us48",t) = sum(r, co2_resid(kf,r,t));
co2_resid("ups","us48",t) = sum(r, co2_resid("ups",r,t));
co2_resid("sec_tot","us48",t) = sum(r, co2_resid("sec_tot",r,t));

* Calculate minimum feasible reduction as a share of base year for sector CO2 as a function of co2_resid

sectorcap_min("bld",r,t) = 1.05 * (co2_resid("res",r,t) + co2_resid("com",r,t)) / co2_bld0(r);
sectorcap_min("ind",r,t) = 1.05 * (co2_resid("ind-sm",r,t) + co2_resid("ind-lg",r,t)) / co2_ind0(r);
sectorcap_min("trn",r,t) = 1.05 * (co2_resid("ldv",r,t) + co2_resid("mdhd",r,t)) / co2_trn0(r);
