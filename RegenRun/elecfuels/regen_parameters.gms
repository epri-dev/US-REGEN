* ----------------------
* regen_parameters.gms
* ----------------------
* REGEN Electric+Fuels Model
* Parameter declarations and load (from upstream)


* * * Electric generation capacity
parameter
* Throughout the model, electric generation is expressed in terms of AC summer capacity
* (where solar profiles are defined assuming a technology-specific DC-AC ratio)
xcap(i,r)                       Existing electric generation capacity (GW_AC)
ncl(type)                       Number of capacity classes for each electric generation type
cumuprates(r,t)                 Cumulative exogenous nuclear uprates (GW)
cumuprates_nuc60(r,t)           Cumulative exogenous nuclear uprates (GW) (60 yrs nuclear life)
caplim(i,r)                     Upper bound on total installed electric generation capacity (GW)
solarcap(class,r)               Upper bound on total solar capacity (PV + weighted CSP) (GW)
cspwt                           Weight on CSP in solar capacity constraint
invlim(type,r,t)                Upper bound on investment in electric generation capacity based on near-term pipeline (cumulative since last time period) (GW)
usinvlim(*,tech,t)              Upper bound on national investments in electric generation capacity by technology category with alternative scenarios (cumulative since last time period) (GW)
convadj(i)	                Adjustment to electric generation capacity for conversions (penalty)
convlim(i,r)	                Upper bounds on conversion eligible existing electric generation capacity (GW)
convertgas(i,r,t)               Fraction of existing coal blocks exogenously converted to gas based on announcements
convertbio(i,r,t)               Fraction of existing coal blocks exogenously converted to bio based on announcements
dismin(i,t)                     Minimum dispatch factor for dspt_min electric generation technologies
invlife(type)                   Investment life for new electric generation capacity additions by type (years)
invlife_i(i)	                Investment life for new electric generation technologies (years)
* Lifetime coefficient refers to share of base year capacity that potentially remains (has not retired due to age) in each time step
lifetime(i,r,t_all)             Lifetime coefficient for existing electric generation capacity (including extension beyond model time horizon)
lifetime_coal(*,i,r,t_all)      Lifetime coefficient sensitivity options for existing coal capacity
lifetime_nuc60(r,t_all)         Lifetime coefficient for existing nuclear capacity with 60 year lifetimes
lifetime_nucnz60(r,t_all)       Lifetime coefficient for existing nuclear capacity with net-zero ownership and 60 year lifetimes
uscoal20_gw                     Total US installed coal capacity in 2020 (GW)
;

* * * Electric generation costs
parameter
capcost(i,v,r)                  Capital cost for new electric generation capacity ($ per kW_AC)
capcost_rnw(tlc,i,v,r)          Capital cost for new renewable electric generation capacity ($ per kW_AC) (alternative scenarios)
tcostadder(tdcscen,i)           Intra-regional transmission capital cost adder for wind and solar ($ per kW) (alternative scenarios)
fomcost(i,r)                    Fixed O&M cost for electric generation capacity ($ per kW-year)
vcost(i,v,r)                    Variable O&M cost for electric generation (excluding fuel) ($ per MWh)
vcost_c(i,v,v,r)                Variable O&M cost for converted electric generation (excluding fuel) ($ per MWh)
pfadd(i,f,r,t)                  Region- or technology-specific fuel price adder for electric generation ($ per MMBtu)
icost(i,v,f,r,t)                Total exogenous (excluding endogenous market claims) variable cost for electric generation ($ per MWh)
icost_c(i,v,v,f,r,t)            Total exogenous (excluding endogenous market claims) variable cost for electric generation (converted units) ($ per MWh)
;

* * * Electric generation operational parameters
parameter
htrate(i,v,f,r,t)               Heat rate for electric generation (MMBtu per MWh)
htrate_c(i,v,v,f,r,t)           Heat rate for electric generation (converted units) (MMBtu per MWh)
htrate_m(i,v,r)	                Marginal heat rate for diverting thermal steam dispatch (MMBtu per MWh)
ifuel(i,f)                      Limit on fuel blending (equals 1 for single-fuel technologies or dual-fuel with no limits)
emit(i,v,f,pol,r,t)             Pollutant emission rate (intensity) for electric generation (metric tonne per MWh)
emit_c(i,v,v,f,pol,r,t)         Pollutant emission rate (intensity) for electric generation (converted units) (metric tonne per MWh)
caprate(i)                      Capture rate for electric generation technologies (fraction of total process CO2 captured)
capture(i,v,f,r)                Captured CO2 intensity for electric generation technologies by output (tCO2 per MWh)
capture_c(i,v,v,f,r)            Captured CO2 intensity for electric generation technologies by output (converted units) (tCO2 per MWh)
waterdraw(i,r)                  Water withdrawal intensity for electric generation technologies (gallons per MWh)
watercons(i,r)                  Water consumption intensity for electric generation technologies (gallons per MWh)
pf_alt(*,f,t)                   Alternative power producer fuel price paths for sensitivity analysis ($ per MMBtu)
acf_h(i,v,r)                    Annual average hourly capacity factors for variable generation resources
aaf_m(i,r,t)                    Annual average monthly availability factors for non-variable resources
acf_s(i,v,r,t)                  Annual average capacity factors based on current segments
acf_s_chk(*,i,v,r,t)            Check on adjusted annual average capacity factors
af_m(i,r,m)                     Availability factor by month in base year (not specified for wind and solar)
af_s(s,i,v,r,t)                 Availability factor by segment (for wind and solar and hydro)
vrsc_t(i,r,t)                   Time-varying coefficient for variable resources (if applicable)
af(s,i,v,r,t)                   Availability factor by segment (consolidated)
cf_y(i,r)                       Annual capacity factor upper bound (unrestricted if 0)
hydadj(r,t)                     Hydro cf adjustment factor to modify shapes to match long-run average (fraction of 2015)
xdr(i,f,xr)                     Map between technologies and dispatch reporting categories
xkr(i,kr)                       Map between technologies and capacity reporting categories
gdpdef(*,*)                     GDP deflator (based on St Louis Fed data)
;

