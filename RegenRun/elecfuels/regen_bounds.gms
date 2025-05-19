* ----------------------
* regen_bounds.gms
* ----------------------
* REGEN Electric+Fuels Model
* Upper and lower bound constraints

* The model also includes several simple bound constraints, many of which are scenario options
* and can be specified with switches

* Note in general that model equations are conditioned on eligibility for electric generation (via the ivrt ivfrt sets),
* transmission (via the tcapcost parameter indicating adjacent region-pairs), and fuel production (via the fivrt set).
* This avoids the need to fix ineligible domain elements of these variables to zero, which can be costly for system memory.

* Future capacity of existing vintage cannot exceed current capacity lifetimes
XC.UP(i,vbase,r,t)$ivrt(i,vbase,r,t) = xcap(i,r) * lifetime(i,r,t);
FC.UP(fi,vbase,r,t)$fivrt(fi,vbase,r,t) = fc0(fi,r) * lifetime_trf(fi,r,t);

* Ensure that biomass upgrade option is available in all time periods
FC.UP("bio-upgr",v,r,t)$vt(v,t) = inf;
fivrt("bio-upgr",v,r,t)$vt(v,t) = yes;
* No new conventional ethanol
FC.UP("eth-conv",newv(v),r,t)$vt(v,t) = 0;
* No CCS technologies before 2025
IFC.UP(fi_ccs(fi),r,t)$(t.val le 2025) = 0;
* If HTSE is excluded, fix to zero
$ifi %htse%==no FC.FX("elys-hts",v,r,t) = 0;

* Direct air capture is not allowed before 2025 and can be omitted entirely if indicated
DACC.UP(dac,v,r,t)$(t.val le 2025) = 0;
$if %nodac%==yes DACC.UP(dac,v,r,t) = 0;
* For now, DAC with waste heat is omitted pending data on waste heat supply
DACC.UP("dac-lt-waste",v,r,t) = 0;

* Fix existing CSP storage to 10 hours, and existing CSP solar multiple to 2.3
GR_CSP.FX("cspr-x",r,t) = (10 / (csp_eff_p * csp_eff_r)) * xcap("cspr-x",r);
C_CSP_CR.L("cspr-x",r,t) = (2.3 / (csp_eff_p * csp_eff_r)) * xcap("cspr-x",r);

* Lower bound on new battery capacity based on historical and planned additions (if storage is active)
$ifi not %storage%==no IGC.LO(j,r,t)$(not tbase(t)) = newunits_j(j,r,t);
$ifi not %storage%==no IGR.LO(j,r,t)$(not tbase(t)) = ghours(j,r) * newunits_j(j,r,t);

* If running in static mode with storage, can import storage capacity values from dynamic run
$ifi not %storage%==no $ifi not %static%==no $ifi not %gdynfx%==no GC.FX(j,r,t) = gcfx(j,r,"%static%");

* If storage is endogenous, then fix endowment of existing pumped hydro capacity
$ifi not %storage%==no GC.FX("hyps-x",r,t) = gcap("hyps-x",r); GR.FX("hyps-x",r,t) = gcap("hyps-x",r) * ghours("hyps-x",r);

* In certain storage runs, we only allow new investment in one type of storage technology
$if set hypsonly IGC.FX(batt,r,t) = 0; IGR.FX(batt,r,t) = 0;
$if set battonly IGC.FX("bulk",r,t) = 0; IGR.FX("bulk",r,t) = 0;

* Allowable nuclear uprates are defined by exogenous cumulative uprate trajectory over time
NUPR.UP(r,t)$ivrt("nucl-x","2015",r,t) = max(0, cumuprates(r,t) - cumuprates(r,t-1));

* If specified, restrict transmission additions into and out of Texas to 1 GW per time period
* (Note that Texas must be an element in the region set to use this option)
$if not %texasent%==no IT.UP("Texas",r,t) = 1; IT.UP(r,"Texas",t) = 1;

* If specified, restrict new nuclear additions (beyond current projects)
$ifi not %nuclim%==no IX.FX(nuc(i),r,t)$(t.val ge 2025) = 0;

