* ----------------------
* regen_runtime.gms
* ----------------------
* REGEN Electric+Fuels Model
* Run-time model set-up to enact switch settings

* * * Time-mode dependent settings:

* Adjust existing coal lifetimes if specified
$iftheni.xcllife not %xcllife%==default
lifetime(i,r,t)$(idef(i,"clcl") and xcap(i,r)) = lifetime_coal("%xcllife%",i,r,t) ;
$endif.xcllife

* Adjust existing nuclear lifetimes if specified
$ifi not %nuc60%==no lifetime("nucl-x",r,t) = lifetime_nuc60(r,t);
$ifi not %nuc60%==no cumuprates(r,t) = cumuprates_nuc60(r,t);

* Identify unit-vintage-region-time period combinations relevant for optimization
* The idea is to write model equations so that variables are only invoked over the domain ivrt
* This is more efficient than fixing the ineligible set combinations to zero

* Existing and new technologies are subject to fixed lifetime (declining survival function for existing)
ivrt(xtech(i),vbase(v),r,t)$(vt(v,t) and xcap(i,r) * lifetime(i,r,t)) = yes;
ivrt(new(i),newv(v),r,t)$(vt(v,t) and vyr(v) + sum(idef(new,type), invlife(type)) > t.val) = yes;

* Conversions must happen after the original vintage is installed and can remain active as long as the original
* A separate mapping is needed to identify both the original vintage as well as the vintage (i.e. date) of the conversion
civrt(conv,vv,newv(v),r,t)$(vt(v,t) and vyr(v) > vyr(vv) and sum(convmap(conv,orig(i)), ivrt(i,vv,r,t))) = yes;

* Remove new renewable technologies if resource class is inactive in region
ivrt(i,v,r,t)$(irnw(i) and new(i) and not sameas(i,"wind-r") and (caplim(i,r) eq 0 or (sum(iclass(i,type,class), solarcap(class,r)) eq 0 and sol(i)))) = no;
ivrt("wind-r",v,r,t)$(xcap("wind-x",r) eq 0) = no;

* Define eligible technology-region mapping
ir(i,r)$(sum((v,t), ivrt(i,v,r,t))) = yes;

* Define eligible technology-fuel mapping
ifl(i,f)$ifuel(i,f) = yes;

* ivrt set defines eligible combinations for capacity variables
* Generation is also defined over a fuel set to accommodate dual-fuel technologies
* Extend ivrt and civrt to include fuel set as ivfrt and civfrt to define eligible combinations for generation variables
* For most technologies, only a single fuel (element of f) is eligible
ivfrt(strd(i),v,f,r,t)$(ivrt(i,v,r,t) and ifl(i,f)) = yes;
civfrt(conv(i),vv,v,f,r,t)$(civrt(i,vv,v,r,t) and ifl(i,f)) = yes;

* Same applies for fuel transformation technologies (fivrt)
fivrt(fi,v,r,t)$(vt(v,t) and fc0(fi,r) * lifetime_trf(fi,r,t)) = yes;
fivrt(fi,newv,r,t)$vt(newv,t) = yes;
fivrt(fi,newv,r,t)$((vyr(newv) + invlife_trf(fi)) <= t.val) = no;

* Turn off any excluded combinations in CSAPR compliance set
csapr_iv(pol,i,v)$(not sum((r,t), ivrt(i,v,r,t))) = no;

* Set discount factor and number of years per time period
$iftheni not %static%==no
   dfact(t) = 1;
   nyrs(t) = 1;
$else
*  Define discount factor (equal to sum of discounted years between t-1 and t)
*  e.g. for drate = 5%
*  dfact(2015) = 0.95   * (1 + 0.95 + 0.95^2)
*  dfact(2020) = 0.95^4 * (1 + 0.95 + ... + 0.95^4)
*  etc...

   dfact(tbase) = 1;
   nyrs(tbase) = 1;
   nyrs(t_all)$(not tbase_all(t_all)) = tyr(t_all) - tyr(t_all-1);
   dfact(t_all)$(not tbase_all(t_all)) = (1 - drate)**(tyr(t_all-1)+1 - sum(tbase, tyr(tbase))) * (1 - (1-drate)**(nyrs(t_all))) / drate;
$endif

* Assign PTC and ITC subsidy values

ptc(i,f,v) = 0;
$if %ptc%==yes ptc(i,f,v) = sum(idef(i,type), ptc_type(type,f,v));
$if %ptc%==no ptctv(t,v) = no;

itc(i,v) = 0;
$if %itc%==yes itc(i,v) = sum(idef(i,type), itc_type(type,v));
$if %itc%==no  itc_j(j,v) = 0;

* * * Inflation Reduction Act (IRA) options

* If ira=no switch is used, PTC/ITC and 45Q values revert to 2022 levels and following settings are enforced:
$ifthen %ira%==no
$set iraecbon_sol 0
$set iraecbon_nuc 0
$set iraecbon_stor 0
itc_j(j,v) = 0;
$set iija45u no
$set elys45v no
$endif

* The IRA-prescribed values of 45Y (PTC) and 48E (ITC) credits are specified in input dataset
* The default values assume labor bonus criteria are met but do not include other bonuses

* Some solar may qualify for energy communities bonus (10% increase in PTC).  Approximate this by scaling up PTC by a fraction
* of the 10% bonus (assume 50% by default, i.e. 5% bonus, can specify other values with %iraecbon_sol% switch)
ptc(i,"rnw",v)$(idef(i,"pvft") or idef(i,"pvsx") or idef(i,"pvdx")) = (1 + %iraecbon_sol% * 0.1) * ptc(i,"rnw",v);

* Some new nuclear may qualify for energy communities bonus (10% p.p. increase in ITC).  Approximate this by increasing ITC by a fraction
* of the 10% p.p. bonus (assume 50% by default, i.e. 5% p.p. bonus, can specify other values with %iraecbon_nuc% switch)
itc(i,v)$(idef(i,"nucl") or idef(i,"nuca")) = %iraecbon_nuc% * 0.1$itc(i,v) + itc(i,v);

* Some storage may qualify for energy communities bonus. Approximate this by increasing ITC by a fraction
* of the 10% p.p. bonus (assume 50% by default, i.e. 5% p.p. bonus, can specify other values with %iraecbon_stor% switch)
itc_j(j,v) = %iraecbon_stor% * 0.1 + itc_j(j,v);

* 45Y and 48E credits eligibility can be extended beyond the 2035 vintage if the target reduction in
* electric sector emissions has not been met (this can be determined by a previous iteration and specified in the batch call)
* By default, assume incentives extended to 2050 (in other words, the threshold is not met by 2050)
parameter iraext	Year to which IRA 45Y and 48E incentives are extended;
iraext = 2050;
* The switch %iraext% can force an exogenous year
$if set iraext iraext = %iraext%;
* The switch %iraext_iter% sets the end year based on an iterative calculation
$ifthen set iraext_iter
$if exist %elecdata%\iraext_%scen%.gdx execute_load '%elecdata%\iraext_%scen%.gdx', iraext;
$endif
ptc(i,f,v)$(vyr(v) gt 2035 and vyr(v) le iraext) = ptc(i,f,"2035");
itc(i,v)$(vyr(v) gt 2035 and vyr(v) le iraext) = itc(i,"2035");
itc_j(j,v)$(vyr(v) gt 2035 and vyr(v) le iraext) = itc_j(j,"2035");