* * * Transmission parameters
parameter
tcap(r,r)                       Existing capacity for inter-regional transmission (GW)
tlinelen(r,r)                   Length in miles of hypothetical transmission lines between two regions (based on centroids)
tusinvlim(*,t)                  Upper bound on national transmission investment - alternative scenarios (cumulative since last time period) (GW-miles)
tgrow(r,r)	                Maximum growth rate per period for inter-regional transmission capacity
tcapcost(r,r)                   Capital cost of new transmission capacity ($ per kW) (blank for ineligible links)
tcost(r,r)                      Variable cost for inter-regional power exchange ($ per MWh)
trnspen(r,r)                    Transmission loss penalty as a fraction of power exchange
ntxintl(r)                      Exogenous annual net international exports by region (TWh)
;

* * * Electricity storage parameters
parameter
gcap(j,r)                       Existing electricity storage capacity (GW)
ghours(j,r)                     Hours of electricity storage (room size relative to door size) if exogenously specified
capcost_gc(tlc,j,t)             Electricity storage power capacity cost ($ per kW) (alternative scenarios)
capcost_gr(tlc,j,t)             Electricity storage energy capacity cost ($ per kWh) (alternative scenarios)
fomcost_g(j,t)	                Electricity storage fixed O&M costs for charging capacity ($ per kW-year)
chrgpen(j)                      Charge efficiency penalty for electricity storage (> 1)
loss_g(j)                       Loss rate from accumulated electricity storage (% per hour)
loss_d(j)	                Degradation of electricity storage capacity (% per five-year time period)
htrate_g(j)                     Gas consumption for electricity storage (CAES only) (MMBtu per MWh)
vcg(j,r,t)                      Variable cost for electricity storage (excluding claims on endogenous markets) (CAES only) ($ per MWh)
invlife_g(j)                    Investment life for new electricity storage additions (years)
hyps(s,r,t)                     Energy requirement for pumped storage (net charge) (when storage is exogenous) (GW)
;

* * * CSP parameters
* Values based on DOE Sunshot 2030 optimistic cost assumptions
parameter
dni(s,i,r)                      Direct irradiance for concentrated solar (differs from af only when using endogenous thermal storage)
ic_csp_cr(i)                    Investment cost for CSP collector + receiver ($ per kW-th)
irg_csp(i)                      Investment cost for CSP storage room capacity ($ per kWh-th)
csp_cost_c                      CSP cost of collector ($ per m2)
csp_cost_r                      CSP cost of receiver ($ per kW-th)
csp_eff_p                       CSP power block efficiency (net)
csp_eff_c                       CSP collector efficiency (kW-th per m2 relative to nominal conditions of 1)
csp_eff_r                       CSP receiver efficiency
csp_loss_g                      CSP storage loss per hour (based on 1 pct per day)
;