* If specified, restrict new advanced nuclear additions (does not affect "conventional" new nuclear) 
$ifi %advnuc%==no IX.FX("nuca-n",r,t) = 0;

* If specified, restrict new coal additions without CCS after a given year (based on 111b NSPS rules)
IX.FX("clcl-n",r,t)$(t.val > %nonewcoal%) = 0;
IX.FX("igcc-n",r,t)$(t.val > %nonewcoal%) = 0;

* If including updated 111d existing source rules, force retirement or CCS retrofit of existing coal by 2035 time step 
$ifthen not %incl111%==no
XC.UP(ivrt(i,vbase,r,t))$((idef(i,"clcl") or idef(i,"igcc")) and t.val ge 2035) = 0;
XC_C.UP(civrt(i,vbase,v,r,t))$((idef(i,"cgcf") or idef(i,"cbcf")) and t.val ge 2035) = 0;
$endif

* If specified, limit investment in gas+CCS power generation technologies before a certain date
$if set ngcs IX.FX(i,r,t)$((idef(i,"nccs") or idef(i,"ncch") or idef(i,"nccx")) and t.val < %ngcs%) = 0;

* If specified, restrict electric generation from bio+CCS
$ifi %becslim%==yes IX.FX("becs-n",r,t) = 0;

* If specified, restrict hydrogen-fired generation (no investment in dedicated hydrogen and no hydrogen dispatch of dual fuel technologies)
$ifi %h2gen%==no IX.FX(i,r,t)$(idef(i,"h2cc") or idef(i,"h2gt")) = 0; IX_C.FX(i,v,r,t)$((idef(i,"g2hc") or idef(i,"g2ht")) and t.val > vyr(v)) = 0; XTWH.FX(ivfrt(i,v,f,r,t))$(sameas(f,"h2") or sameas(f,"h2_45v")) = 0;

* Consider policy scenario where no fossil gas is allowed in electric sector starting in specified year
$if set noelecgas QD_BLEND.UP("gas","ele","ppg",r,t)$(t.val ge %noelecgas%) = 0;

* Do not allow rooftop PV in electric model (all comes from end-use)
IX.FX("pvrf-xn",r,t) = 0;

* Lower bound on net exports for CSAPR compliance ("assurance level" constraint)
NTX_CSAPR.LO(trdprg,pol,r,t)$csaprcap(trdprg,pol,r,t,"%noncap%") = - (csaprcap(trdprg,pol,r,t,"%noncap%") - csaprbudget(trdprg,pol,r,t,"%noncap%"));

* Hypothetical federal RPS constraint expressed as share of generation (rather than a share of retail load)
* When target equals 100%, the constraint is replaced by upper bounds of zero on non-qualified sources
* In hypothetical "full" federal RPS (as a share of generation), apply similar constraint to hydrogen production (only electrolysis is considered renewable)
$ifi not %rps_full%==none XTWH.UP(ivrt(i,v,f,r,t))$(rpstgt(t,"%rps_full%") eq 1 and not rps(i,f,r,"full")) = 0;  HPROD.UP(hi,v,r,t)$(rpstgt(t,"%rps_full%") eq 1 and not elys(hi)) = 0;

* Unless explicitly specified, no safety valve mechanism is included
$ifi %svpr%==no SV.FX(t) = 0; SV_EQ.FX(t) = 0; SV_ELE.FX(t) = 0;

* Define additional constraints for state RPS Scenarios
* Non-RPS participants cannot import bundled RECs (to export as unbundled)
$ifi %srps%==yes  RPC.FX(rr,r,t)$(not rpstgt_r(r,t)) = 0;
* Unbundled REC trade limit
$ifi %srps%==yes   NMR.UP(r,t) = nmrlim(r,t);
* Alternative compliance payment limit
$ifi %srps%==yes ACP.UP(r,t) = acplim(r,t);

* Turn state RPS variables off if not indicated:
$ifi not %srps%==yes  RPC.FX(r,rr,t) = 0; NMR.FX(r,t) = 0; ACP.FX(r,t) = 0; ER.FX(s,r,rr,t) = 0;