* Existing nuclear credit subsidy period (from IIJA and IRA/45U credits, turn off in no IRA case)
t_iija45u(t)$(t.val gt 2022 and t.val le 2032) = yes;

* CO2 storage 45Q credits can be turned off by setting cred45q switch to 'no' (set to 'yes' by default)

* The IRA-prescribed value of 45Q credits is specified in input dataset
* The default values are based on point-source capture and storage (utilization is handled with a separate adjustment)
* 2035 vintage is eligble by default, can be turned off if specified
$if %cred45q35%==no co2cred("2035",t) = 0;

* 45Q credits are translated here to a subsidy per unit output for all capture technologies
* based on captured tCO2 per unit output multiplied by the credit per captured tCO2
ccs45q(ivfrt(ccs(i),v,f,r,t))$%cred45q% = co2cred(v,t) * capture(i,v,f,r);
ccs45q_c(civfrt(ccs(i),vv,v,f,r,t))$%cred45q% = co2cred(v,t) * capture_c(i,vv,v,f,r);
ccs45q_trf(fi_ccs(fi),vt(v,t))$%cred45q% = co2cred(v,t) * capture_trf(fi,v);
* CCU credit is smaller than CCS:  implied cost for utilization equal to difference (scale based on nominal values in IRA)
ccu45q_trf(fi,vt(v,t))$%cred45q% = ((60 - 85) / 85) * co2cred(v,t) * cpsyn(fi,v);
* DAC credit is larger than point-source:  scale up based on nominal values in IRA
* Here it is assumed that DAC is subsidized via 45Q based on its gross capture rate
ccs45q_dac(dac,v,t)$%cred45q% = (180 / 85) * co2cred(v,t) * capture_dac("%dacscn%",dac,v);

* 45V subsidy provides a $3/kg credit to qualified electrolysis
* Can be removed if specified (included by default)
$if %elys45v%==no ptc_h(hi,v) = 0;

* If specified, allow existing as well as new sources to qualify for 45V (including existing hydro)
$if not %ex45v%==no if_45v(i,f)$(sameas(f,"ura") or sameas(f,"rnw")) = yes;

* If specified, allow electrolysis from all generation sources to qualify for 45V
* (note if hydrogen itself is included as a qualified source, it could result in an unbounded ray depending on the subsidy value)
$if not %free45v%==no if_45v(i,f)$(not sameas(f,"h2-e")) = ifl(i,f);

* Eligible vintages of input electric generation must coincide with new vintage 45V-eligible hydrogen production (incrementality)
loop(ptctv(t,v), ifvt_45v(i,f,v,t)$(if_45v(i,f) and ptc_h("elys-45v",v)) = yes;);
* If existing vintages are allowed to qualify, extend eligibility to any active vintage in a time period during which the 45V subsidy is offered
$if not %ex45v%==no ifvt_45v(i,f,v,t)$(if_45v(i,f) and vt(v,t) and sum(ptctv(t,vv), ptc_h("elys-45v",vv))) = yes;

* Only consider investment in 45V qualified electrolysis for vintages receiving the subsidy 
fivrt("elys-45v",v,r,t)$(not ptc_h("elys-45v",v)) = no;

* Consider possibility of IRA repeal scenario in which all subsidies are removed after 2025 time step
$ifthen %irarepeal%==yes
ptc(i,f,v)$(vyr(v) gt 2025) = 0;
ptctv(t,v)$(vyr(v) gt 2025) = no;
itc(i,v)$(vyr(v) gt 2025) = 0;
itc(j,v)$(vyr(v) gt 2025) = 0;
ccs45q(i,v,f,r,t)$(vyr(v) gt 2025) = 0;
ccs45q_c(i,vv,v,f,r,t)$(vyr(v) gt 2025) = 0;
ccs45q_trf(fi,v,t)$(vyr(v) gt 2025) = 0;
ccs45q_dac(dac,v,t)$(vyr(v) gt 2025) = 0;
ptc_h(hi,v)$(vyr(v) gt 2025) = 0;
newunits(type,r,t) = 0;
newunits_j(j,r,t) = 0;
$endif

* * * Carbon-Free Energy (CFE) Procurement Targets

* Assume qualification criteria are same as 45V
if_cfe(i,f) = if_45v(i,f);
* If specified, allow existing as well as new sources to qualify for CFE (including existing hydro)
$if not %excfe%==no if_cfe(i,f)$(sameas(f,"ura") or sameas(f,"rnw")) = yes;
* If specified, only allow wind, solar, and batteries
$if not %cfe_vre%==no if_cfe(i,f)$sameas(f,"ura") = no; if_cfe("geot-n",f) = no;
* If specified, allow CDR and additional technologies
$if not %cfe_cdr%==no if_cfe(i,f)$(ccs(i) or sameas(i,"ngcc-n")) = yes;

* Eligible vintages of input electric generation must be new as of target year (incrementality)
ifvt_cfe(i,f,v,t)$(if_cfe(i,f) and vt(v,t) and (vyr(v) ge %cfe247yr%) and (t.val ge %cfe247yr%)) = yes;
* If existing vintages are allowed to qualify, extend eligibility to any active vintage beginning in target year
$if not %excfe%==no ifvt_cfe(i,f,v,t)$(if_cfe(i,f) and vt(v,t) and (t.val ge %cfe247yr%)) = yes;



* Can enforce a national moratorium on new NGCC/DFCC builds after %nonewgas% year
* (Similar optional restriction for coal is enforced at the unit level as a bound on IX in regen_bounds)
invlim("ngcc",r,t)$(t.val > %nonewgas%) = 0; invlim("dfcc",r,t)$(t.val > %nonewgas%) = 0;

* Turn off transmission growth constraints if specified (constrained by default)
$if %tgrow%==no tgrow(r,rr)$tgrow(r,rr) = inf;

* * *
* Assemble segment-level availability factors (de-rating of nominal capacity in a given hour or segment)

* For thermal technologies, availability is specified on a monthly basis based on assumed forced outage 
* or seasonal maintenance patterns (calibrated from observed historical dispatch)

* Use monthly af where specified (adjusted for time trends if applicable, currently only specified for geothermal)
af(s,ivrt(i,v,r,t)) = sum(sm(s,m,t), af_m(i,r,m)) * (1 + (vrsc_t(i,r,t)-1)$vrsc_t(i,r,t));
af(s,i,v,r,t)$sum(vv, civrt(i,vv,v,r,t)) = sum(sm(s,m,t), af_m(i,r,m)) * (1 + (vrsc_t(i,r,t)-1)$vrsc_t(i,r,t));

* For wind, solar, and hydro technologies, availability is specified based on hourly (or segment-level) variability profiles
* These profiles (vrsc parameter) are constructed at the segment level using the hour choice algorithm.
* Note that af_m also includes a monthly profile for hydro based on observed base year hydro generation.
* This monthly profile is used in the hour choice algorithm to approximate an hourly shape.

parameter vrscsum(i,v,r,t)  Intermediate parameter to identify technologies with segment-level profiles;
vrscsum(i,v,r,t) = sum(ss, af_s(ss,i,v,r,t));
af(s,ivrt(i,v,r,t))$vrscsum(i,v,r,t) = af_s(s,i,v,r,t) + eps;

* Adjust hydro to use long-run historical average for projection years
af(s,i,v,r,t)$(vrscsum(i,v,r,t) and idef(i,"hydr")) = af_s(s,i,v,r,t) * hydadj(r,t) + eps;