* * * Fuels Transformation sector parameters
* Note that hydrogen and ammonia production are represented as fuel transformation activities even when the
* product is used for non-energy applications
* Fuel quantities are represented in energy terms using LHV
parameter
fimap(f,fi)                     Percent mapping from fuel transformation sector technologies to output fuels
fc0(fi,r)                       Base year fuel transformation sector production capacity (BBtu per hour)
convadj_fi(fi)	                Adjustment to fuel transformation capacity for conversions (penalty)
af_trf(fi)                      Availability factor relative to nominal capacity for fuel transformation
eptrf(f,fi,v)                   Energy consumption per MMBtu of fuel transformation output (MMBtu)
epccs(f,fi,v)                   Incremental energy consumption for CCS (subset of eptrf) per MMBtu of fuel transformation output (MMBtu)
fptrf(f,fi,v)                   Fuel consumption as feedstock per MMBtu of fuel transformation output (MMBtu)
htse_ratio                      Ratio of thermal energy input to electric input for high-temperature steam electrolysis
tph2(fi,v)		        Thermal energy input requirement for hydrogen production (elys-htse) (MMBtu per MMBtu H2 produced)
epbfs(f,bfs)                    Fuel (ammonia) consumption per MMBtu of biofeedstock (MMBtu)
nnrdpbfs(*,bfs)                 Non-road vehicle service demand per MMBtu of biofeedstock production (MMBtu)
emit_bfs(bfs,pol,t)             Emissions rate for biofeedstock production (kg non-CO2 per MMBtu)
emit_trf(fi,pol,v)              Emissions rate for fuel transformation technologies (tCO2 or kg non-CO2 per MMBtu output)
emit_h2(pol)                    Emissions rate for hydrogen combustion (kg non-CO2 per MMBtu)
cprt_trf(fi,v)                  Capture rate for fuel transformation (fraction of total input CO2)
capture_trf(fi,v)               Captured CO2 intensity for fuel transformation by output (tCO2 captured per MMBtu output)
capcost_trf(fi,v)               Capital cost for fuel transformation capacity ($ per thousand Btu per hour)
capcost_elys(tlc,fi,v)	        Capital cost for electrolysis ($ per thousand Btu per hour) (alternative scenarios)
fomcost_trf(fi,v)               Fixed O&M cost for fuel transformation capacity ($ per thousand Btu per hour per year)
vcost_trf(fi,v)                 Variable O&M cost for fuel transformation capacity ($ per MMBtu)
waterdraw_trf(fi)               Water withdrawal intensity for fuel transformation technologies (gallon per MMBtu output)
watercons_trf(fi)               Water consumption intensity for fuel transformation technologies (gallon per MMBtu output)
invlife_trf(fi)                 Investment life for fuel transformation technologies (years)
lifetime_trf(fi,r,t)            Lifetime coefficient by region for existing transformation sector capacity
bfspbfl(fi,v)                   Total bioenergy feedstock consumption per MMBtu of biofuel output (MMBtu)
cpsyn(fi,v)                     Carbon feedstock use per MMBtu of synthetic fuel output (tCO2)
ntxintl_f(f,t)                  Net international exports of non-electric fuels (TBtu per year)
pfadd_r(f,r,t)                  Regional average basis differential fuel price ($ per MMBtu)
fcost(fi,v,r,t)                 Exogenous variable operating cost for fuel transformation sectors ($ per MMBtu output)
;

* * * Distribution costs
parameter
dcost(f,kf,r,t)                 Average (levelized) cost of distribution of fuels to end-use sectors by region over time ($ per MMBtu)
dcost_kf(f,kf)	                Average (levelized) cost of distribution of fuels to end-use sectors ($ per MMBtu)
ftax(f,r)                       Fuel taxes by region (state and federal) ($ per MMBtu)
dcost_gas(kf,r)	                Levelized cost of pipeline gas distribution by region ($ per MMBtu)
dcost_dh2(kf,t)	                Final distribution (dispensing) of distributed hydrogen ($ per MMBtu)
dcost_cng                       Final distribution of CNG ($ per MMBtu)
rtl_q(r,sec)                    Retail quantities in 2015 (TWh)
rtl_p(r,sec)                    Retail prices (total) in 2015 ($ per MWh)
rtl_pg(r)                       Retail prices (generation component) in 2015 ($ per MWh)
rtl_ptd(r,sec)                  Retail prices (T&D component) in 2015 ($ per MWh)
rtl_ptd_end(tdcscen,r,sec,t)	T&D component of retail prices over time calculated in enduse model ($ per MWh)
tdcost_kf(r,kf,t)	        T&D component of retail price for end-use fuel sectors ($ per MWh)
;

* * * Fossil upstream parameters
parameter
pf_ups(f,r,t)                   Upstream price of fossil fuels ($ per MMBtu)
epups_fuels(f,r,f,r,t)          Regional energy (f1 r1) consumption for upstream production-refining of delivered fossil fuels (f2 r2) (MMBtu per MMBtu)
epups_rfp(f,r,f,r,t)            Regional energy (f1 r1) consumption for upstream refining of petroleum (f2 r2) (MMBtu per MMBtu)
epups_olg(f,r,f,r,t)            Regional energy (f1 r1) consumption for upstream production of oil and gas (f2 r2) (MMBtu per MMBtu)
upsprod_fuels(f,r,f,r,t)        Regional allocation (f1 r1) for upstream production-refining activity associated with delivered fossil fuels (f2 r2) (MMBtu per MMBtu)
capt_ups(f,r,t)			Capture rate for upstream (carbon captured as a percent of total carbon in upstream fuel consumption)
;

* * * Hydrogen infrastructure parameters
parameter
tcapcost_h(r,r)                 Capital cost of new hydrogen transmission capacity ($ per thousand Btu per hour) (blank for ineligible links)
tfomcost_h(r,r)                 Fixed O&M cost of hydrogen transmission capacity ($ per thousand Btu per hour per year) (blank for ineligible links)
tdcost_h(fi,v)		        Annual electric T&D cost for distributed electrolysis (scales with capacity) ($ per thousand Btu per hour)
eptrns_h(r,r,t)		        Electricity consumed for inter-region transmission of hydrogen (MMBtu per MMBtu)
capcost_gch(hk)		        Hydrogen storage door capital cost ($ per thousand Btu per hour charge capacity)
capcost_grh(hk)		        Hydrogen storage room capital cost ($ per thousand Btu of reservoir capacity)
epchrg_h(hk,t)		        Electricity consumed for hydrogen storage injection (MMBtu per MMBtu)
invlife_hg(hk)		        Investment life for hydrogen storage technologies
ghours_h(hk,r)                  Hours of hydrogen storage (room size relative to door size) if exogenously specified
hdcost(hk,kf)		        Distribution costs for hydrogen to end-use sectors ($ per MMBtu)
hdcost_trf		        Distribution costs for hydrogen to transformation sector (and blending) ($ per MMBtu)
blend_lim(f,f,*)                Upper bound on f1 as a part of blend f2 delivered to destination dst
;