* Unless explicitly specified, backstop demand response option is excluded
$ifi %bs%==no BS.FX(s,r,t) = 0;

* Turn off banking variables if no cap (or in static application, or for post-2050 in all modes)
NBC.FX(t)$(t.val > 2050) = 0;
$ifi     %cap%==none    NBC.FX(t)=0; CBC.FX(t)=0;
$ifi     %capeq%==none    NBC_EQ.FX(t)=0; CBC_EQ.FX(t)=0;
$ifi     %cap_rg%==none NBC_RG.FX(r,t)=0; CBC_RG.FX(r,t)=0;
$ifi     %cap_ele%==none NBC_ELE.FX(t)=0; CBC_ELE.FX(t)=0;
$ifi     %RGGI%==off    NBC_RGGI.FX(t)=0; CBC_RGGI.FX(t)=0;
$ifi not %static%==no   NBC.FX(t)=0; CBC.FX(t)=0; NBC_RG.FX(r,t)=0; CBC_RG.FX(r,t)=0; NBC_EQ.FX(t)=0; CBC_EQ.FX(t)=0; NBC_ELE.FX(t)=0; CBC_ELE.FX(t)=0;

* Banking and borrowing with a cap must be explicitly allowed
$ifi %bank%==no     NBC.FX(t)=0; CBC.FX(t)=0; NBC_RG.FX(r,t)=0; CBC_RG.FX(r,t)=0; NBC_EQ.FX(t)=0; CBC_EQ.FX(t)=0; NBC_ELE.FX(t)=0; CBC_ELE.FX(t)=0;
$ifi %borrow%==no   CBC.LO(t)=0; CBC_EQ.LO(t)=0; CBC_RG.LO(r,t)=0; CBC_ELE.LO(t)=0;
* $ifi %borrow%==no   CBC_CO2E.LO(t) = 0;
* Borrowing never allowed under RGGI, banking always allowed
CBC_RGGI.LO(t) = 0;

* Define additional constraints for CES scenarios
* Ensure no borrowing
$ifi not %ces%==none CES_CBC.lo(t) = 0;
* Fix banking variable to zero when cestarget is not in play
CES_NBC.fx(t)$((t.val gt 2050) or (not cestgt(t,"%ces%"))) = 0;
$ifi not %cesbnk%==yes   CES_NBC.FX(t) = 0;
* $ifi not %cesacp%==no    CES_ACP.lo(tbase) = 1 ;
$ifi %cesacp%==no        CES_ACP.UP(r,t) = 0;

* Turn off storage variables unless indicated
$ifi %storage%==no G.FX(s,j,r,t)=0; GD.FX(s,j,r,t)=0; GC.FX(j,r,t)=0; GB.FX(s,j,r,t)=0; GR.FX(j,r,t)=0; IGC.FX(j,r,t)=0; IGR.FX(j,r,t)=0; GR_H.FX(hk,r,t)=0; IGR_H.FX(hk,r,t)=0;
$ifi %storage%==no $ifi not %opres%==no  SRJ.FX(s,j,r,t)=0; QSJ.FX(s,j,r,t)=0;

* Turn off CSP thermal storage variables unless indicated
$ifi not %cspstorage%==yes   G_CSP.FX(s,cspi,r,t) = 0; GD_CSP.FX(s,cspi,r,t) = 0; GB_CSP.FX(s,cspi,r,t) = 0;

* No investment in CSP generation in the dynamic model
$ifi %static%==no IX.UP(cspi,r,t) = 0;

* Turn off biomass co-firing if indicated
$ifi not %nocof%==no X.FX(s,ivfrt(i,v,"bio",r,t))$idef(i,"cbcf") = 0;  XC.FX(ivrt(i,v,r,t))$idef(i,"cbcf") = 0;

* In certain cases, no new transmission is allowed
$ifi not %notrn%==no TC.FX(r,rr,t) = 0;