* * The cfadj option is off by default, can be used to adjust capacity factor weights of variable renewables
$iftheni.cf %cfadj%==yes

* The following code adjusts the availability factors assigned to segments by the hour hoice algorithm to
* make the average annual c.f. equal to that calculated from the underlying 8760 hourly data.

* This is potentially an important adjustment if the focus of the analysis is on
* comparison across scenarios and measurement of incremental change.  Such
* measurements can be corrupted by different approximation errors in the hour choice algorithm,
* both in terms of annual energy from non-dispatched resources and incentives for investment.
* It is also potentially important if using a small number of segments, so that the
* approximation errors from the hour choice algorithm are large in magnitude.

* Caveat:  this is not 100% ideal as the hour weighting algorithm explicitly takes this error
* into account and balances it against other objectives (i.e. capturing the distribution).
* If we are concerned about the residual error being too large, we could add another degree
* of freedom to the hour weighting problem and systematically evaluate the trade-offs.
* However:  it may not compromise the distribution all that much, pros likely outweigh cons.

* Calculate an average availability factor for thermal
aaf_m(i,r,t) = sum(m, monthdays(m) * af_m(i,r,m)) / sum(m, monthdays(m)) * (1 + (hydadj(r,t) - 1)$idef(i,"hydr"));

* Calculate segment-weighted annual average availability factors from segment data
acf_s(i,v,r,t) = sum(s, hours(s,t) * af(s,i,v,r,t)) / sum(s, hours(s,t));

* Calculate segment-weighted annual TWh
twh_s(r,t) = 1e-3 * sum(s, hours(s,t) * load(s,r,t));

* Calculate 8760-based annual TWh
twh_h(r,t) = 1e-3 * sum(h, load_h(h,r,t));

* Scale availability factors so average availability factor over the segments equals that over the hours
af(s,i,v,r,t)$(acf_h(i,v,r) and acf_s(i,v,r,t)) = af(s,i,v,r,t) * acf_h(i,v,r) / acf_s(i,v,r,t);
af(s,i,v,r,t)$(aaf_m(i,r,t) and acf_s(i,v,r,t)) = af(s,i,v,r,t) * aaf_m(i,r,t) / acf_s(i,v,r,t);

* Also need to re-assign rfpv_out (or move initial assign downstream of this)
rfpv_out(s,r,tbase(t)) = sum(vbase(v), af(s,"pvrf-xn",v,r,t) * rfpv_gw(r,t));
rfpv_out(s,r,t)$(not tbase(t)) = sum(tv(t,v), af(s,"pvrf-xn",v,r,t)) * rfpv_gw(r,t);
rfpv_twh(r,t) = 1e-3 * sum(s, hours(s,t) * rfpv_out(s,r,t));
netder(s,r,t) = rfpv_out(s,r,t) + selfgen(r,t) / 8.76;

* Scale load to match hourly total
load(s,r,t) = load(s,r,t) * twh_h(r,t) / twh_s(r,t);

acf_s_chk("before",i,v,r,t) = acf_s(i,v,r,t);
acf_s_chk("after",i,v,r,t) = sum(s, hours(s,t) * af(s,i,v,r,t)) / sum(s, hours(s,t));
acf_s_chk("target",i,v,r,t) = acf_h(i,v,r) + aaf_m(i,r,t);
acf_s_chk("max>1",i,v,r,t) = smax(s, af(s,i,v,r,t))$(smax(s, af(s,i,v,r,t)) > 1);

$endif.cf

* Concentrated Solar Power (CSP) specifications if included:
* Default direct normal irradiance (DNI) for solar thermal to zero
dni(s,cspi,r) = 0;
* For the static 8760 model with an endogenous representation of CSP storage,
* set the af = monthly availability (for the steam turbine) and dni=af_s
* (the solar irradiance). 
$iftheni.cspaf %cspstorage%==yes
af(s,cspi,v,r,t)$csp_r(r) = sum(sm(s,m,t), af_m(cspi,r,m));
* Assigned hourly profiles for CSP technologies reflect DNI
dni(s,cspi,r)  = sum((tbase,vbase), af_s(s,cspi,vbase,r,tbase));
$else.cspaf
af(s,cspi,v,r,t)$new(cspi) = 0;
$endif.cspaf

* * *
* Cost and deployment settings:

* Temporary experiment for handshake with previous version
* Set tdcost to elec (instead of end)
* Set tcap to REEDs in upstream
* year $ adjustment for fomcost_g

fomcost_g("bulk",t) = 25.4 / 1.18;
fomcost_g("caes",t) = 12 / 1.18;
fomcost_g(batt,t) = 5.1 / 1.18;


* Remove fixed O&M costs on existing capacity if specified
$ifi not %fomx0%==no     fomcost(i,r)$(not new(i)) = 0;

* Set renewable costs as appropriate (irnw(i) apart from CSP technologies have alternative cost pathways)
capcost(irnw(i),newv(v),r)$(not idef(i,"cspr")) = capcost_rnw("%rnwtlc%",i,v,r);

* Adjust renewable capacity costs by a scalar factor if specified
capcost(new(i),newv(v),r)$idef(i,"wind") = capcost(i,v,r) * %windcstadj%;
capcost(new(i),newv(v),r)$sol(i) = capcost(i,v,r) * %solcstadj%;

* Adjust capital cost of new gas if appropriate
capcost("ngcc-n",v,r) = capcost("ngcc-n",v,r) * %ngcapadj%;
capcost("nggt-n",v,r) = capcost("nggt-n",v,r) * %ngcapadj%;

* Adjust capital cost of ccs technologies based on switch. 
capcost(ccs(i),v,r)$(capcost(i,v,r) > 0) = capcost(i,v,r) * %ccscost%;

* Translate investment tax credit (as specified in current scenario) to fixed value in $ per kW by technology
* Make sure this assignment happens after all modifications to itc and capcost parameters
itcval(new,v,r) = capcost(new,v,r) * itc(new,v);

* Check for missing values in capital cost parameter
capcost_zero(new,newv)$(sum(r, capcost(new,newv,r)) eq 0) = yes;
abort$sum(capcost_zero(new,newv), 1) "Capcost for some vintage and new technology is zero (see capcost_zero in gdx)";