* * * Bioenergy parameters
parameter
cc_bfs(bfs)		        CO2 content of biomass feedstocks (tCO2 per MMBtu)
credit_bio(bfs)	                Share of biomass feedstock carbon content credited as carbon-neutral
biocost(bfsc)                   Cost of biomass feedstock by supply class ($ per MMBtu)
biocap(bfs,bfsc,r,t)            Upper bound on biomass feedstock supply by class by region (TBtu)
croplim(r)                      Factor reduction in crop availability by supply step (if specified)
croplim_min(r)                  Minimum feasible factor reduction in crop availability by region
;

* * * Direct air capture parameters
parameter
af_dac(dac)		        Availability factor relative to nominal capacity for DAC
epdac(dacscn,f,dac,v)		Energy consumption per tCO2 net removal (MMBtu)
capcost_dac(dacscn,dac,v)       Capital cost of direct air capture ($ per net tCO2 removed per year)
fomcost_dac(dacscn,dac,v)       Fixed O&M cost for transformation capacity ($ per tCO2) 
vcost_dac(dac,v)	        Variable O&M cost for direct air capture ($ per net tCO2 removed)
waterdraw_dac(dac)              Water withdrawal intensity for DAC technologies (gallon per net tCO2 removed)
watercons_dac(dac)              Water consumption intensity for DAC technologies (gallon per net tCO2 removed)
capture_dac(dacscn,dac,v)       Captured CO2 intensity of DAC (gross captured tCO2 per net tCO2 removed)
invlife_dac(dac)	        Investment life for DAC technologies (years)
daccost(dac,v,r,t)	        Variable operating cost for DAC ($ per net tCO2 removed)
;

* * * CO2 transport and storage parameters
parameter
capcost_pc(co2trscn,r,r)        Capital cost for inter-regional CO2 pipeline capacity ($ per tCO2 per year) 
fomcost_pc(co2trscn,r,r)        Fixed O&M cost for inter-regional CO2 pipeline capacity ($ per tCO2)
co2pcap(co2trscn,i,v,r)         Additional plant capital cost of within-region CO2 pipeline for electric generation ($ per kW)
co2pfom(co2trscn,i,r)           Additional plant FOM cost of within-region CO2 pipeline for electric generation ($ per kW)
co2pcap_trf(co2trscn,fi,v)      Additional plant capital cost of within-region CO2 pipeline for fuel transformation ($ per thousand Btu per hour)
co2pfom_trf(co2trscn,fi,v)      Additional plant FOM cost of within-region CO2 pipeline for fuel transformation ($ per thousand Btu per hour per year)
co2pcap_dac(co2trscn,dac,v)	Additional plant capital cost of within-region CO2 pipeline for DAC ($ per net tCO2 removed per year)
co2pfom_dac(co2trscn,dac,v)	Additional plant FOM cost of within-region CO2 pipeline for DAC ($ per net tCO2 removed per year)
injcap(cstorscen,cstorclass,r)  CO2 storage capacity in each region (GtCO2)
capcost_inj(cstorscen,cstorclass,r) Capital cost for CO2 injection capacity ($ per tCO2 per year)
fomcost_inj(cstorscen,cstorclass,r) Fixed O&M cost for CO2 injection capacity ($ per tCO2) 
vcost_inj(r)                    Variable O&M cost of CO2 injection ($ per tCO2)
epco2trn(f,r,r)                 Energy consumption for inter-regional CO2 pipeline transmission (MMBtu per tCO2)
epco2inj(f)                     Energy consumption for CO2 injection (MMBtu per tCO2)
;