* Each supply step for bioenergy feedstocks has fixed quantity cap
QS_BFS.UP(bfs,bfsc,r,t) = biocap(bfs,bfsc,r,t);
* In scenario with limited energy crops/logs, assume cap is 14% of full cap (targeting 4 quads total supply)
$if set croplim QS_BFS.UP(bfs,bfsc,r,t)$((sameas(bfs,"cll") or sameas(bfs,"log")) and t.val > 2020) = croplim(r) * biocap(bfs,bfsc,r,t);

* Existing vintages of MD-HD and non-road vehicles subject to fixed lifetime
XV.UP(vc_mdhd(vc),vht,exv_e(v_e),r,t)$vcht(vc,vht,v_e,t) = mdhd0(vc,vht,v_e,r) * vt_life(vc,v_e,t);
XV.UP(vc_nnrd(vc),vht,exv_e(v_e),r,t)$vcht(vc,vht,v_e,t) = nnrd0(vc,vht,v_e,r) * vt_life(vc,v_e,t);

* Enforce ban on incumbent vehicle type by time period (if specified)
IV.UP(incumb(vc,vht),r,t)$incumbban(t) = 0;
IV.UP(incumb(vc_mdhd(vc),vht),r,t)$icevban(t) = 0;

* Upper bounds on direct emissions by sector

$ifthen set sectorcap
CO2_BLD.UP(r,t) = direct_bld(r,t) * co2_bld0(r);
CO2_IND.UP(r,t) = direct_ind(r,t) * co2_ind0(r);
CO2_TRN.UP(r,t) = direct_trn(r,t) * co2_trn0(r);
$endif

* Regional cap can be applied in addition to national cap
$ifthen set rgnz50
CO2_EMIT.UP(r,"2050") = 0;
$endif

* Regional electric sector cap can be applied in addition to national cap
$ifthen set elergnz50
CO2_ELE.UP(r,"2050") = 0;
$endif

* Option to prevent net-negative total emissions
$if set co2pos US_CO2.LO(t) = 0;

* In policy case, investments can be fixed to what occurred in the reference (fixIXref.gdx), up to the year %fixIX%
* Note that a small allowable .LO/.UP range is enforced rather than an explicit .FX based on numerical testing.
$iftheni.fixix not %fixIX%==no
IX.LO(i,r,t)$(sum(tv(t,v), ivrt(i,v,r,t)) and (t.val le %fixIX%) and not tbase(t)) =
         max(0, ixfx(i,r,t) - 0.001);
IX.UP(i,r,t)$(sum(tv(t,v), ivrt(i,v,r,t)) and (t.val le %fixIX%) and not tbase(t)) =
         max(0, ixfx(i,r,t) + 0.001);

IX_C.LO(i,vv,r,t)$(sum(tv(t,v), civrt(i,vv,v,r,t)) and (t.val le %fixIX%) and not tbase(t)) =
         max(0, ixfx_c(i,vv,r,t) - 0.001);
IX_C.UP(i,vv,r,t)$(sum(tv(t,v), civrt(i,vv,v,r,t)) and (t.val le %fixIX%) and not tbase(t)) =
         max(0, ixfx_c(i,vv,r,t) + 0.001);

XC.LO(i,v,r,t)$(ivrt(i,v,r,t)$(t.val le %fixIX%)) = max(0, xcfx(i,v,r,t) - 0.001);
XC.UP(i,v,r,t)$(ivrt(i,v,r,t)$(t.val le %fixIX%)) = max(0, xcfx(i,v,r,t) + 0.001);

XC_C.LO(i,vv,v,r,t)$(civrt(i,vv,v,r,t)$(t.val le %fixIX%)) = max(0, xc_cfx(i,vv,v,r,t) - 0.001);
XC_C.UP(i,vv,v,r,t)$(civrt(i,vv,v,r,t)$(t.val le %fixIX%)) = max(0, xc_cfx(i,vv,v,r,t) + 0.001);