* Set electrolysis costs as appropriate (elys(hi) technologies have alternative cost pathways
capcost_trf(elys(hi),v) = capcost_elys("%elystlc%",hi,v);

* Adjust electrolysis capital costs if spcecified
capcost_trf(elys(fi),v) = capcost_trf(fi,v) * %elyscost%;

* Adjust biofuel conversion costs if specified
capcost_trf(bi(fi),v)$(not sameas(fi,"lfg-upgr")) = capcost_trf(fi,v) * %biofcost%;

* Option to force higher (forecourt-scale) hydrogen storage costs at central scale production points
$if not %hhg%==no capcost_gch(hk) = capcost_gch("frc"); capcost_grh(hk) = capcost_grh("frc");

* Assume flat dcost for now (include fuel taxes)
dcost(f,kf,r,t) = dcost_kf(f,kf) + ftax(f,r)$(sameas(kf,"ldv") or sameas(kf,"mdhd"));
dcost("ppg",kf,r,t) = dcost_gas(kf,r) + (ftax("mgs",r) + dcost_cng)$(sameas(kf,"ldv") or sameas(kf,"mdhd"));

* Hydrogen distribution costs already captured by hdcost (to differentiate between central and forecourt production)
* Hence remove from dcost parameter
dcost("h2",kf,r,t) = 0;

* Electricity distribution costs (for endogenous end-uses) are not included in dcost, need to be added
* Convert units for electricity distribution costs from $ per MWh to $ per MMBtu
dcost("ele",kf,r,t) = (1/3.412) * tdcost_kf(r,kf,t);

* Annual operating costs for new vehicles excluding wholesale electric/non-electric fuel purchases (endogenous)
* = variable O&M plus fuel distribution costs
annual_cost_mdhd(vc_mdhd(vc),vht,v_e,di,r,t)$vt_life(vc,v_e,t) =
	di_vmt(vc,di) * vmti(vc) * (vom(vc,vht,v_e) + 1e-3 * sum(f, epvmt_r(vc,vht,f,r,v_e,t) * dcost(f,"mdhd",r,t))); 
* For non-road vehicles, include hydrogen dispensing cost (not included in delivered cost for small industrial)
annual_cost_nnrd(vc_nnrd(vc),vht,v_e,r,t)$vt_life(vc,v_e,t) =
	vom(vc,vht,v_e) + sum((kfvc(kf,vc),f), epsrv_r(vc,vht,f,r,v_e,t) * (dcost(f,kf,r,t) + 12$(sameas(f,"h2") and (sameas(vc,"nre-a1") or sameas(vc,"nre-c1") or sameas(vc,"nre-m1")))));

* Include delivery cost for hydrogen to power plants and transformation sectors
* As a default, assume $6/mmbtu (probably should be a component of capital cost)
* For consistency with upstream, assume distribution costs are expressed in 2018$ terms
$if not set pfh $set pfh 6
pfadd(i,f,r,t)$(h2f(f) and ifuel(i,f)) = gdpdef("2018","%curryr%") * %pfh%;
hdcost_trf = gdpdef("2018","%curryr%") * %pfh%;

* Remove nnrd service demand and fuel demands for bfs for now
nnrdpbfs(vc,bfs) = 0;
epbfs(f,bfs) = 0;

* Include gas price sensitivity
$if not set pgas_add $set pgas_add 0
pf_ups("gas",r,t)$(t.val > 2020) = pf_ups("gas",r,t) + %pgas_add%;

* Include oil price sensitivity (parameter is in $/brl)
$if not set poil_add $set poil_add 0
pf_ups(rfp(f),r,t)$(t.val > 2020) = pf_ups(f,r,t) + %poil_add% / 5.8;

* Adjust natural climate solution quantities (default is to scale by 0.25)
ncrcap(ncr,t) = %ncrlim% * ncrcap(ncr,t);

* Adjust supply curve for energy crops if specified (default is 1, some regions may have minimum for feasibility)
croplim(r) = max(%croplim%, croplim_min(r));

* Adjust emissions factor of biomass based on scenario-specified carbon neutrality credit
* Note that this is for reporting only:  emit, emit_c, and emit_trf parameters do not flow into sector-level emissions variables
$if set credit_bio credit_bio(bfs) = %credit_bio%;

emit("bioe-n",v,"bio","co2",r,t)             = htrate("bioe-n",v,"bio",r,t) * cc_bfs("cll") * (1 - credit_bio("cll"));
emit("becs-n",v,"bio","co2",r,t)             = htrate("becs-n",v,"bio",r,t) * cc_bfs("cll") * (1 - credit_bio("cll") - caprate("becs-n"));
emit_c(conv(i),vbase,v,"bio","co2",r,t)$idef(i,"bioc") = htrate_c(i,vbase,v,"bio",r,t) * cc_bfs("cll") * (1 - credit_bio("cll"));
emit_trf("bioh2","co2",v) = eptrf("bio","bioh2",v) * cc_bfs("cll") * (1 - credit_bio("cll"));
emit_trf("bioh2-ccs","co2",v) = eptrf("bio","bioh2-ccs",v) * cc_bfs("cll") * (1 - credit_bio("cll") - cprt_trf("bioh2-ccs",v));

* * See EPRI report 3002020121 for description of CES scenario options
* Adjust CES credit based on scenario-specified biomass emissions factor (allow BECS credit to be > 1 if specified)
ces(i,v,"bio",r,"degette")$((idef(i,"bioe") or idef(i,"becs")) and new(i)) =
$if not %cesbecs%==yes	min(1,
			max(0, (1 - sum(sameas(v,t), emit(i,v,"bio","co2",r,t)) / 0.82))
$if not %cesbecs%==yes	)
;
ces_c(conv(i),vbase,v,"bio",r,"degette")$idef(i,"bioc") = min(1, max(0, (1 - sum(sameas(v,t), emit_c(i,vbase,v,"bio","co2",r,t)) / 0.82)));

ces(i,v,"bio",r,"cfa")$((idef(i,"bioe") or idef(i,"becs")) and new(i)) =
$if not %cesbecs%==yes	min(1,
			max(0, (1 - sum(sameas(v,t), emit(i,v,"bio","co2",r,t)) / 0.82))
$if not %cesbecs%==yes	)
;
ces_c(conv(i),vbase,v,"bio",r,"cfa")$idef(i,"bioc") = min(1, max(0, (1 - sum(sameas(v,t), emit_c(i,vbase,v,"bio","co2",r,t)) / 0.82)));

* Option to set a flat gas price across all time periods
$iftheni.flatgas not %flatgas%==no
pf_ups("gas",r,t)$(not tbase(t)) = %flatgas%;
$endif.flatgas

* Option to fix investment to a specified baseline scenario through a specified year
* to simulate response to an unanticipated shock (e.g. fuel price change)
* Override fuel prices after %fixIX% year if specified
$iftheni.pfshock not %pf_shock%==no
$iftheni.fixix3 not %fixIX%==no
pf_ups("gas",r,t)$(t.val gt %fixIX%) = pf_alt("%pf_shock%","ppg",t);
$else.fixix3
$abort 'Need to set fixIX switch when using pf_shock switch'
$endif.fixix3
$endif.pfshock

* Set demand response backstop cost
drcost(r) = %drcost%;

* Set value of planning reserve marginout-of-region credit for planning reserve margins
rsvmarg(r) = %rsvmarg%;
* Calculate shortfall relative to assumed planning reserve margins in observed base year
* in-region capacity vs. peak load.
* Assume this shortfall is supplied by other (e.g. out-of-region) resources:
rsvoth(r) = max(eps,
            sum(peak(s,r,tbase(t)), ((load(s,r,t) - netder(s,r,t)) * localloss) * (1 + rsvmarg(r)) + hyps(s,r,t)
              - sum(ivrt(irnw(i),vbase(v),r,t), af_s(s,i,v,r,t) * xcap(i,r)))
          - sum(i, xcap(i,r) * rsvcc(i,r))
);

* If specified, assumed all technologies are dispatchable
$ifi not %free%==no dspt(i) = yes; ndsp(i) = no;

* If specified, include minimum dispatch constraint on certain technologies

* By default, dismin is zero
dismin(i,t) = 0;

* Nucl-x is in ndsp by default, can override if nucxmin < 1 to allow flexible dispatch
$ifthene.flex %nucxmin%<1
ndsp("nucl-x") = no; dspt("nucl-x") = yes;
* If 0 < nucxmin < 1, add to dspt_min and enforce minimum dispatch constraint
$ifthene.min %nucxmin%>0 
dismin("nucl-x",t)$(t.val le 2030) = %nucxmin%;
$endif.min
$endif.flex

* If specified, adjust contribution of variable renewables to operating reserves
$if set orvre orreq_vr = %orvre%;

* * *
* Policy settings

* Economy-wide carbon tax uses ctax_kr parameter instead of pp parameter
* pp is applied to electric generation at unit level in objective function,
* while ctax_kr is applied at sector/region level.
* A carbon tax path starting in different years can be specified directly
ctax_econ(t) = 0;
$if set ctax20  ctax_econ("co2",t)$(tyr(t) ge 2020) = %ctax20% * (1 + %ctaxrate%)**(tyr(t) - 2020);
$if set ctax25  ctax_econ("co2",t)$(tyr(t) ge 2025) = %ctax25% * (1 + %ctaxrate%)**(tyr(t) - 2025);
$if set ctax30  ctax_econ("co2",t)$(tyr(t) ge 2030) = %ctax30% * (1 + %ctaxrate%)**(tyr(t) - 2030);
$if set ctax35  ctax_econ("co2",t)$(tyr(t) ge 2035) = %ctax35% * (1 + %ctaxrate%)**(tyr(t) - 2035);
$if set ctax40  ctax_econ("co2",t)$(tyr(t) ge 2040) = %ctax40% * (1 + %ctaxrate%)**(tyr(t) - 2040);
$if set ctax45  ctax_econ("co2",t)$(tyr(t) ge 2045) = %ctax45% * (1 + %ctaxrate%)**(tyr(t) - 2045);
$if set ctax50  ctax_econ("co2",t)$(tyr(t) ge 2050) = %ctax50% * (1 + %ctaxrate%)**(tyr(t) - 2050);

* Could add a switch here to specify different carbon taxes for different regions
* Default is same carbon tax in all regions
ctax_econ_r(r,t) = ctax_econ(t);

* Could add a switch here to specify different carbon taxes for different sectors
* Default is same carbon tax in all sectors
ctax_kr("ele",r,t) = ctax_econ_r(r,t);
ctax_kr("ups",r,t) = ctax_econ_r(r,t); 
ctax_kr("bld",r,t) = ctax_econ_r(r,t); 
ctax_kr("ind",r,t) = ctax_econ_r(r,t); 
ctax_kr("trn",r,t) = ctax_econ_r(r,t); 
ctax_kr("trf",r,t) = ctax_econ_r(r,t); 
* Carbon tax applied to DAC reflects a subsidy for net removals, which will results in an unbounded
* ray if larger than levelized cost (and zero deployment of DAC otherwise)
* Hence default value is zero.  To include DAC in a carbon tax scenario, consider using upper bound on deployment
* ctax_kr("dac",r,t) = ctax_econ_r(r,t); 
ctax_kr("dac",r,t) = 0; 

* If specified, extend carbon tax applied to upstream sectors to energy-related methane emissions
ch4tax(r,t) = 0;
$if not %ch4tax%==no ch4tax(r,t) = ctax_kr("ups",r,t);

* To reproduce a CES scenario with a tax/subsidy instrument, read cestax from previous run
cestax(i,v,f,r,t) = 0; cestax_c(i,vv,v,f,r,t) = 0;
$ifi not %cestax%==no execute_load '%cestax%.gdx', cestax, cestax_c;

* In certain run modes, model variables can be fixed to output from a previous scenario
* Use the following parameters to represent the target values
parameter
xcfx(i,v,r,t)                   Fixed target for electric generation capacity (XC variable) (GW)
xc_cfx(i,v,v,r,t)               Fixed target for converted electric generation capacity (XC_C variable) (GW)
tcfx(r,r,t)                     Fixed target for inter-regional transmission capacity (TC variable) (GW)
gcfx(j,r,t)                     Fixed target for electric storage power capacity (GC variable) (GW)
grfx(j,r,t)                     Fixed target for electric storage energy capacity (GR variable) (GWh)
fcfx(fi,v,r,t)                  Fixed target for non-electric fuel production capacity (FC variable) (BBtu per year)
tc_hfx(r,r,t)                   Fixed taregt for inter-regional hydrogen transmission capacity (TC_H variable) (BBtu per hour)
gc_hfx(hk,r,t)                  Fixed target for hydrogen storage charge capacity (GC_H variable) (BBtu per hour)
gr_hfx(hk,r,t)                  Fixed target for hydrogen storage reservoir capacity (GR_H variable) (BBtu)
pcfx(r,r,t)                     Fixed target for CO2 pipeline capacity (PC variable) (MtCO2 per year)
injcfx(cstorclass,r,t)          Fixed target for CO2 injection capacity (INJC variable) (MtCO2 per year)
xvfx(vc,vht,v_e,r,t)            Fixed target for active vehicles (XV variable) (millions)
ixfx(i,r,t)                     Fixed target for electric generation capacity investment (IX variable) (GW)
ixfx_c(i,v,r,t)			Fixed target for electric generation conversion investment (IX_C variable) (GW)
itfx(r,r,t)                     Fixed target for inter-regional transmission capacity per-period investment (IT variable) (GW)
ixprev(i,r,t_all)               Electric generation capacity additions in specified previous dynamic scenario (GW)
ixlo(i,r)                       Lower bound on endogenous electric generation capacity additions in current static year (GW)
;

* In dynfx static mode, endogenous rental capacity is allowed for some capacity of certain types, identified here
* Note:  CSP should not be part of i_end unless cspstorage is turned on
set
type_end(type)                  Electric generation types that can be rented endogenously in static mode /
                                nucl, nuca, wind, wnos, pvft, pvsx, pvdx, ngcc, nggt, nccs, ncch, nccx, h2cc, h2gt
$ifi %cspstorage%==yes          cspr
/
type_end_lo(type)               Types that get a lower bound on endogenous rental based on a previous rental solution /
                                nucl, nuca, nccs, ncch, nccx
/
;

* * * DYNFX MODE

* In dynfx static mode, the model is run for a single year with certain variables fixed to output from a previous dynamic model run
* (the i after ifthen here refers to case insensitive compare)
$iftheni.dynfx %dynfx%==yes

execute_load '%dynfxgdx%.gdx', xcfx=XC.L, xc_cfx=XC_C.L tcfx=TC.L, itfx=IT.L, gcfx=GC.L, fcfx=FC.L, rsvoth;

* If the dynfx_prev option is specified in dynfx mode, an earlier year's model output can be used to constrain additions in the current static solve
* Read in the previous year's investment level to use as a lower bound in current scenario
ixlo(i,r) = 0;
$ifthen.dynfx_prev not %dynfx_prev%==no
execute_load '%dynfx_prevgdx%.gdx', ixprev=IX.L;
ixlo(i,r) = ixprev(i,r,"%dynfx_prev%");
$endif.dynfx_prev

* Identify subsets of (i,v) corresponding to fixed and endogenous capacity blocks in dynfx static mode if specified with %i_end% option
i_end(i) = no;
i_end_lo(i) = no;

$if not %i_end%==no i_end(new(i))$sum(idef(i,type), type_end(type)) = yes;
i_end_lo(i)$(i_end(i) and sum(idef(i,type), type_end_lo(type))) = yes;
iv_fix(xtech,vbase) = yes;
iv_fix(new(i),vstatic)$(not i_end(i)) = yes;

* Update ivrt assignment based on xcfx and i_end/iv_fix
ivrt(i,v,r,t) = yes$((xcfx(i,v,r,t) and iv_fix(i,v)) or (i_end(i) and tv(t,v)));
civrt(i,vv,v,r,t) = yes$xc_cfx(i,vv,v,r,t);
ivfrt(i,v,f,r,t) = yes$(ivfrt(i,v,f,r,t) and ivrt(i,v,r,t));
civfrt(i,vv,v,f,r,t) = yes$(civfrt(i,vv,v,f,r,t) and civrt(i,vv,v,r,t));
* Remove new renewable technologies if class is inactive in region
ivrt(i,v,r,t)$(irnw(i) and new(i) and not sameas(i,"wind-r") and (caplim(i,r) eq 0 or (sum(iclass(i,type,class), solarcap(class,r)) eq 0 and sol(i)))) = no;
ivrt("wind-r",v,r,t)$(xcap("wind-x",r) eq 0) = no;

$endif.dynfx
* * * END DYNFX MODE

* * * STATFX MODE
* Static fixed capacity mode:  run static model with all capacity fixed to a previous dynamic solution

$ifthen.statfx %statfx%==yes
execute_load '%statfxgdx%.gdx', xcfx=XC.L, xc_cfx=XC_C.L, tcfx=TC.L, itfx=IT.L, gcfx=GC.L, grfx=GR.L, fcfx=FC.L, tc_hfx=TC_H.L, gc_hfx=GC_H.l, gr_hfx=GR_H.L, pcfx=PC.L, injcfx=INJC.L, xvfx=XV.L, rsvoth;
* No endogenous capacity additions
i_end(i) = no;
iv_fix(xtech,vbase) = yes;
iv_fix(new(i),vstatic) = yes;

* * * * Replacing ivrt assignment with a simple conditional on xcfx or i_end
ivrt(i,v,r,t) = yes$((xcfx(i,v,r,t) and iv_fix(i,v)) or (i_end(i) and tv(t,v)));
civrt(i,vv,v,r,t) = yes$xc_cfx(i,v,vv,r,t);
ivfrt(i,v,f,r,t) = yes$(ivfrt(i,v,f,r,t) and ivrt(i,v,r,t));
civfrt(i,vv,v,f,r,t) = yes$(civfrt(i,vv,v,f,r,t) and civrt(i,vv,v,r,t));
fivrt(fi,v,r,t) = yes$fcfx(fi,v,r,t);
* Remove new renewable technologies if class is inactive in region
ivrt(i,v,r,t)$(irnw(i) and new(i) and not sameas(i,"wind-r") and (caplim(i,r) eq 0 or (sum(iclass(i,type,class), solarcap(class,r)) eq 0 and sol(i)))) = no;
ivrt("wind-r",v,r,t)$(xcap("wind-x",r) eq 0) = no;
$endif.statfx
* * * END STATFX MODE

* * * FIXIX MODE
* For FixIX option, read targets for fixed investment for a given set of years to what occurred in the baseline
$ifi not %fixIX%==no execute_load '%fixIXgdx%.gdx', ixfx=IX.L, ixfx_c=IX_C.L, xcfx=XC.L, xc_cfx=XC_C.L, itfx=IT.L;

* If sectorcap option is specified, assign target reduction relative to base year (default is no cap, i.e. set to inf)

direct_bld(r,t) = inf;
direct_ind(r,t) = inf;
direct_trn(r,t) = inf;

$ifthen set sectorcap
direct_bld(r,t)$(t.val ge 2030) = max(sectorcap(t), sectorcap_min("bld",r,t));
direct_ind(r,t)$(t.val ge 2030) = max(sectorcap(t), sectorcap_min("ind",r,t));
direct_trn(r,t)$(t.val ge 2030) = max(sectorcap(t), sectorcap_min("trn",r,t));
$endif

* Setting --cap_ele=ref provides a convenient way to fix U.S. electric sector CO2
* emissions to those in a reference scenario. Be sure to include an extra line in
* the electric model run file 'set ref_scen=#reference scenario name#'
usemitref(pol,t) = 0 ;
$ifthen.co2ref %cap_ele%==ref
execute_load '%elecrptrefgdx%.gdx', usemitref=usemit ;
co2cap_ele(t,"ref")$(not tbase(t)) = usemitref("co2",t) ;
$endif.co2ref

* Manually defined electric sector caps:
* Setting --cap_ele to a user-specified label and assigning values (in MtCO2) to mcap switches allows user to 
* specify an electric sector cap over time, with linear interpolation as necessary
$ifthen.manual set manualcap
$set cap %manualcap%
co2cap_ele("2020","%cap_ele%") = %mcap20%;
co2cap_ele("2025","%cap_ele%") = (2/3) * %mcap20% + (1/3) * %mcap35%;
co2cap_ele("2030","%cap_ele%") = (1/3) * %mcap20% + (2/3) * %mcap35%;
co2cap_ele("2035","%cap_ele%") = %mcap35%;
$ifthen.m50 set mcap50
co2cap_ele("2040","%cap_ele%") = (2/3) * %mcap35% + (1/3) * %mcap50%;
co2cap_ele("2045","%cap_ele%") = (1/3) * %mcap35% + (2/3) * %mcap50%;
co2cap_ele("2050","%cap_ele%") = %mcap50%;
$else.m50
$if set mcap40 co2cap_ele("2040","%cap_ele%") = %mcap40%;
$if set mcap45 co2cap_ele("2045","%cap_ele%") = %mcap45%;
$endif.m50
zerocap_ele(t,"%cap_ele%")$(t.val > 2015) = yes$(co2cap_ele(t,"%cap_ele%") eq 0);
$endif.manual

* Calculate state RPS parameters based on scenario load projections
rcmlim(r,t) = 1e-3 * sum(s, hours(s,t) * load(s,r,t)) * rpstgt_r(r,t) * rcmlim_r(r,t) * (1 + 0.1$cal_r(r));
nmrlim(r,t) = 1e-3 * sum(s, hours(s,t) * load(s,r,t)) * rpstgt_r(r,t) * nmrlim_r(r,t) * (1 + 0.1$cal_r(r));
acplim(r,t) = 1e-3 * sum(s, hours(s,t) * load(s,r,t)) * rpstgt_r(r,t) * acplim_r(r) * (1 + 0.1$cal_r(r));
soltgt(r,t) = 1e-3 * sum(s, hours(s,t) * load(s,r,t)) * soltgt_r(r,t);

* ------------------------------------------------------------------------------
* Capital cost adjustments for end-effects in dynamic mode (i.e. intertemporal optimization)
* modlife parameter adjusts investment costs for the remaining investment lifetime within the model horizon
* If the investment lifetime is entirely contained within the remaining model horizon, modlife = 1 (no adjustment)
* In later time periods, as less of the investment lifetime is contained within the remaining model horizon,
* modlife falls below 1, reflecting the fraction of the discounted lifetime remaining.
* The implication is that capacity investment is increasingly treated as capacity rental as the end of the model horizon approaches.

* Assign investment life for new generation technologies
invlife_i(i)$(new(i) or conv(i)) = sum(idef(i,type), invlife(type));

$ifthen.mcalc %static%==no

* For infinitely-lived investments (infrastructure), estimate the fraction based on all future time periods included in t_all
modlife_inf(t) = sum(tt$(tyr(tt) ge tyr(t)), dfact(tt)) / sum(t_all$(tyr(t_all) ge tyr(t)), dfact(t_all));

* For vintaged electric generation technologies, fraction is calculated for explicit lifetime
modlife(new(i),t) =
*	Discounted sum over time periods remaining in model within the investment lifetime
	sum(tt$(tyr(tt) ge tyr(t) and tyr(tt) < tyr(t) + invlife_i(i)), dfact(tt)) /
*	As a fraction of discounted sum of all future time periods within the investment lifetime
	sum(t_all$(tyr(t_all) ge tyr(t) and tyr(t_all) < tyr(t) + invlife_i(i)), dfact(t_all))
;

* For conversion electric generation technologies of existing capacity, remaining fraction is linked to lifetime(i,r,t)
* for underlying block (which depends on region, hence modlife_c is indexed over region as well)
modlife_c(conv(i),vbase,r,t)$sum(convmap(i,orig), lifetime(orig,r,t)) = 
*	Discounted sum over time periods remaining in model within the investment lifetime
	sum(tt$(tyr(tt) ge tyr(t)), sum(convmap(i,orig), lifetime(orig,r,tt)) * dfact(tt)) /
*	As a fraction of discounted sum of all future time periods within the investment lifetime
	sum(t_all$(tyr(t_all) ge tyr(t)), sum(convmap(i,orig), lifetime(orig,r,t_all)) * dfact(t_all))
;

* Alternative for technologies like coal ccs retrofits driven by short-lived 45Q subsidy:
* For conversion technologies of some existing capacity, assume retrofit investment must pay off within model time horizon
modlife_c(conv(i),vbase,r,t)$idef(i,"ccs9") = 1;

* For conversion technologies of new additions, fraction is calculated for lifetime of original investment
modlife_c(conv(i),newv(vv),r,t)$(tyr(t) > vyr(vv) and sum(convmap(i,new), 1)) =
*	Discounted sum over time periods remaining in model within the remaining lifetime of underlying vintage
	sum(tt$(tyr(tt) ge tyr(t) and tyr(tt) < vyr(vv) + sum(convmap(i,orig), invlife_i(orig))), dfact(tt)) /
*	As a fraction of discounted sum of all future time periods within the investment lifetime
	sum(t_all$(tyr(t_all) ge tyr(t) and tyr(t_all) < vyr(vv) + sum(convmap(i,orig), invlife_i(orig))), dfact(t_all))
;

* Lifetime adjustment for electricity storage technologies
modlife_g(j,t) =
*	Discounted sum over time periods remaining in model within the investment lifetime
	sum(tt$(tyr(tt) ge tyr(t) and tyr(tt) < tyr(t) + invlife_g(j)), dfact(tt)) /
*	As a fraction of discounted sum of all future time periods within the investment lifetime
	sum(t_all$(tyr(t_all) ge tyr(t) and tyr(t_all) < tyr(t) + invlife_g(j)), dfact(t_all))
;

* Lifetime adjsutment for hydrogen storage technologies
modlife_hg(hk,t) =
*	Discounted sum over time periods remaining in model within the investment lifetime
	sum(tt$(tyr(tt) ge tyr(t) and tyr(tt) < tyr(t) + invlife_hg(hk)), dfact(tt)) /
*	As a fraction of discounted sum of all future time periods within the investment lifetime
	sum(t_all$(tyr(t_all) ge tyr(t) and tyr(t_all) < tyr(t) + invlife_hg(hk)), dfact(t_all))
;

* Lifetime adjustment for fuel transformation technologies
modlife_trf(fi,t) =
*	Discounted sum over time periods remaining in model within the investment lifetime
	sum(tt$(tyr(tt) ge tyr(t) and tyr(tt) < tyr(t) + invlife_trf(fi)), dfact(tt)) /
*	As a fraction of discounted sum of all future time periods within the investment lifetime
	sum(t_all$(tyr(t_all) ge tyr(t) and tyr(t_all) < tyr(t) + invlife_trf(fi)), dfact(t_all))
;

* For electrolysis driven by short-lived 45V subsidy, investment must pay off within model time horizon
modlife_trf("elys-45v",t) = 1;

* Lifetime adjustment for direct air capture
modlife_dac(dac,t) =
*	Discounted sum over time periods remaining in model within the investment lifetime
	sum(tt$(tyr(tt) ge tyr(t) and tyr(tt) < tyr(t) + invlife_dac(dac)), dfact(tt)) /
*	As a fraction of discounted sum of all future time periods within the investment lifetime
	sum(t_all$(tyr(t_all) ge tyr(t) and tyr(t_all) < tyr(t) + invlife_dac(dac)), dfact(t_all))
;

* Assign modlife_mdhd based on updated vt_life and expanded v_e, t_all sets
modlife_eu(vc,t) =
*	Discounted sum over time periods remaining in model within the investment lifetime
	sum((tv_e(t,v_e),tt)$(tt.val ge t.val), vt_life(vc,v_e,tt) * dfact(tt)) /
*	As a fraction of discounted sum of all future time periods within the investment lifetime
	sum((tv_e(t,v_e),t_all)$(t_all.val ge t.val), vt_life(vc,v_e,t_all) * dfact(t_all))
;

* A similar factor must be calculated for fixed term subsidies
modlife_ptc(v)$sum(t, ptctv(t,v)) =
*	Discounted sum over time periods remaining in model within the 45Y/PTC eligibility period
	sum(tt$ptctv(tt,v), dfact(tt)) /
*	As a fraction of discounted sum of all future time periods within the 45Y/PTC eligibility period
	sum(t_all$ptctv(t_all,v), dfact(t_all))
;

modlife_45q(v)$sum(t, co2cred(v,t)) =
*	Discounted sum over time periods remaining in model within the 45Q eligibility period
	sum(tt, co2cred(v,tt) * dfact(tt)) /
*	As a fraction of discounted sum of all future time periods within the 45Q eligibility period
	sum(t_all, co2cred(v,t_all) * dfact(t_all))
;


$else.mcalc
* In static mode, a capital recovery factor is calculated to represent annualized rental costs of new investments:

* Set capital recovery factor to coincide with one year's worth of rental using above formula
crf(new(i)) = drate / (1 - (1+drate)**(-invlife_i(i)));
* Set capital recovery factor for conversions based on full lifetime
crf_c(conv(i),v) = drate / (1 - (1+drate)**(-invlife_i(i)));

* Set capital recover factors for each investment class (j, hk, fi, dac, vc)
crf_g(j) = drate / (1 - (1 + drate)**(-invlife_g(j)));
crf_hg(hk) = drate / (1 - (1 + drate)**(-invlife_hg(hk)));
crf_trf(fi) = drate / (1 - (1 + drate)**(-invlife_trf(fi)));
crf_dac(dac) = drate / (1 - (1 + drate)**(-invlife_dac(dac)));
crf_eu(vc) = drate / (1 - (1 + drate)**(-invlife_eu));

$endif.mcalc

* Set effective price of capital depending on model formulation.  Investment flows are
*	- annualized evenly across period in dynamic mode
*	- rented at a fixed charge rate in static mode
*	- adjusted for remaining lifetime in model horizon in dynamic mode (modlife)
*	  (modlife is assigned above, overriden here if specified)
*       - subject to capital tax rate tk in both dynamic and static mode

$iftheni not %modlife%==yes
modlife(new(i),t) = 1;
modlife_c(conv(i),vbase,r,t)$sum(convmap(i,orig), lifetime(orig,r,t)) = 1;
modlife_c(conv(i),newv(vv),r,t)$(tyr(t) > vyr(vv) and sum(convmap(i,new), 1)) = 1;
modlife_ptc(v)$sum(t, ptctv(t,v)) = 1;
modlife_45q(v)$sum(t, co2cred(v,t)) = 1;
modlife_g(j,t) = 1;
modlife_hg(hk,t) = 1;
modlife_inf(t) = 1;
modlife_trf(fi,t) = 1;
modlife_dac(dac,t) = 1;
modlife_eu(vc,t) = 1;
$endif

$iftheni %static%==no
cappr_i(new(i),r,t) = (1 + tk) * (1 / nyrs(t)) * modlife(i,t);
cappr_c(conv(i),vv,r,t) = (1 + tk) * (1 / nyrs(t)) * modlife_c(i,vv,r,t);
cappr_g(j,r,t) = (1 + tk) * (1 / nyrs(t)) * modlife_g(j,t);
cappr_hg(hk,r,t) = (1 + tk) * (1 / nyrs(t)) * modlife_hg(hk,t);
cappr_inf(r,t) = (1 + tk) * (1 / nyrs(t)) * modlife_inf(t);
cappr_trf(fi,r,t) = (1 + tk) * (1 / nyrs(t)) * modlife_trf(fi,t);
cappr_dac(dac,r,t) = (1 + tk) * (1 / nyrs(t)) * modlife_dac(dac,t);
cappr_eu(vc,r,t) = (1 / nyrs(t)) * modlife_eu(vc,t);
$else
cappr_i(new(i),r,t) = (1 + tk) * crf(i);
cappr_c(conv(i),vv,r,t) = (1 + tk) * crf_c(i,vv);
cappr_g(j,r,t) = (1 + tk) * crf_g(j);
cappr_hg(hk,r,t) = (1 + tk) * crf_hg(hk);
cappr_inf(r,t) = (1 + tk) * drate;
cappr_trf(fi,r,t) = (1 + tk) * crf_trf(fi);
cappr_dac(dac,r,t) = (1 + tk) * crf_dac(dac);
cappr_eu(vc,r,t) = crf_eu(vc);
$endif


* Aggregate exogenously specified variable costs into a single parameter
* Note that full dispatch cost will also include claims from endogenous fuel and carbon markets

* Also note that production and carbon capture subsidies (45Q) are adjusted for the model time horizon.
* The modlife parameter calculates the NPV of remaining investment life within the model time horizon as a fraction of
* the NPV of the full hypothetical investment life and adjusts capital cost accordingly.  The idea is that revenue from
* the markets in the model need only cover the rental costs of capacity during the remaining time horizon.
* When there is a fixed term subsidy, it is providing some of the revenue (in addition to the endogenous markets).
* The modlife_ptc/45q parameter is used to adjust the subsidy value so that it provides the same fraction of
* total NPV revenue (= capital cost) over the shortened remaining model horizon.  

* New/existing (single fuel) units
icost(strd(i),v,f,r,t)$ivfrt(i,v,f,r,t) =
*       Variable O&M costs
          vcost(i,v,r)
*       Fuel cost adjustments (i-specific price delta)
        + htrate(i,v,f,r,t) * pfadd(i,f,r,t)
*       Pollutant prices applied at plant level
        + sum(pol, emit(i,v,f,pol,r,t) * pp(pol,t))
*       Regional pollutant prices applied at plant level
        + sum(pol, emit(i,v,f,pol,r,t) * pp_rg(pol,r,t))
*       Implicit CES tax or subsidy
        + cestax(i,v,f,r,t)
*       Production Tax Credit (if applicable)
        - (ptc(i,f,v)$ptctv(t,v)) * (sum(tv(t.local,v), modlife(i,t)) / modlife_ptc(v))$modlife_ptc(v)
*       CO2 Storage 45Q Credit (will be 0 if not activated)
        - ccs45Q(i,v,f,r,t) * (sum(tv(t.local,v), modlife(i,t)) / modlife_45q(v))$modlife_45q(v)
;

* Converted units
icost_c(conv(i),vv,v,f,r,t)$civfrt(i,vv,v,f,r,t) =
*       Variable O&M costs 
          vcost_c(i,vv,v,r)
*       Fuel cost adjustments (i-specific price delta)
        + htrate_c(i,vv,v,f,r,t) * pfadd(i,f,r,t)
*       Pollutant prices applied at plant level
        + sum(pol, emit_c(i,vv,v,f,pol,r,t) * pp(pol,t))
*       Regional pollutant prices applied at plant level
        + sum(pol, emit_c(i,vv,v,f,pol,r,t) * pp_rg(pol,r,t))
*       Implicit CES tax or subsidy
        + cestax_c(i,vv,v,f,r,t)
*       Production Tax Credit (if applicable)
        - (ptc(i,f,v)$ptctv(t,v)) * (sum(tv(t.local,v), modlife_c(i,vv,r,t)) / modlife_ptc(v))$modlife_ptc(v) 
*       CO2 Storage 45Q Credit (will be 0 if not activated)
        - ccs45Q_c(i,vv,v,f,r,t) * (sum(tv(t.local,v), modlife_c(i,vv,r,t)) / modlife_45q(v))$modlife_45q(v)
;

* Fuel Transformation Sectors
fcost(fi,v,r,t)$vt(v,t) =
*       Variable O&M costs
          vcost_trf(fi,v)
*       Fuel cost adjustments (r-specific price delta) 
        + sum(f, (eptrf(f,fi,v) + fptrf(f,fi,v)) * pfadd_r(f,r,t))
*       Pollutant prices applied at plant level (excluding CO2)
        + sum(pol, emit_trf(fi,pol,v) * pp(pol,t))
*       Regional pollutant prices applied at plant level
        + sum(pol, emit_trf(fi,pol,v) * pp_rg(pol,r,t))
*       Production Tax Credit (if applicable)
        - (ptc_h(fi,v)$ptctv(t,v)) * (sum(tv(t.local,v), modlife_trf(fi,t)) / modlife_ptc(v))$modlife_ptc(v) 
*       CO2 Storage 45Q Credit (will be 0 if not activated)
        - ccs45Q_trf(fi,v,t) * (sum(tv(t.local,v), modlife_trf(fi,t)) / modlife_45q(v))$modlife_45q(v) 
*	CO2 utilization credit reduction (i.e. user of CO2 must reimburse the capture source for the difference)
	- ccu45Q_trf(fi,v,t) * (sum(tv(t.local,v), modlife_trf(fi,t)) / modlife_45q(v))$modlife_45q(v)
;

* Direct air capture 
daccost(dac,v,r,t)$vt(v,t) =
*	Variable O&M costs
	vcost_dac(dac,v)
*	Fuel cost adjustments (r-specific price delta)
	+ sum(f, epdac("%dacscn%",f,dac,v) * pfadd_r(f,r,t))
*	CO2 storage 45Q credit (will be 0 if not activated)
	- ccs45Q_dac(dac,v,t) * (sum(tv(t.local,v), modlife_dac(dac,t)) / modlife_45q(v))$modlife_45q(v) 
;

* Variable cost for storage (CAES)
* Includes only fuel cost adjustment (r-specific price delta)
vcg(j,r,t) = htrate_g(j) * pfadd("ngcc-n","ppg",r,t);

* <><><><><><><><><><><><><>
* regen_runtime.gms <end>
* <><><><><><><><><><><><><>