* * * Carbon management parameters
parameter
ncrcost(ncr)                    Natural carbon removal cost by supply step ($ per tCO2)
ncrcap(ncr,t)                   Upper bound on natural carbon removal supply steps (MtCO2)
cc_ff(f)                        CO2 content of all fossil fuels (primary and secondary (tCO2 per MMBtu)
ch4_rate(f,t)                   Methane emissions associated with primary and delivered fuel supply (tCO2-e per MMBtu)
;

* * * End-use sector parameters
* Medium- and Heavy-Duty (MD-HD) on-road vehicles and non-road vehicles in both transport and industrial sectors
parameter
mdhd0(vc,vht,v_e,r)             Base year vehicle stock for MD-HD vehicles (millions of vehicles)
nnrd0(vc,vht,v_e,r)             Base year services for non-road vehicles
mdhd_tot(vc,r,t)                Total projected vehicle stock for MD-HD vehicles (millions of vehicles)
nnrd_tot(vc,r,t)                Total projected service levels for non-road vehicles
vmti(vc)                        Annual vehicle miles per MD-HD vehicle (in reality depends on age) (thousands)
vom(vc,vht,v_e)                 Variable operating and maintenance cost for MD-HD and non-road vehicles over time ($ per vehicle-mile)
epvmt_r(vc,vht,f,r,v_e,t)       MD-HD Energy consumption per vmt adjusted for regional climate (mmtbu per thousand miles)
epsrv_r(vc,vht,f,r,v_e,t)       Non-Road vehicles Energy consumption per service unit adjusted for regional climate (mmtbu per year)
vt_life_mdhd(v_e,t_all)         Vehicle lifetime profile indexed to first year of vintage for all MD-HD vehicles
vt_life(vc,v_e,t_all)           Vehicle lifetime profile indexed to first year of vintage by vehicle class
invlife_eu                      Fixed vehicle lifetime (proxy for calculating crf)
di_shr(vc,di)	                Share of MD-HD vehicles across driving intensity classes
di_vmt(vc,di)                   Relative vmt per MD-HD vehicle across driving intensity classes
newcap_cost(vc,vht,r,t)         Total up-front cost per MD-HD vehicle or non-road service unit ($000)
refuel_cost(vc,vht,r,t)         Up-front cost per MD-HD vehicle or non-road service unit for re-fueling infrastructure ($000)
refuel_cost_mdhd(vc,vht,t)      Up-front cost per MD-HD vehicle for re-fueling infrastructure ($000)
refuel_cost_nnrd(vc,vht,t)	Levelized cost per MMBtu for non-road vehicle re-fueling infrastructure ($ per MMBtu)
annual_cost_mdhd(vc,vht,v_e,di,r,t)     Annual operating operating costs for MD-HD vehicles ($ thousands per vehicle)
annual_cost_nnrd(vc,vht,v_e,r,t)        Annual operating operating costs for non-road vehicles ($ thousands per vehicle)
crf_nnrd(vc)                    Annualized capital recovery factor for non-road vehicles classes
mdhd_fuel_r(*,f,r,t)            Realized MD-HD Fuel use by region (TBtu per year)
nnrd_fuel_r(*,vc,f,r,t)	        Realized Non-road Fuel use by region and vehicle class (TBtu per year)
* End-use model aggregate reporting parameters
qdr_tot_x(k2,u,df,r,t_all)      Regional total quantity of delivered fuel demanded by sector and end-use (with exogenous MD-HD and non-road) (TBtu)
qd_enduse_non(kf,*,r,t)         Non-energy end use (TBtu)
bio_ex(r,t)                     Exogenous industrial biomass (TBtu per year)
newhp_ele(k2,r,t)               Estimated electricity use for space heating from new vintage heat pumps (TBtu)
sindex(k2,u,r,t_all)            Service demand indexed growth for all end uses
eindex(k2,u,r,t_all)            Energy per service unit indexed path for all end uses
eff_scen(k2,u,r,t)              Endogenous efficiency (reduction from baseline)
ind_ccs_ele(r,t)                Electricity use for industrial CCS (TBtu)
fueluse_ind_ccs(*,r,t)          Industrial fuel use with CCS (TBtu)
co2_capt_proc(r,t)              Captured process CO2 emissions by region (MtCO2)
co2_capt_full(*,*,*,r,t)        Full report on CCS technology capacity output and captured CO2 (capacity output and MtCO2)
gascap_eu(*,*,t)                End-use sectors total input gas capacity (buildings and industry) (BBtu per hour)
h2cap_eu(*,*,t)                 Hydrogen use input capacity in end-use sectors (buildings and industry) (BBtu per hour)
ldvrescom_shr(kf,r,t)           Share of personal light-duty vehicle charging between residential and commercial
expend_ldvpubchrg(r,t)          Expenditure on public charging infrastructure for personal light-duty vehicles ($B per year)
hu_total(r,t)                   Number of households (millions)
;

* * * Demand parameters
parameter
hours(s,t)                      Number of hours per load segment (weights that sum to 8760 across segments)
p_ssm(s,s,t)                    Transition probability for state space matrix approximating hourly chronology across load segments
pstay(*,s,t)                    Probability of remaining in same state (representative hour) across hourly chronology
load(s,r,t)                     Load across segments including both retail and self-supplied (GW)
load_h(h,r,t)                   Load in all hours (retail and self-supplied) (GW)
load_ldv(s,r,t)                 Light-duty vehicle charging load in each segment (GW)
load_kf(s,kf,r,t)		Sector-level end-use load profiles (index relative to annual average hourly load)
load_flx(s,flx,r,t)             Potentially flexible end-use load by category (including data center load) (GW)
* Certain categories of load may be flexible (i.e. endogenous allocation across dispatch segments)
flex_twh(flx,r,t)               Target annual load from flexible demand categories (TWh)
flex_gw(flx,r,t)                Exogenous endowment of flexible demand capacity (GW)
caprent_flx(flx)                Marginal rental cost for increased flexible demand capacity ($ per kW-year)
twh_h(r,t)                      Total TWh load from hourly enduse loadshapes
twh_s(r,t)                      Total TWh load based on current segments
localloss                       Losses within regions between generation and delivery (one plus percentage)
drcost(r)                       Demand response (backstop demand) cost ($ per MWh)
drccost(r)                      Cost to curtail distributed resources (negative demand response) ($ per MWh)
monthdays(m)                    Days per month /1 31,2 28,3 31,4 30,5 31,6 30,7 31,8 31,9 30,10 31,11 30,12 31/
;

* * * * * Inputs from end-use model
parameter
netder(s,r,t)                   Net power supply from distributed resources (GW)
selfgen(r,t)                    Total annual electricity supply from industrial co-gen (if included in demand) (TWh)
rfpv_out(s,r,t)                 Power output from rooftop PV by segment (GW)
rfpv_twh(r,t)                   Total annual energy supplied by rooftop PV (TWh)
rfpv_gw(r,t)                    Installed capacity rooftop PV (GW)
qd_enduse(f,r,t)                Exogenous annual demand for fuels total in enduse sectors (TBtu per year)
qd_enduse_kf(kf,f,r,t)          Exogenous annual demand for fuels by enduse sector (TBtu per year)
load_gkw(kf,f,r,w,t)            Weekly buildings gas demand (TBtu per week)
qd_ppg_nele(w,r,t)              Total pipeline gas demand for end-use sectors (TBtu per week)
co2_capt_ind(r,t)               Exogenous flow of captured CO2 from industrial sectors (reported by fuel) (MtCO2)
co2_proc_ind(r,t)               Exogenous CO2 emissions from industrial processes (before capture) (MtCO2)
co2_fne(kf,r,t)                 Exogenous CO2 fixed in non-energy products (reported by sector) (MtCO2)
co2_resid(*,*,t)                CO2 emissions associated with end-use fuel demands that cannot be reduced in fuels model (MtCO2)
;

* * * Policy parameters
* Some policy constraints are included by default, others are activated with scenario switch
parameter
ptc_type(type,f,v)              IRA 45Y Production Tax Credit by electric generation type ($ per MWh)
ptc(i,f,v)                      IRA 45Y Production Tax Credit for electric technologies ($ per MWh)
itc_type(type,v)                IRA 48E Investment Tax Credit by electric generation type (fraction of capital cost)
itc(i,v)	                IRA 48E Investment Tax Credit for electric technologies (fraction of capital cost)
itc_j(j,v)	                IRA 48E Investment Tax Credit for storage technologies (fraction of capital cost)
itcval(i,v,r)                   Value of IRA 48E Investment Tax Credit to specific technologies ($ per kW subsidy)
co2cred(v,t_all)                IRA 45Q credit in each time period and vintage (base credit for point-source capture) ($ per tCO2)
ccs45Q(i,v,f,r,t)               IRA 45Q credit for captured CO2 for electric technologies normalized to output ($ per MWh)
ccs45Q_c(i,v,v,f,r,t)           IRA 45Q credit for captured CO2 for electric technology conversions normalized to output ($ per MWh)
ccs45Q_trf(fi,v,t)	        IRA 45Q credit for captured CO2 for fuel transformation technologies normalized to output ($ per MMBtu)
ccu45Q_trf(fi,v,t)	        IRA 45Q credit adjustment for utilized CO2 in synthetic fuels (negative) ($ per MMBtu)
ccs45Q_dac(dac,v,t)	        IRA 45Q for captured CO2 for direct air capture technologies normalized to output ($ per net tCO2 removed)
ptc_h(fi,v)		        IRA 45V Production Tax Credit for qualified electrolytic hydrogen production ($ per MMBtu output)
nuczec(r,t)                     Nuclear capacity with state policy support (GW)
newunits(type,r,t)              Expected (required) new capacity additions (GW)
newunits_j(j,r,t)               Expected (required) new battery storage capacity additions (GW)
pp(pol,t)                       Pollutant prices (exogenous) ($ per metric tonne)
pp_rg(pol,r,t)                  Regional pollutant prices (exogenous) ($ per metric tonne)
ctax_econ(t)			National economy-wide CO2 tax ($ per tCO2)
ctax_econ_r(r,t)		Regional economy-wide CO2 tax ($ per tCO2)
ctax_kr(*,r,t)                  Region and sector level CO2 tax ($ per tCO2)
ch4tax(r,t)                     CO2-equivalent tax applied to energy-related methane ($ per tCO2-eq)
co2cap(t_all,*)                 Economy-wide carbon emissions cap (MtCO2)
co2eqcap(t_all,*)               Economy-wide GHG emissions cap (MtCO2-e)
co2cap_rg(r,t,*)                Regional economy-wide carbon emissions cap (MtCO2)
co2cap_ele(t_all,*)             Carbon emissions cap for direct electric sector (MtCO2)
svpr(t,*)                       Safety valve emissions price for alternative compliance payments (if specified) ($ per tCO2)
co2_bld0(r)                     Benchmark direct buildings carbon emissions in 2005 (MtCO2)
direct_bld(r,t)                 Policy constraint on direct buildings emissions as a fraction of 2005 benchmark
co2_ind0(r)                     Benchmark direct industry carbon emissions in 2005 (MtCO2)
direct_ind(r,t)                 Policy constraint on direct industry emissions as a fraction of 2005 benchmark
co2_trn0(r)                     Benchmark direct transportation carbon emissions in 2005 (MtCO2)
direct_trn(r,t)                 Policy constraint on direct transportation emissions as a fraction of 2005 benchmark
sectorcap(t)                    Regional end-use sector direct CO2 cap as a fraction of base year emissions
sectorcap_min(*,r,t)            Minimum feasible reduction as a share of base year for sector CO2
csaprbudget(trdprg,pol,r,t,*)   CSAPR regional budgets for annual and seasonal non-CO2 emissions (Mt)
csaprcap(trdprg,pol,r,t,*)      CSAPR regional assurance levels for annual and seasonal non-CO2 emissions (Mt)
ozsadj_r(r,t)                   Adjustment for segment-approximated length of ozone season relative to actual length by region
csapradj_s(trdprg,r,t)          CSAPR segment-approximation adjustment of cap
rps(i,f,r,*)                    Technologies-fuels that contribute towards RPS
rpstgt(t,*)                     Federal RPS targets
rpstgt_r(r,t)                   State and regional level RPS targets
rcmlim_r(r,t)                   Total state-regional RPS compliance import limits (pct of RPS target)
rcmlim(r,t)                     Total state-regional RPS compliance import limits (TWh)
nmrlim_r(r,t)                   Unbundled REC import limits for state-regional RPS compliance (pct of RPS target)
nmrlim(r,t)                     Unbundled REC import limits for state-regional RPS compliance (TWh)
acplim_r(r)                     Alternative compliance payment limits (pct of RPS target)
acplim(r,t)                     Alternative compliance payment limits (TWh)
acpcost(r)                      Price of alternative compliance payment ($ per MWh)
soltgt_r(r,t)                   Solar energy mandated by regional solar carve-outs (pct of total energy)
soltgt(r,t)                     Solar energy mandated by regional solar carve-outs (TWh)
canhyd_r(r)                     Exogenous supply of RECs for state-regional RPS compliance from Canadian hydro (TWh)
wnostgt_r(r,t)                  Offshore wind capacity level required by state policy mandate (GW)
batttgt_r(r,t)                  Battery storage GW capacity level required by state policy mandate (GW)
ces(i,v,f,r,*)                  Contribution toward Clean Energy Standard for standard units (credits per MWh)
ces_c(i,v,v,f,r,*)              Contribution toward Clean Energy Standard for converted units (credits per MWh)
ces_oth(*,r,*)                  Contribution of other technologies to Clean Energy Standard (%)
cestgt(t,*)                     Clean Energy Standard Target (single federal target) (% of generation)
cestgt_r(r,t,*)                 Regional CES Targets under a federal policy
cesbase_r(r,*)                  Regional base level of clean energy for CES target on incremental energy (TWh)
cesacpr(t,*)                    CES Alternative Compliance Payment price ($ per MWh)
cestax(i,v,f,r,t)               Implicit tax or subsidy representing a CES ($ per MWh)
cestax_c(i,v,v,f,r,t)           Implicit tax or subsidy representing a CES for converted units ($ per MWh)
sb100tgt(t)                     California SB-100 clean electricity standard targets
sb100impcost(t)                 California SB-100 cost on unspecified imports ($ per MWh)
sb100i(i,f,r)                   Contribution toward SB-100 (in-state resources)
sb100enh(i,r)                   Eligible clean electricity for California SB-100 from existing nuclear and hydro in neighboring states
caab32(t)                       California AB32 economy-wide CO2 target (GtCO2)
nys6599_ele(t)                  New York electric sector CO2 target (GtCO2)
nys6599(t)                      New York economy-wide CO2 target (GtCO2)
rggicap(t)                      Joint carbon cap for Regional Greenhouse Gas Initiative (RGGI) regions (GtCO2)
usemitref(pol,t)                Emissions from reference run (only populated when fixIX and ets turned on) (Mt)
;

* * * Reserve requirements
parameter
rsvmarg(r)                      Planning reserve margin by region
rsvcc(i,r)                      Planning reserve margin capacity credit
rsvoth(r)                       Out of region capacity that counts towards a regions planning reserve margin (GW)
;

* * * Operating reserves
parameter
ramprate(i)                     Limit to spinning reserve provision - set at percentage of nameplate capacity
orfrac                          Fraction of operating reserve requirement spinning vs quick-start
orreq_ld                        Operating reserve requirement on load (fixed percentage)
orreq_vr                        Operating reserve requirement on variable resources (fixed percentage)
orcost(type)                    Cost of providing reserves for generation ($ per MWh)
orcostg(j)                      Cost of providing reserves for storage ($ per MWh)
;

* * * Discounting parameters
parameter
nyrs(t_all)                     Number of years since last time step
tk                              Capital tax rate /%tk%/
drate                           Annual discount rate /%drate%/
dfact(t_all)                    Discount factor for time period t (reflects number of years)
cappr_i(i,r,t)		        Price of capital for generation investments (new) in objective function
cappr_c(i,v,r,t)	        Price of captial for generation conversion investments in objective function
cappr_g(j,r,t)		        Price of capital for storage investments in objective function
cappr_hg(hk,r,t)	        Price of capital for hydrogen storage investments in objective function
cappr_inf(r,t)		        Price of capital for infrastructure investments in objective function
cappr_trf(fi,r,t)	        Price of capital for hydrogen production investments in objective function
cappr_dac(dac,r,t)	        Price of capital for direct air capture investments in objective function
cappr_eu(vc,r,t)                Price of capital for MD-HD and non-road vehicle investments
crf(i)			        Annual capital recovery factor for generation investments (new)
crf_c(i,v)		        Annual captial recovery factor for conversion investments
crf_g(j)		        Annual capital recovery factor for storage investments
crf_hg(hk)		        Annual capital recovery factor for hydrogen storage investments
crf_trf(fi)		        Annual capital recovery factor for hydrogen production investments
crf_dac(dac)		        Annual capital recovery factor for direct air capture investments
crf_eu(vc)                      Annual capital recovery factor for MD-HD and non-road vehicle investments
modlife(i,t)                    Fraction of generation investment (new) lifetime remaining in model
modlife_c(i,v,r,t)              Fraction of generation conversion investment lifetime remaining in model
modlife_ptc(v)                  Fraction of production subsidy eligibility period remaining in model
modlife_45q(v)                  Fraction of 45Q subsidy eligibility period remaining in model
modlife_g(j,t)		        Fraction of storage investment lifetime remaining in model
modlife_hg(hk,t)                Fraction of hydrogen storage investment lifetime remaining in model
modlife_inf(t)		        Fraction of infrastructure investment lifetime remaining in model
modlife_trf(fi,t)               Fraction of fuel transformation investment lifetime remaining in model
modlife_dac(dac,t)	        Fraction of direct air capture investment lifetime remaining in model
modlife_eu(vc,t)                Fraction of generation investment (new) lifetime remaining in model for MD-HD and non-road vehicles
;


* Load parameters (except those that depend on the number of segments)

$gdxin %elecdata%\elecgen_data
$load ifuel, caplim, convlim, invlife, vrsc_t
$load invlim, usinvlim, tusinvlim, tcap, gcap, convadj, ncl, gdpdef
$load pf_alt, co2cap, co2eqcap, co2cap_ele, co2cap_rg, sectorcap, csaprbudget, csaprcap, pp, pp_rg, svpr, tcost, tcapcost, tgrow, tlinelen, trnspen, xdr, xkr
$load rps, rpstgt, rpstgt_r, rcmlim_r, nmrlim_r, acplim_r, acpcost, soltgt_r, wnostgt_r, batttgt_r,
$load canhyd_r, ces, ces_c, cesacpr, cestgt, cestgt_r, cesbase_r, ces_oth, rsvcc
$load ramprate, orfrac, orreq_ld, orreq_vr, orcost, orcostg
$ifi not %ira%==no $load ptc_type,itc_type
$ifi     %ira%==no $load ptc_type=ptc_type_2022,itc_type=itc_type_2022
$load itc_j,rggicap
$load solarcap, cspwt, pfadd, pfadd_r, vcost, vcost_c, waterdraw, watercons, caprent_flx, drccost
$load ic_csp_cr, irg_csp, csp_cost_r, csp_cost_c, csp_eff_p, csp_eff_c, csp_eff_r, csp_loss_g
$load htrate=htrate_%htrate%, htrate_c=htrate_%htrate%c, htrate_m, emit=emit_%htrate%, emit_c=emit_%htrate%c, capture=capture_%htrate%, capture_c=capture_%htrate%c 
$load capcost, capcost_rnw, capcost_gc, capcost_gr, fomcost, lifetime, lifetime_nuc60, lifetime_coal, convertgas, convertbio, tcostadder
$load lifetime_nucnz60
$load xcap, uscoal20_gw
$load fomcost_g, ghours, chrgpen, loss_g, loss_d, htrate_g, invlife_g
$load ntxintl, af_m, cf_y, localloss cumuprates, cumuprates_nuc60, hydadj, acf_h
$load caprate, co2pcap, co2pfom, co2cred
$load sb100i, sb100impcost, sb100tgt, sb100enh, caab32, nys6599_ele, nys6599, nuczec, newunits, newunits_j
$load rtl_q, rtl_p, rtl_pg, rtl_ptd
$gdxin

* Read in parameters for transformation fuels and hydrogen
$gdxin %elecdata%\h2fuels_data
$load fimap, fc0, convadj_fi, af_trf, eptrf, epccs, fptrf, htse_ratio, tph2, epbfs, nnrdpbfs, cpsyn, bfspbfl, emit_bfs, emit_trf, emit_h2, cprt_trf, capture_trf, lifetime_trf, epups_fuels, epups_rfp, epups_olg, upsprod_fuels
$load vcost_trf, waterdraw_trf, watercons_trf, capcost_trf, capcost_elys, fomcost_trf, invlife_trf, ptc_h
$load co2pcap_trf, co2pfom_trf, tcapcost_h, tfomcost_h, tdcost_h, eptrns_h, capcost_gch, capcost_grh, epchrg_h, invlife_hg, ghours_h, hdcost, blend_lim
$load capcost_pc, fomcost_pc, capcost_inj, fomcost_inj, vcost_inj, injcap, epco2trn, epco2inj, dcost_kf, ftax, dcost_gas, dcost_cng, dcost_dh2
$load af_dac, vcost_dac, waterdraw_dac, watercons_dac, fomcost_dac, capcost_dac, epdac, capture_dac, invlife_dac, co2pcap_dac, co2pfom_dac
$load ncrcost, ncrcap, co2_bld0, co2_ind0, co2_trn0, ch4_rate, cc_ff, cc_bfs, credit_bio
$load biocost, biocap, croplim_min, invlife_eu
$gdxin

* <><><><><><><><><><><><><>
* regen_parameters.gms <end>
* <><><><><><><><><><><><><>