IT.LO(r,rr,t)$((t.val le %fixIX%) and not tbase(t)) = max(0, itfx(r,rr,t) - 0.001);
IT.UP(r,rr,t)$((t.val le %fixIX%) and not tbase(t)) = max(0, itfx(r,rr,t) + 0.001);
$endif.fixix

* In dynfx mode, some installed capacity is fixed to results from a previous dynamic run
$iftheni.dynfx %dynfx%==yes
XC.FX(iv_fix(i,v),r,t) = xcfx(i,v,r,t);
XC_C.FX(civrt(conv(i),vv,v,r,t)) = xc_cfx(i,vv,v,r,t);
* TC.FX(r,rr,t)  = tcfx(r,rr,t);
IX.FX(i,r,t)$(not i_end(i)) = 0;
* If a previous time period's static run is indicated, use those capacity levels as lower bounds
IX.LO(i_end_lo(i),r,t) = ixlo(i,r);
* If specified, restrict new transmission additions
$if %allowtrans%==no IT.FX(r,rr,t) = 0;
* Limit 45V-subsidized electrolysis given dynamics of the tax credit (expires after 10 years)
IFC.UP("elys-45v",r,t) = sum(v, fcfx("elys-45v",v,r,t));
$endif.dynfx

* In statfx mode, no investment is allowed (all capacity is "inherited")
$iftheni.statfx %statfx%==yes
XC.FX(iv_fix(i,v),r,t) = xcfx(i,v,r,t);
XC_C.FX(civrt(conv(i),vv,v,r,t)) = xc_cfx(i,vv,v,r,t);
TC.FX(r,rr,t)  = tcfx(r,rr,t);
GC.FX(j,r,t) = gcfx(j,r,t);
GR.FX(j,r,t) = grfx(j,r,t);
FC.FX(fivrt(fi,v,r,t)) = fcfx(fi,v,r,t);
TC_H.FX(r,rr,t) = tc_hfx(r,rr,t);
GC_H.FX(hk,r,t) = gc_hfx(hk,r,t);
GR_H.FX(hk,r,t) = gr_hfx(hk,r,t);
PC.FX(r,r,t) = pcfx(r,r,t);
INJC.FX(cstorclass,r,t) = injcfx(cstorclass,r,t);
* Allow capacity rental for end-use sectors even in statfx mode
* XV.FX(vc,vht,v_e,r,t) = xvfx(vc,vht,v_e,r,t);
IX.FX(i,r,t)$(not i_end(i)) = 0;
IT.FX(r,rr,t) = 0;
IGC.FX(j,r,t) = 0;
IGR.FX(j,r,t) = 0;
IFC.FX(fi,r,t) = 0;
IT_H.FX(r,rr,t) = 0;
IGC_H.FX(hk,r,t) = 0;
IGR_H.FX(hk,r,t) = 0;
IP.FX(r,rr,t) = 0;
IINJ.FX(cstorclass,r,t) = 0;
* Allow capacity rental for end-use sectors even in statfx mode
* IV.FX(vc,vht,r,t) = 0;
$endif.statfx

* Minimum battery storage policy constraints
$ifi not %static%==no $ifi %storage%==yes $ifi %statfx%==no GC.LO("li-ion",r,t) = batttgt_r(r,t);

* No investment in base year (not applicable for static mode)
$ifi %static%==no IX.FX(i,r ,tbase) = 0; IX_C.FX(i,vbase,r,tbase) = 0;
$ifi %static%==no IT.FX(r,rr,tbase) = 0;
$ifi %static%==no IGC.FX(j,r ,tbase)$(not sameas(j,"hyps-x")) = 0; IGR.FX(j,r ,tbase)$(not sameas(j,"hyps-x")) = 0;
$ifi %static%==no IV.FX(vc,vht,r,tbase) = 0;

* No retirements permitted in the base year (not applicable for static model)
$ifi %static%==no XC.LO(i,vbase,r,tbase)$(not new(i)) = xcap(i,r);

* Restrict coal CCS retrofits before a given year if specified
$ifi not %crb4%==no    IX.FX(i,r,t)$(cr(i) and (not idef(i,"ccs9")) and (t.val ge %crb4%)) = 0;
