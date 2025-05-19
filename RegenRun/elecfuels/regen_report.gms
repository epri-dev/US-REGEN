* ----------------------
* regen_report.gms
* ----------------------
* REGEN Electric+Fuels Model
* Reporting parameters (run as a separate file)

* Show execution time and memory usage by statement in lst file
option profile = 1;
* Show environment variables in lst file
$show
* Cause dollar statements to appear in lst file
$ondollar
* Set EOL comment indicator to the default of !!
$oneolcom
* Set global directory names
$include %sysenv.runutil%\setglobals.gms
* Set code version (do not use '.' in the version name)
$set codeversion 20250201
* Set titles (loopmode, scen, iter, defined in setglobals.gms)
$iftheni.title %loopmode%==yes
$set titlelead "Iter %iter% %scen% electric model report"
$else.title
$set titlelead "Standalone %scen% electric model report"
$endif.title
* Set default switch values
$include regen_defaults.gms
* Set name for report output
$setglobal rptgdx %elecrpt%\%scen%_it%iter%.elec_rpt

$ifthen set replace_output
execute_unload '%elecout%\%scen%_it%iter%.elec.gdx';
$exit
$endif

set
xrrpt(rpt,r)            Alias of xrpt
dummy_miso              Dummy declaration of MISO regions /MISO-East,MISO-North,MISO-South/
miso_r(r)               Regions comprising MISO
xbio(i)                 Existing biomass capacity blocks /bioe-x,othc-x/
grc                     Graphical reporting category labels (full text versions of xr and kr) /
                        "Existing Nuclear"
                        "New Nuclear"
                        "New Nuclear (Advanced)"
                        "Geothermal"
                        "Other Combustion"
                        "Hydro (Conventional)"
                        "Bioenergy"
                        "Bioenergy (with CC)"
                        "Existing Coal"
                        "New Coal"
                        "Coal (with CC)"
                        "Existing NGCC"
                        "New NNGC"
                        "NNGC (with CC)"
                        "Existing Gas Steam and CT"
                        "New Gas CT"
                        "Existing Oil Peakers"
                        "New Dual-Fuel"
                        "New Dual-Fuel (gas)"
                        "New Dual-Fuel (liquid)"
                        "New Dual-Fuel (H2)"
                        "New Dedicated H2"
                        "Existing Wind"
                        "New Wind (On-shore)"
                        "New Wind (Off-shore)"
                        "Existing Solar PV"
                        "New Solar PV"
                        "Existing Solar CSP"
                        "New Solar CSP"
                        "Storage (gross discharge)"
                        "Distributed Solar PV"
                        "Self Generation"
                        "Net Imports"
                        "Total Energy for Load"
                        "Energy for End-Use Load"
                        "Storage (gross charge)"
                        "Energy for H2 Production"
                        "Other Intermediate Use"
                        "Import Capacity"
                        "Peak End-Use Load"
                        /
cdcat                   Coal disposition categories for reporting
                        /1max,2asis,3cofr,4cofr-pen,5cgas,6cgas-pen,7cbio,8cbio-pen,9cccs,10cccs-pen,11early,12age/
nonretcdc(cdcat)        Coal disposition categories excluding maximum allowable to calculate retirements
                        /2asis,3cofr,4cofr-pen,5cgas,6cgas-pen,7cbio,8cbio-pen,9cccs,10cccs-pen/
xcapmodes               Modes of existing capacity (everything but asis applies only to coal)
                        /asis, cofr, cgas, cbio, ccs, retired/
xcapmap(xcapmodes,i,i)  Map from existing capacity to converted block by xcapmodes
xcapv(xcapmodes,v)      Applicable vintages for xcapmodes
pkgrid_s(s,r,t)         Segment in which residual peak occurs (reserve margin is binding)
ed                      Electricity Demand Categories /
                        01-Ex-Bld       Existing Building Uses
                        02-Ex-Ind       Existing Industrial Uses
                        03-Data         Data Centers
                        04-New-HP       New Building Uses (electrification of space and water heating)
                        05-New-Ind-E    New industrial Uses (electrification and CCS LCF)
                        06-LDV          Light-duty vehicles
                        07-MDHD         Medium- and heavy-duty transport
                        08-Elys         Electrolysis (for direct and indirect use as fuel)
                        /
* Sankey diagram sets
sfl_ind         Sankey flow index to ensure consistent ordering of output to Excel /1*92/
sankey_node     Sankey Diagram Nodes /
* Primary nodes (source only)
"Renewables"
"Nuclear"
"Coal"
"Natural Gas"
"Bioenergy"
"Petroleum"
"Distributed Solar"
* Conversion, trade, and blending nodes
* Imports are source only; exports are sink only
* Other nodes should balance to zero, or imbalance reflects losses
"Thermal Gen"
"Net Imports (Ele)"
"Electricity"
"Net Exports (Ele)"
"Bio-Refining"
"Net Imports (Biof)"
"Biof Disp"
"Net Exports (Biof)"
"Petroleum Refining"
"Net Imports (RFP)"
"Petroleum Disp"
"Net Exports (RFP)"
"Hydrogen Sup"
"Net Imports (H2)"
"Hydrogen Disp"
"Net Exports (H2)"
"Ammonia Sup"
"Net Imports (NH3)"
"Ammonia Disp"
"Net Exports (NH3)"
"Synfuels Sup"
"Net Imports (Syn)"
"Synfuels Disp"
"Net Exports (Syn)"
"Pipeline Gas"
"Liquid Fuels"
* End-use nodes (sink only)
"Upstream (Coal)"
"Upstream (Ele)"
"DAC (Ele)"
"Upstream (RFP)"
"Non-Energy (RFP)"
"Upstream (H2)"
"Non-Energy (H2)"
"Non-Energy (NH3)"
"Upstream (Gas)"
"DAC (Gas)"
"Upstream (Liq)"
"Buildings"
"Industry"
"Transportation"
/
sankey_node_bal(sankey_node)  Sankey nodes for which we should check the balance /
* Nodes with losses
"Thermal Gen","Electricity","Bio-Refining","Petroleum Refining","Hydrogen Sup","Ammonia Sup","Synfuels Sup"
* Nodes that should balance exactly
"Biof Disp","Petroleum Disp","Hydrogen Disp","Ammonia Disp","Synfuels Disp","Pipeline Gas","Liquid Fuels"
/
sankey_flow   Sankey Diagram Flows /
* Primary electric
wind, solar, hydro, geot, nuclear
* Primary non-electric
coal, coal+CC, gas, gas+CC, bio, bio+CC, petro
* Secondary
ele, pgas, pgas+CC, biof, rfp, liq, h2, nh3, synf
/
sankey_diagram(sfl_ind,sankey_node,sankey_node,sankey_flow) Layout of Sankey diagram inputs/
        "1"."Renewables"."Electricity"."wind"
        "2"."Renewables"."Electricity"."solar"
        "3"."Renewables"."Electricity"."hydro"
        "4"."Renewables"."Electricity"."geot"
        "5"."Nuclear"."Thermal Gen"."nuclear"
        "6"."Coal"."Thermal Gen"."coal"
        "7"."Coal"."Thermal Gen"."coal+CC"
        "8"."Pipeline Gas"."Thermal Gen"."pgas"
        "9"."Pipeline Gas"."Thermal Gen"."pgas+CC"
        "10"."Bioenergy"."Thermal Gen"."bio"
        "11"."Bioenergy"."Thermal Gen"."bio+CC"
        "12"."Hydrogen Disp"."Thermal Gen"."h2"
        "13"."Liquid Fuels"."Thermal Gen"."liq"
        "14"."Thermal Gen"."Electricity"."nuclear"
        "15"."Thermal Gen"."Electricity"."coal"
        "16"."Thermal Gen"."Electricity"."coal+CC"
        "17"."Thermal Gen"."Electricity"."pgas"
        "18"."Thermal Gen"."Electricity"."pgas+CC"
        "19"."Thermal Gen"."Electricity"."bio"
        "20"."Thermal Gen"."Electricity"."bio+CC"
        "21"."Thermal Gen"."Electricity"."h2"
        "22"."Thermal Gen"."Electricity"."liq"
        "23"."Net Imports (Ele)"."Electricity"."ele"
        "24"."Electricity"."Hydrogen Sup"."ele"
        "25"."Nuclear"."Hydrogen Sup"."nuclear"
        "26"."Coal"."Hydrogen Sup"."coal"
        "27"."Coal"."Hydrogen Sup"."coal+CC"
        "28"."Natural Gas"."Hydrogen Sup"."gas"
        "29"."Natural Gas"."Hydrogen Sup"."gas+CC"
        "30"."Bioenergy"."Hydrogen Sup"."bio"
        "31"."Bioenergy"."Hydrogen Sup"."bio+CC"
        "32"."Hydrogen Sup"."Hydrogen Disp"."h2"
        "33"."Net Imports (H2)"."Hydrogen Disp"."h2"
        "34"."Coal"."Industry"."coal"
        "35"."Coal"."Industry"."coal+CC"
        "36"."Coal"."Upstream (Coal)"."coal"
        "37"."Natural Gas"."Pipeline Gas"."gas"
        "38"."Bioenergy"."Buildings"."bio"
        "39"."Bioenergy"."Industry"."bio"
        "40"."Bioenergy"."Industry"."bio+CC"
        "41"."Bioenergy"."Bio-refining"."bio"
        "42"."Bioenergy"."Bio-refining"."bio+CC"
        "43"."Bio-refining"."Biof Disp"."biof"
        "44"."Net Imports (Biof)"."Biof Disp"."biof"
        "45"."Biof Disp"."Pipeline Gas"."biof"
        "46"."Biof Disp"."Liquid Fuels"."biof"
        "47"."Biof Disp"."Net Exports (Biof)"."biof"
        "48"."Petroleum"."Petroleum Refining"."petro"
        "49"."Petroleum Refining"."Petroleum Disp"."rfp"
        "50"."Net Imports (RFP)"."Petroleum Disp"."rfp"
        "51"."Petroleum Disp"."Liquid Fuels"."rfp"
        "52"."Petroleum Disp"."Upstream (RFP)"."rfp"
        "53"."Petroleum Disp"."Non-Energy (RFP)"."rfp"
        "54"."Petroleum Disp"."Net Exports (RFP)"."rfp"
        "55"."Electricity"."Net Exports (Ele)"."ele"
        "56"."Electricity"."Upstream (Ele)"."ele"
        "57"."Electricity"."DAC (Ele)"."ele"
        "58"."Distributed Solar"."buildings"."solar"
        "59"."Electricity"."Buildings"."ele"
        "60"."Electricity"."Industry"."ele"
        "61"."Electricity"."Transportation"."ele"
        "62"."Hydrogen Disp"."Net Exports (H2)"."h2"
        "63"."Hydrogen Disp"."Ammonia Sup"."h2"
        "64"."Hydrogen Disp"."Upstream (H2)"."h2"
        "65"."Hydrogen Disp"."Non-Energy (H2)"."h2"
        "66"."Hydrogen Disp"."Pipeline Gas"."h2"
        "67"."Hydrogen Disp"."Synfuels Sup"."h2"
        "68"."Hydrogen Disp"."Buildings"."h2"
        "69"."Hydrogen Disp"."Industry"."h2"
        "70"."Hydrogen Disp"."Transportation"."h2"
        "71"."Ammonia Sup"."Ammonia Disp"."nh3"
        "72"."Net Imports (NH3)"."Ammonia Disp"."nh3"
        "73"."Ammonia Disp"."Net Exports (NH3)"."nh3"
        "74"."Ammonia Disp"."Industry"."nh3"
        "75"."Ammonia Disp"."Transportation"."nh3"
        "76"."Ammonia Disp"."Non-Energy (NH3)"."nh3"
        "77"."Synfuels Sup"."Synfuels Disp"."synf"
        "78"."Net Imports (Syn)"."Synfuels Disp"."synf"
        "79"."Synfuels Disp"."Pipeline Gas"."synf"
        "80"."Synfuels Disp"."Liquid Fuels"."synf"
        "81"."Synfuels Disp"."Net Exports (Syn)"."synf"
        "82"."Pipeline Gas"."Buildings"."pgas"
        "83"."Pipeline Gas"."Industry"."pgas"
        "84"."Pipeline Gas"."Industry"."pgas+CC"
        "85"."Pipeline Gas"."Transportation"."pgas"
        "86"."Pipeline Gas"."Upstream (Gas)"."pgas"
        "87"."Pipeline Gas"."Upstream (Gas)"."pgas+CC"
        "88"."Pipeline Gas"."DAC (Gas)"."pgas+CC"
        "89"."Liquid Fuels"."Buildings"."liq"
        "90"."Liquid Fuels"."Industry"."liq"
        "91"."Liquid Fuels"."Transportation"."liq"
        "92"."Liquid Fuels"."Upstream (Liq)"."liq"
/
supdem /Supply,Demand/
supdem_h2 /"SMR (gas)","SMR (gas)+CCS","Bio-H2","Bio-H2+CCS","Electrolysis","Total Production","Hydrogen Net Imports"/
supdem_ppg /"NG to H2/NH3 vis SMR","NG Blend","RNG Blend","SNG Blend","Hydrogen Blend","H2/NH3 via SMR","Power","Buildings","Industry","Transportation","Upstream/DAC"/
supdem_bio /"Waste Methane","Cellulosic Residues","Cellulosic Energy Crops and Logs","Corn for Ethanol","Biofuel Net Imports","Conventional Ethanol","Cellulosic Liquid Fuels","Biofuel Net Exports","RNG","Bio-H2","Buildings","Industry","Thermal Gen"/
finalsec /"Buildings","Industry","Transportation","Total"/
finalfuel /"Coal","Coal+CCS","Biomass","Biomass+CCS","Liquid Fuels","Pipeline Gas","Pipeline Gas+CCS","Hydrogen","Ammonia","Electricity"/
;

alias(i,ii);
alias(rpt,rrpt);
xrrpt(rpt,r)$xrpt(rpt,r) = yes;

miso_r(r)$(sameas(r,"MISO-East") or sameas(r,"MISO-North") or sameas(r,"MISO-South")) = yes;

xcapmap("asis",i,i) = yes;
xcapmap("cofr",conv,i)$(convmap(conv,i) and idef(conv,"cbcf")) = yes;
xcapmap("cgas",conv,i)$(convmap(conv,i) and idef(conv,"clng")) = yes;
xcapmap("cbio",conv,i)$(convmap(conv,i) and idef(conv,"bioc")) = yes;
xcapmap("ccs",conv,i)$(convmap(conv,i) and idef(conv,"ccs9")) = yes;

xcapv("asis",vbase) = yes;
xcapv(xcapmodes,v)$(not sameas(xcapmodes,"asis")) = yes;

alias(f,fff);

* * * * * * * * * * * * * * * * * Primal Variable Reporting * * * * * * * * * * * * * * * * *
set
xgg(i,f,grc)            Map between technologies-fuels and generation graphical reporting categories
xgc(i,grc)              Map between technologies and capacity graphical reporting categories
ccs_ind                 CCS technologies in the industrial sector (ccs_i in industry model) /cem-ccs,ist-bf-ccs/
;

parameter
* Electricity consumption
con_s(s,r,t)            Electricity consumption by segment in each region (GWh)
con_ldv_s(s,r,t)        Electricity consumption for light-duty vehicle charging by segment in each region (GWh)
con_mdhd_s(s,r,t)       Electricity consumption for MD-HD vehicle charging by segment in each region (GWh)
con_nnrd_s(s,r,t)       Electricity consumption for non-road vehicle charging by segment in each region (GWh)
con_dc_s(s,r,t)         Electricity consumption for data centers by segment in each region (GWh)
con_45v_s(s,r,t)        Electricity consumption for 45V-eligible electrolysis by segment in each region (GWh)
contot(r,t)             Total annual electricity consumption in each region gross of distributed (TWh)
uscontot(t)             Total annual electricity consumption in the US (TWh)
contot_ldv(r,t)         Total annual electricity consumption in each region for light-duty vehicle charging (TWh)
contot_mdhd(r,t)        Total annual electricity consumption in each region for MD-HD charging (TWh)
contot_nnrd(r,t)        Total annual electricity consumption in each region for non-road vehicle charging (TWh)
contot_dc(r,t)          Total annual electricity consumption in each region for data centers (TWh)
contot_fuels(r,t)       Total annual electricity consumption in each region for fuels activities (TWh)
uscontot_fuels(t)       Total annual electricity consumption in the US for fuels activities (TWh)
retail(r,t)             Total annual electricity delivered from grid to retail customers (TWh)
usretail(t)             Total annual electricity retail sales (TWh)
gridsup(s,r,t)          Total grid-supplied energy by region and segment (GW before losses)
en4load(s,r,t)          Energy for grid-supplied end-use load by region and segment (GW before losses)
en4int(s,r,t)           Energy for intermediate (energy sector) load by region and segment (GW)
netstor(s,r,t)          Net charge of electricity storage by region and segment (GW)
netload(s,r,t)          Energy for load net of renewable output (GW)
netdertot(r,t)          Total annual electricity supplied by distributed resources (TWh)
backstop(r,t)           Percentage of consumption supplied by backstop demand response

* Electricity generation by grid resources
dsp_si(s,i,f,r,t)       Dispatch by block-fuel by segment in each region (GWh per hour)
dsp_si_45v(*,s,i,f,r,t) Dispatch by 45V-eligible block-fuel by segment in each region (GWh per hour)
gen_s(s,r,t)            Electricity generated by grid resources by segment in each region (GWh)
gentot(r,t)             Total annual electricity generated by grid resources in each region (TWh)
usgentot(t)             Total annual electricity generated by grid resources in the US (TWh)
gen_i(i,f,r,t)          Regional annual generation by grid resources by capacity block and fuel type (TWh)
gen_iv(i,v,f,r,t)       Regional annual generation by grid resources by capacity block and vintage (TWh)
gen(type,r,t)           Regional annual generation by grid resources by type (TWh)
usgen(type,t)           US annual generation by grid resources by type (TWh)
gen_45v(type,r,t)       Regional annual generation linked to 45V hydrogen production (TWh)
usgen_45v(type,t)       US annual generation linked to 45V hydrogen production (TWh)
gen_cfe(type,r,t)       Regional annual generation linked to voluntary CFE procurement (TWh)
usgen_cfe(type,t)       US annual generation linked to voluntary CFE procurement (TWh)

* Standard summary reporting template for generation and capacity
gencaprpt(*,grc,t,*)    Generation and capacity report for post-processing (TWh and GW)

* Electricity generation
genrpt_r(r,*,t)         Generation (grid and distributed) by region (TWh)
genrpt(*,*,t)           Generation (grid and distributed) by reporting region (TWh)
natrpt(*,t)             National generation (grid and distributed) (TWh)
check_gen_r(r,*,t)      Check on equivalence of generation plus net imports and energy for load
trnlossrpt(*,*,t)       Transmission and distribution loss report (inter- and intra-regional) (TWh)
biorpt(r,*,t)           Electricity generation from biomass by region (TWh)

* Electricity trade
domexp_s(s,r,rr,t)      Exports of electricity by segment from region r to rr (GWh)
intexp_s(s,r,t)         Exports of electricity by segment from region r internationally (GWh)
domimp_s(s,r,rr,t)      Imports of electricity by segment from region rr into r (GWh)
intimp_s(s,r,t)         Imports of electricity by segment into region r internationally (GWh)
domexp(r,rr,t)          Total annual electricity exports from region r to rr (TWh)
intexp(r,t)             Total annual electricity exports from region r internationally (TWh)
domimp(r,rr,t)          Total annual electricity imports from region rr into r (TWh)
intimp(r,t)             Total annual electricity imports into region r internationally (TWh)
balance_qs(s,r,t,*,*)   Segment-level electricity supply and disposition balance by segment (GW)
balance_q(*,t,*,*)      Annual electricity supply and disposition quantity balance (TWh)
ntxelec(r,t)            Net annual exports of electricity (TWh)
ntmelec(r,t)            Net annual imports of electricity (TWh)
trdrpt_r(r,r,t)         Electricity trade between regions (TWh)
trdrpt(rpt,rpt,*,t)     Electricity trade between reporting regions (TWh)
trnrpt(*,r,r,t)         Transmission capacity (existing and new) between regions (GW)
trntotal(*,t)           Total transmission capacity (1000 GW-miles)

* Electricity storage
storrpt(*,j,*,t)        Realized electricity storage room and door capacity ratio energy and losses

* Electricity dispatch report
dspsrpt_r(*,s,r,*,t)    Segment-level dispatch report (not weighted by hours) (GW)
dspsrpt_check(r,t)      Annual sum of check on supply-demand balance (should be zero) (GWh)
share_spin(s,r,t)       Share of total generation and storage discharge coming from spinning resources (thermal or hydro)
share_inv(s,r,t)        Share of total generation and storage discharge coming from inverters (wind solar or batteries)
share_inv_hours(*,r,t)  Number of annual hours where inverter share exceeds 50 70 or 90 percent
share_spin_ic(s,intrcon,t)       Interconnect-level share of total generation and storage discharge coming from spinning resources (thermal or hydro)
share_inv_ic(s,intrcon,t)        Interconnect-level share of total generation and storage discharge coming from inverters (wind solar or batteries)
share_inv_hours_ic(*,intrcon,t)  Interconnect-level number of hours where inverter share exceeds 50 70 or 90 percent
hourly_export(r,s,*,*)  Hourly generation and power flow report for export (GW)

* Water use
wtrdraw(*,*,t)          Regional water withdrawals by type (billion gallons per year)
wtrcons(*,*,t)          Regional water consumption by type (billion gallons per year)

* Electricity capacity levels, investment, retrofit, and retirement
coaldisp_i(r,class,cdcat,t)      Coal disposition by coal block (IGCC added to block 1) (GW)
coaldisp_r(*,cdcat,t)            Coal disposition by region and for US (GW)
clncdisprpt(*,*,cdcat,t)         Existing coal and nuclear disposition by region and for US (GW)
ngccdisp_i(r,class,*,t) NGCC disposition by block (GW)
ngccdisp_r(*,*,t)       NGCC disposition by region and for US (GW)
supcurve(*,i,v,v,r,t)   Installed capacity plotted against dispatch cost (GW and $ per MWh)
natcaprpt(*,t)          Capacity report for US (GW)
caprpt(rpt,*,t)         Capacity report for aggregate reporting regions (GW)
caprpt_r(r,*,t)         Capacity report by region (GW)
cuminv(i,r,t)           Regional cumulative investments (excluding conversions) (GW)
cumconv(i,v,r,t)        Regional cumulative conversions (GW)
uscuminv(i,t)           US cumulative investment (excluding conversions) (GW)
uscumconv(i,v,t)        US cumulative conversions (GW)
retirement(type,r,t,*)  Report on retirement of existing capacity (GW and pct)
annual_rnw(*,r,t)       Annual renewable additions (GW)
rghours_csp(i,r,t)      CSP storage hours (implied from model output)
csp_sm(i,r,t)           CSP solar multiplier (implied from model output)
finalcspcost(i,r,*,t)   Concentrated solar power cost report

* Electricity capacity operation
ncap_i(i,r,t)           Nominal installed capacity by region (GW)
acap_si(s,i,r,t)        Available installed capacity by segment (GW)
opcap(type,r,t,*)       Summary capacity operation report by region
usopcap(type,t,*)       Summary capacity operation report for US
curtailment(r,t)        Total curtailed wind and solar energy by region (TWh)
curtail_type(type,r,t)  Annual curtailment by type (TWh)
nuccap(i,r,t,*)         Nuclear capacity operation report
windutil(i,r,t,*)       Report of wind utilization (absorbed vs spilled) (TWh)
caputil(s,type,r,t,*)   Detailed capacity utilization report by segment

* Gas and hydrogen capacity
gascap(*,*,t)           Total input gas capacity (BBtu per hour)
h2cap_con(*,*,t)        Total installed hydrogen input capacity across sectors (BBtu per hour)

* Electricity demand
uspeakload(t)           Peak grid-supplied load for US (GW)
peakload(*,t)           Peak grid-supplied load in aggregate reporting regions (GW)
peakload_r(r,t)         Peak grid-supplied load by model region (GW)
peakcont_ldv(r,t)       Contribution of light-duty vehicle charging load to regional peak (GW)
peakcont_mdhd(r,t)      Contribution of MD-HD vehicle charging load to regional peak (GW)
peakcont_nnrd(r,t)      Contribution of non-road vehicle charging load to regional peak (GW)
peakcont_dc(r,t)        Contribution of data center load to regional peak (GW)
netpkbal(*,*,s,r,t)     Supply demand balance at residual peak (load net of renewables) (GW)
peakgrid_report(*,s,r,t)        Report on peakgrid equation (all segments)
peakgrid_bind(*,s,r,t)  Report on peakgrid equation (binding segments)

* Operating reserves
rsvrpt(*,*,r,t)         Reserve reporting (TWh)
oprespr(*,s,r,t)        Price of operating reserves ($ per MWh)

* Fuel consumption
fuel_s(s,f,r,t)         Fuel consumption by segment for electric and e-fuels sectors (BBtu per hour)
fuel_i(i,f,*,t)         Fuel consumption by technology for electric generation (TBtu)
fuelbal_rpt(*,f,*,t)    Fuel balance report
fuelbal_rpt2(*,f,*,t)   Fuel balance report (allocates blend constituents to destinations)
fuelbal_ups_rpt2(*,f,*,t)        Fuel balance report for upstream use of fuels (with allocated blend constituents)
fuelbal_trf_rpt2(*,f,*,t)        Fuel balance report for transformation sector use of fuels (with allocated blend constituents)
fuelbal_blend_rpt(*,*,f,*,t)     Blended fuel balance report (by destination)
blend_shr(f,*,f,*,t)    Blend share report
ppg_rpt(*,r,t)          Report on total pipeline gas production (including blending components) and consumption (TBtu per year)
eu0_seds(*,*,r)         Base year energy use data from SEDS (TBtu per year)
prim_elec(*,*,t)        Primary energy for electric generation (TBtu per year)
prim_rpt(*,*,t)         Economy-wide primary energy (TBtu per year)
fuels_tot(*,r,t)        Total fuels supply and demand for non-CO2 emissions reporting (TBtu per year)
qsec_elec(*,*,t)        Secondary energy (electricity supply) by primary category (TBtu per year)
qsec_h2(*,*,t)          Secondary energy (hydrogen supply) by primary or input category (TBtu per year)
ele_det_r(ed,r,t)       Detailed electricity demand by REGEN region (TWh)
ele_det_us(ed,t)        Detailed electricity demand - US Total (TWh)

* End-use sector demand
qdr_tot_e(k2,u,df,r,t_all)       Regional total quantity of delivered fuel demanded by sector and end-use (with endogenous MD-HD and non-road) (TBtu)
qdr_chk(*,kf,df,t)      Check on national sum of end-use demands (TBtu)
qd_eeu_kf(kf,f,r,t)     Enduse demand by sector from endogenous activities (TBtu)
qd_eeu_vc(vc,f,*,t)     Enduse demand by vehicle class from endogenous activities (TBtu)
vmt_vc(vc,vht,t)        Annual vehicle miles traveled (billions)
qd_enduse_rpt(kf,f,*,t) Total end-use demand by sector from both endogenous and exogenous activities (TBtu)
enduse_chk(*,*,f,t)     Check on exogenous vs endogenous end-use sector energy use (TBtu)
enduse_chk_twh_r(*,kf,r,t)       Exogenous vs endogenous electricity end-use (TWh)
eleconrpt(*,*,t)        Breakout on electricity consumption (TWh)
elec_fuels_rpt(*,r,t)   Report on regional electricity demand in fuels sectors (TBtu)
rfp_rpt(*,*,t)          Report on petroluem refining (TBtu)
gas_rpt(r,t)            Report on upstream gas production (TBtu)
gastrade_rpt(r,r,t)     Report on bilateral gas trade between regions (TBtu)
trf_rpt(*,*,*,t)        Report on transformation sector energy (TBtu)
trf_cap_rpt(*,*,*,t)    Report on transformation sector capacity (BBtu per hour)
bfs_rpt(*,*,*,t)        Report on bio feedstock demand (TBtu)
biopr_rpt(*,*,t)        Report on bio feedstock price by region ($ per MMBtu)

* Medium- and Heavy-Duty (MD-HD) on-road vehicles and non-road vehicles in both transport and industrial sectors
mdhd_rpt(*,*,vht,*,t)   MD-HD vehicle stock sales and VMT (millions)
mdhd_fuel(*,df,t)       MD-HD fuel use (TBtu)
nnrd_fuel(vc,df,t)      Non-road fuel use (TBtu)
expend_fleetchrg(kf,r,t)         Expenditure on charging infrastructure for fleet vehicles ($B per year)
refuel_cost(vc,vht,r,t)          Up-front cost per MD-HD vehicle or non-road service unit for re-fueling infrastructure ($000)

* Hydrogen production and consumption
h2rpt(fi,*,t)           Hydrogen production (TBtu per year)
h2rpt_45v(v,*,t)        Hydrogen production tax credit outlay ($M per year)
h2cap(*,fi,*,t)         Hydrogen production capacity (various units)
h2con(*,*,t)            Consumption of hydrogen (TBtu per year)
h2conrpt(*,*,t)         Report for hydrogen disposition (TBtu per year)
h2conrpt_ind(*,*,t)     Breakout report for industrial hydrogen consumption (TBtu per year)
h2con_nele(*,*,t)       Consumption of hydrogen for direct non-electric use (TBtu per year)
h2con_blend(*,t)        Consumption of hydrogen for gas blending (TBtu per year)
h2storcap               Hydrogen storage capacity report
h2cost_tot(*,hk,fi,r,t) Total annualized expenditure on hydrogen production ($M)
h2cost(*,hk,r,t)        Levelized hydrogen production cost by component ($ per MMBtu)
elys_s(s,hk,r,t)        Hydrogen production rate from electrolysis (BBtu per hour)
h2blend_s(s,hk,r,t)     Hydrogen blending into non-electric natural gas deliveries by segment (BBtu per hour)
h2nh3_shr(f,*,*,t)      Regional share of hydrogen and ammonia use across refinery industrial products and fuel supply

* Captured CO2
ccs_rpt(*,cstorclass,*) Report on cumulative and annual geologic CO2 storage (GtCO2)
co2_capt_rpt(*,*,*,t)   Detailed report on captured CO2 (MtCO2)
co2_capt_rpt_f(*,*,*,t) Detailed report on captured CO2 by fuel (MtCO2)
report_co2_pipe(r,r,t)  CO2 pipeline capacity between regions (MtCO2)

* Emissions
emitlev(pol,*,t)        Electric sector pollutant emissions by region (Gt)
usemit(pol,t)           US electric sector pollutant emissions (Mt)
emittype(pol,f,v,r,t)   Electric sector pollutant emissions by unit fuel and vintage (Mt)
dactot(r,t)             Net CO2 removal from direct air capture by region (MtCO2)
usdactot(t)             US total net CO2 removal from DAC (MtCO2)
useleco2(*,t)           US electric sector CO2 emissions (positive and negative components broken out) (GtCO2)
secco2_rpt(*,*,t)       CO2 emissons by sector and region (MtCO2)
netco2_rpt(*,*,t)       Net economy-wide CO2 emissions report (MtCO2)
polint_r(pol,r,t)       Emissions intensity of electricity generation (t per MWh)
uspolint(pol,t)         US average emissions intensity of generation (t per MWh)

* Renewable generation reports
rnwshr(r,t)             Share of regional grid-based generation provided by non-hydro renewables
usrnwshr(t)             Share of US grid-based generation provided by non-hydro renewables
srnwgen(r,t,*)          Breakdown of renewable generation (as defined by state RPS) by region (TWh)
srpsrpt(r,t,*)          Breakdown of state RPS compliance (TWh)

* Other policy reports
ceshr(r,t,*)            Regional share of clean electricity compared to target
ceshr_us(t)             National share of clean electricity
cesrpt(r,t,*)           Breakdown of regional CES compliance
cesrpt_rpt(rpt,t,*)     Breakdown of aggregate reporting region CES compliance
cesrpt_us(t,*)          Breakdown of national CES compliance
ceschk(t)               Check on national CES credit balance (should be 0 in each time period)
rpt_taxcr(*,*,*)        Tax credit reporting (billion $)
rpt_iija(t)             IIJA spending (billion $)

* Sankey diagram reports
sankey_rpt(sfl_ind,sankey_node,sankey_node,sankey_flow,*,t)     Sankey diagram input matrix by region (TBtu per year)
sankey_bal_check(sankey_node,*,*,t)	Sankey diagram check on balance nodes (TBtu per year)
hydrogen(*,*,*,t)       Hydrogen balance reporting
pipeline_gas(*,*,*,t)   Pipeline gas balance reporting
liquid_fuels(*,sankey_node,*,t) Liquid fuels balanace reporting
biomass(*,*,*,t)        Biomass balance reporting
finalen(finalsec,finalfuel,*,t) Final energy reporting
;


* * * Electricity consumption, generation, capacity, and trade reporting

* Electricity consumption (includes retail and self-supplied)
con_s(s,r,t) = (load(s,r,t) + QD_EEU_S.L(s,r,t) + sum(flx, QD_FLX_S.L(s,flx,r,t))) * hours(s,t);
con_ldv_s(s,r,t) = load_ldv(s,r,t) * hours(s,t);
con_mdhd_s(s,r,t) = load_kf(s,"mdhd",r,t) * (1 / 3.412 / 8.76) * QD_EEU.L("mdhd","ele",r,t) * hours(s,t);
con_nnrd_s(s,r,t) = load_kf(s,"ind-sm",r,t) * (1 / 3.412 / 8.76) * QD_EEU.L("ind-sm","ele",r,t) * hours(s,t);
$if not set skipdc con_dc_s(s,r,t) = QD_DC_S.L(s,r,t) * hours(s,t);
$if set skipdc con_dc_s(s,r,t) = 0;
contot(r,t) = 1e-3 * sum(s, con_s(s,r,t));
contot_ldv(r,t) = 1e-3 * sum(s, con_ldv_s(s,r,t));
contot_mdhd(r,t) = 1e-3 * sum(s, con_mdhd_s(s,r,t));
contot_nnrd(r,t) = 1e-3 * sum(s, con_nnrd_s(s,r,t));
contot_dc(r,t) = 1e-3 * sum(s, con_dc_s(s,r,t));
uscontot(t) = sum(r, contot(r,t));
retail(r,t) = GRIDTWH.L(r,t) / localloss;
usretail(t) = sum(r, retail(r,t));

* Electricity consumption in intermediate/fuels sectors
contot_fuels(r,t) =
* Central-scale energy sector activities
        (1/3.412) * (QD_UPS.L("ele",r,t) + sum(f$(not sameas(f,"h2-de")), QD_TRF.L("ele",f,r,t)) + QD_DAC.L("ele",r,t) + QD_CO2.L("ele",r,t)) + 1e-3 * sum(s, hours(s,t) * QD_H2I_S.L(s,r,t)) +
* Distributed electrolysis and hydrogen storage
        (1/3.412) * 1e-3 * sum(s, hours(s,t) * (QD_TRF_S.L(s,"ele","h2-de",r,t) + sum(hkf("frc",f), epchrg_h("frc",t) * G_H.L(s,"frc",f,r,t))))
;
uscontot_fuels(t) = sum(r, contot_fuels(r,t));

* "Grid supply" (gridsup) means total grid-supplied enery in segment s, gross of storage/T&D charging/losses,
* "Energy for load" (en4load) means energy available for delivery to end-use sectors (load before losses)
* For example, gridsup could be < load for segments where electricity storage discharge exceeds T&D losses

* From the elebal (electricity market balanace) equation, we have:
* Generation   - Net exports                   - Inter-rg T losses          - Net charge of storage      - Elec consumed for intermediate sectors (e.g. H2 and DAC)
* sum(i, X(i)) - (E(r,rr) - E(rr,r) + ntxintl) - sum(r, trnspen * E(r)) - (hyps + chrgpen * G - GD)  - (QD_TRF + QD_UPS + QD_DAC + QD_H2I + QD_CO2)
* =
* Local grid-supplied energy for load
* GRID

* We set en4load = GRID + Inter-rg T losses
* We set gridsup = GRID + Inter-rg T losses  + Net charge of electricity storage + Elec Consumed for intermediate activities (en4int)
* Hence via the elebal equation, we have:
*        gridsup = generation - net exports
*                = generation + net imports
* This identity is confirmed below in the generation report
en4load(s,r,t) = GRID.L(s,r,t)
*               Inter-rg T losses
              + sum(rr$tcapcost(r,rr), (trnspen(r,rr)-1) * E.L(s,r,rr,t))
;

netstor(s,r,t) =
*       Net charge of electricity storage (including penalty) (include 45V-associated electricity storage after subsidy period)
                sum(j$(not sameas(j,"li-ion-45v")), chrgpen(j) * G.L(s,j,r,t) - GD.L(s,j,r,t))
              + sum(j$(sameas(j,"li-ion-45v") and t.val > 2040 and %elys45v%), chrgpen(j) * G.L(s,j,r,t) - GD.L(s,j,r,t))
*       Plus fixed net charge of existing pumped storage (if exogenous, otherwise this term is zero)
              + hyps(s,r,t)
;

* Energy for intermediate (energy sector) load by region and segment (GW)
en4int(s,r,t) =
*               Electricity consumed for e-fuel production
                sum(ef(f)$(not sameas(f,"h2-de")), (1/3.412) * QD_TRF_S.L(s,"ele",f,r,t))
*               Electricity consumed for other non-electric fuels production
              + sum(trf(f)$(not ef(f)), (1/3.412) * QD_TRF.L("ele",f,r,t)) / 8.76
*               Electricity consumed for DAC (including flexible segment-level dispatch of e-DAC)
              + QD_DAC_S.L(s,r,t)
*               Electricity consumed for upstream fossil production (annual TBtu scaled uniformly to segment level GW)
              + (1/3.412) * QD_UPS.L("ele",r,t) / 8.76
*               Electricity consumed for (central-scale) storage injection and inter-region transmission (export) of hydrogen
              + QD_H2I_S.L(s,r,t)
*               Electricity consumed for CO2 transport and storage
              + (1/3.412) * QD_CO2.L("ele",r,t) / 8.76
;

* Total grid-supplied energy by region and segment (GW before losses)
gridsup(s,r,t) = en4load(s,r,t)
*               Net charge of storage
              + netstor(s,r,t)
*               Electricity consumed for intermediate activities (excluding distributed eletcrolysis, included in en4load)
              + en4int(s,r,t)
;

* Calculate energy for load (including net exports, electricity storage charge, and other uses) net of local renewable output
* This equates to total non-renewable generation in each segment/region
netload(s,r,t) =
*       End-use load net of distributed generation plus electricity use for distributed electrolysis
             (load(s,r,t) + QD_EEU_S.L(s,r,t) + sum(flx, QD_FLX_S.L(s,flx,r,t)) - DR.L(s,r,t) - (netder(s,r,t) - DRC.L(s,r,t))
*       Plus electricity consumed for distributed electrolysis hydrogen production and storage (convert billion btu per hour to GW)
              + (1/3.412) * QD_TRF_S.L(s,"ele","h2-de",r,t)
              + sum(hkf("frc",f), (1/3.412) * epchrg_h("frc",t) * G_H.L(s,"frc",f,r,t))
              ) * localloss
*       Less inter-region imports
              - sum(rr$tcapcost(rr,r), E.L(s,rr,r,t))
*       Plus inter-region exports (including loss penalty)
              + sum(rr$tcapcost(r,rr), trnspen(r,rr) * E.L(s,r,rr,t))
*       Plus net international exports (fixed annual TWh scaled uniformly to segment level GW)
              + (ntxintl(r) / 8.76)
*       Plus net charge of electricity storage
              + netstor(s,r,t)
*       Plus electricity consumed for intermediate activities
              + en4int(s,r,t)
*       Less local renewable output
              - sum(ivfrt(irnw(i),v,f,r,t), X.L(s,i,v,f,r,t));

* Total annual electricity supplied by distributed resources (TWh)
netdertot(r,t) = 1e-3 * sum(s, (netder(s,r,t) - DRC.L(s,r,t)) * hours(s,t));

* Percentage of consumption supplied by backstop demand response
backstop(r,t) = 1e-3 * sum(s, DR.L(s,r,t) * hours(s,t)) / contot(r,t);

* Dispatch by block-fuel by segment in each region (GWh per hour)
dsp_si(s,i,f,r,t) = sum(ivfrt(i,v,f,r,t), X.L(s,i,v,f,r,t)) + sum(civfrt(i,vv,v,f,r,t), X_C.L(s,i,vv,v,f,r,t));
gen_s(s,r,t)    = sum((i,f), dsp_si(s,i,f,r,t)) * hours(s,t);
$ifthen.elys45v not %elys45v%==no
$ifthen.elys45vh    %ann45v%==no
dsp_si_45v("45v",s,i,f,r,t) = sum(ivfrt(i,v,f,r,t)$ifvt_45v(i,f,v,t), HZERC_45V.L(s,i,v,f,r,t));
dsp_si_45v("grid",s,i,f,r,t) = sum(ivfrt(i,v,f,r,t)$ifvt_45v(i,f,v,t), X.L(s,i,v,f,r,t) - HZERC_45V.L(s,i,v,f,r,t));
$endif.elys45vh
$endif.elys45v

* Annual electricity generation (TWh)
gentot(r,t)     = 1e-3 * sum(s, gen_s(s,r,t));
usgentot(t)     = sum(r, gentot(r,t));
gen_i(i,f,r,t)  = sum(ivfrt(i,v,f,r,t), XTWH.L(i,v,f,r,t)) + sum(civfrt(i,vv,v,f,r,t), XTWH_C.L(i,vv,v,f,r,t));
gen_iv(i,v,f,r,t) = XTWH.L(i,v,f,r,t) + sum(vv, XTWH_C.L(i,vv,v,f,r,t));
gen(type,r,t)   = sum((idef(i,type),f), gen_i(i,f,r,t));
usgen(type,t)   = sum(r, gen(type,r,t));
gen_45v(type,r,t) = 0;
$if not %elys45v%==no gen_45v(type,r,t) = sum((ivfrt(i,v,f,r,t),idef(i,type))$ifvt_45v(i,f,v,t), ZERC_45V.L(i,v,f,r,t));
gen_cfe(type,r,t) = 0;
$if not %cfe247%==no gen_cfe(type,r,t) = sum((ivfrt(i,v,f,r,t),idef(i,type))$ifvt_cfe(i,f,v,t), ZERC_CFE.L(i,v,f,r,t));
usgen_45v(type,t) = sum(r, gen_45v(type,r,t));
usgen_cfe(type,t) = sum(r, gen_cfe(type,r,t));

xdr(i,h2f(f),"06h2")$((idef(i,"dfcc") or idef(i,"dfgt") or idef(i,"g2hc") or idef(i,"g2ht") or idef(i,"h2cc") or idef(i,"h2gt")) and not sameas(f,"h2-de")) = yes;

* Regional electricity generation by graphical reporting categories (TWh)
genrpt_r(r,xr,t) = eps + sum(ifl(i,f), xdr(i,f,xr) * gen_i(i,f,r,t));
genrpt_r(r,"11rfpv",t) = eps + rfpv_twh(r,t) - 1e-3 * sum(s, DRC.L(s,r,t) * hours(s,t));
genrpt(rpt,xr,t) = sum(xrpt(rpt,r), genrpt_r(r,xr,t));
genrpt("MISO",xr,t) = sum(miso_r(r), genrpt_r(r,xr,t));
natrpt(xr,t) = sum(rpt, genrpt(rpt,xr,t));
genrpt_r(r,"netdertot",t) = eps + netdertot(r,t);
genrpt(rpt,"netdertot",t) = eps + sum(xrpt(rpt,r), netdertot(r,t));
natrpt("netdertot",t) = sum(rpt, genrpt(rpt,"netdertot",t));

* Transmission and distribution loss report (inter- and intra-regional) (TWh)
trnlossrpt("inter-rg",r,t) = 1e-3 * sum(s, hours(s,t) * sum(rr$tcapcost(r,rr), (trnspen(r,rr)-1) * E.L(s,r,rr,t)));
trnlossrpt("intra-rg",r,t) = GRIDTWH.L(r,t) * (1 - 1 / localloss);
trnlossrpt("total",r,t) = trnlossrpt("inter-rg",r,t) + trnlossrpt("intra-rg",r,t);
trnlossrpt("inter-rg","us48",t) = sum(r, trnlossrpt("inter-rg",r,t));
trnlossrpt("intra-rg","us48",t) = sum(r, trnlossrpt("intra-rg",r,t));
trnlossrpt("total","us48",t) = sum(r, trnlossrpt("total",r,t));

* Electricity generation from biomass by region (TWh)
biorpt(r,"exist",t) = sum(ifl(xbio(i),f), gen_i(i,f,r,t));
biorpt(r,"cofire",t) = sum(ifl(i,"bio")$idef(i,"cbcf"), gen_i(i,"bio",r,t));
biorpt(r,"retro",t) = sum(ifl(conv,"bio")$idef(conv,"bioe"), gen_i(conv,"bio",r,t));
biorpt(r,"new",t) = gen_i("bioe-n","bio",r,t);
biorpt(r,"becs",t) = gen_i("becs-n","bio",r,t);
biorpt(r,"total_net",t) = biorpt(r,"exist",t) + biorpt(r,"cofire",t) + biorpt(r,"retro",t) + biorpt(r,"new",t) - genrpt_r(r,"03othc",t);

* Generation report to be exported post-processing to spreadsheet templates
xgg(i,"ura","Existing Nuclear")$(idef(i,"nucl") and not new(i)) = yes;
xgg(i,"ura","New Nuclear")$(idef(i,"nucl") and new(i)) = yes;
xgg(i,"ura","New Nuclear (Advanced)")$(idef(i,"nuca") and new(i)) = yes;
xgg(i,"rnw","Geothermal")$idef(i,"geot") = yes;
xgg(i,"oth","Other Combustion")$idef(i,"othc") = yes;
xgg(i,"rnw","Hydro (Conventional)")$idef(i,"hydr") = yes;
xgg(i,"bio","Bioenergy")$(idef(i,"bioe") or idef(i,"bioc") or idef(i,"cbcf")) = yes;
xgg(i,"bio","Bioenergy (with CC)")$idef(i,"becs") = yes;
xgg(i,"cls","Existing Coal")$((idef(i,"clcl") or idef(i,"igcc") or idef(i,"cgcf") or idef(i,"cbcf")) and not new(i)) = yes;
xgg(i,"cls","New Coal")$(sameas(i,"clcl-n") or sameas(i,"igcc-n")) = yes;
xgg(i,"cls","Coal (with CC)")$(idef(i,"ccs9") or idef(i,"clcs") or idef(i,"clch")) = yes;
xgg(i,"ppg","Existing NGCC")$(idef(i,"ngcc") and not new(i)) = yes;
xgg(i,"ppg","New NNGC")$(idef(i,"ngcc") and new(i)) = yes;
xgg(i,"ppg","NNGC (with CC)")$(idef(i,"ngcr") or idef(i,"nccs") or idef(i,"ncch") or idef(i,"nccx")) = yes;
xgg(i,"ppg","Existing Gas Steam and CT")$((idef(i,"nggt") and not new(i)) or idef(i,"ngst") or idef(i,"clng") or idef(i,"cgcf")) = yes;
xgg(i,"ppg","New Gas CT")$(idef(i,"nggt") and new(i)) = yes;
xgg(i,"dsl","Existing Oil Peakers")$idef(i,"ptsg") = yes;
xgg(i,"ppg","New Dual-Fuel (gas)")$(idef(i,"dfcc") or idef(i,"dfgt")) = yes;
xgg(i,"dsl","New Dual-Fuel (liquid)")$(idef(i,"dfcc") or idef(i,"dfgt")) = yes;
xgg(i,"h2-e","New Dual-Fuel (H2)")$(idef(i,"dfcc") or idef(i,"dfgt")) = yes;
xgg(i,"h2_45v","New Dual-Fuel (H2)")$(idef(i,"dfcc") or idef(i,"dfgt")) = yes;
xgg(i,"h2-n","New Dual-Fuel (H2)")$(idef(i,"dfcc") or idef(i,"dfgt")) = yes;
xgg(i,"h2-e","New Dedicated H2")$(idef(i,"h2cc") or idef(i,"h2gt") or idef(i,"g2hc") or idef(i,"g2ht")) = yes;
xgg(i,"h2_45v","New Dedicated H2")$(idef(i,"h2cc") or idef(i,"h2gt") or idef(i,"g2hc") or idef(i,"g2ht")) = yes;
xgg(i,"h2-n","New Dedicated H2")$(idef(i,"h2cc") or idef(i,"h2gt") or idef(i,"g2hc") or idef(i,"g2ht")) = yes;
xgg(i,"rnw","Existing Wind")$(idef(i,"wind") and not new(i)) = yes;
xgg(i,"rnw","New Wind (On-shore)")$(idef(i,"wind") and new(i)) = yes;
xgg(i,"rnw","New Wind (Off-shore)")$(idef(i,"wnos")) = yes;
xgg(i,"rnw","Existing Solar PV")$((idef(i,"pvft") or idef(i,"pvsx") or idef(i,"pvdx"))  and not new(i)) = yes;
xgg(i,"rnw","New Solar PV")$((idef(i,"pvft") or idef(i,"pvsx") or idef(i,"pvdx")) and new(i)) = yes;
xgg(i,"rnw","Existing Solar CSP")$(idef(i,"cspr") and not new(i)) = yes;
xgg(i,"rnw","New Solar CSP")$(idef(i,"cspr") and new(i)) = yes;

* Define capacity reporting categories, which are similar to generation but account for dual-fuel capacity
loop(xgg(i,"ura",grc), xgc(i,grc) = yes;);
loop(xgg(i,"rnw",grc), xgc(i,grc) = yes;);
loop(xgg(i,"oth",grc), xgc(i,grc) = yes;);
* Count coal-bio co-firing capacity under coal not bio
loop(xgg(i,"bio",grc)$(not idef(i,"cbcf")), xgc(i,grc) = yes;);
loop(xgg(i,"cls",grc), xgc(i,grc) = yes;);
* Include separate category for dual-fuel capacity (i.e. not gas, diesel, or hydrogen categories)
loop(xgg(i,"ppg",grc)$(not (idef(i,"dfcc") or idef(i,"dfgt") or idef(i,"g2hc") or idef(i,"g2ht"))), xgc(i,grc) = yes;);
loop(xgg(i,"dsl",grc)$(not (idef(i,"dfcc") or idef(i,"dfgt") or idef(i,"g2hc") or idef(i,"g2ht"))), xgc(i,grc) = yes;);
loop(xgg(i,"h2-e",grc)$(not (idef(i,"dfcc") or idef(i,"dfgt") or idef(i,"g2hc") or idef(i,"g2ht"))), xgc(i,grc) = yes;);
xgc(i,"New Dual-Fuel")$(idef(i,"dfcc") or idef(i,"dfgt") or idef(i,"g2hc") or idef(i,"g2ht")) = yes;

* Fill in generation by graphical reporting category (TWh)
gencaprpt(r,grc,t,"twh") = eps + sum(xgg(i,f,grc), gen_i(i,f,r,t));
* Electricity storage discharge
gencaprpt(r,"Storage (gross discharge)",t,"twh") = eps + 1e-3 * sum(s, hours(s,t) * (
                sum(j$(not sameas(j,"li-ion-45v")),  GD.L(s,j,r,t))
              + sum(j$(sameas(j,"li-ion-45v") and t.val > 2040 and %elys45v%), GD.L(s,j,r,t))
              - hyps(s,r,t)$(hyps(s,r,t) < 0))
);
gencaprpt(r,"Distributed Solar PV",t,"twh") = eps + genrpt_r(r,"11rfpv",t);
gencaprpt(r,"Self Generation",t,"twh") = eps + selfgen(r,t);

* Electricity trade (TWh)
domexp_s(s,r,rr,t) = E.L(s,r,rr,t) * hours(s,t);
intexp_s(s,r,t) = max(0, (ntxintl(r) / 8.76)) * hours(s,t);
domimp_s(s,r,rr,t) = E.L(s,rr,r,t) * hours(s,t);
intimp_s(s,r,t) = max(0, -(ntxintl(r)/8.76)) * hours(s,t);
domexp(r,rr,t) = 1e-3 * sum(s, domexp_s(s,r,rr,t));
intexp(r,t) = 1e-3 * sum(s, intexp_s(s,r,t));
domimp(r,rr,t) = 1e-3 * sum(s, domimp_s(s,r,rr,t));
intimp(r,t) = 1e-3 * sum(s, intimp_s(s,r,t));
ntxelec(r,t) = sum(rr, domexp(r,rr,t)) - sum(rr, domimp(r,rr,t)) + ntxintl(r);
ntmelec(r,t) = sum(rr, domimp(r,rr,t)) - sum(rr, domexp(r,rr,t)) - ntxintl(r);
* Include imports in regional generation reports, which includes the positive part of net imports only
genrpt_r(r,"12ntm",t) = eps + max(0, ntmelec(r,t));
genrpt(rpt,"12ntm",t) = eps + max(0, sum(xrpt(rpt,r), ntmelec(r,t)));
natrpt("12ntm",t) = eps + max(0, sum(r, ntmelec(r,t)));
* Include net imports, which includes both positive and negative
gencaprpt(r,"Net Imports",t,"twh") = eps + ntmelec(r,t);

* Include energy for load/gridsup in gen reports
* Energy for load/gridsup here should align with the sum of all generation excluding rfpv+self
* plus net imports (see identity above, confirm this with check_gen_r)
genrpt_r(r,"13en4",t) = eps + 1e-3 * sum(s, hours(s,t) * gridsup(s,r,t));
genrpt(rpt,"13en4",t) = eps + 1e-3 * sum((s,xrpt(rpt,r)), hours(s,t) * gridsup(s,r,t));
natrpt("13en4",t) = sum(rpt, genrpt(rpt,"13en4",t));
check_gen_r(r,"gen_plus_ntm",t) = sum(xr$(not sameas(xr,"11rfpv")), genrpt_r(r,xr,t)) + ntmelec(r,t);
check_gen_r(r,"gridsup",t) = genrpt_r(r,"13en4",t);
check_gen_r(r,"check",t) = check_gen_r(r,"gen_plus_ntm",t) - check_gen_r(r,"gridsup",t);
gencaprpt(r,"Total Energy for Load",t,"twh") = eps + genrpt_r(r,"13en4",t);
gencaprpt(r,"Energy for End-Use Load",t,"twh") = eps + 1e-3 * sum(s, hours(s,t) * en4load(s,r,t));
gencaprpt(r,"Storage (gross charge)",t,"twh") = eps + 1e-3 * sum(s, hours(s,t) * (
                sum(j$(not sameas(j,"li-ion-45v")),  chrgpen(j) * G.L(s,j,r,t))
              + sum(j$(sameas(j,"li-ion-45v") and t.val > 2040 and %elys45v%), chrgpen(j) * G.L(s,j,r,t))
              + hyps(s,r,t)$(hyps(s,r,t) > 0))
);
* Exclude distributed hydrogen production, part of end-use load
gencaprpt(r,"Energy for H2 Production",t,"twh") = eps + 1e-3 * sum(s, hours(s,t) * sum(ef(f)$(h2f(f) and not sameas(f,"h2-de")), (1/3.412) * QD_TRF_S.L(s,"ele",f,r,t)));
gencaprpt(r,"Other Intermediate Use",t,"twh") = eps + 1e-3 * sum(s, hours(s,t) * (
*               Electricity consumed for e-fuel production (other than hydrogen)
              + sum(ef(f)$(not h2f(f)), (1/3.412) * QD_TRF_S.L(s,"ele",f,r,t))
*               Electricity consumed for other non-electric fuels production
              + sum(trf(f)$(not ef(f)), (1/3.412) * QD_TRF.L("ele",f,r,t)) / 8.76
*               Electricity consumed for DAC (including flexible segment-level dispatch of e-DAC)
              + QD_DAC_S.L(s,r,t)
*               Electricity consumed for upstream fossil production (annual TBtu scaled uniformly to segment level GW)
              + (1/3.412) * QD_UPS.L("ele",r,t) / 8.76
*               Electricity consumed for (central-scale) storage injection and inter-region transmission (export) of hydrogen
              + QD_H2I_S.L(s,r,t)
*               Electricity consumed for CO2 transport and storage
              + (1/3.412) * QD_CO2.L("ele",r,t) / 8.76
*               Electricity consumed for distributed hydrogen storage (EXCLUDE, part of end-use load)
*             + sum(hkf("frc",f), (1/3.412) * epchrg_h("frc",t) * G_H.L(s,"frc",f,r,t))
));

* Aggregate gencaprpt to reporting regions and US total
gencaprpt(rpt,grc,t,"twh") = sum(xrrpt(rpt,r), gencaprpt(r,grc,t,"twh"));
gencaprpt("MISO",grc,t,"twh") = sum(miso_r(r), gencaprpt(r,grc,t,"twh"));
gencaprpt("US48",grc,t,"twh") = sum(r, gencaprpt(r,grc,t,"twh"));

* Instantaneous quantity balance in each segment for grid-supplied energy (terms of demand equation)
balance_qs(s,r,t,"gen_grid",r) = gen_s(s,r,t) / hours(s,t);
balance_qs(s,r,t,"gen_dist",r) = netder(s,r,t) - DRC.L(s,r,t);
* Net discharge from electricity storage (i.e. supply)
balance_qs(s,r,t,"netstor",r) = -netstor(s,r,t);
balance_qs(s,r,t,"exp",rr) = E.L(s,r,rr,t);
balance_qs(s,r,t,"exp","int") = max(0, (ntxintl(r)/8.76));
balance_qs(s,r,t,"imp",rr) = E.L(s,rr,r,t);
balance_qs(s,r,t,"imp","int") = max(0, -(ntxintl(r)/8.76));
balance_qs(s,r,t,"imp","net") = sum(rr, balance_qs(s,r,t,"imp",rr)) +
                                        balance_qs(s,r,t,"imp","int") - (
                                sum(rr, balance_qs(s,r,t,"exp",rr)) +
                                        balance_qs(s,r,t,"exp","int"));
balance_qs(s,r,t,"loss","exp") = sum(rr$tcapcost(r,rr), (trnspen(r,rr)-1) * E.L(s,r,rr,t));
balance_qs(s,r,t,"loss",r) = GRID.L(s,r,t) * (1 - 1 / localloss) ;
balance_qs(s,r,t,"con_int",r) = en4int(s,r,t);
balance_qs(s,r,t,"con_grid",r) = GRID.L(s,r,t) / localloss;
balance_qs(s,r,t,"check","total") = balance_qs(s,r,t,"gen_grid",r) +
                                    balance_qs(s,r,t,"netstor",r) +
                                    balance_qs(s,r,t,"imp","net") -
                                    balance_qs(s,r,t,"loss","exp") -
                                    balance_qs(s,r,t,"loss",r) -
                                    balance_qs(s,r,t,"con_int",r) -
                                    balance_qs(s,r,t,"con_grid",r);

* Annual electricity supply and disposition quantity balance (TWh)
balance_q(r,t,"gen_grid",r) = gentot(r,t);
balance_q(r,t,"gen_dist",r) = netdertot(r,t);
* Net discharge from electricity storage
balance_q(r,t,"netstor",r) = 1e-3 * sum(s, balance_qs(s,r,t,"netstor",r) * hours(s,t));
balance_q(r,t,"exp",rr) = domexp(r,rr,t);
balance_q(r,t,"exp","int") = intexp(r,t);
balance_q(r,t,"imp",rr) = domimp(r,rr,t);
balance_q(r,t,"imp","int") = intimp(r,t);
balance_q(r,t,"imp","net") = sum(rr, balance_q(r,t,"imp",rr)) +
                                     balance_q(r,t,"imp","int") - (
                             sum(rr, balance_q(r,t,"exp",rr)) +
                                     balance_q(r,t,"exp","int"));
balance_q(r,t,"loss","exp") = 1e-3 * sum(s, balance_qs(s,r,t,"loss","exp") * hours(s,t));
balance_q(r,t,"loss",r) = 1e-3 * sum(s, balance_qs(s,r,t,"loss",r) * hours(s,t));
balance_q(r,t,"con_int",r) = gencaprpt(r,"Energy for H2 Production",t,"twh") + gencaprpt(r,"Other Intermediate Use",t,"twh");
balance_q(r,t,"con_grid",r) = GRIDTWH.L(r,t) / localloss;
balance_q(r,t,"con_dist",r) = netdertot(r,t);
balance_q(r,t,"check","total") = balance_q(r,t,"gen_grid",r) +
                                    balance_q(r,t,"netstor",r) +
                                    balance_q(r,t,"imp","net") -
                                    balance_q(r,t,"loss","exp") -
                                    balance_q(r,t,"loss",r) -
                                    balance_q(r,t,"con_int",r) -
                                    balance_q(r,t,"con_grid",r);
balance_q("USA",t,"gen_grid","USA") = sum(r, balance_q(r,t,"gen_grid",r));
balance_q("USA",t,"gen_dist","USA") = sum(r, balance_q(r,t,"gen_dist",r));
balance_q("USA",t,"netstor","USA") = sum(r, balance_q(r,t,"netstor",r));
balance_q("USA",t,"imp","net") = sum(r, balance_q(r,t,"imp","net"));
balance_q("USA",t,"loss","USA") = sum(r, balance_q(r,t,"loss","exp") + balance_q(r,t,"loss",r));
balance_q("USA",t,"con_int","USA") = sum(r, balance_q(r,t,"con_int",r));
balance_q("USA",t,"con_grid","USA") = sum(r, balance_q(r,t,"con_grid",r));
balance_q("USA",t,"con_dist","USA") = sum(r, balance_q(r,t,"con_dist",r));
balance_q("USA",t,"check","total") = balance_q("USA",t,"gen_grid","USA") +
                                     balance_q("USA",t,"netstor","USA") +
                                     balance_q("USA",t,"imp","net") -
                                     balance_q("USA",t,"loss","USA") -
                                     balance_q("USA",t,"con_int","USA") -
                                     balance_q("USA",t,"con_grid","USA");

* Net annual exports/imports of electricity and trade between regions (TWh)
ntxelec(r,t) = -balance_q(r,t,"imp","net");
ntmelec(r,t) =  balance_q(r,t,"imp","net");
trdrpt_r(r,rr,t) =  1e-3 * sum(s, E.L(s,r,rr,t) * hours(s,t));
trdrpt("east_rpt","south_rpt","LtoR",t) = -1e-3 * sum((s,xrpt("east_rpt",r),xrrpt("south_rpt",rr)),
                                                E.L(s,r,rr,t) * hours(s,t));
trdrpt("east_rpt","south_rpt","RtoL",t) = 1e-3 * sum((s,xrpt("east_rpt",rr),xrrpt("south_rpt",r)),
                                                E.L(s,r,rr,t) * hours(s,t));
trdrpt("midwest_rpt","east_rpt","LtoR",t) = -1e-3 * sum((s,xrpt("midwest_rpt",r),xrrpt("east_rpt",rr)),
                                                E.L(s,r,rr,t) * hours(s,t));
trdrpt("midwest_rpt","east_rpt","RtoL",t) = 1e-3 * sum((s,xrpt("midwest_rpt",rr),xrrpt("east_rpt",r)),
                                                E.L(s,r,rr,t) * hours(s,t));
trdrpt("midwest_rpt","south_rpt","LtoR",t) = -1e-3 * sum((s,xrpt("midwest_rpt",r),xrrpt("south_rpt",rr)),
                                                E.L(s,r,rr,t) * hours(s,t));
trdrpt("midwest_rpt","south_rpt","RtoL",t) = 1e-3 * sum((s,xrpt("midwest_rpt",rr),xrrpt("south_rpt",r)),
                                                E.L(s,r,rr,t) * hours(s,t));
trdrpt("west_rpt","midwest_rpt","LtoR",t) = -1e-3 * sum((s,xrpt("west_rpt",r),xrrpt("midwest_rpt",rr)),
                                                E.L(s,r,rr,t) * hours(s,t));
trdrpt("west_rpt","midwest_rpt","RtoL",t) = 1e-3 * sum((s,xrpt("west_rpt",rr),xrrpt("midwest_rpt",r)),
                                                E.L(s,r,rr,t) * hours(s,t));
trnrpt("exist",r,rr,t) = tcap(r,rr);
trnrpt("new",r,rr,t)$(tcap(r,rr) or tcapcost(r,rr)) = eps + TC.L(r,rr,t);
trnrpt("total",r,rr,t)$(tcap(r,rr) or tcapcost(r,rr)) = tcap(r,rr) + TC.L(r,rr,t);
trntotal("exist",t) = 1e-3 * sum((r,rr), tlinelen(r,rr) * tcap(r,rr)) / 2;
trntotal("new",t) = 1e-3 * sum((r,rr), tlinelen(r,rr) * TC.L(r,rr,t)) / 2;
trntotal("total",t) = 1e-3 * sum((r,rr), tlinelen(r,rr) * (tcap(r,rr) + TC.L(r,rr,t))) / 2;

* Electricity storage reporting
*       Calculate realized storage capacity and duration (room-door ratio)
storrpt("room_GWh",j,r,t)$GC.L(j,r,t) = GR.L(j,r,t);
$if %storage%==no storrpt("room_GWh","hyps-x",r,t) = 20 * gcap("hyps-x",r);
storrpt("room_GWh",j,"us48",t) = sum(r, storrpt("room_GWh",j,r,t));
storrpt("door_GW",j,r,t)$GC.L(j,r,t) = GC.L(j,r,t);
$if %storage%==no storrpt("door_GW","hyps-x",r,t) = gcap("hyps-x",r);
storrpt("door_GW",j,"us48",t) = sum(r, storrpt("door_GW",j,r,t));
storrpt("ratio",j,r,t)$GC.L(j,r,t) = GR.L(j,r,t) / GC.L(j,r,t);
$if %storage%==no storrpt("ratio","hyps-x",r,t)$gcap("hyps-x",r) = 20;
storrpt("ratio",j,"us48",t)$storrpt("door_GW",j,"us48",t) = storrpt("room_GWh",j,"us48",t) / storrpt("door_GW",j,"us48",t);
*       Calculate realized gross charge, discharge, and losses
storrpt("gross_charge",j,r,t) = 1e-3 * sum(s, hours(s,t) * (chrgpen(j) * G.L(s,j,r,t) + hyps(s,r,t)$(sameas(j,"hyps-x") and hyps(s,r,t) > 0)));
storrpt("gross_discharge",j,r,t) = 1e-3 * sum(s, hours(s,t) * (GD.L(s,j,r,t) - hyps(s,r,t)$(sameas(j,"hyps-x") and hyps(s,r,t) < 0)));
storrpt("net_loss",j,r,t) = storrpt("gross_charge",j,r,t) - storrpt("gross_discharge",j,r,t);
storrpt("gross_charge",j,"us48",t) = sum(r, storrpt("gross_charge",j,r,t));
storrpt("gross_discharge",j,"us48",t) = sum(r, storrpt("gross_discharge",j,r,t));
storrpt("net_loss",j,"us48",t) = sum(r, storrpt("net_loss",j,r,t));

* Block-level nominal installed capacity and available capacity by segment
ncap_i(i,r,t) = sum(ivrt(i,v,r,t), XC.L(i,v,r,t)) + sum(civrt(i,vv,v,r,t), XC_C.L(i,vv,v,r,t));
acap_si(s,i,r,t) = sum(ivrt(i,v,r,t), af(s,i,v,r,t) * XC.L(i,v,r,t)) +
                   sum(civrt(i,vv,v,r,t), af(s,i,v,r,t) * XC_C.L(i,vv,v,r,t))
;

* Segment-level dispatch report (not weighted by hours) (GW)
dspsrpt_r("supply",s,r,xr,t) = eps + sum(ifl(i,f), xdr(i,f,xr) * dsp_si(s,i,f,r,t));
dspsrpt_r("supply",s,r,"11rfpv",t) = eps + rfpv_out(s,r,t) - DRC.L(s,r,t);
dspsrpt_r("supply",s,r,"selfgen",t) = eps + selfgen(r,t) / 8.76;
dspsrpt_r("supply",s,r,"DR",t) = eps + DR.L(s,r,t);
dspsrpt_r("supply",s,r,"batt-disc",t) = eps + sum(batt(j), GD.L(s,j,r,t));
dspsrpt_r("supply",s,r,"bulk-disc",t) = eps + sum(j$(sameas(j,"bulk") or sameas(j,"caes")), GD.L(s,j,r,t));
dspsrpt_r("supply",s,r,"hyps-disc",t) = eps + sum(j$(sameas(j,"hyps-x")), GD.L(s,j,r,t)) - hyps(s,r,t)$(hyps(s,r,t) < 0);
dspsrpt_r("supply",s,r,"domimp",t) = eps + sum(rr, domimp_s(s,r,rr,t)) / hours(s,t);
dspsrpt_r("supply",s,r,"intimp",t) = eps + intimp_s(s,r,t) / hours(s,t);
dspsrpt_r("demand",s,r,"load",t) = eps + load(s,r,t) + QD_EEU_S.L(s,r,t) + sum(flx, QD_FLX_S.L(s,flx,r,t));
dspsrpt_r("demand",s,r,"localloss",t) = eps + GRID.L(s,r,t) * (1 - 1/localloss);
dspsrpt_r("demand",s,r,"domexp",t) = eps + sum(rr, trnspen(r,rr) * domexp_s(s,r,rr,t)) / hours(s,t);
dspsrpt_r("demand",s,r,"intexp",t) = eps + intexp_s(s,r,t) / hours(s,t);
dspsrpt_r("demand",s,r,"batt-chrg",t) = eps + sum(batt(j), chrgpen(j) * G.L(s,j,r,t));
dspsrpt_r("demand",s,r,"bulk-chrg",t) = eps + sum(j$(sameas(j,"bulk") or sameas(j,"caes")), chrgpen(j) * G.L(s,j,r,t));
dspsrpt_r("demand",s,r,"hyps-chrg",t) = eps + sum(j$(sameas(j,"hyps-x")), chrgpen(j) * G.L(s,j,r,t)) + max(0, hyps(s,r,t));
dspsrpt_r("demand",s,r,"h2stortrn",t) = eps + QD_H2I_S.L(s,r,t);
dspsrpt_r("demand",s,r,"trfupsdac",t) = eps +
*               Electricity consumed for e-fuel production (other than hydrogen)
                sum(ef(f)$(not h2f(f)), (1/3.412) * QD_TRF_S.L(s,"ele",f,r,t))
*               Electricity consumed for other non-electric fuels production
              + sum(trf(f)$(not ef(f)), (1/3.412) * QD_TRF.L("ele",f,r,t)) / 8.76
*               Electricity consumed for DAC (including flexible segment-level dispatch of e-DAC)
              + QD_DAC_S.L(s,r,t)
*               Electricity consumed for upstream fossil production (annual TBtu scaled uniformly to segment level GW)
              + (1/3.412) * QD_UPS.L("ele",r,t) / 8.76
*               Electricity consumed for CO2 transport and storage
              + (1/3.412) * QD_CO2.L("ele",r,t) / 8.76
;
dspsrpt_r("demand",s,r,"h2prod_pa",t) = eps + sum(fivrt(elys(hi),v,r,t)$(not sameas(hi,"elys-hts")), (1/3.412) * eptrf("ele",hi,v) * HX.L(s,hi,v,r,t));
dspsrpt_r("demand",s,r,"h2prod_ht",t) = eps + sum(fivrt(elys(hi),v,r,t)$sameas(hi,"elys-hts"), (1/3.412) * eptrf("ele",hi,v) * HX.L(s,hi,v,r,t));
* Hourly wind and solar curtailment
dspsrpt_r("curtail",s,r,xr,t)$(sameas(xr,"09wnd") or sameas(xr,"10slr")) = eps + sum(i, xdr(i,"rnw",xr) * (acap_si(s,i,r,t) - dsp_si(s,i,"rnw",r,t)));
dspsrpt_r("curtail",s,r,"11rfpv",t) = eps + DRC.L(s,r,t);

* Include hourly curtailment in 45V dispatch report (probably zero)
$ifthen.elys45v not %elys45v%==no
$ifthen.elys45vh    %ann45v%==no
dsp_si_45v("curtail",s,i,"rnw",r,t)$if_45v(i,"rnw") = acap_si(s,i,r,t) - dsp_si(s,i,"rnw",r,t);
$endif.elys45vh
$endif.elys45v

* Check supply balance
dspsrpt_r("check",s,r,"total",t) =
        sum(xr, dspsrpt_r("supply",s,r,xr,t)) +
        dspsrpt_r("supply",s,r,"selfgen",t) +
        dspsrpt_r("supply",s,r,"DR",t) +
        dspsrpt_r("supply",s,r,"batt-disc",t) +
        dspsrpt_r("supply",s,r,"bulk-disc",t) +
        dspsrpt_r("supply",s,r,"hyps-disc",t) +
        dspsrpt_r("supply",s,r,"domimp",t) +
        dspsrpt_r("supply",s,r,"intimp",t) -
        dspsrpt_r("demand",s,r,"load",t) -
        dspsrpt_r("demand",s,r,"localloss",t) -
        dspsrpt_r("demand",s,r,"domexp",t) -
        dspsrpt_r("demand",s,r,"intexp",t) -
        dspsrpt_r("demand",s,r,"batt-chrg",t) -
        dspsrpt_r("demand",s,r,"bulk-chrg",t) -
        dspsrpt_r("demand",s,r,"hyps-chrg",t) -
        dspsrpt_r("demand",s,r,"h2stortrn",t) -
        dspsrpt_r("demand",s,r,"trfupsdac",t) -
        dspsrpt_r("demand",s,r,"h2prod_pa",t) -
        dspsrpt_r("demand",s,r,"h2prod_ht",t)
;
dspsrpt_r("hours",s,r,"hours",t) = hours(s,t);
dspsrpt_check(r,t) = sum(s, dspsrpt_r("check",s,r,"total",t) * hours(s,t));

* In each hour and in each region, share of total generation and electricity storage discharge coming from either dispatchable or hydro sources
* (i.e. excluding inverter-based energy from wind, solar, and batteries)
share_spin(s,r,t)$gen_s(s,r,t) =
        (sum((i,f)$(not irnw(i)), dsp_si(s,i,f,r,t)) + sum(j$(not batt(j)), GD.L(s,j,r,t)) - hyps(s,r,t)$(hyps(s,r,t) < 0)) /
        (sum((i,f), dsp_si(s,i,f,r,t)) + sum(j, GD.L(s,j,r,t)) - hyps(s,r,t)$(hyps(s,r,t) < 0));
share_inv(s,r,t) = 1 - share_spin(s,r,t);

* Number of annual hours where inverter share exceeds 50, 70, or 90 percent
share_inv_hours("50",r,t) = sum(s$(share_spin(s,r,t) < 0.5), hours(s,t));
share_inv_hours("70",r,t) = sum(s$(share_spin(s,r,t) < 0.3), hours(s,t));
share_inv_hours("90",r,t) = sum(s$(share_spin(s,r,t) < 0.1), hours(s,t));

* Make same calculations for shares at interconnect level
share_spin_ic(s,intrcon,t)$sum(xintrcon(intrcon,r), gen_s(s,r,t)) =
        (sum((xintrcon(intrcon,r),i,f)$(not irnw(i)), dsp_si(s,i,f,r,t)) + sum((xintrcon(intrcon,r),j)$(not batt(j)), GD.L(s,j,r,t)) - sum(xintrcon(intrcon,r), hyps(s,r,t)$(hyps(s,r,t) < 0))) /
        (sum((xintrcon(intrcon,r),i,f), dsp_si(s,i,f,r,t)) + sum((xintrcon(intrcon,r),j), GD.L(s,j,r,t)) - sum(xintrcon(intrcon,r), hyps(s,r,t)$(hyps(s,r,t) < 0)));
share_inv_ic(s,intrcon,t) = 1 - share_spin_ic(s,intrcon,t);
share_inv_hours_ic("50",intrcon,t) = sum(s$(share_spin_ic(s,intrcon,t) < 0.5), hours(s,t));
share_inv_hours_ic("70",intrcon,t) = sum(s$(share_spin_ic(s,intrcon,t) < 0.3), hours(s,t));
share_inv_hours_ic("90",intrcon,t) = sum(s$(share_spin_ic(s,intrcon,t) < 0.1), hours(s,t));

$ifthen.static not %static%==no
$ifthen.hourly     %seg%==8760
hourly_export(r,s,"gen",xr) = eps + round(dspsrpt_r("supply",s,r,xr,"%static%"), 3);
hourly_export(r,s,"gen","cogen") = eps + round(dspsrpt_r("supply",s,r,"selfgen","%static%"), 3);
hourly_export(r,s,"stor-disc",j) = eps + round(GD.L(s,j,r,"%static%") - hyps(s,r,"%static%")$(sameas(j,"hyps-x") and hyps(s,r,"%static%") < 0),3);
hourly_export(r,s,"import",rr) = eps + round(domimp_s(s,r,rr,"%static%") / hours(s,"%static%"), 3);
hourly_export(r,s,"import","intl") = round(dspsrpt_r("supply",s,r,"intimp","%static%"), 3);
hourly_export(r,s,"export",rr) = eps + round(domexp_s(s,r,rr,"%static%") / hours(s,"%static%"), 3);
hourly_export(r,s,"export","intl") = eps + round(dspsrpt_r("demand",s,r,"intexp","%static%"), 3);
hourly_export(r,s,"stor-chrg",j) = eps + round(chrgpen(j) * G.L(s,j,r,"%static%") + max(hyps(s,r,"%static%"),0)$sameas(j,"hyps-x"), 3);
hourly_export(r,s,"demand","h2") = eps + round(dspsrpt_r("demand",s,r,"h2stortrn","%static%") + dspsrpt_r("demand",s,r,"h2prod_pa","%static%") + dspsrpt_r("demand",s,r,"h2prod_ht","%static%"), 3);
hourly_export(r,s,"demand","othfuel") = eps + round(dspsrpt_r("demand",s,r,"trfupsdac","%static%"), 3);
hourly_export(r,s,"demand","en4load") = eps + round(dspsrpt_r("demand",s,r,"load","%static%") + dspsrpt_r("demand",s,r,"localloss","%static%"),3);
hourly_export(r,s,"snsp","region") = eps + round(share_inv(s,r,"%static%"), 3);
hourly_export(r,s,"snsp","interconnect") = eps + round(sum(xintrcon(intrcon,r), share_inv_ic(s,intrcon,"%static%")), 3);
execute_unload '%elecrpt%\%scen%_hourly.gdx', hourly_export;
$endif.hourly
$endif.static

* Disposition report for existing coal
coaldisp_i(r,class,"1max",t)  = eps + sum((iclass(i,xcl,class)), xcap(i,r) * lifetime(i,r,t)) + (xcap("igcc-x",r) * lifetime("igcc-x",r,t))$(class.val eq 1);
coaldisp_i(r,class,"2asis",t) = eps + sum((iclass(i,xcl,class),vbase(v)), XC.L(i,v,r,t)) + sum(vbase(v), XC.L("igcc-x",v,r,t))$(class.val eq 1);
coaldisp_i(r,class,"3cofr",t) = eps + sum((iclass(conv,"cbcf",class),vbase,v), XC_C.L(conv,vbase,v,r,t));
coaldisp_i(r,class,"4cofr-pen",t) = eps + sum((iclass(conv,"cbcf",class),vbase,v), XC_C.L(conv,vbase,v,r,t) * (convadj(conv)-1));
coaldisp_i(r,class,"5cgas",t) = eps + sum((iclass(conv,"clng",class),vbase,v), XC_C.L(conv,vbase,v,r,t));
coaldisp_i(r,class,"6cgas-pen",t) = eps + sum((iclass(conv,"clng",class),vbase,v), XC_C.L(conv,vbase,v,r,t) * (convadj(conv)-1));
coaldisp_i(r,class,"7cbio",t) = eps + sum((iclass(conv,"bioc",class),vbase,v), XC_C.L(conv,vbase,v,r,t));
coaldisp_i(r,class,"8cbio-pen",t) = eps + sum((iclass(conv,"bioc",class),vbase,v), XC_C.L(conv,vbase,v,r,t) * (convadj(conv)-1));
coaldisp_i(r,class,"9cccs",t) = eps + sum((iclass(conv,"ccs9",class),vbase,v), XC_C.L(conv,vbase,v,r,t));
coaldisp_i(r,class,"10cccs-pen",t) = eps + sum((iclass(conv,"ccs9",class),vbase,v), XC_C.L(conv,vbase,v,r,t) * (convadj(conv)-1));
* Calculate early retirements here as residuals relative to maximum based on lifetime survival function
coaldisp_i(r,class,"11early",t) = eps + (coaldisp_i(r,class,"1max",t) - sum(nonretcdc(cdcat), coaldisp_i(r,class,cdcat,t)));
* Note that in static mode when t and tbase are identical, this term resolves to zero
coaldisp_i(r,class,"12age",t) = eps + (sum(tbase, coaldisp_i(r,class,"1max",tbase)) - coaldisp_i(r,class,"1max",t));

* Aggregate coal disposition (not disaggregating by class)
coaldisp_r(r,cdcat,t) = sum(class, coaldisp_i(r,class,cdcat,t));
coaldisp_r("us48",cdcat,t) = sum(r, coaldisp_r(r,cdcat,t));

* Include coal disposition in pivot report for standard output
clncdisprpt(r,"coal",cdcat,t) = coaldisp_r(r,cdcat,t);
clncdisprpt("us48","coal",cdcat,t) = coaldisp_r("us48",cdcat,t);

* Disposition report for existing nuclear
* Note that eps + x - x evaluates 0, while eps + (x - x) evaluates to eps
clncdisprpt(r,"nuclear","1max",t) = eps + xcap("nucl-x",r) * lifetime("nucl-x",r,t);
clncdisprpt(r,"nuclear","2asis",t) = eps + sum(vbase(v), XC.L("nucl-x",v,r,t));
clncdisprpt(r,"nuclear","11early",t) = eps + (clncdisprpt(r,"nuclear","1max",t) - clncdisprpt(r,"nuclear","2asis",t));
clncdisprpt(r,"nuclear","12age",t) = eps + (sum(tbase, clncdisprpt(r,"nuclear","1max",tbase)) - clncdisprpt(r,"nuclear","1max",t));
clncdisprpt("us48","nuclear",cdcat,t) = sum(r, clncdisprpt(r,"nuclear",cdcat,t));

* Regional water use (withdrawals and consumption) report (billion gallons per year)
wtrdraw(type,r,t) = 1e-3 * sum((idef(i,type),v,f), waterdraw(i,r) * XTWH.L(i,v,f,r,t));
wtrcons(type,r,t) = 1e-3 * sum((idef(i,type),v,f), watercons(i,r) * XTWH.L(i,v,f,r,t));
wtrdraw(fi,r,t) = 1e-3 * sum(v, waterdraw_trf(fi) * FX.L(fi,v,r,t));
wtrcons(fi,r,t) = 1e-3 * sum(v, watercons_trf(fi) * FX.L(fi,v,r,t));
wtrdraw(dac,r,t) = 1e-3 * sum(v, waterdraw_dac(dac) * DACANN.L(dac,v,r,t));
wtrcons(dac,r,t) = 1e-3 * sum(v, watercons_dac(dac) * DACANN.L(dac,v,r,t));
wtrdraw("elec_total",r,t) = sum(type, wtrdraw(type,r,t));
wtrcons("elec_total",r,t) = sum(type, wtrcons(type,r,t));
wtrdraw("trf_total",r,t) = sum(fi, wtrdraw(fi,r,t));
wtrcons("trf_total",r,t) = sum(fi, wtrcons(fi,r,t));
wtrdraw("dac_total",r,t) = sum(dac, wtrdraw(dac,r,t));
wtrcons("dac_total",r,t) = sum(dac, wtrcons(dac,r,t));
wtrdraw("supply_total",r,t) = wtrdraw("elec_total",r,t) + wtrdraw("trf_total",r,t) + wtrdraw("dac_total",r,t);
wtrcons("supply_total",r,t) = wtrcons("elec_total",r,t) + wtrcons("trf_total",r,t) + wtrcons("dac_total",r,t);

* National water use
wtrdraw(type,"us48",t) = sum(r, wtrdraw(type,r,t));
wtrcons(type,"us48",t) = sum(r, wtrcons(type,r,t));
wtrdraw(fi,"us48",t) = sum(r, wtrdraw(fi,r,t));
wtrcons(fi,"us48",t) = sum(r, wtrcons(fi,r,t));
wtrdraw(dac,"us48",t) = sum(r, wtrdraw(dac,r,t));
wtrcons(dac,"us48",t) = sum(r, wtrcons(dac,r,t));
wtrdraw("elec_total","us48",t) = sum((type,r), wtrdraw(type,r,t));
wtrcons("elec_total","us48",t) = sum((type,r), wtrcons(type,r,t));
wtrdraw("trf_total","us48",t) = sum((fi,r), wtrdraw(fi,r,t));
wtrcons("trf_total","us48",t) = sum((fi,r), wtrcons(fi,r,t));
wtrdraw("dac_total","us48",t) = sum((dac,r), wtrdraw(dac,r,t));
wtrcons("dac_total","us48",t) = sum((dac,r), wtrcons(dac,r,t));
wtrdraw("supply_total","us48",t) = wtrdraw("elec_total","us48",t) + wtrdraw("trf_total","us48",t) + wtrdraw("dac_total","us48",t);
wtrcons("supply_total","us48",t) = wtrcons("elec_total","us48",t) + wtrcons("trf_total","us48",t) + wtrcons("dac_total","us48",t);

* Supply curve: Installed capacity plotted against dispatch cost (GW and $ per MWh)
* Note that second v dimension captures conversions
supcurve("xc",i,v,v,r,t)$(ivrt(i,v,r,t) and XC.L(i,v,r,t) > 1e-3) = XC.L(i,v,r,t);
supcurve("xc","pvrf-xn",v,v,r,t) = rfpv_gw(r,t)$sameas(v,t);
supcurve("xc",i,vv,v,r,t)$(civrt(i,vv,v,r,t) and XC_C.L(i,vv,v,r,t) > 1e-3) = XC_C.L(i,vv,v,r,t);
supcurve("cost",i,v,v,r,t)$(ivrt(i,v,r,t) and XC.L(i,v,r,t) > 1e-3) = smin(ifl(i,f), icost(i,v,f,r,t));
supcurve("cost",i,vv,v,r,t)$(civrt(i,vv,v,r,t) and XC_C.L(i,vv,v,r,t) > 1e-3) = smin(ifl(i,f), icost_c(i,vv,v,f,r,t));

* Electricity capacity report by region (GW)
caprpt_r(r,kr,t) = eps + sum(i, xkr(i,kr) * ncap_i(i,r,t));
caprpt(rpt,kr,t) = eps + sum(xrpt(rpt,r), caprpt_r(r,kr,t));
natcaprpt(kr,t)  = eps + sum(r, caprpt_r(r,kr,t));
caprpt(rpt,"12Import Capacityacity",t) = eps + sum((xrpt(rpt,r)),sum(xrrpt(rrpt,rr)$(not sameas(rrpt,rpt)), tcap(rr,r) + TC.L(r,rr,t)));
caprpt_r(r,"12Import Capacityacity",t) = eps + sum(rr$(not sameas(r,rr)), tcap(rr,r) + TC.L(r,rr,t)) ;

* Peak grid-supplied load (GW)
uspeakload(t)   = smax(s, sum(r, GRID.L(s,r,t)));
peakload(rpt,t) = smax(s, sum(xrpt(rpt,r), GRID.L(s,r,t)));
peakload("MISO",t) = smax(s, sum(miso_r(r), GRID.L(s,r,t)));
peakload_r(r,t) = smax(s, GRID.L(s,r,t));
natcaprpt("13PeakLoad",t)  = eps + uspeakload(t)   ;
caprpt(rpt,"13PeakLoad",t) = eps + peakload(rpt,t) ;
caprpt_r(r,"13PeakLoad",t) = eps + peakload_r(r,t) ;

* Total input gas capacity (BBtu per hour)
gascap("ele",r,t) = sum(ivrt(i,v,r,t), XC.L(i,v,r,t) * htrate(i,v,"ppg",r,t)) + sum(civrt(i,vv,v,r,t), XC_C.L(i,vv,v,r,t) * htrate_c(i,vv,v,"ppg",r,t));
gascap("trf",r,t) = sum(fivrt(fi,v,r,t), FC.L(fi,v,r,t) * eptrf("ppg",fi,v));
gascap("ups",r,t) = QD_UPS.L("ppg",r,t) / 8.76 / 0.9;
gascap("dac",r,t) = sum((dac,v), DACC.L(dac,v,r,t) * epdac("%dacscn%","ppg",dac,v));
gascap("ele","usa",t) = sum(r, gascap("ele",r,t));
gascap("trf","usa",t) = sum(r, gascap("trf",r,t));
gascap("ups","usa",t) = sum(r, gascap("ups",r,t));
gascap("dac","usa",t) = sum(r, gascap("dac",r,t));

* Capacity report for graphical reporting
gencaprpt(r,grc,t,"gw") = eps + sum(xgc(i,grc), ncap_i(i,r,t));
* Include electricity storage discharge capacity; note that existing pumped hydro is included in GC if storage is active
* (otherwise, add it separately)
gencaprpt(r,"Storage (gross discharge)",t,"gw") = eps + sum(j, GC.L(j,r,t))
$if %storage%==no               + gcap("hyps-x",r)
;
* Include distributed generation categories
gencaprpt(r,"Distributed Solar PV",t,"gw") = eps + rfpv_gw(r,t);
gencaprpt(r,"Self Generation",t,"gw") = eps + selfgen(r,t) / 8.76;
* Sum to reporting regions and national total for above categories
gencaprpt(rpt,grc,t,"gw") = sum(xrrpt(rpt,r), gencaprpt(r,grc,t,"gw"));
gencaprpt("MISO",grc,t,"gw") = sum(miso_r(r), gencaprpt(r,grc,t,"gw"));
gencaprpt("US48",grc,t,"gw") = sum(r, gencaprpt(r,grc,t,"gw"));
gencaprpt(r,"Import Capacity",t,"gw") =  eps + sum(rr$(not sameas(r,rr)), tcap(rr,r) + TC.L(r,rr,t));
gencaprpt(r,"Peak End-Use Load",t,"gw") = eps + peakload_r(r,t);
gencaprpt(rpt,"Import Capacity",t,"gw") =  eps + sum((r,rr)$(xrrpt(rpt,r) and not xrrpt(rpt,rr)), tcap(rr,r) + TC.L(r,rr,t));
gencaprpt(rpt,"Peak End-Use Load",t,"gw") = eps + peakload(rpt,t);
gencaprpt("MISO","Import Capacity",t,"gw") =  eps + sum((r,rr)$(miso_r(r) and not miso_r(rr)), tcap(rr,r) + TC.L(r,rr,t));
gencaprpt("MISO","Peak End-Use Load",t,"gw") = eps + peakload("MISO",t);
gencaprpt("US48","Import Capacity",t,"gw") = eps;
gencaprpt("US48","Peak End-Use Load",t,"gw") = eps + uspeakload(t);

* Define net peak (binding hour for peakgrid equation, and hence reserve margin):
* When this equation is binding, PKGRID on the LHS is equal to the peak (over segments) of the
* RHS expression, which equals residual load net of dynamic contribution of renewables and storage
peakgrid_report("pkgrid",s,r,t) = PKGRID.L(r,t);
peakgrid_report("netgrid",s,r,t) = GRID.L(s,r,t)
                - sum(ivfrt(irnw(i),v,f,r,t), X.L(s,i,v,f,r,t))
                + hyps(s,r,t)
                - sum(j, GD.L(s,j,r,t) - chrgpen(j) * G.L(s,j,r,t))
                + sum(ef(f)$(not sameas(f,"h2-de")), (1/3.412) * QD_TRF_S.L(s,"ele",f,r,t))
                + QD_H2I_S.L(s,r,t)
                + QD_DAC_S.L(s,r,t)
                + sum(trf(f)$(not ef(f)), (1/3.412) * QD_TRF.L("ele",f,r,t)) / 8.76
                + (1/3.412) * QD_UPS.L("ele",r,t) / 8.76
;
peakgrid_report("grid",s,r,t) = GRID.L(s,r,t);
peakgrid_report("rnw",s,r,t) = - sum(ivfrt(irnw(i),v,f,r,t), X.L(s,i,v,f,r,t));
peakgrid_report("netstor",s,r,t) =
                hyps(s,r,t)
                - sum(j, GD.L(s,j,r,t) - chrgpen(j) * G.L(s,j,r,t))
;

* Identify segment(s) when net grid equals peak in each region (binding reserve margin segments)
pkgrid_s(s,r,t)$(abs(PKGRID.L(r,t) - peakgrid_report("netgrid",s,r,t)) < 1e-6) = yes;
peakgrid_bind("pkgrid",pkgrid_s(s,r,t)) = peakgrid_report("pkgrid",s,r,t);
peakgrid_bind("netgrid",pkgrid_s(s,r,t)) = peakgrid_report("netgrid",s,r,t);
peakgrid_bind("grid",pkgrid_s(s,r,t)) = peakgrid_report("grid",s,r,t);
peakgrid_bind("rnw",pkgrid_s(s,r,t)) = peakgrid_report("rnw",s,r,t);
peakgrid_bind("netstor",pkgrid_s(s,r,t)) = peakgrid_report("netstor",s,r,t);

netpkbal("installed",grc,pkgrid_s(s,r,t))$(not sameas(grc,"Peak End-Use Load")) = gencaprpt(r,grc,t,"gw");
netpkbal("available",grc,pkgrid_s(s,r,t)) = eps + sum(xgc(i,grc), acap_si(s,i,r,t));
netpkbal("available","Storage (gross discharge)",pkgrid_s(s,r,t)) = eps + sum(j, GC.L(j,r,t))
$if %storage%==no               + gcap("hyps-x",r)
;
netpkbal("available","Distributed Solar PV",pkgrid_s(s,r,t)) = eps + rfpv_out(s,r,t);
netpkbal("available","Self Generation",pkgrid_s(s,r,t)) = eps + selfgen(r,t) / 8.76;
netpkbal("available","Import Capacity",pkgrid_s(s,r,t)) = eps + sum(rr$(not sameas(r,rr)), tcap(rr,r) + TC.L(r,rr,t));
netpkbal("dispatch",grc,pkgrid_s(s,r,t)) = eps + sum(xgg(i,f,grc), dsp_si(s,i,f,r,t));
netpkbal("dispatch","Storage (gross discharge)",pkgrid_s(s,r,t)) = eps + sum(j, GD.L(s,j,r,t)) - hyps(s,r,t)$(hyps(s,r,t) < 0);
netpkbal("dispatch","Distributed Solar PV",pkgrid_s(s,r,t)) = eps + rfpv_out(s,r,t) - DRC.L(s,r,t);
netpkbal("dispatch","Self Generation",pkgrid_s(s,r,t)) = eps + selfgen(r,t) / 8.76;
netpkbal("dispatch","DR",pkgrid_s(s,r,t)) = eps + DR.L(s,r,t);
netpkbal("dispatch","Import-dom",pkgrid_s(s,r,t)) = eps + sum(rr$tcapcost(rr,r), E.L(s,rr,r,t));
netpkbal("dispatch","import-intl",pkgrid_s(s,r,t)) = eps - (ntxintl(r) / 8.76)$(ntxintl(r) < 0);
netpkbal("absorb","Load non-ldvDC",pkgrid_s(s,r,t)) = eps + load(s,r,t) + QD_EEU_S.L(s,r,t) - load_ldv(s,r,t) - sum(flx, QD_FLX_S.L(s,flx,r,t));
netpkbal("absorb","Load ldv",pkgrid_s(s,r,t)) = eps + load_ldv(s,r,t);
netpkbal("absorb","Load DC",pkgrid_s(s,r,t)) = eps + sum(flx, QD_FLX_S.L(s,flx,r,t));
netpkbal("absorb","localloss",pkgrid_s(s,r,t)) = eps + GRID.L(s,r,t) * (1 - 1 / localloss);
netpkbal("absorb","elys-dist",pkgrid_s(s,r,t)) = eps + (1/3.412) * QD_TRF_S.L(s,"ele","h2-de",r,t);
netpkbal("absorb","jchrg",pkgrid_s(s,r,t)) = eps + sum(j, chrgpen(j) * G.L(s,j,r,t)) + hyps(s,r,t)$(hyps(s,r,t) > 0);
netpkbal("absorb","h2prod",pkgrid_s(s,r,t)) = eps + sum(ef(f)$(h2f(f) and not sameas(f,"h2-de")), (1/3.412) * QD_TRF_S.L(s,"ele",f,r,t));
netpkbal("absorb","othintuse",pkgrid_s(s,r,t)) = eps +
*               Electricity consumed for e-fuel production (other than hydrogen)
                sum(ef(f)$(not h2f(f)), (1/3.412) * QD_TRF_S.L(s,"ele",f,r,t))
*               Electricity consumed for other non-electric fuels production
              + sum(trf(f)$(not ef(f)), (1/3.412) * QD_TRF.L("ele",f,r,t)) / 8.76
*               Electricity consumed for DAC (including flexible segment-level dispatch of e-DAC)
              + QD_DAC_S.L(s,r,t)
*               Electricity consumed for upstream fossil production
              + (1/3.412) * QD_UPS.L("ele",r,t) / 8.76
*               Electricity consumed for (central-scale) storage injection and inter-region transmission (export) of hydrogen
              + QD_H2I_S.L(s,r,t)
*               Electricity consumed for CO2 transport and storage
              + (1/3.412) * QD_CO2.L("ele",r,t) / 8.76
;
netpkbal("absorb","export",pkgrid_s(s,r,t)) = eps + sum(rr$tcapcost(r,rr), trnspen(r,rr) * E.L(s,r,rr,t)) + (ntxintl(r)/8.76)$(ntxintl(r) > 0);
netpkbal("rsvsup",grc,pkgrid_s(s,r,t)) = eps + sum((ivrt(i,v,r,t),xgc(i,grc)), rsvcc(i,r) * XC.L(i,v,r,t))
                                              + sum((ivrt(i,v,r,t),xgc(i,grc))$irnw(i), af(s,i,v,r,t) * XC.L(i,v,r,t));
netpkbal("rsvsup","Storage (gross discharge)",pkgrid_s(s,r,t)) = eps + sum(j, GD.L(s,j,r,t)) - hyps(s,r,t)$(hyps(s,r,t) < 0);
netpkbal("rsvsup","rsvoth",pkgrid_s(s,r,t)) = eps + rsvoth(r);
netpkbal("rsvdem","grid",pkgrid_s(s,r,t)) = eps + GRID.L(s,r,t);
netpkbal("rsvdem","jchrg",pkgrid_s(s,r,t)) = netpkbal("absorb","jchrg",s,r,t);
netpkbal("rsvdem","h2prod",pkgrid_s(s,r,t)) = netpkbal("absorb","h2prod",s,r,t);
netpkbal("rsvdem","othintuse",pkgrid_s(s,r,t)) = netpkbal("absorb","othintuse",s,r,t);
$if not %reserve%==no netpkbal("rsvdem","rmarg",pkgrid_s(s,r,t)) = eps + RMARG.L(r,t);

* Regional cumulative investments and conversions (GW)
cuminv(new(i),r,t) = 0;
cumconv(conv(i),v,r,t) = 0;
loop(t$(t.val > %tbase%),
  cuminv(new(i),r,t) = cuminv(i,r,t-1) + IX.L(i,r,t);
  cumconv(conv(i),v,r,t) = cumconv(i,v,r,t-1) + IX_C.L(i,v,r,t);
);
uscuminv(new(i),t) = sum(r, cuminv(i,r,t));
uscumconv(conv(i),v,t) = sum(r, cumconv(i,v,r,t));

* Report on retirement of existing capacity (GW and pct)
retirement(type,r,t,"GW" )$sum(idef(i,type), xcap(i,r)) = sum(idef(i,type), xcap(i,r)) - sum((idef(i,type),vbase), XC.L(i,vbase,r,t));
retirement(type,r,t,"pct")$sum(idef(i,type), xcap(i,r)) = retirement(type,r,t,"GW") / sum(idef(i,type), xcap(i,r));

* Annual renewable additions (GW per year)
annual_rnw("wind",r,t) = sum(i$((idef(i,"wind") and not sameas(i,"wind-r")) or idef(i,"wnos")), IX.L(i,r,t)) / 5;
annual_rnw("solar",r,t) = sum(i$(idef(i,"pvft") or idef(i,"pvsx") or idef(i,"pvdx")), IX.L(i,r,t)) / 5;

* Capacity operation report by region
opcap(type,r,t,"GW") = sum(idef(i,type), ncap_i(i,r,t));
opcap(type,r,t,"TWh-rlz") = gen(type,r,t);
opcap("clcl",r,t,"TWh-rlz") = gen("clcl",r,t) + gen("cbcf",r,t);
opcap(type,r,t,"TWh-ptl") = 1e-3 * sum((s,idef(i,type)), hours(s,t) * acap_si(s,i,r,t));
opcap(type,r,t,"Sp-pct")$opcap(type,r,t,"TWh-ptl") = (opcap(type,r,t,"TWh-ptl") - opcap(type,r,t,"TWh-rlz"))/ opcap(type,r,t,"TWh-ptl");
opcap(type,r,t,"CF-rlz")$opcap(type,r,t,"GW") = 1000 * opcap(type,r,t,"TWh-rlz") / (8760 * opcap(type,r,t,"GW"));
opcap(type,r,t,"CF-ptl")$opcap(type,r,t,"GW") = 1000 * opcap(type,r,t,"TWh-ptl") / (8760 * opcap(type,r,t,"GW"));

* Total curtailed wind and solar energy by region (TWh)
curtailment(r,t) = sum(type$(sameas(type,"pvft") or sameas(type,"pvsx") or sameas(type,"pvdx") or sameas(type,"wind") or sameas(type,"wnos")), opcap(type,r,t,"TWh-ptl") - opcap(type,r,t,"TWh-rlz")) + 1e-3 * sum(s, DRC.L(s,r,t) * hours(s,t));
curtail_type(type,r,t)$(sameas(type,"pvft") or sameas(type,"pvsx") or sameas(type,"pvdx") or sameas(type,"wind") or sameas(type,"wnos")) = opcap(type,r,t,"TWh-ptl") - opcap(type,r,t,"TWh-rlz");
curtail_type("pvrf",r,t) = 1e-3 * sum(s, DRC.L(s,r,t) * hours(s,t));

* National capacity operation report
usopcap(type,t,"GW") = sum((idef(i,type),r), ncap_i(i,r,t));
usopcap(type,t,"TWh-rlz") = usgen(type,t);
usopcap("clcl",t,"TWh-rlz") = usgen("clcl",t) + usgen("cbcf",t);
usopcap(type,t,"TWh-ptl") = 1e-3 * sum((s,idef(i,type),r), hours(s,t) * acap_si(s,i,r,t));
usopcap(type,t,"Sp-pct")$usopcap(type,t,"TWh-ptl") = (usopcap(type,t,"TWh-ptl") - usopcap(type,t,"TWh-rlz"))/ usopcap(type,t,"TWh-ptl");
usopcap(type,t,"CF-rlz")$usopcap(type,t,"GW") = 1000 * usopcap(type,t,"TWh-rlz") / (8760 * usopcap(type,t,"GW"));
usopcap(type,t,"CF-ptl")$usopcap(type,t,"GW") = 1000 * usopcap(type,t,"TWh-ptl") / (8760 * usopcap(type,t,"GW"));

* Nuclear capacity operation report
nuccap(i,r,t,"GW")$idef(i,"nucl") = ncap_i(i,r,t);
nuccap(i,r,t,"TWh-rlz")$idef(i,"nucl") = gen_i(i,"ura",r,t);
nuccap(i,r,t,"TWh-ptl")$idef(i,"nucl") = 1e-3 * sum(s, hours(s,t) * acap_si(s,i,r,t));

* Capacity utilization report
windutil(i,r,t,"absorb")$idef(i,"wind") = gen_i(i,"rnw",r,t);
windutil(i,r,t,"spill")$idef(i,"wind") = 1e-3 * sum(s, hours(s,t) * acap_si(s,i,r,t)) - gen_i(i,"rnw",r,t);
caputil(s,type,r,t,"dispatch") = sum((ifl(i,f),idef(i,type)), dsp_si(s,i,f,r,t));
caputil(s,type,r,t,"idle") = sum((ifl(i,f),idef(i,type)), acap_si(s,i,r,t) - dsp_si(s,i,f,r,t));

* * * Operating reserve reporting

$ifthen.orrep not %opres%==no
* Quantity spinning
rsvrpt("SR",type,r,t) = 1e-3 * sum((s,idef(i,type),v), SR.L(s,i,v,r,t) * hours(s,t));
rsvrpt("SR","total",r,t) = sum(type, rsvrpt("SR",type,r,t));
rsvrpt("SR","req",r,t) = 1e-3 * sum(s, SPINREQ.L(s,r,t) * hours(s,t));
* Quantity quick-start
rsvrpt("QS",type,r,t) = 1e-3 * sum((s,idef(i,type),v), QS.L(s,i,v,r,t) * hours(s,t));
rsvrpt("QS","total",r,t) = sum(type, rsvrpt("QS",type,r,t));
rsvrpt("QS","req",r,t) = 1e-3 * sum(s, QSREQ.L(s,r,t) * hours(s,t));
* Operating reserve prices
oprespr("spin",s,r,t) = 1e-8 + 1e3 * abs(srreqt.M(s,r,t)) / dfact(t);
oprespr("qstart",s,r,t) = 1e-8 + 1e3 * abs(qsreqt.M(s,r,t)) / dfact(t);
$endif.orrep

* * * Concentrated solar power (CSP) reporting

* Calculate implied solar multiplier
csp_sm(cspi,r,t)$sum(v, XC.L(cspi,v,r,t)) = C_CSP_CR.L(cspi,r,t) / sum(v, XC.L(cspi,v,r,t)) * csp_eff_p * csp_eff_r;
* Calculate realized storage hours (room-door ratio)
rghours_csp(cspi,r,t)$sum(v, XC.L(cspi,v,r,t)) = GR_CSP.L(cspi,r,t) / sum(v, XC.L(cspi,v,r,t)) * csp_eff_p * csp_eff_r;
* Calculate cost components of CSP
finalcspcost(cspi,r,"power",t)     = sum(tv(t,v), capcost(cspi,v,r));
finalcspcost(cspi,r,"receiver",t)  = csp_cost_r * 1.173 * C_CSP_CR.L(cspi,r,t);
finalcspcost(cspi,r,"collector",t) = ((csp_cost_c * 1.173) / csp_eff_c) * C_CSP_CR.L(cspi,r,t);
finalcspcost(cspi,r,"storage",t)   = irg_csp(cspi) * GR_CSP.L(cspi,r,t);
finalcspcost(cspi,r,"total",t)     = finalcspcost(cspi,r,"power",t) + finalcspcost(cspi,r,"receiver",t) + finalcspcost(cspi,r,"collector",t) + finalcspcost(cspi,r,"storage",t);

* * Fuel use reporting

* Technology-level non-electric fuel use for generation
fuel_i(i,f,r,t) = sum(ivfrt(i,v,f,r,t), XTWH.L(i,v,f,r,t) * htrate(i,v,f,r,t)) + sum(civfrt(i,vv,v,f,r,t), XTWH_C.L(i,vv,v,f,r,t) * htrate_c(i,vv,v,f,r,t));
fuel_i(i,f,"us48",t) = sum(r, fuel_i(i,f,r,t));

* Fuel consumption by segment for electric and e-fuels sectors (BBtu per hour)
fuel_s(s,f,r,t)$(not sameas(f,"ele")) =
                 sum(ivfrt(i,v,f,r,t), htrate(i,v,f,r,t) * X.L(s,i,v,f,r,t)) +
                 sum(civfrt(i,vv,v,f,r,t), htrate_c(i,vv,v,f,r,t) * X_C.L(s,i,vv,v,f,r,t)) +
                 sum(fivrt(hi,v,r,t), eptrf(f,hi,v) * HX.L(s,hi,v,r,t))
* Include CAES fuel use
$ifi not %storage%==no  + sum(j, htrate_g(j) * GD.L(s,j,r,t))$sameas(f,"ppg")
;

* Fuel balance reporting
* Annual quantity supplied for non-electric fuels
loop(f$(not sameas(f,"ele")),
* Report showing terms of fuel balance equation fuelbal and fuelbal_blend equations
fuelbal_rpt("QSF",f,r,t)$(not blend(f)) = QSF.L(f,r,t);
fuelbal_rpt("QSF",f,r,t)$(    blend(f)) = sum(dst, QS_BLEND.L(dst,f,r,t));
* Annual quantity consumed by upstream oil and gas (and coal) sectors
fuelbal_rpt("QD_UPS",f,r,t) = QD_UPS.L(f,r,t);
* Annual quantity consumed in blending sectors
fuelbal_rpt("QD_BLEND",f,r,t) = sum((blendmap(f,ff),dst_f(dst,ff)), QD_BLEND.L(f,dst,ff,r,t));
* Annual quantity consumed in transformation sectors
fuelbal_rpt("QD_TRF",f,r,t) = sum(trf(ff), QD_TRF.L(f,ff,r,t));
* Annual quantity consumed in production of bio feedstocks
fuelbal_rpt("QD_BFS",f,r,t) = sum((bfs,bfsc), epbfs(f,bfs) * QS_BFS.L(bfs,bfsc,r,t));
* Annual quantity consumed for direct air capture
fuelbal_rpt("QD_DAC",f,r,t) = QD_DAC.L(f,r,t);
* Annual quantity consumed in electric sector (fixed) plus
fuelbal_rpt("QD_ELEC",f,r,t) = QD_ELEC.L(f,r,t);
* Annual quantity consumed in end-use sectors (fixed) plus endogenous
fuelbal_rpt("qd_enduse_x",f,r,t) = qd_enduse(f,r,t);
fuelbal_rpt("QD_EEU",f,r,t) = sum(kf, QD_EEU.L(kf,f,r,t));
* Calculated net trade such that supply matches demand
* Calculate total demand term in fuelbal
fuelbal_rpt("QD_Tot",f,r,t) =
fuelbal_rpt("QD_UPS",f,r,t) +
fuelbal_rpt("QD_BLEND",f,r,t) +
fuelbal_rpt("QD_TRF",f,r,t) +
fuelbal_rpt("QD_BFS",f,r,t) +
fuelbal_rpt("QD_DAC",f,r,t) +
fuelbal_rpt("QD_ELEC",f,r,t) +
fuelbal_rpt("qd_enduse_x",f,r,t) +
fuelbal_rpt("QD_EEU",f,r,t)
;
* Calculate implied net exports
fuelbal_rpt("NTX_calc",f,r,t) = fuelbal_rpt("QSF",f,r,t) - fuelbal_rpt("QD_Tot",f,r,t);
* Compare to actual net exports
fuelbal_rpt("NTX.L",f,r,t) = NTX.L(f,r,t);
* Calculate other fuel balance terms
fuelbal_rpt("QSF",f,"us48",t) = sum(r, fuelbal_rpt("QSF",f,r,t));
fuelbal_rpt("QD_UPS",f,"us48",t) = sum(r, fuelbal_rpt("QD_UPS",f,r,t));
fuelbal_rpt("QD_BLEND",f,"us48",t) = sum(r, fuelbal_rpt("QD_BLEND",f,r,t));
fuelbal_rpt("QD_TRF",f,"us48",t) = sum(r, fuelbal_rpt("QD_TRF",f,r,t));
fuelbal_rpt("QD_BFS",f,"us48",t) = sum(r, fuelbal_rpt("QD_BFS",f,r,t));
fuelbal_rpt("QD_DAC",f,"us48",t) = sum(r, fuelbal_rpt("QD_DAC",f,r,t));
fuelbal_rpt("QD_ELEC",f,"us48",t) = sum(r, fuelbal_rpt("QD_ELEC",f,r,t));
fuelbal_rpt("qd_enduse_x",f,"us48",t) = sum(r, fuelbal_rpt("qd_enduse_x",f,r,t));
fuelbal_rpt("QD_EEU",f,"us48",t) = sum(r, fuelbal_rpt("QD_EEU",f,r,t));
fuelbal_rpt("QD_Tot",f,"us48",t) = sum(r, fuelbal_rpt("QD_Tot",f,r,t));
fuelbal_rpt("NTX_calc",f,"us48",t) = sum(r, fuelbal_rpt("NTX_calc",f,r,t));
fuelbal_rpt("NTX.L",f,"us48",t) = sum(r, fuelbal_rpt("NTX.L",f,r,t));
);

* Blended fuels report: Matching blend constituents to total supply by destination
fuelbal_blend_rpt(ff,dst,f,r,t)$blendmap(ff,f) = QD_BLEND.L(ff,dst,f,r,t);
fuelbal_blend_rpt("QS_Tot",dst,f,r,t)$blend(f) = QS_BLEND.L(dst,f,r,t);

fuelbal_blend_rpt(ff,"QD_Tot",f,r,t)$blendmap(ff,f) = sum(dst, QD_BLEND.L(ff,dst,f,r,t));
fuelbal_blend_rpt("QS_Tot","QD_Tot",f,r,t)$blend(f) = sum(dst, QS_BLEND.L(dst,f,r,t));

fuelbal_blend_rpt(ff,dst,f,"us48",t) = sum(r, fuelbal_blend_rpt(ff,dst,f,r,t));
fuelbal_blend_rpt("QS_Tot",dst,f,"us48",t) = sum(r, fuelbal_blend_rpt("QS_Tot",dst,f,r,t));

fuelbal_blend_rpt(ff,"QD_Tot",f,"us48",t)$blendmap(ff,f) = sum(dst, fuelbal_blend_rpt(ff,dst,f,"us48",t));
fuelbal_blend_rpt("QS_Tot","QD_Tot",f,"us48",t)$blend(f) = sum(dst, fuelbal_blend_rpt("QS_Tot",dst,f,"us48",t));

blend_shr(ff,dst,f,r,t)$(blendmap(ff,f) and fuelbal_blend_rpt("QS_Tot",dst,f,r,t)) = fuelbal_blend_rpt(ff,dst,f,r,t) / fuelbal_blend_rpt("QS_Tot",dst,f,r,t);
blend_shr(ff,"QD_Tot",f,r,t)$(blendmap(ff,f) and fuelbal_blend_rpt("QS_Tot","QD_Tot",f,r,t)) = fuelbal_blend_rpt(ff,"QD_Tot",f,r,t) / fuelbal_blend_rpt("QS_Tot","QD_Tot",f,r,t);

blend_shr(ff,dst,f,"us48",t)$(blendmap(ff,f) and fuelbal_blend_rpt("QS_Tot",dst,f,"us48",t)) = fuelbal_blend_rpt(ff,dst,f,"us48",t) / fuelbal_blend_rpt("QS_Tot",dst,f,"us48",t);
blend_shr(ff,"QD_Tot",f,"us48",t)$(blendmap(ff,f) and fuelbal_blend_rpt("QS_Tot","QD_Tot",f,"us48",t)) = fuelbal_blend_rpt(ff,"QD_Tot",f,"us48",t) / fuelbal_blend_rpt("QS_Tot","QD_Tot",f,"us48",t);

* Fuel balance that combines blend constituents with non-blended fuels (and omits blended fuels)
fuelbal_rpt2("QSF",f,r,t) = fuelbal_rpt("QSF",f,r,t)$(not blend(f));
fuelbal_rpt2("QD_UPS",f,r,t) = fuelbal_rpt("QD_UPS",f,r,t)$(not blend(f)) + sum(blendmap(f,ff), fuelbal_blend_rpt(f,"ups",ff,r,t));
fuelbal_rpt2("QD_TRF",f,r,t) = fuelbal_rpt("QD_TRF",f,r,t)$(not blend(f)) + sum((blendmap(f,ff),sameas(dst,trf)), fuelbal_blend_rpt(f,dst,ff,r,t));
fuelbal_rpt2("QD_BFS",f,r,t) = fuelbal_rpt("QD_BFS",f,r,t)$(not blend(f)) + sum(blendmap(f,ff), fuelbal_blend_rpt(f,"bfs",ff,r,t));
fuelbal_rpt2("QD_DAC",f,r,t) = fuelbal_rpt("QD_DAC",f,r,t)$(not blend(f)) + sum(blendmap(f,ff), fuelbal_blend_rpt(f,"dac",ff,r,t));
fuelbal_rpt2("QD_ELEC",f,r,t) = fuelbal_rpt("QD_ELEC",f,r,t)$(not blend(f)) + sum(blendmap(f,ff), fuelbal_blend_rpt(f,"ele",ff,r,t));
fuelbal_rpt2("QD_ENDUSE",f,r,t) = (fuelbal_rpt("qd_enduse_x",f,r,t) + fuelbal_rpt("QD_EEU",f,r,t))$(not blend(f)) +
                                  sum((blendmap(f,ff),sameas(dst,kf)), fuelbal_blend_rpt(f,dst,ff,r,t));
fuelbal_rpt2("QD_Tot",f,r,t) = fuelbal_rpt("QD_Tot",f,r,t)$(not blend(f)) + sum(blendmap(f,ff), fuelbal_blend_rpt(f,"QD_Tot",ff,r,t));

* Combined fuel balance with detail on upstream sectors
fuelbal_ups_rpt2("col",f,r,t) = sum((ff,rr)$(sameas(ff,"cls") or sameas(ff,"clm")),
      epups_fuels(f,r,ff,rr,t) * QSF.L(ff,rr,t)$(not blend(f)) +
      sum(blendmap(f,fff), blend_shr(f,"ups",fff,r,t) * epups_fuels(fff,r,ff,rr,t) * QSF.L(ff,rr,t)));
fuelbal_ups_rpt2("olg",f,r,t) = sum((ff,rr),
      epups_olg(f,r,ff,rr,t) * QSF.L(ff,rr,t)$(not blend(f)) +
      sum(blendmap(f,fff), blend_shr(f,"ups",fff,r,t) * epups_olg(fff,r,ff,rr,t) * QSF.L(ff,rr,t)));
fuelbal_ups_rpt2("rfp",f,r,t) = sum((ff,rr),
      epups_rfp(f,r,ff,rr,t) * QSF.L(ff,rr,t)$(not blend(f)) +
      sum(blendmap(f,fff), blend_shr(f,"ups",fff,r,t) * epups_rfp(fff,r,ff,rr,t) * QSF.L(ff,rr,t)));

* Combined fuel balance with detail on transformation sectors
fuelbal_trf_rpt2(trf,f,r,t) = QD_TRF.L(f,trf,r,t)$(not blend(f)) + sum((blendmap(f,ff),dst)$sameas(dst,trf), fuelbal_blend_rpt(f,dst,ff,r,t));

* Share of regional hydrogen demand allocated to petroleum refineries
h2nh3_shr("h2","refinery",r,t)$(fuelbal_rpt("QD_Tot","h2",r,t) > 1e-3) = fuelbal_rpt("QD_UPS","h2",r,t) / fuelbal_rpt("QD_Tot","h2",r,t);
* Share of regional hydrogen demand allocated to organic chemical industry for non-energy (excluding ammonia)
h2nh3_shr("h2","indprod_orc",r,t)$(fuelbal_rpt("QD_Tot","h2",r,t) > 1e-3) = sum(kf, qd_enduse_non(kf,"h2",r,t)) / fuelbal_rpt("QD_Tot","h2",r,t);

* Share of regional ammonia demand allocated to non-energy use (for fertilizer)
h2nh3_shr("nh3","indprod",r,t)$(fuelbal_rpt("QD_Tot","nh3",r,t) > 1e-3) = sum(kf, qd_enduse_non(kf,"nh3",r,t)) / fuelbal_rpt("QD_Tot","nh3",r,t);
* Share of regional ammonia demand allocated to fuel (everything else)
h2nh3_shr("nh3","fuelsup",r,t) = 1 - h2nh3_shr("nh3","indprod",r,t);

* Share of regional hydrogen demand allocated to direct synthesis of ammonia for non-energy (excluding H-B process)
h2nh3_shr("h2","indprod_nh3",r,t)$(fuelbal_rpt("QD_Tot","h2",r,t) > 1e-3) = h2nh3_shr("nh3","indprod",r,t) * QD_TRF.L("h2","nh3",r,t) / fuelbal_rpt("QD_Tot","h2",r,t);
* Share of regional hydrogen demand used for fuel, including direct use, blending, or input to synthetic H-C or ammonia used as fuel (everything else)
h2nh3_shr("h2","fuelsup",r,t) = 1 - h2nh3_shr("h2","refinery",r,t) - h2nh3_shr("h2","indprod_orc",r,t) - h2nh3_shr("h2","indprod_nh3",r,t);


* * End-use sectors

* Break out endogenous energy use into sectors
qd_eeu_kf(kf,f,r,t) =
                  sum((vcht(vc_mdhd(vc),vht,v_e,t),di), epvmt_r(vc,vht,f,r,v_e,t) * di_vmt(vc,di) * vmti(vc) * VDI.L(vc,vht,v_e,di,r,t))$sameas(kf,"mdhd") +
                  sum((kfvc(kf,vc),vcht(vc_nnrd(vc),vht,v_e,t)), epsrv_r(vc,vht,f,r,v_e,t) * XV.L(vc,vht,v_e,r,t));
qd_eeu_vc(vc,f,r,t) =
                  sum((vcht(vc_mdhd(vc),vht,v_e,t),di), epvmt_r(vc,vht,f,r,v_e,t) * di_vmt(vc,di) * vmti(vc) * VDI.L(vc,vht,v_e,di,r,t)) +
                  sum(vcht(vc_nnrd(vc),vht,v_e,t), epsrv_r(vc,vht,f,r,v_e,t) * XV.L(vc,vht,v_e,r,t));
vmt_vc(vc,vht,t) = sum((vcht(vc_mdhd(vc),vht,v_e,t),di,r), di_vmt(vc,di) * vmti(vc) * VDI.L(vc,vht,v_e,di,r,t));
qd_eeu_vc(vc,f,"us48",t) = sum(r, qd_eeu_vc(vc,f,r,t));

* Include refeuling costs for reporting (normalize per service unit for non-road vehicles)
refuel_cost(vc_mdhd(vc),vht,r,t) = refuel_cost_mdhd(vc,vht,t);
refuel_cost(vc_nnrd(vc),vht,r,t) = sum(sameas(v_e,t), refuel_cost_nnrd(vc,vht,t) * sum(df, epsrv_r(vc,vht,df,r,v_e,t))) / crf_nnrd(vc);

* Detailed reports for MD-HD and NNRD: Vehicle sales, stock, and VMT (millions)
mdhd_rpt("sales",vc,vht,r,t) = IV.L(vc,vht,r,t);
mdhd_rpt("sales",vc,vht,"us48",t) = sum(r, IV.L(vc,vht,r,t));
mdhd_rpt("sales","mdhd_tot",vht,r,t) = sum(vc, mdhd_rpt("sales",vc,vht,r,t));
mdhd_rpt("sales","mdhd_tot",vht,"us48",t) = sum(vc, mdhd_rpt("sales",vc,vht,"us48",t));
mdhd_rpt("stock",vc,vht,r,t) = sum(v_e, XV.L(vc,vht,v_e,r,t));
mdhd_rpt("stock",vc,vht,"us48",t) = sum((r,v_e), XV.L(vc,vht,v_e,r,t));
mdhd_rpt("stock","mdhd_tot",vht,r,t) = sum(vc, mdhd_rpt("stock",vc,vht,r,t));
mdhd_rpt("stock","mdhd_tot",vht,"us48",t) = sum(vc, mdhd_rpt("stock",vc,vht,"us48",t));
mdhd_rpt("vmt",vc,vht,r,t) = sum((di,v_e), di_vmt(vc,di) * vmti(vc) * VDI.L(vc,vht,v_e,di,r,t));
mdhd_rpt("vmt",vc,vht,"us48",t) = sum((di,r,v_e), di_vmt(vc,di) * vmti(vc) * VDI.L(vc,vht,v_e,di,r,t));
mdhd_rpt("vmt","mdhd_tot",vht,r,t) = sum(vc, mdhd_rpt("vmt",vc,vht,r,t));
mdhd_rpt("vmt","mdhd_tot",vht,"us48",t) = sum(vc, mdhd_rpt("vmt",vc,vht,"us48",t));

* Fuel use reporting for MD-HD and non-road (TBtu)
mdhd_fuel(vc,df,t) = sum((vht,di,r,v_e), epvmt_r(vc,vht,df,r,v_e,t) * di_vmt(vc,di) * vmti(vc) * VDI.L(vc,vht,v_e,di,r,t));
nnrd_fuel(vc,df,t) = sum((vht,v_e,r), epsrv_r(vc,vht,df,r,v_e,t) * XV.L(vc,vht,v_e,r,t));

* Combine endogenous and exogenous end-use activities (TBtu)
qd_enduse_rpt(kf,f,r,t) = qd_enduse_kf(kf,f,r,t) + qd_eeu_kf(kf,f,r,t);
qd_enduse_rpt(kf,f,"us48",t) = sum(r, qd_enduse_rpt(kf,f,r,t));

* Breakout on annual electricity consumption (TWh)
eleconrpt("bld",r,t) = (1/3.412) * (qd_enduse_rpt("res","ele",r,t) + qd_enduse_rpt("com","ele",r,t));
eleconrpt("ind",r,t) = (1/3.412) * (qd_enduse_rpt("ind-sm","ele",r,t) + qd_enduse_rpt("ind-lg","ele",r,t));
eleconrpt("trn",r,t) = (1/3.412) * (qd_enduse_rpt("ldv","ele",r,t) + qd_enduse_rpt("mdhd","ele",r,t));
eleconrpt("trf",r,t) = gencaprpt(r,"Other Intermediate Use",t,"twh");
eleconrpt("h2e",r,t) = gencaprpt(r,"Energy for H2 Production",t,"twh") +
* Distributed electrolysis and hydrogen storage
        (1/3.412) * 1e-3 * sum(s, hours(s,t) * (QD_TRF_S.L(s,"ele","h2-de",r,t) + sum(hkf("frc",f), epchrg_h("frc",t) * G_H.L(s,"frc",f,r,t))))
;
eleconrpt("total",r,t) = eleconrpt("bld",r,t) + eleconrpt("ind",r,t) + eleconrpt("trn",r,t) + eleconrpt("trf",r,t) + eleconrpt("h2e",r,t);
eleconrpt("bld","us48",t) = sum(r, eleconrpt("bld",r,t));
eleconrpt("ind","us48",t) = sum(r, eleconrpt("ind",r,t));
eleconrpt("trn","us48",t) = sum(r, eleconrpt("trn",r,t));
eleconrpt("trf","us48",t) = sum(r, eleconrpt("trf",r,t));
eleconrpt("h2e","us48",t) = sum(r, eleconrpt("h2e",r,t));
eleconrpt("total","us48",t) = sum(r, eleconrpt("total",r,t));

* Check on exogenous versus endogenous end-use sector energy use (TBtu)
enduse_chk("eu-x",vc,f,t) = sum(r, mdhd_fuel_r(vc,f,r,t) + nnrd_fuel_r("opt",vc,f,r,t));
enduse_chk("eu-x","tot",f,t) = sum(vc, enduse_chk("eu-x",vc,f,t));
enduse_chk("eu-e",vc_mdhd(vc),f,t) = sum((vcht(vc,vht,v_e,t),di,r), epvmt_r(vc,vht,f,r,v_e,t) * di_vmt(vc,di) * vmti(vc) * VDI.L(vc,vht,v_e,di,r,t));
enduse_chk("eu-e",vc_nnrd(vc),f,t) = sum((vcht(vc,vht,v_e,t),r), epsrv_r(vc,vht,f,r,v_e,t) * XV.L(vc,vht,v_e,r,t));
enduse_chk("eu-e","tot",f,t) = sum(vc, enduse_chk("eu-e",vc,f,t));
enduse_chk_twh_r("eu-x",kf,r,t) = (sum(vc, mdhd_fuel_r(vc,"ele",r,t))$sameas(kf,"mdhd") + sum(kfvc(kf,vc), nnrd_fuel_r("opt",vc,"ele",r,t))) / 3.412;
enduse_chk_twh_r("eu-e",kf,r,t) = qd_eeu_kf(kf,"ele",r,t) / 3.412;

* Regional electricity demand in fuels sectors (TBtu)
elec_fuels_rpt("h2e",r,t) = eps + 1e-3 * sum(s, hours(s,t) * sum(ef(f)$h2f(f), QD_TRF_S.L(s,"ele",f,r,t)));
elec_fuels_rpt("h2nh3-n",r,t) = eps + QD_TRF.L("ele","h2-n",r,t) + QD_TRF.L("ele","nh3-n",r,t);
elec_fuels_rpt("ups",r,t) = eps + QD_UPS.L("ele",r,t);
elec_fuels_rpt("lcf_inf",r,t) = eps + QD_CO2.L("ele",r,t) +
* Also include electricity consumed for hydrogen storage and infrastructure
       1e-3 * sum(s, hours(s,t) * (3.412 * QD_H2I_S.L(s,r,t) + sum(hkf("frc",f), epchrg_h("frc",t) * G_H.L(s,"frc",f,r,t))));
elec_fuels_rpt("biofuels",r,t) = eps + sum(bfl(f), QD_TRF.L("ele",f,r,t));
elec_fuels_rpt("nh3-e",r,t) = eps + QD_TRF.L("ele","nh3-e",r,t);
elec_fuels_rpt("syn_fuel",r,t) = eps + sum(syn(f), QD_TRF.L("ele",f,r,t));
elec_fuels_rpt("dac_",r,t) = eps + 1e-3 * sum(s, hours(s,t) * 3.412 * QD_DAC_S.L(s,r,t));
* The following is an alternative breakout of non-electric fuels
elec_fuels_rpt("ethanol",r,t) = eps + sum(vt(v,t), eptrf("ele","eth-conv",v) * FX.L("eth-conv",v,r,t));
elec_fuels_rpt("new-bio-b4ccs",r,t) = eps + sum((bi(fi),vt(v,t)), (eptrf("ele",fi,v) - epccs("ele",fi,v)) * FX.L(fi,v,r,t));
elec_fuels_rpt("h2nh3-b4ccs",r,t) = eps + sum((fi,vt(v,t))$(sameas(fi,"gsst") or sameas(fi,"gsst-ccs") or sameas(fi,"hbbs") or sameas(fi,"hbbs-ccs")), (eptrf("ele",fi,v) - epccs("ele",fi,v)) * FX.L(fi,v,r,t));
elec_fuels_rpt("fuels-ccs",r,t) = eps + sum((fi,vt(v,t)), epccs("ele",fi,v) * FX.L(fi,v,r,t));

* * * Detailed electricity use report

* Bring in endogenous MD-HD and non-road energy use (replace exogenous use)
qdr_tot_e(k2,u,df,r,t) = qdr_tot_x(k2,u,df,r,t) +
                         sum(k2vc(k2,vc_mdhd(vc))$sameas(u,vc), qd_eeu_vc(vc,df,r,t) - mdhd_fuel_r(vc,df,r,t)) +
                         sum(k2vc(k2,vc_nnrd(vc))$sameas(u,vc), qd_eeu_vc(vc,df,r,t) - nnrd_fuel_r("opt",vc,df,r,t))
;
qdr_chk("qdr_x",kf,df,t) = sum((kfmap(kf,k2),u,r), qdr_tot_x(k2,u,df,r,t));
qdr_chk("qdr_e",kf,df,t) = sum((kfmap(kf,k2),u,r), qdr_tot_e(k2,u,df,r,t));
qdr_chk("enduse_rpt",kf,df,t) = sum(r, qd_enduse_rpt(kf,df,r,t));
sindex(k2,u,r,t)$(sindex(k2,u,r,"2020") and t.val > 2015) = sindex(k2,u,r,t) / sindex(k2,u,r,"2020");
eindex(k2,u,r,t)$(eindex(k2,u,r,"2020") and t.val > 2015) = eindex(k2,u,r,t) / eindex(k2,u,r,"2020");

* Buildings uses:
* Subtract out data centers and new heat pumps and non-building commercial uses
ele_det_r("03-Data",r,t) = (1/3.412) * qdr_tot_e("com","dat","ele",r,t);
ele_det_r("04-New-HP",r,t) = (1/3.412) * sum(k2, newhp_ele(k2,r,t));
ele_det_r("01-Ex-Bld",r,t) = (1/3.412) * sum((b(k2),u)$(not sameas(u,"nnb")), qdr_tot_e(k2,u,"ele",r,t)) - ele_det_r("03-Data",r,t) - ele_det_r("04-New-HP",r,t);
* Industrial uses:
ele_det_r("02-Ex-Ind",r,t) = (1/3.412) * sum((k2,u)$(kfmap("ind-sm",k2) or kfmap("ind-lg",k2) or sameas(u,"nnb")),
        min(qdr_tot_e(k2,u,"ele",r,t), qdr_tot_e(k2,u,"ele",r,"2020") * sindex(k2,u,r,t) * eindex(k2,u,r,t) * (1 - eff_scen(k2,u,r,t))))
* Include electricity use for conventional fuels production including ethanol and ammonia
        + (1/3.412) * (elec_fuels_rpt("ups",r,t) + elec_fuels_rpt("ethanol",r,t) + elec_fuels_rpt("h2nh3-b4ccs",r,t))
;
ele_det_r("05-New-Ind-E",r,t) = (1/3.412) * sum((k2,u)$(kfmap("ind-sm",k2) or kfmap("ind-lg",k2) or sameas(u,"nnb")),
        max(qdr_tot_e(k2,u,"ele",r,t) - qdr_tot_e(k2,u,"ele",r,"2020") * sindex(k2,u,r,t) * eindex(k2,u,r,t) * (1 - eff_scen(k2,u,r,t)), 0))
* Include electrification of ammonia and hydrogen for non-electric uses
        + (1/3.412) * elec_fuels_rpt("nh3-e",r,t) * h2nh3_shr("nh3","indprod",r,t)
* Include electricity use for DAC and fuels production (including CCS) except for electrolysis
        + (1/3.412) * (elec_fuels_rpt("dac_",r,t) + elec_fuels_rpt("fuels-ccs",r,t))
        + (1/3.412) * (elec_fuels_rpt("new-bio-b4ccs",r,t) + elec_fuels_rpt("syn_fuel",r,t) + elec_fuels_rpt("nh3-e",r,t) * h2nh3_shr("nh3","fuelsup",r,t))
;
ele_det_r("06-LDV",r,t) = (1/3.412) * qd_enduse_rpt("ldv","ele",r,t);
ele_det_r("07-MDHD",r,t) = (1/3.412) * qd_enduse_rpt("mdhd","ele",r,t);
ele_det_r("08-Elys",r,t) = (1/3.412) * elec_fuels_rpt("h2e",r,t);

ele_det_us(ed,t) = sum(r, ele_det_r(ed,r,t));

* Petroleum refining (regional level inferred)
* Total supply of refined product and HGL
rfp_rpt(f,"us48",t)$(rfp(f) or sameas(f,"hgl")) = sum(rr, QSF.L(f,rr,t));
* Infer regional level based on supply shares
rfp_rpt(rfp(f),r,t) = sum(rr, upsprod_fuels(f,r,f,rr,t) * QSF.L(f,rr,t));
rfp_rpt("hgl",r,t) = sum(rr, upsprod_fuels("hgl",r,"hgl",rr,t) * QSF.L("hgl",rr,t));

* Gas upstream (regional level inferred)
gas_rpt(r,t) = sum(rr, upsprod_fuels("gas",r,"gas",rr,t) * QSF.L("gas",rr,t));
gastrade_rpt(r,rr,t) = upsprod_fuels("gas",r,"gas",rr,t) * QSF.L("gas",rr,t);

* Transformation sector production by technology
trf_rpt(trf(f),fi,r,t) = sum(v, fimap(f,fi) *  FX.L(fi,v,r,t));
trf_rpt(trf(f),fi,"us48",t) = sum((r,v), fimap(f,fi) *  FX.L(fi,v,r,t));
trf_cap_rpt(trf(f),fi,r,t) = sum(v, fimap(f,fi) *  FC.L(fi,v,r,t));
trf_cap_rpt(trf(f),fi,"us48",t) = sum((r,v), fimap(f,fi) *  FC.L(fi,v,r,t));

* Bioenergy feedstock supply
bfs_rpt(bfs,fi,"us48",t) = sum(r, QD_BFS.L(bfs,fi,r,t));
bfs_rpt("bfs-total",fi,"us48",t) = sum(bfs, bfs_rpt(bfs,fi,"us48",t));
bfs_rpt(bfs,"fi-total","us48",t) = sum(fi, bfs_rpt(bfs,fi,"us48",t));
bfs_rpt("bfs-total","fi-total","us48",t) = sum(bfs, bfs_rpt(bfs,"fi-total","us48",t));
bfs_rpt(bfs,fi,r,t) = QD_BFS.L(bfs,fi,r,t);
bfs_rpt("bfs-total",fi,r,t) = sum(bfs, bfs_rpt(bfs,fi,r,t));
bfs_rpt(bfs,"fi-total",r,t) = sum(fi, bfs_rpt(bfs,fi,r,t));
bfs_rpt("bfs-total","fi-total",r,t) = sum(bfs, bfs_rpt(bfs,"fi-total",r,t));
bfs_rpt(bfs,"cap",r,t) = sum(bfsc, QS_BFS.UP(bfs,bfsc,r,t));
bfs_rpt("bfs-total","cap",r,t) = sum(bfs, bfs_rpt(bfs,"cap",r,t));
bfs_rpt(bfs,"cap","us48",t) = sum((bfsc,r), QS_BFS.UP(bfs,bfsc,r,t));
bfs_rpt("bfs-total","cap","us48",t) = sum(bfs, bfs_rpt(bfs,"cap","us48",t));
bfs_rpt(bfs,"price",r,t)$sum(bi, QD_BFS.L(bfs,bi,r,t)) = abs(bfs_balance.M(bfs,r,t)) / dfact(t);
bfs_rpt(bfs,"price","us48",t)$sum((bi,r), QD_BFS.L(bfs,bi,r,t)) = sum(r, abs(bfs_balance.M(bfs,r,t)) * sum(bi, QD_BFS.L(bfs,bi,r,t))) / sum((bi,r), QD_BFS.L(bfs,bi,r,t)) / dfact(t);
biopr_rpt(bfs,r,t) = abs(bfs_balance.M(bfs,r,t)) / dfact(t);
biopr_rpt("avg",r,t)$sum((bi,bfs), QD_BFS.L(bfs,bi,r,t)) = sum(bfs, abs(bfs_balance.M(bfs,r,t)) * sum(bi, QD_BFS.L(bfs,bi,r,t))) / sum((bi,bfs), QD_BFS.L(bfs,bi,r,t)) / dfact(t);
biopr_rpt("avg","usa",t)$sum((bi,bfs,r), QD_BFS.L(bfs,bi,r,t)) = sum((bfs,r), abs(bfs_balance.M(bfs,r,t)) * sum(bi, QD_BFS.L(bfs,bi,r,t))) / sum((bi,bfs,r), QD_BFS.L(bfs,bi,r,t)) / dfact(t);

* * * Detailed hydrogen reporting
loop(fi$sum(h2f(f), fimap(f,fi)),

* Hydrogen production
h2rpt(fi,r,t) = sum(v, FX.L(fi,v,r,t));
h2rpt(fi,rpt,t) = sum(xrpt(rpt,r), h2rpt(fi,r,t));
h2rpt(fi,"us48",t) = sum(r, h2rpt(fi,r,t));

* Hydrogen capacity
* Native units are bbtu/hour
h2cap("bbtu_per_hour",fi,r,t) = sum(v, FC.L(fi,v,r,t));
* TBtu/year = 0.001 TBtu/BBtu * 8760 hours/year * BBtu/hour
h2cap("trbtu_per_year",fi,r,t) = 8.76 * sum(v, FC.L(fi,v,r,t));
* tH2/day = 0.001 tH2/kg  * 1000 MMBtu/BBtu / 0.12 MMBtu/kg * 24 hours/day * BBtu/hour
h2cap("tH2_per_day",fi,r,t) = sum(v, FC.L(fi,v,r,t)) / 0.12 * 24;
* GW = MMBtu in / MMBtu out / 3.412 MMBtu/MWh * 0.001 GW/MW * 1000 MMBtu/bbtu * BBtu/hour
h2cap("GW_elys",fi,r,t)$sum(sameas(fi,hi), elys(hi)) = sum(v, (1/3.412) * eptrf("ele",fi,v) * FC.L(fi,v,r,t));
* Realized capacity factor
h2cap("rlz_CF",fi,r,t)$h2cap("trbtu_per_year",fi,r,t) = h2rpt(fi,r,t) / h2cap("trbtu_per_year",fi,r,t);

h2cap("bbtu_per_hour",fi,rpt,t) = sum(xrpt(rpt,r), h2cap("bbtu_per_hour",fi,r,t));
h2cap("trbtu_per_year",fi,rpt,t) = sum(xrpt(rpt,r), h2cap("trbtu_per_year",fi,r,t));
h2cap("tH2_per_day",fi,rpt,t) = sum(xrpt(rpt,r), h2cap("th2_per_day",fi,r,t));
h2cap("GW_elys",fi,rpt,t) = sum(xrpt(rpt,r), h2cap("GW_elys",fi,r,t));
h2cap("rlz_CF",fi,rpt,t)$h2cap("trbtu_per_year",fi,rpt,t) = h2rpt(fi,rpt,t) / h2cap("trbtu_per_year",fi,rpt,t);

h2cap("bbtu_per_hour",fi,"us48",t) = sum(r, h2cap("bbtu_per_hour",fi,r,t));
h2cap("trbtu_per_year",fi,"us48",t) = sum(r, h2cap("trbtu_per_year",fi,r,t));
h2cap("tH2_per_day",fi,"us48",t) = sum(r, h2cap("th2_per_day",fi,r,t));
h2cap("GW_elys",fi,"us48",t) = sum(r, h2cap("GW_elys",fi,r,t));
h2cap("rlz_CF",fi,"us48",t)$h2cap("trbtu_per_year",fi,"us48",t) = h2rpt(fi,"us48",t) / h2cap("trbtu_per_year",fi,"us48",t);
* end fimap loop
);

* Add H-B ammonia
h2rpt("hbbs",r,t) = sum(fivrt("hbbs",v,r,t), eptrf("ppg","hbbs",v) / eptrf("ppg","gsst",v) * FX.L("hbbs",v,r,t));
h2rpt("hbbs-ccs",r,t) = sum(fivrt("hbbs-ccs",v,r,t), eptrf("ppg","hbbs-ccs",v) / eptrf("ppg","gsst-ccs",v) * FX.L("hbbs-ccs",v,r,t));
h2rpt(fi,rpt,t)$fimap("nh3-n",fi) = sum(xrpt(rpt,r), h2rpt(fi,r,t));
h2rpt(fi,"us48",t)$fimap("nh3-n",fi) = sum(r, h2rpt(fi,r,t));

* Add H-B hydrogen production capacity
h2cap("bbtu_per_hour",fi,r,t)$fimap("nh3-n",fi) = sum(v, FC.L(fi,v,r,t));
h2cap("trbtu_per_year",fi,r,t)$fimap("nh3-n",fi) = 8.76 * sum(v, FC.L(fi,v,r,t));
h2cap("tH2_per_day",fi,r,t)$fimap("nh3-n",fi) = sum(v, FC.L(fi,v,r,t)) / 0.12 * 24;
h2cap("rlz_CF",fi,r,t)$(fimap("nh3-n",fi) and h2cap("trbtu_per_year",fi,r,t)) = h2rpt(fi,r,t) / h2cap("trbtu_per_year",fi,r,t);
h2cap("bbtu_per_hour",fi,rpt,t)$fimap("nh3-n",fi) = sum(xrpt(rpt,r), h2cap("bbtu_per_hour",fi,r,t));
h2cap("trbtu_per_year",fi,rpt,t)$fimap("nh3-n",fi) = sum(xrpt(rpt,r), h2cap("trbtu_per_year",fi,r,t));
h2cap("tH2_per_day",fi,rpt,t)$fimap("nh3-n",fi) = sum(xrpt(rpt,r), h2cap("th2_per_day",fi,r,t));
h2cap("rlz_CF",fi,rpt,t)$(fimap("nh3-n",fi) and h2cap("trbtu_per_year",fi,rpt,t)) = h2rpt(fi,rpt,t) / h2cap("trbtu_per_year",fi,rpt,t);
h2cap("bbtu_per_hour",fi,"us48",t)$fimap("nh3-n",fi) = sum(r, h2cap("bbtu_per_hour",fi,r,t));
h2cap("trbtu_per_year",fi,"us48",t)$fimap("nh3-n",fi) = sum(r, h2cap("trbtu_per_year",fi,r,t));
h2cap("tH2_per_day",fi,"us48",t)$fimap("nh3-n",fi) = sum(r, h2cap("th2_per_day",fi,r,t));
h2cap("rlz_CF",fi,"us48",t)$(fimap("nh3-n",fi) and h2cap("trbtu_per_year",fi,"us48",t)) = h2rpt(fi,"us48",t) / h2cap("trbtu_per_year",fi,"us48",t);

* Expenditures on 45V (hydrogen production tax credit under Inflation Reduction Act)
h2rpt_45v(v,r,t) = FX.L("elys-45v",v,r,t) * ptc_h("elys-45v",v)$ptctv(t,v);
h2rpt_45v(v,"us48",t) = sum(r, FX.L("elys-45v",v,r,t) * ptc_h("elys-45v",v)$ptctv(t,v));

* Segment-level electrolysis production
elys_s(s,hk,r,t) = sum((v,hki(hk,elys(hi))), HX.L(s,hi,v,r,t));

* Consumption of hydrogen (TBtu per year)
h2con("gen",r,t) = sum(h2f(f)$(not sameas(f,"h2_45v")), QD_ELEC.L(f,r,t));
h2con("gen_45v",r,t) = QD_ELEC.L("h2_45v",r,t);
h2con("trf",r,t) = sum(h2f(f)$(not sameas(f,"h2_45v")), sum(trf, QD_TRF.L(f,trf,r,t)) + QD_BLEND.L(f,"ups","h2",r,t));
h2con("trf_45v",r,t) = sum(trf, QD_TRF.L("h2_45v",trf,r,t)) + QD_BLEND.L("h2_45v","ups","h2",r,t);
h2con("blend",r,t) = sum((dst,h2f(f))$(not sameas(f,"h2_45v")), QD_BLEND.L(f,dst,"ppg",r,t));
h2con("blend_45v",r,t) = sum(dst, QD_BLEND.L("h2_45v",dst,"ppg",r,t));
h2con("enduse",r,t) = sum(h2f(f)$(not sameas(f,"h2_45v")), sum(dst$(not sameas(dst,"ups")), QD_BLEND.L(f,dst,"h2",r,t)));
h2con("enduse_45v",r,t) = sum(dst$(not sameas(dst,"ups")), QD_BLEND.L("h2_45v",dst,"h2",r,t));

h2con("gen","us48",t) = sum(r, h2con("gen",r,t));
h2con("gen_45v","us48",t) = sum(r, h2con("gen_45v",r,t));
h2con("trf","us48",t) = sum(r, h2con("trf",r,t));
h2con("trf_45v","us48",t) = sum(r, h2con("trf_45v",r,t));
h2con("blend","us48",t) = sum(r, h2con("blend",r,t));
h2con("blend_45v","us48",t) = sum(r, h2con("blend_45v",r,t));
h2con("enduse","us48",t) = sum(r, h2con("enduse",r,t));
h2con("enduse_45v","us48",t) = sum(r, h2con("enduse_45v",r,t));

h2con_nele(hk,r,t) = sum(hkf(hk,f), QSF.L(f,r,t) - QD_ELEC.L(f,r,t));
h2con_nele(hk,"us48",t) = sum(r, h2con_nele(hk,r,t));

h2con_blend(r,t) = h2con("blend",r,t) + h2con("blend_45v",r,t);
h2con_blend("us48",t) = sum(r, h2con_blend(r,t));

h2conrpt("bld",r,t) = qd_enduse_rpt("res","h2",r,t) + qd_enduse_rpt("com","h2",r,t);
h2conrpt("ind",r,t) = qd_enduse_rpt("ind-sm","h2",r,t) + qd_enduse_rpt("ind-lg","h2",r,t);
h2conrpt("trn",r,t) = qd_enduse_rpt("ldv","h2",r,t) + qd_enduse_rpt("mdhd","h2",r,t);
h2conrpt("nh3",r,t) = sum(fi, fimap("nh3-n",fi) * h2rpt(fi,r,t)) + sum(h2f(f), QD_TRF.L(f,"nh3-e",r,t));
h2conrpt(trf,r,t)$(not sameas(trf,"nh3-e")) = sum(h2f(f), QD_TRF.L(f,trf,r,t));
h2conrpt("ups",r,t) = fuelbal_rpt("QD_UPS","h2",r,t);
h2conrpt("blend",r,t) = h2con("blend_45v",r,t) + h2con("blend",r,t);
h2conrpt("gen",r,t) = h2con("gen_45v",r,t) + h2con("gen",r,t);

h2conrpt_ind("steel",r,t) = qdr_tot_e("ist-331x","prc-h","h2",r,t);
h2conrpt_ind("other process",r,t) = sum((kfmap(kf,k2),u)$((sameas(kf,"ind-sm") or sameas(kf,"ind-lg")) and
                                                         (sameas(u,"prc-h") or sameas(u,"blr") or sameas(u,"chp") or sameas(u,"onp")) and
                                                         (not (sameas(k2,"ist-331x") and sameas(u,"prc-h")))),
                                                         qdr_tot_e(k2,u,"h2",r,t));
h2conrpt_ind("other non-energy",r,t) = qdr_tot_e("inc-325x","non-h","h2",r,t);
h2conrpt_ind("industry non-road",r,t) = sum((kfmap("ind-sm",k2),k2vc(k2,vc),u)$sameas(u,vc), qdr_tot_e(k2,u,"h2",r,t));
h2conrpt_ind("subtotal_check",r,t) = h2conrpt_ind("steel",r,t) + h2conrpt_ind("other process",r,t) + h2conrpt_ind("other non-energy",r,t) + h2conrpt_ind("industry non-road",r,t);
h2conrpt_ind("total_check",r,t) = h2conrpt("ind",r,t);

h2conrpt("bld","us48",t) = sum(r, h2conrpt("bld",r,t));
h2conrpt("ind","us48",t) = sum(r, h2conrpt("ind",r,t));
h2conrpt("trn","us48",t) = sum(r, h2conrpt("trn",r,t));
h2conrpt("nh3","us48",t) = sum(r, h2conrpt("nh3",r,t));
h2conrpt(trf,"us48",t) = sum(r, h2conrpt(trf,r,t));
h2conrpt("ups","us48",t) = sum(r, h2conrpt("ups",r,t));
h2conrpt("blend","us48",t) = sum(r, h2conrpt("blend",r,t));
h2conrpt("gen","us48",t) = sum(r, h2conrpt("gen",r,t));

* Total installed hydrogen input capacity across sectors (BBtu per hour)
h2cap_con("ele",r,t) = sum(ivrt(i,v,r,t), XC.L(i,v,r,t) * htrate(i,v,"h2-e",r,t)) + sum(civrt(i,vv,v,r,t), XC_C.L(i,vv,v,r,t) * htrate_c(i,vv,v,"h2-e",r,t));
h2cap_con("trf",r,t) = sum(fi$fimap("nh3-n",fi), h2cap("bbtu_per_hour",fi,r,t)) + sum(fivrt(fi,v,r,t), FC.L(fi,v,r,t) * (eptrf("h2-e",fi,v) + fptrf("h2-e",fi,v)));
h2cap_con("ups",r,t) = QD_UPS.L("h2",r,t) / 8.76 / 0.9;
h2cap_con("ele","usa",t) = sum(r, h2cap_con("ele",r,t));
h2cap_con("trf","usa",t) = sum(r, h2cap_con("trf",r,t));
h2cap_con("ups","usa",t) = sum(r, h2cap_con("ups",r,t));

* Assume 90% utilization of delivery capacity for MD/HD and non-road H2 applications (with local storage)
* Recalculate industry to reflect endogenous demands
h2cap_eu("trn",r,t) = (qd_enduse_rpt("ldv","h2",r,t) + qd_enduse_rpt("mdhd","h2",r,t)) / 8.76 / 0.9;
h2cap_eu("ind",r,t) = (qd_enduse_rpt("ind-sm","h2",r,t) + qd_enduse_rpt("ind-lg","h2",r,t)) / 8.76 / 0.9;

* Hydrogen storage capacity report
h2storcap("door_trbtu_per_day",hk,r,t) = 1e-3 * 24 * GC_H.L(hk,r,t);
h2storcap("room_trbtu",hk,r,t) = 1e-3 * GR_H.L(hk,r,t);
h2storcap("ratio_days",hk,r,t)$h2storcap("door_trbtu_per_day",hk,r,t) = h2storcap("room_trbtu",hk,r,t) / h2storcap("door_trbtu_per_day",hk,r,t);
h2storcap("ratio_prodcap_to_door",hk,r,t)$h2storcap("door_trbtu_per_day",hk,r,t) = sum(hki(hk,hi), h2cap("trbtu_per_year",hi,r,t)) / 365 / h2storcap("door_trbtu_per_day",hk,r,t);
h2storcap("ratio_prodnrg_to_room",hk,r,t)$h2storcap("room_trbtu",hk,r,t) = sum(hki(hk,hi), h2rpt(hi,r,t)) / h2storcap("room_trbtu",hk,r,t);

h2storcap("door_trbtu_per_day",hk,rpt,t) = 1e-3 * 24 * sum(xrpt(rpt,r), GC_H.L(hk,r,t));
h2storcap("room_trbtu",hk,rpt,t) = 1e-3 * sum(xrpt(rpt,r), GR_H.L(hk,r,t));
h2storcap("ratio_days",hk,rpt,t)$h2storcap("door_trbtu_per_day",hk,rpt,t) = h2storcap("room_trbtu",hk,rpt,t) / h2storcap("door_trbtu_per_day",hk,rpt,t);
h2storcap("ratio_prodcap_to_door",hk,rpt,t)$h2storcap("door_trbtu_per_day",hk,rpt,t) = sum(hki(hk,hi), h2cap("trbtu_per_year",hi,rpt,t)) / 365 / h2storcap("door_trbtu_per_day",hk,rpt,t);
h2storcap("ratio_prodnrg_to_room",hk,rpt,t)$h2storcap("room_trbtu",hk,rpt,t) = sum(hki(hk,hi), h2rpt(hi,rpt,t)) / h2storcap("room_trbtu",hk,rpt,t);

h2storcap("door_trbtu_per_day",hk,"us48",t) = 1e-3 * 24 * sum(r, GC_H.L(hk,r,t));
h2storcap("room_trbtu",hk,"us48",t) = 1e-3 * sum(r, GR_H.L(hk,r,t));
h2storcap("ratio_days",hk,"us48",t)$h2storcap("door_trbtu_per_day",hk,"us48",t) = h2storcap("room_trbtu",hk,"us48",t) / h2storcap("door_trbtu_per_day",hk,"us48",t);
h2storcap("ratio_prodcap_to_door",hk,"us48",t)$h2storcap("door_trbtu_per_day",hk,"us48",t) = sum(hki(hk,hi), h2cap("trbtu_per_year",hi,"us48",t)) / 365 / h2storcap("door_trbtu_per_day",hk,"us48",t);
h2storcap("ratio_prodnrg_to_room",hk,"us48",t)$h2storcap("room_trbtu",hk,"us48",t) = sum(hki(hk,hi), h2rpt(hi,"us48",t)) / h2storcap("room_trbtu",hk,"us48",t);

* Total supply and demand of pipeline gas
* Supply combines implied upstream gas production with explicitly modeled production of RNG and SNG and blended H2
ppg_rpt("qs",r,t) = gas_rpt(r,t) + sum(fi, trf_rpt("rng",fi,r,t) + trf_rpt("sng",fi,r,t)) + h2conrpt("blend",r,t);
ppg_rpt("qd",r,t) = fuelbal_rpt("QD_Tot","ppg",r,t);

* * Primary energy reporting

* Primary energy supply for electric generation (assume direct equivalent for renewables)
*       Total renewables (excluding bio)
prim_elec("renew",r,t) = 3.412 * (sum(i$(irnw(i) or idef(i,"hydr") or idef(i,"geot") or idef(i,"othc")), gen_i(i,"rnw",r,t)) + genrpt_r(r,"11rfpv",t));
*       Subset of renewables broken out by type
prim_elec("wind",r,t) = 3.412 * (sum(i$(idef(i,"wind") or idef(i,"wnos")), gen_i(i,"rnw",r,t)));
prim_elec("solar",r,t) = 3.412 * (sum(i$(sol(i)), gen_i(i,"rnw",r,t)) + genrpt_r(r,"11rfpv",t));
prim_elec("hydro",r,t) = 3.412 * (sum(i$(idef(i,"hydr")), gen_i(i,"rnw",r,t)));
prim_elec("geot",r,t) = 3.412 * (sum(i$(idef(i,"geot")), gen_i(i,"rnw",r,t)));
prim_elec("nuc",r,t) = sum((nuc(i),v), gen_iv(i,v,"ura",r,t) * htrate(i,v,"ura",r,t));
*       Total primary inputs for bio and fossil (renewable and synthetic natural gas counted under bio for now)
prim_elec("bio-oth",r,t) = sum((i,vt(v,t))$(idef(i,"othc")), gen_iv(i,v,"oth",r,t) * htrate(i,v,"oth",r,t));
prim_elec("bio-bfs",r,t) = QD_ELEC.L("bio",r,t) + sum(f$(sameas(f,"rng") or sameas(f,"sng")), blend_shr("rng","ele","ppg",r,t)) * QD_ELEC.L("ppg",r,t);
prim_elec("coal",r,t) = QD_ELEC.L("cls",r,t);
prim_elec("gas",r,t) = blend_shr("gas","ele","ppg",r,t) * QD_ELEC.L("ppg",r,t);
*       Subset of bio and fossil used with CCS (renewable natural gas counted under bio for now)
prim_elec("bio-ccs",r,t) = sum(ccs(i), fuel_i(i,"bio",r,t) * caprate(i)) +
        sum(f$(sameas(f,"rng") or sameas(f,"sng")), blend_shr(f,"ele","ppg",r,t)) * sum(ccs(i), fuel_i(i,"ppg",r,t) * caprate(i));
prim_elec("coal-ccs",r,t) = sum(ccs(i), fuel_i(i,"cls",r,t) * caprate(i));
prim_elec("gas-ccs",r,t) = blend_shr("gas","ele","ppg",r,t) * sum(ccs(i), fuel_i(i,"ppg",r,t) * caprate(i));
prim_elec("renew","us48",t) = sum(r, prim_elec("renew",r,t));
prim_elec("wind","us48",t) = sum(r, prim_elec("wind",r,t));
prim_elec("solar","us48",t) = sum(r, prim_elec("solar",r,t));
prim_elec("hydro","us48",t) = sum(r, prim_elec("hydro",r,t));
prim_elec("geot","us48",t) = sum(r, prim_elec("geot",r,t));
prim_elec("nuc","us48",t) = sum(r, prim_elec("nuc",r,t));
prim_elec("bio-oth","us48",t) = sum(r, prim_elec("bio-oth",r,t));
prim_elec("bio-bfs","us48",t) = sum(r, prim_elec("bio-bfs",r,t));
prim_elec("gas","us48",t) = sum(r, prim_elec("gas",r,t));
prim_elec("rfp","us48",t) = sum(r, prim_elec("rfp",r,t));
prim_elec("col","us48",t) = sum(r, prim_elec("col",r,t));
prim_elec("bio-ccs","us48",t) = sum(r, prim_elec("bio-ccs",r,t));
prim_elec("gas-ccs","us48",t) = sum(r, prim_elec("gas-ccs",r,t));
prim_elec("col-ccs","us48",t) = sum(r, prim_elec("col-ccs",r,t));

* Economy-wide primary energy

* Total renewables (excluding bio)
prim_rpt("renew",r,t) = prim_elec("renew",r,t);
* Subset of renewables broken out by type
prim_rpt("wind",r,t) = prim_elec("wind",r,t);
prim_rpt("solar",r,t) = prim_elec("solar",r,t);
prim_rpt("hydro",r,t) = prim_elec("hydro",r,t);
prim_rpt("geot",r,t) = prim_elec("geot",r,t);
prim_rpt("nuc",r,t) = prim_elec("nuc",r,t) + 1e-3 * sum((nuc(i),s,v), hours(s,t) * XT.L(s,i,v,"ura",r,t));
* Total bio (including other bio tracked in electric generation plus primary supply of bfs)
prim_rpt("bio-oth",r,t) = prim_elec("bio-oth",r,t);
prim_rpt("bio-bfs",r,t) = sum((bfs,bfsc), QS_BFS.L(bfs,bfsc,r,t));
* Incude bio inputs to conventional ethanol (assume 1.8x output)
prim_rpt("bio-ex",r,t) = bio_ex(r,t) + 1.8 * fuelbal_rpt("QSF","eth",r,t);
* Total fossil
prim_rpt("gas",r,t) = QSF.L("gas",r,t) - NTX.L("gas",r,t);
prim_rpt("rfp",r,t) = sum(f$(rfp(f) or sameas(f,"hgl")), QSF.L(f,r,t) - NTX.L(f,r,t));
prim_rpt("col",r,t) = sum(f$(sameas(f,"cls") or sameas(f,"clm")), QSF.L(f,r,t) - NTX.L(f,r,t));
* Subset of bio and fossil used with CCS (renewable natural gas counted under bio)
prim_rpt("bio-ccs",r,t) =
        prim_elec("bio-ccs",r,t) +
        sum((fi_ccs(fi),vt(v,t))$bi(fi), bfspbfl(fi,v) * FX.L(fi,v,r,t) * cprt_trf(fi,v)) +
        sum((trf,fi_ccs(fi),vt(v,t))$fimap(trf,fi), sum(f$(sameas(f,"rng") or sameas(f,"sng")), blend_shr(f,trf,"ppg",r,t)) * (eptrf("ppg",fi,v) + fptrf("ppg",fi,v)) * FX.L(fi,v,r,t) * cprt_trf(fi,v)) +
        sum(f$(sameas(f,"rng") or sameas(f,"sng")), QD_BLEND.L(f,"dac","ppg",r,t)) +
        fueluse_ind_ccs("bio",r,t) + sum(f$(sameas(f,"rng") or sameas(f,"sng")), blend_shr(f,"ind-lg","ppg",r,t)) * fueluse_ind_ccs("ppg",r,t)
;
prim_rpt("gas-ccs",r,t) =
        prim_elec("gas-ccs",r,t) +
        sum((trf,fi_ccs(fi),vt(v,t))$fimap(trf,fi), blend_shr("gas",trf,"ppg",r,t) * (eptrf("ppg",fi,v) + fptrf("ppg",fi,v)) * FX.L(fi,v,r,t) * cprt_trf(fi,v)) +
        QD_BLEND.L("gas","dac","ppg",r,t) +
        blend_shr("gas","ind-lg","ppg",r,t) * fueluse_ind_ccs("ppg",r,t)
;
prim_rpt("col-ccs",r,t) =
        prim_elec("coal-ccs",r,t) +
        sum((fi_ccs(fi),vt(v,t)), (eptrf("cls",fi,v) + eptrf("clm",fi,v) * FX.L(fi,v,r,t) * cprt_trf(fi,v))) +
        fueluse_ind_ccs("cls",r,t) + fueluse_ind_ccs("cok",r,t)
;
prim_rpt("renew","us48",t) = sum(r, prim_rpt("renew",r,t));
prim_rpt("wind","us48",t) = sum(r, prim_rpt("wind",r,t));
prim_rpt("solar","us48",t) = sum(r, prim_rpt("solar",r,t));
prim_rpt("hydro","us48",t) = sum(r, prim_rpt("hydro",r,t));
prim_rpt("geot","us48",t) = sum(r, prim_rpt("geot",r,t));
prim_rpt("nuc","us48",t) = sum(r, prim_rpt("nuc",r,t));
prim_rpt("bio-oth","us48",t) = sum(r, prim_rpt("bio-oth",r,t));
prim_rpt("bio-bfs","us48",t) = sum(r, prim_rpt("bio-bfs",r,t));
prim_rpt("gas","us48",t) = sum(r, prim_rpt("gas",r,t));
prim_rpt("rfp","us48",t) = sum(r, prim_rpt("rfp",r,t));
prim_rpt("col","us48",t) = sum(r, prim_rpt("col",r,t));
prim_rpt("bio-ccs","us48",t) = sum(r, prim_rpt("bio-ccs",r,t));
prim_rpt("gas-ccs","us48",t) = sum(r, prim_rpt("gas-ccs",r,t));
prim_rpt("col-ccs","us48",t) = sum(r, prim_rpt("col-ccs",r,t));

* Secondary energy (electric generation and hydrogen production in TBtu)
qsec_elec("renew",r,t) = prim_elec("renew",r,t);
qsec_elec("wind",r,t) = prim_elec("wind",r,t);
qsec_elec("solar",r,t) = prim_elec("solar",r,t);
qsec_elec("hydro",r,t) = prim_elec("hydro",r,t);
qsec_elec("geot",r,t) = prim_elec("geot",r,t);
qsec_elec("bio-oth",r,t) = 3.412 * sum((i,vt(v,t))$(idef(i,"othc")), gen_iv(i,v,"oth",r,t));
qsec_elec("nuc",r,t) = 3.412 * sum((nuc(i),v), gen_iv(i,v,"ura",r,t));
qsec_elec("coal_",r,t) = 3.412 * sum((i,v)$(not ccs(i)), gen_iv(i,v,"cls",r,t));
qsec_elec("coal-ccs",r,t) = 3.412 * sum((ccs(i),v), gen_iv(i,v,"cls",r,t));
qsec_elec("gas_",r,t) = 3.412 * sum((i,v)$(not ccs(i)), gen_iv(i,v,"ppg",r,t));
qsec_elec("gas-ccs",r,t) = 3.412 * sum((ccs(i),v), gen_iv(i,v,"ppg",r,t));
qsec_elec("bio_",r,t) = 3.412 * sum((i,v)$(not ccs(i)), gen_iv(i,v,"bio",r,t));
qsec_elec("bio-ccs",r,t) = 3.412 * sum((ccs(i),v), gen_iv(i,v,"bio",r,t));
qsec_elec("dsl_",r,t) = 3.412 * sum((i,v)$(not ccs(i)), gen_iv(i,v,"dsl",r,t));
qsec_elec("hydrogen",r,t) = 3.412 * sum((i,v,h2f(f))$(not ccs(i)), gen_iv(i,v,f,r,t));
qsec_elec("tds_losses",r,t) = -1e-3 * 3.412 * sum(s, hours(s,t) * (
*               Within region T&D losses
                GRID.L(s,r,t) * (1 - 1 / localloss)
*               Interregional transmission losses
              + sum(rr$tcapcost(r,rr), (trnspen(r,rr)-1) * E.L(s,r,rr,t))
*               Net charge of storage
              + hyps(s,r,t) + sum(j, chrgpen(j) * G.L(s,j,r,t) - GD.L(s,j,r,t))
));
* This includes intermediate electricity demands
qsec_elec("total",r,t) = 1e-3 * 3.412 * sum(s, hours(s,t) * (load(s,r,t) + QD_EEU_S.L(s,r,t) + sum(flx, QD_FLX_S.L(s,flx,r,t))));
qsec_elec("renew","us48",t) = sum(r, qsec_elec("renew",r,t));
qsec_elec("wind","us48",t) = sum(r, qsec_elec("wind",r,t));
qsec_elec("solar","us48",t) = sum(r, qsec_elec("solar",r,t));
qsec_elec("hydro","us48",t) = sum(r, qsec_elec("hydro",r,t));
qsec_elec("geot","us48",t) = sum(r, qsec_elec("geot",r,t));
qsec_elec("bio-oth","us48",t) = sum(r, qsec_elec("bio-oth",r,t));
qsec_elec("nuc","us48",t) = sum(r, qsec_elec("nuc",r,t));
qsec_elec("coal_","us48",t) = sum(r, qsec_elec("coal_",r,t));
qsec_elec("coal-ccs","us48",t) = sum(r, qsec_elec("coal-ccs",r,t));
qsec_elec("gas_","us48",t) = sum(r, qsec_elec("gas_",r,t));
qsec_elec("gas-ccs","us48",t) = sum(r, qsec_elec("gas-ccs",r,t));
qsec_elec("bio_","us48",t) = sum(r, qsec_elec("bio_",r,t));
qsec_elec("bio-ccs","us48",t) = sum(r, qsec_elec("bio-ccs",r,t));
qsec_elec("dsl_","us48",t) = sum(r, qsec_elec("dsl_",r,t));
qsec_elec("hydrogen","us48",t) = sum(r, qsec_elec("hydrogen",r,t));
qsec_elec("tds_losses","us48",t) = sum(r, qsec_elec("tds_losses",r,t));
qsec_elec("total","us48",t) = sum(r, qsec_elec("total",r,t));

* Secondary energy (hydrogen supply) by primary or input category
qsec_h2("elec",r,t) = sum(elys(hi), h2rpt(hi,r,t));
qsec_h2("cls_",r,t) = h2rpt("clgs",r,t);
qsec_h2("cls-ccs",r,t) = h2rpt("clgs-ccs",r,t);
qsec_h2("gas-ccs",r,t) = h2rpt("gsst-ccs",r,t);
qsec_h2("gas_",r,t) = h2rpt("gsst",r,t) + h2rpt("hbbs",r,t);
qsec_h2("gas-ccs",r,t) = h2rpt("gsst-ccs",r,t) + h2rpt("hbbs-ccs",r,t);
qsec_h2("bio_",r,t) = h2rpt("bioh2",r,t);
qsec_h2("bio-ccs",r,t) = h2rpt("bioh2-ccs",r,t);
qsec_h2("total",r,t) = sum(hi, h2rpt(hi,r,t));
qsec_h2("elec","us48",t) = sum(r, sum(elys(hi), h2rpt(hi,r,t)));
qsec_h2("cls_","us48",t) = sum(r, h2rpt("clgs",r,t));
qsec_h2("cls-ccs","us48",t) = sum(r, h2rpt("clgs-ccs",r,t));
qsec_h2("gas_","us48",t) = sum(r, h2rpt("gsst",r,t));
qsec_h2("gas-ccs","us48",t) = sum(r, h2rpt("gsst-ccs",r,t));
qsec_h2("bio_","us48",t) = sum(r, h2rpt("bioh2",r,t));
qsec_h2("bio-ccs","us48",t) = sum(r, h2rpt("bioh2-ccs",r,t));
qsec_h2("total","us48",t) = sum((r,hi), h2rpt(hi,r,t));

* Total fuel supply and demand report for non-electric emissions
* Infer location of upstream production from epups
fuels_tot("qs_rfp",r,t)$sum((f,r.local,rfp(ff),rr), epups_fuels(f,r,ff,rr,t) * QSF.L(ff,rr,t)) =
* Total supply of refined product
     sum((rfp(f),rr), QSF.L(f,rr,t)) *
* Multiplied by share of refining input energy occuring in region r (actually this includes both refining and upstream oil extraction)
     sum((f,rfp(ff),rr), epups_fuels(f,r,ff,rr,t) * QSF.L(ff,rr,t)) / sum((f,r.local,rfp(ff),rr), epups_fuels(f,r,ff,rr,t) * QSF.L(ff,rr,t));
fuels_tot("qs_gas",r,t)$sum((f,r.local,rr), epups_fuels(f,r,"gas",rr,t) * QSF.L("gas",rr,t)) =
* Total supply of gas
     sum(rr, QSF.L("gas",rr,t)) *
* Multiplied by share of upstream gas input energy occuring in region r
     sum((f,rr), epups_fuels(f,r,"gas",rr,t) * QSF.L("gas",rr,t)) / sum((f,r.local,rr), epups_fuels(f,r,"gas",rr,t) * QSF.L("gas",rr,t));
fuels_tot("qs_col",r,t)$sum((f,r.local,ff,rr)$(sameas(ff,"cls") or sameas(ff,"clm")), epups_fuels(f,r,ff,rr,t) * QSF.L(ff,rr,t)) =
* Total supply of coal
     sum((f,rr)$(sameas(f,"cls") or sameas(f,"clm")), QSF.L(f,rr,t)) *
* Multiplied by share of upstream coal input energy occuring in region r (actually this includes both refining and upstream oil extraction)
     sum((f,ff,rr)$(sameas(ff,"cls") or sameas(ff,"clm")), epups_fuels(f,r,ff,rr,t) * QSF.L(ff,rr,t)) / sum((f,r.local,ff,rr)$(sameas(ff,"cls") or sameas(ff,"clm")), epups_fuels(f,r,ff,rr,t) * QSF.L(ff,rr,t));
fuels_tot("qd_rfp",r,t) = sum(f$(rfp(f) or sameas(f,"rgl") or sameas(f,"rdl") or sameas(f,"spk") or sameas(f,"sjf")), QSF.L(f,r,t));
fuels_tot("qd_ppg",r,t) = sum(dst, QS_BLEND.L(dst,"ppg",r,t));

* * * CO2 capture reporting

* Cumulative geologic storage (GtCO2)
ccs_rpt("ann_2050",cstorclass,r) = 1e-3 * sum(t$sameas(t,"2050"), CSTOR.L(cstorclass,r,t));
ccs_rpt("cum_2050",cstorclass,r) = 1e-3 * sum(t$(t.val le 2050), CSTOR.L(cstorclass,r,t) * nyrs(t));
ccs_rpt("injcap",cstorclass,r) = injcap("%cstorscen%",cstorclass,r);
ccs_rpt("ann_2050",cstorclass,rpt) = 1e-3 * sum(xrpt(rpt,r), sum(t$sameas(t,"2050"), CSTOR.L(cstorclass,r,t)));
ccs_rpt("cum_2050",cstorclass,rpt) = 1e-3 * sum((xrpt(rpt,r),t)$(t.val le 2050), CSTOR.L(cstorclass,r,t) * nyrs(t));
ccs_rpt("injcap",cstorclass,rpt) = sum(xrpt(rpt,r), injcap("%cstorscen%",cstorclass,r));
ccs_rpt("ann_2050",cstorclass,"us48") = 1e-3 * sum((r,t)$sameas(t,"2050"), CSTOR.L(cstorclass,r,t));
ccs_rpt("cum_2050",cstorclass,"us48") = 1e-3 * sum((r,t)$(t.val le 2050), CSTOR.L(cstorclass,r,t) * nyrs(t));
ccs_rpt("injcap",cstorclass,"us48") = sum(r, injcap("%cstorscen%",cstorclass,r));

* CO2 capture by sector and technology
co2_capt_rpt("elec",type,r,t) =
        sum(ivfrt(strd(i),v,f,r,t)$(ccs(i) and idef(i,type)), XTWH.L(i,v,f,r,t) * capture(i,v,f,r)) +
        sum(civfrt(conv(i),vv,v,f,r,t)$(ccs(i) and idef(i,type)), XTWH_C.L(i,vv,v,f,r,t) * capture_c(i,vv,v,f,r));
co2_capt_rpt("fuels",fi_ccs(fi),r,t) = sum(vt(v,t), FX.L(fi,v,r,t) * capture_trf(fi,v));
co2_capt_rpt("dac",f,r,t) = sum((dac,vt(v,t))$epdac("%dacscn%",f,dac,v), DACANN.L(dac,v,r,t) * (capture_dac("%dacscn%",dac,v) - 1));
co2_capt_rpt("dac","air",r,t) = sum((dac,vt(v,t)), DACANN.L(dac,v,r,t));
co2_capt_rpt("ind","tot",r,t) = co2_capt_ind(r,t);
co2_capt_rpt("elec",type,"us48",t) = sum(r, co2_capt_rpt("elec",type,r,t));
co2_capt_rpt("fuels",fi,"us48",t) = sum(r, co2_capt_rpt("fuels",fi,r,t));
co2_capt_rpt("dac",f,"us48",t) = sum(r, co2_capt_rpt("dac",f,r,t));
co2_capt_rpt("dac","air","us48",t) = sum(r, co2_capt_rpt("dac","air",r,t));
co2_capt_rpt("ind","tot","us48",t) = sum(r, co2_capt_rpt("ind","tot",r,t));

* CO2 capture by sector and fuel (assign to blend constituents, in particular gas vs rng for ppg)
* For now, assign same gas/rng share to gas generation with and without capture
co2_capt_rpt_f("elec",f,r,t)$(not blend(f)) =
        (sum(ivfrt(strd(i),v,f,r,t)$ccs(i), XTWH.L(i,v,f,r,t) * capture(i,v,f,r)) +
        sum(civfrt(conv(i),vv,v,f,r,t)$ccs(i), XTWH_C.L(i,vv,v,f,r,t) * capture_c(i,vv,v,f,r)))
;

co2_capt_rpt_f("elec",f,r,t)$sum(ff, blendmap(f,ff)) =
        (sum((blendmap(f,ff),ivfrt(strd(i),v,ff,r,t))$ccs(i), blend_shr(f,"ele",ff,r,t) * XTWH.L(i,v,ff,r,t) * capture(i,v,ff,r)) +
        sum((blendmap(f,ff),civfrt(conv(i),vv,v,ff,r,t))$ccs(i), blend_shr(f,"ele",ff,r,t) * XTWH_C.L(i,vv,v,ff,r,t) * capture_c(i,vv,v,ff,r)))
;

co2_capt_rpt_f("fuels",f,r,t)$(not blend(f)) = sum((fi_ccs(fi),vt(v,t))$eptrf(f,fi,v), FX.L(fi,v,r,t) * capture_trf(fi,v));
co2_capt_rpt_f("fuels",f,r,t)$sum(ff, blendmap(f,ff)) = sum((trf,blendmap(f,ff),fi_ccs(fi),vt(v,t))$eptrf(ff,fi,v),
        fimap(trf,fi) * blend_shr(f,trf,ff,r,t) * FX.L(fi,v,r,t) * capture_trf(fi,v));

co2_capt_rpt_f("dac",f,r,t) = sum((dac,vt(v,t))$epdac("%dacscn%",f,dac,v), DACANN.L(dac,v,r,t) * (capture_dac("%dacscn%",dac,v) - 1));
co2_capt_rpt_f("dac","air",r,t) = sum((dac,vt(v,t)), DACANN.L(dac,v,r,t));

co2_capt_rpt_f("elec",f,"us48",t) = sum(r, co2_capt_rpt_f("elec",f,r,t));
co2_capt_rpt_f("fuels",f,"us48",t) = sum(r, co2_capt_rpt_f("fuels",f,r,t));
co2_capt_rpt_f("dac",f,"us48",t) = sum(r, co2_capt_rpt_f("dac",f,r,t));
co2_capt_rpt_f("dac","air","us48",t) = sum(r, co2_capt_rpt_f("dac","air",r,t));

* CO2 capture by technology and sector alongside capacity and output
co2_capt_full("elec","capacity",type,r,t)$(sum(idef(ccs(i),type), ncap_i(i,r,t)) > 1e-3) = sum(idef(ccs(i),type), ncap_i(i,r,t));
co2_capt_full("elec","output",type,r,t)$(sum(idef(ccs(i),type), ncap_i(i,r,t)) > 1e-3) = sum((idef(ccs(i),type),ifl(i,f)), gen_i(i,f,r,t));
co2_capt_full("elec","co2_capt_capacity",type,r,t)$(sum(idef(ccs(i),type), ncap_i(i,r,t)) > 1e-3) = 8.76 * (
        sum(ivrt(strd(i),v,r,t)$(ccs(i) and idef(i,type)), XC.L(i,v,r,t) * smax(f, capture(i,v,f,r))) +
        sum(civrt(conv(i),vv,v,r,t)$(ccs(i) and idef(i,type)), XC_C.L(i,vv,v,r,t) * smax(f, capture_c(i,vv,v,f,r))));
co2_capt_full("elec","co2_capt",type,r,t)$(sum(idef(ccs(i),type), ncap_i(i,r,t)) > 1e-3) = co2_capt_rpt("elec",type,r,t);

co2_capt_full("fuels","capacity",fi_ccs(fi),r,t)$(sum(vt(v,t), FC.L(fi,v,r,t)) > 1e-3) = sum(vt(v,t), FC.L(fi,v,r,t));
co2_capt_full("fuels","output",fi_ccs(fi),r,t)$(sum(vt(v,t), FC.L(fi,v,r,t)) > 1e-3) = sum(vt(v,t), FX.L(fi,v,r,t));
co2_capt_full("fuels","co2_capt_capacity",fi_ccs(fi),r,t)$(sum(vt(v,t), FC.L(fi,v,r,t)) > 1e-3) = 8.76 * sum(vt(v,t), FC.L(fi,v,r,t) * capture_trf(fi,v));
co2_capt_full("fuels","co2_capt",fi_ccs(fi),r,t)$(sum(vt(v,t), FC.L(fi,v,r,t)) > 1e-3) = co2_capt_rpt("fuels",fi,r,t);

co2_capt_full("dac","capacity",dac,r,t) = sum(vt(v,t), DACC.L(dac,v,r,t));
co2_capt_full("dac","output",dac,r,t) = sum(vt(v,t), DACANN.L(dac,v,r,t));
co2_capt_full("dac","co2_capt_capacity",dac,r,t) = sum(vt(v,t), DACC.L(dac,v,r,t) * capture_dac("%dacscn%",dac,v));
co2_capt_full("dac","co2_capt",dac,r,t) = sum(vt(v,t), DACANN.L(dac,v,r,t) * capture_dac("%dacscn%",dac,v));

* CO2 pipeline capacity between regions (MtCO2)
report_co2_pipe(r,rr,t)$capcost_pc("%co2trscn%",r,rr) = eps + PC.L(r,rr,t);

* * * Emissions

* Direct air capture total anual net removal (MtCO2 per year)
dactot(r,t) = sum((dac,vt(v,t)), DACANN.L(dac,v,r,t));
usdactot(t) = sum(r, dactot(r,t));

* Electric sector pollutant emissions by fuel and vintage (Mt)
emittype(pol,f,v,r,t) = sum(ivfrt(i,v,f,r,t), emit(i,v,f,pol,r,t) * XTWH.L(i,v,f,r,t)) +
                        sum(civfrt(i,vv,v,f,r,t), emit_c(i,vv,v,f,pol,r,t) * XTWH_C.L(i,vv,v,f,r,t));

* Electric sector pollutant emissions by region (Gt)
* Note that electric sector emissions exclude offsets from DAC or non-electric bio+CCS
emitlev("co2",r,t) = 1e-3 * CO2_ELE.L(r,t);
emitlev(pol,r,t)$(not sameas(pol,"co2")) =
                   sum(ivfrt(i,v,f,r,t), emit(i,v,f,pol,r,t) * XTWH.L(i,v,f,r,t)) +
                   sum(civfrt(i,vv,v,f,r,t), emit_c(i,vv,v,f,pol,r,t) * XTWH_C.L(i,vv,v,f,r,t))
;

* US national electric sector pollutant emissions (Mt)
usemit(pol,t) = 1e3 * sum(r, emitlev(pol,r,t));

* US electric sector CO2 emissions (positive and negative components broken out) (GtCO2)
* Note this is based on unit-level emissions factors; need to adjust for rng/sng gas blends
useleco2("pos",t) = 1e-3 * sum((f,r),
                             (sum(ivfrt(i,v,f,r,t)$(emit(i,v,f,"co2",r,t) > 0), emit(i,v,f,"co2",r,t) * XTWH.L(i,v,f,r,t)) +
                              sum(civfrt(i,vv,v,f,r,t)$(emit_c(i,vv,v,f,"co2",r,t) > 0), emit_c(i,vv,v,f,"co2",r,t) * XTWH_C.L(i,vv,v,f,r,t))
* Include CAES fuel use
$ifi not %storage%==no      + sum(j, 1e-3 * cc_ff("gas") * htrate_g(j) * sum(s, hours(s,t) * GD.L(s,j,r,t)))$sameas(f,"ppg")
                             ) * (1 + (blend_shr("gas","ele","ppg",r,t) - 1)$sameas(f,"ppg")))
;
useleco2("neg",t) = 1e-3 * (sum(ivfrt(i,v,f,r,t)$(emit(i,v,f,"co2",r,t) < 0), emit(i,v,f,"co2",r,t) * XTWH.L(i,v,f,r,t)) +
                            sum(civfrt(i,vv,v,f,r,t)$(emit_c(i,vv,v,f,"co2",r,t) < 0), emit_c(i,vv,v,f,"co2",r,t) * XTWH_C.L(i,vv,v,f,r,t)))
;
useleco2("tot",t) = 1e-3 * sum(r, CO2_ELE.L(r,t));

* CO2 emissons by sector and region (MtCO2)
secco2_rpt("ele",r,t) = CO2_ELE.L(r,t);
secco2_rpt("ups",r,t) = CO2_UPS.L(r,t);
secco2_rpt("trf",r,t) = CO2_TRF.L(r,t);
secco2_rpt("dac",r,t) = - CO2_DAC.L(r,t);
secco2_rpt("ncr",r,t) = - sum(ncr, CO2_NAT.L(ncr,r,t));
secco2_rpt("bld",r,t) = CO2_BLD.L(r,t);
secco2_rpt("ind",r,t) = CO2_IND.L(r,t);
secco2_rpt("trn",r,t) = CO2_TRN.L(r,t);
* Net total of sectoral break-out (should match CO2_EMIT.L)
secco2_rpt("sec_net",r,t) = CO2_ELE.L(r,t) - cc_ff("gas") * QD_ELEC.L("gas",r,t) + CO2_UPS.L(r,t) + CO2_TRF.L(r,t) - CO2_DAC.L(r,t) - sum(ncr, CO2_NAT.L(ncr,r,t)) + CO2_BLD.L(r,t) + CO2_IND.L(r,t) + CO2_TRN.L(r,t);
* US Total
secco2_rpt("ele","us48",t) = sum(r, secco2_rpt("ele",r,t));
secco2_rpt("ups","us48",t) = sum(r, secco2_rpt("ups",r,t));
secco2_rpt("trf","us48",t) = sum(r, secco2_rpt("trf",r,t));
secco2_rpt("dac","us48",t) = sum(r, secco2_rpt("dac",r,t));
secco2_rpt("ncr","us48",t) = sum(r, secco2_rpt("ncr",r,t));
secco2_rpt("bld","us48",t) = sum(r, secco2_rpt("bld",r,t));
secco2_rpt("ind","us48",t) = sum(r, secco2_rpt("ind",r,t));
secco2_rpt("trn","us48",t) = sum(r, secco2_rpt("trn",r,t));
secco2_rpt("sec_net","us48",t) = sum(r, secco2_rpt("sec_net",r,t));

* Disaggregate components of net economy-wide CO2 emission calculation (MtCO2)
netco2_rpt("fos",r,t) =
* Carbon content of primary fuels
        sum(fos(f), cc_ff(f) * QSF.L(f,r,t))
;
netco2_rpt("ntm",r,t) =
* Adjusted for carbon content of traded fuels
        sum(fos(f), cc_ff(f) * (- NTX.L(f,r,t)))
;
netco2_rpt("bfs",r,t) = eps +
* Plus non-atmosphere-neutral carbon content of biomass feedstocks
        sum(bfs, cc_bfs(bfs) * (1 - credit_bio(bfs)) * sum(bi, QD_BFS.L(bfs,bi,r,t)))
;
netco2_rpt("proc",r,t) =
* Plus industrial process emissions (e.g. limestone in cement, before capture)
        co2_proc_ind(r,t)
;
netco2_rpt("fne",r,t) =
* Less CO2 fixed in non-energy products
	- sum(kf, co2_fne(kf,r,t))
;
netco2_rpt("cc-elec-fos",r,t) =
*       CO2 captured from fossil in electric sector (may include some bio if ppg to ele includes rng)
        - co2_capt_rpt_f("elec","cls",r,t) - co2_capt_rpt_f("elec","ppg",r,t)
;
netco2_rpt("cc-ind-fos",r,t) =
*       CO2 captured (from fossil) in industrial model
        - co2_capt_ind(r,t)
;
netco2_rpt("cc-trf-fos",r,t) =
*       CO2 captured from fossil by transformation technologies with CCS
         - sum((fi_ccs(fi),vt(v,t))$(not bi(fi)), FX.L(fi,v,r,t) * capture_trf(fi,v))
;
netco2_rpt("cc-dac-fos",r,t) =
*       CO2 captured from fossil used to fuel DAC
         - sum((dac,vt(v,t)), DACANN.L(dac,v,r,t) * (capture_dac("%dacscn%",dac,v) - 1))
;
netco2_rpt("cc-elec-bio",r,t) =
*       CO2 captured from bioenergy in electric sector (including rng share in ppg)
        - co2_capt_rpt_f("elec","bio",r,t) - co2_capt_rpt_f("elec","rng",r,t)
;
netco2_rpt("cc-biof",r,t) =
*       CO2 captured by biofuel-conversion technologies with CCS
         - sum((fi_ccs(fi),vt(v,t))$bi(fi), FX.L(fi,v,r,t) * capture_trf(fi,v))
;
netco2_rpt("cc-dac-air",r,t) =
*       CO2 captured by direct air capture (DAC) technologies (net removal)
        - sum((dac,vt(v,t)), DACANN.L(dac,v,r,t))
;
netco2_rpt("ccu-syn",r,t) =
*       Captured CO2 utilized for synfuels (i.e. re-emitted)
        CO2_SYN.L(r,t)
;
* These terms does not contribute to emissions, just for visibility
netco2_rpt("ccs-tot",r,t) =
*       Captured CO2 injected underground in geologic storage
        sum(cstorclass, CSTOR.L(cstorclass,r,t))
;
netco2_rpt("px-net",r,t) =
*       Net exports of captureed CO2 by pipeline
        sum(rr$capcost_pc("%co2trscn%",rr,r), PX.L(r,rr,t) - PX.L(rr,r,t))
;
netco2_rpt("ncr",r,t) =
* Less CO2 fixed in natural systems
        - sum(ncr, CO2_NAT.L(ncr,r,t))
;

* Total positive CO2 emissions (MtCO2)
netco2_rpt("positive",r,t) =
netco2_rpt("fos",r,t) +
netco2_rpt("ntm",r,t) +
netco2_rpt("proc",r,t) +
netco2_rpt("fne",r,t) +
netco2_rpt("cc-elec-fos",r,t) +
netco2_rpt("cc-ind-fos",r,t) +
netco2_rpt("cc-trf-fos",r,t) +
netco2_rpt("cc-dac-fos",r,t)
;

* Total negative CO2 emissions (includes positive part of bioenergy emissions, which may be zero) (MtCO2)
netco2_rpt("negative",r,t) =
netco2_rpt("bfs",r,t) +
netco2_rpt("cc-biof",r,t) +
netco2_rpt("cc-elec-bio",r,t) +
netco2_rpt("cc-dac-air",r,t) +
netco2_rpt("ncr",r,t) +
netco2_rpt("ccu-syn",r,t)
;

* Net CO2 emissions (sum over all categories) should match variable (MtCO2)
netco2_rpt("net",r,t) =
netco2_rpt("fos",r,t) +
netco2_rpt("ntm",r,t) +
netco2_rpt("bfs",r,t) +
netco2_rpt("proc",r,t) +
netco2_rpt("fne",r,t) +
netco2_rpt("cc-elec-fos",r,t) +
netco2_rpt("cc-ind-fos",r,t) +
netco2_rpt("cc-trf-fos",r,t) +
netco2_rpt("cc-dac-fos",r,t) +
netco2_rpt("cc-biof",r,t) +
netco2_rpt("cc-elec-bio",r,t) +
netco2_rpt("cc-dac-air",r,t) +
netco2_rpt("ccu-syn",r,t) +
netco2_rpt("ncr",r,t);

* US total (MtCO2)
netco2_rpt("fos","us48",t) = sum(r, netco2_rpt("fos",r,t));
netco2_rpt("ntm","us48",t) = sum(r, netco2_rpt("ntm",r,t));
netco2_rpt("proc","us48",t) = sum(r, netco2_rpt("proc",r,t));
netco2_rpt("fne","us48",t) = sum(r, netco2_rpt("fne",r,t));
netco2_rpt("cc-elec-fos","us48",t) = sum(r, netco2_rpt("cc-elec-fos",r,t));
netco2_rpt("cc-ind-fos","us48",t) = sum(r, netco2_rpt("cc-ind-fos",r,t));
netco2_rpt("cc-trf-fos","us48",t) = sum(r, netco2_rpt("cc-trf-fos",r,t));
netco2_rpt("cc-dac-fos","us48",t) = sum(r, netco2_rpt("cc-dac-fos",r,t));
netco2_rpt("bfs","us48",t) = sum(r, netco2_rpt("bfs",r,t));
netco2_rpt("cc-biof","us48",t) = sum(r, netco2_rpt("cc-biof",r,t));
netco2_rpt("cc-elec-bio","us48",t) = sum(r, netco2_rpt("cc-elec-bio",r,t));
netco2_rpt("cc-dac-air","us48",t) = sum(r, netco2_rpt("cc-dac-air",r,t));
netco2_rpt("ncr","us48",t) = sum(r, netco2_rpt("ncr",r,t));
netco2_rpt("ccu-syn","us48",t) = sum(r, netco2_rpt("ccu-syn",r,t));
netco2_rpt("ccs-tot","us48",t) = sum(r, netco2_rpt("ccs-tot",r,t));
netco2_rpt("px-net","us48",t) = sum(r, netco2_rpt("px-net",r,t));
netco2_rpt("positive","us48",t) = sum(r, netco2_rpt("positive",r,t));
netco2_rpt("negative","us48",t) = sum(r, netco2_rpt("negative",r,t));
netco2_rpt("net","us48",t) = sum(r, netco2_rpt("net",r,t));

* Compare break-out to CO2_EMIT variable
secco2_rpt("CO2_EMIT.L",r,t) = CO2_EMIT.L(r,t);
secco2_rpt("CO2_EMIT.L","us48",t) = sum(r, secco2_rpt("CO2_EMIT.L",r,t));

netco2_rpt("CO2_EMIT.L",r,t) = CO2_EMIT.L(r,t);
netco2_rpt("CO2_EMIT.L","us48",t) = sum(r, netco2_rpt("CO2_EMIT.L",r,t));

* Average emissions intensity of electricity generation  (t per MWh)
polint_r(pol,r,t) = 1e3 * emitlev(pol,r,t) / gentot(r,t);
uspolint(pol,t) = usemit(pol,t) / usgentot(t);
 
* Check whether threshold for extensions of IRA power sector emissions has been met
* According to the IRA, PTC and ITC only expire once the average CO2 intensity of generation
* falls below 25% of 2022 level of 0.368 tCO2/MWh.
$ifthen set iraext_iter
parameter iraext_threshold /0/;
loop(t$(not iraext_threshold),
iraext_threshold = 1$(uspolint("co2",t) < 0.25 * 0.368);
iraext$iraext_threshold = tyr(t-1);
);
execute_unload '%elecdata%\iraext_%scen%.gdx', iraext;
$endif

* * * Renewable generation reports

rnwshr(r,t) = sum(ifl(i,f), rps(i,f,r,"fed") * gen_i(i,f,r,t)) / gentot(r,t);
usrnwshr(t) = sum((ifl(i,f),r), rps(i,f,r,"fed") * gen_i(i,f,r,t)) / usgentot(t);
srnwgen(r,t,"wind-on") = sum((ifl(i,f),idef(i,"wind")), rps(i,f,r,"state") * gen_i(i,f,r,t));
srnwgen(r,t,"wind-off") = sum((ifl(i,f),idef(i,"wnos")), rps(i,f,r,"state") * gen_i(i,f,r,t));
srnwgen(r,t,"geoth") = sum((ifl(i,f),idef(i,"geot")), rps(i,f,r,"state") * gen_i(i,f,r,t));
srnwgen(r,t,"bio-cf") = sum((ifl(i,f),idef(i,"cbcf")), rps(i,f,r,"state") * gen_i(i,f,r,t));
srnwgen(r,t,"bio-rn") = sum((ifl(i,f),idef(i,"bioe")), rps(i,f,r,"state") * gen_i(i,f,r,t));
srnwgen(r,t,"pvut") = sum((ifl(i,f),sol(i)), rps(i,f,r,"state") * gen_i(i,f,r,t)) ;
srnwgen(r,t,"rfpv") = rfpv_twh(r,t)$rps("pvrf-xn","rnw",r,"state");

* State RPS report (TWh)
srpsrpt(r,t,"localgen") = sum(ifl(i,f), rps(i,f,r,"state") * gen_i(i,f,r,t)) + rfpv_twh(r,t)$rps("pvrf-xn","rnw",r,"state");
srpsrpt(r,t,"rpcmpt") = sum(rr, RPC.L(rr,r,t));
srpsrpt(r,t,"rpcxpt") = sum(rr, RPC.L(r,rr,t));
srpsrpt(r,t,"nmrnet") = NMR.L(r,t);
srpsrpt(r,t,"acp") = ACP.L(r,t);
srpsrpt(r,t,"canhyd") = canhyd_r(r);
srpsrpt(r,t,"target") = rpstgt_r(r,t) * (GRIDTWH.L(r,t) / localloss + rfpv_twh(r,t)$rps("pvrf-xn","rnw",r,"state"));
srpsrpt(r,t,"demand") = srpsrpt(r,t,"target") - (srpsrpt(r,t,"localgen") + srpsrpt(r,t,"rpcmpt") - srpsrpt(r,t,"rpcxpt") + srpsrpt(r,t,"nmrnet") + srpsrpt(r,t,"acp") + srpsrpt(r,t,"canhyd"));

* * * Other policy reports

* Clean electricity standard (CES) reporting: Regional share of clean electricity compared to target
$iftheni NOT %ces%==none
ceshr(r,t,"realized")$CESTOT.L(r,t) = (sum((i,v,f), ces(i,v,f,r,"%ces%") * XTWH.L(i,v,f,r,t) +
                                       sum(vv, ces_c(i,vv,v,f,r,"%ces%") * XTWH_C.L(i,vv,v,f,r,t))) +
                                       rfpv_twh(r,t) * ces_oth("rfpv",r,"%ces%")
                                      ) / CESTOT.L(r,t);
ceshr(r,t,"target") = cestgt_r(r,t,"%ces%");
ceshr_us(t)$sum(r, CESTOT.L(r,t)) = (sum((i,v,f,r), ces(i,v,f,r,"%ces%") * XTWH.L(i,v,f,r,t) +
                                     sum(vv, ces_c(i,vv,v,f,r,"%ces%") * XTWH_C.L(i,vv,v,f,r,t))) +
                                     sum(r, rfpv_twh(r,t) * ces_oth("rfpv",r,"%ces%"))
                                    ) / sum(r, CESTOT.L(r,t));

* Breakdown of regional CES compliance
cesrpt(r,t,"localgen") = sum((i,v,f), ces(i,v,f,r,"%ces%") * XTWH.L(i,v,f,r,t) +
                         sum(vv, ces_c(i,vv,v,f,r,"%ces%") * XTWH_C.L(i,vv,v,f,r,t))) +
                         rfpv_twh(r,t) * ces_oth("rfpv",r,"%ces%");
cesrpt(r,t,"dac") = sum((dac,vt(v,t)), ces_oth("dac",r,"%ces%") * DACANN.L(dac,v,r,t));
cesrpt(r,t,"bundled") = sum(rr$tcapcost(r,rr), BCE.L(rr,r,t) - BCE.L(r,rr,t));
cesrpt(r,t,"unbundled") = CES_NTX.L(r,t);
cesrpt(r,t,"acp") = CES_ACP.L(r,t);
cesrpt(r,t,"target") = cestgt_r(r,t,"%ces%") * CESTOT.L(r,t);

*  Breakdown of aggregate reporting region CES compliance
cesrpt_rpt(rpt,t,"localgen") = sum(xrpt(rpt,r), cesrpt(r,t,"localgen"));
cesrpt_rpt(rpt,t,"dac") = sum(xrpt(rpt,r), cesrpt(r,t,"dac"));
cesrpt_rpt(rpt,t,"bundled") = sum(xrpt(rpt,r), cesrpt(r,t,"bundled"));
cesrpt_rpt(rpt,t,"unbundled") = sum(xrpt(rpt,r), cesrpt(r,t,"unbundled"));
cesrpt_rpt(rpt,t,"acp") = sum(xrpt(rpt,r), cesrpt(r,t,"acp"));
cesrpt_rpt(rpt,t,"target") = sum(xrpt(rpt,r), cesrpt(r,t,"target"));

* Breakdown of national CES compliance
cesrpt_us(t,"localgen") = sum(r, cesrpt(r,t,"localgen"));
cesrpt_us(t,"dac") = sum(r, cesrpt(r,t,"dac"));
cesrpt_us(t,"bundled") = sum(r, cesrpt(r,t,"bundled"));
cesrpt_us(t,"unbundled") = sum(r, cesrpt(r,t,"unbundled"));
cesrpt_us(t,"acp") = sum(r, cesrpt(r,t,"acp"));
cesrpt_us(t,"target") = sum(r, cesrpt(r,t,"target"));
$endif

* * * Regional Sankey diagram reporting

* Renewables primary input to electric generation (direct equivalent)
sankey_rpt("1","Renewables","Electricity","wind",r,t) = eps + prim_elec("wind",r,t);
sankey_rpt("2","Renewables","Electricity","solar",r,t) = eps + prim_elec("solar",r,t) - 3.412 * genrpt_r(r,"11rfpv",t);
sankey_rpt("3","Renewables","Electricity","hydro",r,t) = eps + prim_elec("hydro",r,t);
sankey_rpt("4","Renewables","Electricity","geot",r,t) = eps + prim_elec("geot",r,t);

* Thermal generation primary inputs
sankey_rpt("5","Nuclear","Thermal Gen","nuclear",r,t) = eps + prim_elec("nuc",r,t);
sankey_rpt("6","Coal","Thermal Gen","coal",r,t) = eps + prim_elec("coal",r,t) - prim_elec("coal-ccs",r,t);
sankey_rpt("7","Coal","Thermal Gen","coal+CC",r,t) = eps + prim_elec("coal-ccs",r,t);
sankey_rpt("8","Pipeline Gas","Thermal Gen","pgas",r,t) = eps + fuelbal_rpt("QD_ELEC","ppg",r,t) - sum(ccs(i), fuel_i(i,"ppg",r,t));
sankey_rpt("9","Pipeline Gas","Thermal Gen","pgas+CC",r,t) = eps + sum(ccs(i), fuel_i(i,"ppg",r,t));
sankey_rpt("10","Bioenergy","Thermal Gen","bio",r,t) = eps + fuelbal_rpt("QD_ELEC","bio",r,t) + fuelbal_rpt("QD_ELEC","oth",r,t) - sum(ccs(i), fuel_i(i,"bio",r,t) * caprate(i));
sankey_rpt("11","Bioenergy","Thermal Gen","bio+CC",r,t) = eps + sum(ccs(i), fuel_i(i,"bio",r,t) * caprate(i));
sankey_rpt("12","Hydrogen Disp","Thermal Gen","h2",r,t) = eps + h2conrpt("gen",r,t);
sankey_rpt("13","Liquid Fuels","Thermal Gen","liq",r,t) = eps + fuelbal_rpt("QD_ELEC","dsl",r,t);

* Thermal generation (net of thermal losses)
sankey_rpt("14","Thermal Gen","Electricity","nuclear",r,t) = eps + qsec_elec("nuc",r,t);
sankey_rpt("15","Thermal Gen","Electricity","coal",r,t) = eps + qsec_elec("coal_",r,t);
sankey_rpt("16","Thermal Gen","Electricity","coal+CC",r,t) = eps + qsec_elec("coal-ccs",r,t);
sankey_rpt("17","Thermal Gen","Electricity","pgas",r,t) = eps + qsec_elec("gas_",r,t);
sankey_rpt("18","Thermal Gen","Electricity","pgas+CC",r,t) = eps + qsec_elec("gas-ccs",r,t);
sankey_rpt("19","Thermal Gen","Electricity","bio",r,t) = eps + qsec_elec("bio_",r,t) + qsec_elec("bio-oth",r,t);
sankey_rpt("20","Thermal Gen","Electricity","bio+CC",r,t) = eps + qsec_elec("bio-ccs",r,t);
sankey_rpt("21","Thermal Gen","Electricity","h2",r,t) = eps + qsec_elec("hydrogen",r,t);
sankey_rpt("22","Thermal Gen","Electricity","liq",r,t) = eps + qsec_elec("dsl_",r,t);

* Net imports (input to generation)
sankey_rpt("23","Net Imports (Ele)","Electricity","ele",r,t) = eps + max(0, -3.412 * ntxelec(r,t));

* Inputs into hydrogen production
sankey_rpt("24","Electricity","Hydrogen Sup","ele",r,t) = eps + elec_fuels_rpt("h2e",r,t);
sankey_rpt("25","Nuclear","Hydrogen Sup","nuclear",r,t) = eps + 1e-3 * sum((nuc(i),s,v), hours(s,t) * XT.L(s,i,v,"ura",r,t));
sankey_rpt("26","Coal","Hydrogen Sup","coal",r,t) = eps + sum((fi,v)$sameas(fi,"clgs"), eptrf("cls",fi,v) * FX.L(fi,v,r,t));
sankey_rpt("27","Coal","Hydrogen Sup","coal+CC",r,t) = eps + sum((fi,v)$sameas(fi,"clgs-ccs"), eptrf("cls",fi,v) * FX.L(fi,v,r,t));
sankey_rpt("28","Natural Gas","Hydrogen Sup","gas",r,t) = eps + sum(dst$(sameas(dst,"h2-n") or sameas(dst,"nh3-n")), fuelbal_blend_rpt("gas",dst,"ppg",r,t) - blend_shr("gas",dst,"ppg",r,t) * (
                                                                sum(v, cprt_trf("gsst-ccs",v) * (eptrf("ppg","gsst-ccs",v) + fptrf("ppg","gsst-ccs",v)) * FX.L("gsst-ccs",v,r,t))$sameas(dst,"h2-n") +
                                                                sum(v, cprt_trf("hbbs-ccs",v) * (eptrf("ppg","hbbs-ccs",v) + fptrf("ppg","hbbs-ccs",v)) * FX.L("hbbs-ccs",v,r,t))$sameas(dst,"nh3-n")))
;
sankey_rpt("29","Natural Gas","Hydrogen Sup","gas+CC",r,t) = eps + sum(dst$(sameas(dst,"h2-n") or sameas(dst,"nh3-n")), blend_shr("gas",dst,"ppg",r,t) * (
                                                                sum(v, cprt_trf("gsst-ccs",v) * (eptrf("ppg","gsst-ccs",v) + fptrf("ppg","gsst-ccs",v)) * FX.L("gsst-ccs",v,r,t))$sameas(dst,"h2-n") +
                                                                sum(v, cprt_trf("hbbs-ccs",v) * (eptrf("ppg","hbbs-ccs",v) + fptrf("ppg","hbbs-ccs",v)) * FX.L("hbbs-ccs",v,r,t))$sameas(dst,"nh3-n")));
sankey_rpt("30","Bioenergy","Hydrogen Sup","bio",r,t) = eps + sum((fi,v)$(sameas(fi,"bioh2") or sameas(fi,"bioh2-ccs")), (1 - cprt_trf(fi,v)) * bfspbfl(fi,v) * FX.L(fi,v,r,t))
                                                              + sum(dst$(sameas(dst,"h2-n") or sameas(dst,"nh3-n")), fuelbal_blend_rpt("rng",dst,"ppg",r,t) - blend_shr("rng",dst,"ppg",r,t) * (
                                                                sum(v, cprt_trf("gsst-ccs",v) * (eptrf("ppg","gsst-ccs",v) + fptrf("ppg","gsst-ccs",v)) * FX.L("gsst-ccs",v,r,t))$sameas(dst,"h2-n") +
                                                                sum(v, cprt_trf("hbbs-ccs",v) * (eptrf("ppg","hbbs-ccs",v) + fptrf("ppg","hbbs-ccs",v)) * FX.L("hbbs-ccs",v,r,t))$sameas(dst,"nh3-n")));
sankey_rpt("31","Bioenergy","Hydrogen Sup","bio+CC",r,t) = eps + sum((fi,v)$sameas(fi,"bioh2-ccs"), cprt_trf(fi,v) * bfspbfl(fi,v) * FX.L(fi,v,r,t))
                                                                 + sum(dst$(sameas(dst,"h2-n") or sameas(dst,"nh3-n")), blend_shr("rng",dst,"ppg",r,t) * (
                                                                  sum(v, cprt_trf("gsst-ccs",v) * (eptrf("ppg","gsst-ccs",v) + fptrf("ppg","gsst-ccs",v)) * FX.L("gsst-ccs",v,r,t))$sameas(dst,"h2-n") +
                                                                  sum(v, cprt_trf("hbbs-ccs",v) * (eptrf("ppg","hbbs-ccs",v) + fptrf("ppg","hbbs-ccs",v)) * FX.L("hbbs-ccs",v,r,t))$sameas(dst,"nh3-n")));

* Total hydrogen supply
sankey_rpt("32","Hydrogen Sup","Hydrogen Disp","h2",r,t) = eps + sum(fi, h2rpt(fi,r,t));

* Net imports of hydrogen
sankey_rpt("33","Net Imports (H2)","Hydrogen Disp","h2",r,t) = eps + max(0, sum(h2f(f), -fuelbal_rpt("NTX_calc",f,r,t)));

* Coal disposition (non-electric, non-hydrogen)
sankey_rpt("34","Coal","Industry","coal",r,t) = eps + qd_enduse_rpt("ind-sm","cls",r,t) + qd_enduse_rpt("ind-lg","cls",r,t) - fueluse_ind_ccs("cls",r,t)
                                            + (qd_enduse_rpt("ind-sm","cok",r,t) + qd_enduse_rpt("ind-lg","cok",r,t) - fueluse_ind_ccs("cok",r,t)) * fptrf("clm","ckov","2020");
sankey_rpt("35","Coal","Industry","coal+CC",r,t) = eps + fueluse_ind_ccs("cls",r,t) + fueluse_ind_ccs("cok",r,t);
sankey_rpt("36","Coal","Upstream (Coal)","coal",r,t) = eps + fuelbal_rpt("QD_UPS","cls",r,t) + sum(bfl(f), QD_TRF.L("cls",f,r,t));

* Natural Gas to pipeline gas (after feedstock use for hydrogen)
sankey_rpt("37","Natural Gas","Pipeline Gas","gas",r,t) = eps + sum(dst$(not sameas(dst,"h2-n") and not sameas(dst,"nh3-n")), fuelbal_blend_rpt("gas",dst,"ppg",r,t));

* Bioenergy and bio-refining
sankey_rpt("38","Bioenergy","Buildings","bio",r,t) = eps + qd_enduse_rpt("res","bio",r,t) + qd_enduse_rpt("com","bio",r,t);
sankey_rpt("39","Bioenergy","Industry","bio",r,t) = eps + qd_enduse_rpt("ind-sm","bio",r,t) + qd_enduse_rpt("ind-lg","bio",r,t) + bio_ex(r,t) - fueluse_ind_ccs("bio",r,t);
sankey_rpt("40","Bioenergy","Industry","bio+CC",r,t) = eps + fueluse_ind_ccs("bio",r,t);

* Add exogenous biomass feedstock to conventional ethanol production (assume 1.8x output)
sankey_rpt("41","Bioenergy","Bio-refining","bio",r,t) = eps + sum((bi(fi),v)$(not sameas(fi,"bio-upgr") and not fimap("h2-n",fi)), (1 - cprt_trf(fi,v)) * (bfspbfl(fi,v) + 1.8$fimap("eth",fi)) * FX.L(fi,v,r,t))
                                                            - sum(dst$(sameas(dst,"h2-n") or sameas(dst,"nh3-n")), fuelbal_blend_rpt("rng",dst,"ppg",r,t));
sankey_rpt("42","Bioenergy","Bio-refining","bio+CC",r,t) = eps + sum((bi(fi),v)$(not sameas(fi,"bio-upgr") and not fimap("h2-n",fi)), cprt_trf(fi,v) * (bfspbfl(fi,v) + 1.8$fimap("eth",fi)) * FX.L(fi,v,r,t));

sankey_rpt("43","Bio-refining","Biof Disp","biof",r,t) = eps + sum(bfl(f)$(not sameas(f,"bio")), fuelbal_rpt("QSF",f,r,t)) - sum(dst$(sameas(dst,"h2-n") or sameas(dst,"nh3-n")), fuelbal_blend_rpt("rng",dst,"ppg",r,t));
sankey_rpt("44","Net Imports (Biof)","Biof Disp","biof",r,t) = eps + max(0, sum(bfl(f), -fuelbal_rpt("NTX_calc",f,r,t)));

sankey_rpt("45","Biof Disp","Pipeline Gas","biof",r,t) = eps + sum(dst$(not sameas(dst,"h2-n") and not sameas(dst,"nh3-n")), fuelbal_blend_rpt("rng",dst,"ppg",r,t));
sankey_rpt("46","Biof Disp","Liquid Fuels","biof",r,t) = eps + fuelbal_rpt("QD_BLEND","eth",r,t) + fuelbal_rpt("QD_BLEND","rgl",r,t) + fuelbal_rpt("QD_BLEND","rdl",r,t) + fuelbal_rpt("QD_BLEND","spk",r,t);
sankey_rpt("47","Biof Disp","Net Exports (Biof)","biof",r,t) = eps + max(0, sum(bfl(f), fuelbal_rpt("NTX_calc",f,r,t)));

* Primary petroleum including HGLs (assume all primary energy is converted to outputs, but some outputs are consumed by the refinery, mainly stg and pck)
sankey_rpt("48","Petroleum","Petroleum Refining","petro",r,t) = eps + sum(f, rfp_rpt(f,r,t));
sankey_rpt("49","Petroleum Refining","Petroleum Disp","rfp",r,t) = eps + sum(f, rfp_rpt(f,r,t) - fuelbal_rpt("QD_UPS",f,r,t)$(sameas(f,"stg") or sameas(f,"pck")));

* Assume stg (still gas) is consumed locally
sankey_rpt("50","Net Imports (RFP)","Petroleum Disp","rfp",r,t) = eps + max(0,
                sum(f$((rfp(f) or sameas(f,"hgl")) and not sameas(f,"stg")), fuelbal_rpt("QD_Tot",f,r,t)) - sum(f$(not sameas(f,"stg")), rfp_rpt(f,r,t))
);

sankey_rpt("51","Petroleum Disp","Liquid Fuels","rfp",r,t) = eps + fuelbal_rpt("QD_Blend","gsl",r,t) + fuelbal_rpt("QD_Blend","dfo",r,t) + fuelbal_rpt("QD_BLEND","jfk",r,t)
  + fuelbal_rpt("qd_enduse_x","hgl",r,t) - sum(kf, qd_enduse_non(kf,"hgl",r,t))
  + fuelbal_rpt("qd_enduse_x","mpp",r,t) - sum(kf, qd_enduse_non(kf,"mpp",r,t))
  + fuelbal_rpt("qd_enduse_x","rfo",r,t);
;
* Non-refinery upstream use of other petroleum products is typically very small (and omitted from diagram) but included for completeness
sankey_rpt("52","Petroleum Disp","Upstream (RFP)","rfp",r,t) = eps + sum(f$(sameas(f,"rfo") or sameas(f,"mpp")), fuelbal_rpt("QD_UPS",f,r,t));
sankey_rpt("53","Petroleum Disp","Non-Energy (RFP)","rfp",r,t) = eps + sum((kf,f)$(not sameas(f,"h2") and not sameas(f,"nh3")), qd_enduse_non(kf,f,r,t));
sankey_rpt("54","Petroleum Disp","Net Exports (RFP)","rfp",r,t) = eps + max(0,
                sum(f$(not sameas(f,"stg")), rfp_rpt(f,r,t)) - sum(f$(rfp(f) or sameas(f,"hgl") and not sameas(f,"stg")), fuelbal_rpt("QD_Tot",f,r,t))
);

* Disposition of electricity
sankey_rpt("55","Electricity","Net Exports (Ele)","ele",r,t) = eps + max(0, 3.412 * ntxelec(r,t));
sankey_rpt("56","Electricity","Upstream (Ele)","ele",r,t) = eps + (elec_fuels_rpt("h2nh3-n",r,t) + elec_fuels_rpt("ups",r,t) + elec_fuels_rpt("lcf_inf",r,t) + elec_fuels_rpt("biofuels",r,t) + elec_fuels_rpt("nh3-e",r,t) + elec_fuels_rpt("syn_fuel",r,t));
sankey_rpt("57","Electricity","DAC (Ele)","ele",r,t) = eps + elec_fuels_rpt("dac_",r,t);
sankey_rpt("58","Distributed Solar","buildings","solar",r,t) = eps + 3.412 * genrpt_r(r,"11rfpv",t);
sankey_rpt("59","Electricity","Buildings","ele",r,t) = eps + qd_enduse_rpt("res","ele",r,t) + qd_enduse_rpt("com","ele",r,t) - 3.412 * genrpt_r(r,"11rfpv",t);
sankey_rpt("60","Electricity","Industry","ele",r,t) = eps + qd_enduse_rpt("ind-sm","ele",r,t) + qd_enduse_rpt("ind-lg","ele",r,t);
sankey_rpt("61","Electricity","Transportation","ele",r,t) = eps + qd_enduse_rpt("ldv","ele",r,t) + qd_enduse_rpt("mdhd","ele",r,t);

* Disposition of Hydrogen
* Hydrogen exports
sankey_rpt("62","Hydrogen Disp","Net Exports (H2)","h2",r,t) = eps+ max(0, sum(h2f(f),  fuelbal_rpt("NTX_calc",f,r,t)));
sankey_rpt("63","Hydrogen Disp","Ammonia Sup","h2",r,t) = eps + h2conrpt("nh3",r,t);
sankey_rpt("64","Hydrogen Disp","Upstream (H2)","h2",r,t) = eps + h2conrpt("ups",r,t);
sankey_rpt("65","Hydrogen Disp","Non-Energy (H2)","h2",r,t) = eps + sum(kf, qd_enduse_non(kf,"h2",r,t));
sankey_rpt("66","Hydrogen Disp","Pipeline Gas","h2",r,t) = eps + h2conrpt("blend",r,t);
sankey_rpt("67","Hydrogen Disp","Synfuels Sup","h2",r,t) = eps + sum(syn(f), h2conrpt(f,r,t));
sankey_rpt("68","Hydrogen Disp","Buildings","h2",r,t) = eps + qd_enduse_rpt("res","h2",r,t) + qd_enduse_rpt("com","h2",r,t);
sankey_rpt("69","Hydrogen Disp","Industry","h2",r,t) = eps + qd_enduse_rpt("ind-sm","h2",r,t) + qd_enduse_rpt("ind-lg","h2",r,t) - sum(kf, qd_enduse_non(kf,"h2",r,t));
sankey_rpt("70","Hydrogen Disp","Transportation","h2",r,t) = eps + qd_enduse_rpt("ldv","h2",r,t) + qd_enduse_rpt("mdhd","h2",r,t);

* Total supply of ammonia
sankey_rpt("71","Ammonia Sup","Ammonia Disp","nh3",r,t) = eps + sum(blendmap(f,"nh3"), fuelbal_rpt("QSF",f,r,t));
sankey_rpt("72","Net Imports (NH3)","Ammonia Disp","nh3",r,t) = eps + max(0, fuelbal_rpt("QD_Tot","nh3",r,t) - sum(blendmap(f,"nh3"), fuelbal_rpt("QSF",f,r,t)));

* Disposition of Ammonia
sankey_rpt("73","Ammonia Disp","Net Exports (NH3)","nh3",r,t) = eps + max(0, sum(blendmap(f,"nh3"), fuelbal_rpt("QSF",f,r,t)) - fuelbal_rpt("QD_Tot","nh3",r,t));
sankey_rpt("74","Ammonia Disp","Industry","nh3",r,t) = eps + qd_enduse_rpt("ind-sm","nh3",r,t) + qd_enduse_rpt("ind-lg","nh3",r,t) - sum(kf, qd_enduse_non(kf,"nh3",r,t));
sankey_rpt("75","Ammonia Disp","Transportation","nh3",r,t) = eps + qd_enduse_rpt("mdhd","nh3",r,t);
sankey_rpt("76","Ammonia Disp","Non-Energy (NH3)","nh3",r,t) = eps + sum(kf, qd_enduse_non(kf,"nh3",r,t));

* Total supply of synfuels (SNF and synthetic liquid fuels)
sankey_rpt("77","Synfuels Sup","Synfuels Disp","synf",r,t) = eps + fuelbal_rpt("QSF","sng",r,t) + fuelbal_rpt("QSF","sjf",r,t);
sankey_rpt("78","Net Imports (Syn)","Synfuels Disp","synf",r,t) = eps + max(0, -fuelbal_rpt("NTX_calc","sng",r,t) - fuelbal_rpt("NTX_calc","sjf",r,t));
sankey_rpt("79","Synfuels Disp","Pipeline Gas","synf",r,t) = eps + sum(dst, fuelbal_blend_rpt("sng",dst,"ppg",r,t));
sankey_rpt("80","Synfuels Disp","Liquid Fuels","synf",r,t) = eps + fuelbal_rpt("QD_BLEND","sjf",r,t);
sankey_rpt("81","Synfuels Disp","Net Exports (Syn)","synf",r,t) = eps + max(0,  fuelbal_rpt("NTX_calc","sng",r,t) + fuelbal_rpt("NTX_calc","sjf",r,t));

* Disposition of Pipeline Gas
sankey_rpt("82","Pipeline Gas","Buildings","pgas",r,t) = eps + qd_enduse_rpt("res","ppg",r,t) + qd_enduse_rpt("com","ppg",r,t);
sankey_rpt("83","Pipeline Gas","Industry","pgas",r,t) = eps + qd_enduse_rpt("ind-sm","ppg",r,t) + qd_enduse_rpt("ind-lg","ppg",r,t) - fueluse_ind_ccs("ppg",r,t);
sankey_rpt("84","Pipeline Gas","Industry","pgas+CC",r,t) = eps + fueluse_ind_ccs("ppg",r,t);
sankey_rpt("85","Pipeline Gas","Transportation","pgas",r,t) = eps + qd_enduse_rpt("mdhd","ppg",r,t);
sankey_rpt("86","Pipeline Gas","Upstream (Gas)","pgas",r,t) = eps + fuelbal_rpt("QD_UPS","ppg",r,t) + sum(bfl(f), QD_TRF.L("ppg",f,r,t));
sankey_rpt("87","Pipeline Gas","Upstream (Gas)","pgas+CC",r,t) = eps;
sankey_rpt("88","Pipeline Gas","DAC (Gas)","pgas+CC",r,t) = eps + QD_DAC.L("ppg",r,t);

* Disposition of Liquid Fuels
sankey_rpt("89","Liquid Fuels","Buildings","liq",r,t) = eps + sum(f$(sameas(f,"mgs") or sameas(f,"dsl") or sameas(f,"hgl")), qd_enduse_rpt("res",f,r,t) + qd_enduse_rpt("com",f,r,t));
sankey_rpt("90","Liquid Fuels","Industry","liq",r,t) = eps + sum(f$(sameas(f,"mgs") or sameas(f,"dsl") or sameas(f,"hgl") or sameas(f,"rfo") or sameas(f,"mpp")), qd_enduse_rpt("ind-sm",f,r,t) + qd_enduse_rpt("ind-lg",f,r,t) - qd_enduse_non("ind-sm",f,r,t) - qd_enduse_non("ind-lg",f,r,t));
sankey_rpt("91","Liquid Fuels","Transportation","liq",r,t) = eps + sum(f$(sameas(f,"mgs") or sameas(f,"dsl") or sameas(f,"jfl") or sameas(f,"rfo") or sameas(f,"mpp")), qd_enduse_rpt("ldv",f,r,t) + qd_enduse_rpt("mdhd",f,r,t) - qd_enduse_non("mdhd",f,r,t));
* Upstream use of liquid fuels is typically very small (and omitted from diagram) but included for completeness
sankey_rpt("92","Liquid Fuels","Upstream (Liq)","liq",r,t) = eps + sum(f$(sameas(f,"mgs") or sameas(f,"dsl") or sameas(f,"hgl")), QD_UPS.L(f,r,t) + sum(trf, QD_TRF.L(f,trf,r,t)));

* Check balance nodes to confirm alignment of source and sink totals
alias(sankey_node,source_node);
alias(sankey_node,sink_node);
sankey_bal_check(sankey_node_bal(sankey_node),"source_sum",r,t) = sum(sankey_diagram(sfl_ind,source_node,sankey_node,sankey_flow), sankey_rpt(sfl_ind,source_node,sankey_node,sankey_flow,r,t));
sankey_bal_check(sankey_node_bal(sankey_node),"sink_sum",r,t) = sum(sankey_diagram(sfl_ind,sankey_node,sink_node,sankey_flow), sankey_rpt(sfl_ind,sankey_node,sink_node,sankey_flow,r,t));
sankey_bal_check(sankey_node_bal(sankey_node),"diff",r,t) = sankey_bal_check(sankey_node,"source_sum",r,t) - sankey_bal_check(sankey_node,"sink_sum",r,t);
sankey_bal_check(sankey_node_bal(sankey_node),"loss",r,t)$(sankey_bal_check(sankey_node,"source_sum",r,t) > 1e-3) = sankey_bal_check(sankey_node,"diff",r,t) / sankey_bal_check(sankey_node,"source_sum",r,t);

* Create reporting regions and US totals by aggregation
sankey_rpt(sankey_diagram(sfl_ind,source_node,sink_node,sankey_flow),rpt,t) = sum(xrpt(rpt,r), sankey_rpt(sfl_ind,source_node,sink_node,sankey_flow,r,t));
sankey_rpt(sankey_diagram(sfl_ind,source_node,sink_node,sankey_flow),"us48",t) = sum(r, sankey_rpt(sfl_ind,source_node,sink_node,sankey_flow,r,t));

* Calculate net trade nodes for regional aggregates
sankey_rpt("23","Net Imports (Ele)","Electricity","ele",rpt,t) = eps + max(0, -3.412 * sum(xrpt(rpt,r), ntxelec(r,t)));
sankey_rpt("55","Electricity","Net Exports (Ele)","ele",rpt,t) = eps + max(0,  3.412 * sum(xrpt(rpt,r), ntxelec(r,t)));

sankey_rpt("33","Net Imports (H2)","Hydrogen Disp","h2",rpt,t) = max(0, sum((xrpt(rpt,r),h2f(f)), -fuelbal_rpt("NTX_calc",f,r,t)));
sankey_rpt("62","Hydrogen Disp","Net Exports (H2)","h2",rpt,t) = max(0, sum((xrpt(rpt,r),h2f(f)),  fuelbal_rpt("NTX_calc",f,r,t)));

sankey_rpt("44","Net Imports (Biof)","Biof Disp","biof",rpt,t) = eps + max(0, sum((xrpt(rpt,r),bfl(f)), -fuelbal_rpt("NTX_calc",f,r,t)));
sankey_rpt("47","Biof Disp","Net Exports (Biof)","biof",rpt,t) = eps + max(0, sum((xrpt(rpt,r),bfl(f)), fuelbal_rpt("NTX_calc",f,r,t)));

sankey_rpt("50","Net Imports (RFP)","Petroleum Disp","rfp",rpt,t) = eps + max(0, sum(xrpt(rpt,r),
                sum(f$((rfp(f) or sameas(f,"hgl")) and not sameas(f,"stg")), fuelbal_rpt("QD_Tot",f,r,t)) - sum(f$(not sameas(f,"stg")), rfp_rpt(f,r,t)))
);
sankey_rpt("54","Petroleum Disp","Net Exports (RFP)","rfp",rpt,t) = eps + max(0, sum(xrpt(rpt,r),
                sum(f$(not sameas(f,"stg")), rfp_rpt(f,r,t)) - sum(f$(rfp(f) or sameas(f,"hgl") and not sameas(f,"stg")), fuelbal_rpt("QD_Tot",f,r,t)))
);

sankey_rpt("72","Net Imports (NH3)","Ammonia Disp","nh3",rpt,t) = eps + max(0, sum(xrpt(rpt,r), fuelbal_rpt("QD_Tot","nh3",r,t) - sum(blendmap(f,"nh3"), fuelbal_rpt("QSF",f,r,t))));
sankey_rpt("73","Ammonia Disp","Net Exports (NH3)","nh3",rpt,t) = eps + max(0, sum(xrpt(rpt,r), sum(blendmap(f,"nh3"), fuelbal_rpt("QSF",f,r,t)) - fuelbal_rpt("QD_Tot","nh3",r,t)));

sankey_rpt("78","Net Imports (Syn)","Synfuels Disp","synf",rpt,t) = max(0, sum(xrpt(rpt,r), -fuelbal_rpt("NTX_calc","sng",r,t) - fuelbal_rpt("NTX_calc","sjf",r,t)));
sankey_rpt("81","Synfuels Disp","Net Exports (Syn)","synf",rpt,t) = max(0, sum(xrpt(rpt,r),  fuelbal_rpt("NTX_calc","sng",r,t) + fuelbal_rpt("NTX_calc","sjf",r,t)));

* US total net trade
sankey_rpt("23","Net Imports (Ele)","Electricity","ele","us48",t) = eps + max(0, -3.412 * sum(r, ntxelec(r,t)));
sankey_rpt("55","Electricity","Net Exports (Ele)","ele","us48",t) = eps + max(0,  3.412 * sum(r, ntxelec(r,t)));

sankey_rpt("33","Net Imports (H2)","Hydrogen Disp","h2","us48",t) = max(0, sum((r,h2f(f)), -fuelbal_rpt("NTX_calc",f,r,t)));
sankey_rpt("62","Hydrogen Disp","Net Exports (H2)","h2","us48",t) = max(0, sum((r,h2f(f)),  fuelbal_rpt("NTX_calc",f,r,t)));

sankey_rpt("44","Net Imports (Biof)","Biof Disp","biof","us48",t) = eps + max(0, sum((r,bfl(f)), -fuelbal_rpt("NTX_calc",f,r,t)));
sankey_rpt("47","Biof Disp","Net Exports (Biof)","biof","us48",t) = eps + max(0, sum((r,bfl(f)), fuelbal_rpt("NTX_calc",f,r,t)));

sankey_rpt("50","Net Imports (RFP)","Petroleum Disp","rfp","us48",t) = eps + max(0, sum(r,
                sum(f$((rfp(f) or sameas(f,"hgl")) and not sameas(f,"stg")), fuelbal_rpt("QD_Tot",f,r,t)) - sum(f$(not sameas(f,"stg")), rfp_rpt(f,r,t)))
);
sankey_rpt("54","Petroleum Disp","Net Exports (RFP)","rfp","us48",t) = eps + max(0, sum(r,
                sum(f$(not sameas(f,"stg")), rfp_rpt(f,r,t)) - sum(f$(rfp(f) or sameas(f,"hgl") and not sameas(f,"stg")), fuelbal_rpt("QD_Tot",f,r,t)))
);

sankey_rpt("72","Net Imports (NH3)","Ammonia Disp","nh3","us48",t) = eps + max(0, sum(r, fuelbal_rpt("QD_Tot","nh3",r,t) - sum(blendmap(f,"nh3"), fuelbal_rpt("QSF",f,r,t))));
sankey_rpt("73","Ammonia Disp","Net Exports (NH3)","nh3","us48",t) = eps + max(0, sum(r, sum(blendmap(f,"nh3"), fuelbal_rpt("QSF",f,r,t)) - fuelbal_rpt("QD_Tot","nh3",r,t)));

sankey_rpt("78","Net Imports (Syn)","Synfuels Disp","synf","us48",t) = max(0, sum(r, -fuelbal_rpt("NTX_calc","sng",r,t) - fuelbal_rpt("NTX_calc","sjf",r,t)));
sankey_rpt("81","Synfuels Disp","Net Exports (Syn)","synf","us48",t) = max(0, sum(r,  fuelbal_rpt("NTX_calc","sng",r,t) + fuelbal_rpt("NTX_calc","sjf",r,t)));

* Check balance nodes for regional aggregates to confirm alignment of source and sink totals
sankey_bal_check(sankey_node_bal(sankey_node),"source_sum",rpt,t) = sum(sankey_diagram(sfl_ind,source_node,sankey_node,sankey_flow), sankey_rpt(sfl_ind,source_node,sankey_node,sankey_flow,rpt,t));
sankey_bal_check(sankey_node_bal(sankey_node),"sink_sum",rpt,t) = sum(sankey_diagram(sfl_ind,sankey_node,sink_node,sankey_flow), sankey_rpt(sfl_ind,sankey_node,sink_node,sankey_flow,rpt,t));
sankey_bal_check(sankey_node_bal(sankey_node),"diff",rpt,t) = sankey_bal_check(sankey_node,"source_sum",rpt,t) - sankey_bal_check(sankey_node,"sink_sum",rpt,t);
sankey_bal_check(sankey_node_bal(sankey_node),"loss",rpt,t)$(sankey_bal_check(sankey_node,"source_sum",rpt,t) > 1e-3) = sankey_bal_check(sankey_node,"diff",rpt,t) / sankey_bal_check(sankey_node,"source_sum",rpt,t);

sankey_bal_check(sankey_node_bal(sankey_node),"source_sum","us48",t) = sum(sankey_diagram(sfl_ind,source_node,sankey_node,sankey_flow), sankey_rpt(sfl_ind,source_node,sankey_node,sankey_flow,"us48",t));
sankey_bal_check(sankey_node_bal(sankey_node),"sink_sum","us48",t) = sum(sankey_diagram(sfl_ind,sankey_node,sink_node,sankey_flow), sankey_rpt(sfl_ind,sankey_node,sink_node,sankey_flow,"us48",t));
sankey_bal_check(sankey_node_bal(sankey_node),"diff","us48",t) = sankey_bal_check(sankey_node,"source_sum","us48",t) - sankey_bal_check(sankey_node,"sink_sum","us48",t);
sankey_bal_check(sankey_node_bal(sankey_node),"loss","us48",t)$(sankey_bal_check(sankey_node,"source_sum","us48",t) > 1e-3) = sankey_bal_check(sankey_node,"diff","us48",t) / sankey_bal_check(sankey_node,"source_sum","us48",t);

* * * Sankey derivative reports for individual markets

hydrogen("Supply","SMR (gas)",r,t) = eps$sameas(t,"2020") + h2rpt("gsst",r,t) + sum(v, eptrf("ppg","hbbs",v) / eptrf("ppg","gsst",v) * FX.L("hbbs",v,r,t)); ;
hydrogen("Supply","SMR (gas)+CCS",r,t) = eps$sameas(t,"2020") + h2rpt("gsst-ccs",r,t) + sum(v, eptrf("ppg","hbbs-ccs",v) / eptrf("ppg","gsst-ccs",v) * FX.L("hbbs-ccs",v,r,t));
hydrogen("Supply","Bio-H2",r,t) = eps$sameas(t,"2020") + h2rpt("bioh2",r,t);
hydrogen("Supply","Bio-H2+CCS",r,t) = eps$sameas(t,"2020") + h2rpt("bioh2-ccs",r,t);
hydrogen("Supply","Electrolysis",r,t) = eps$sameas(t,"2020") + h2rpt("elys-pem",r,t) + h2rpt("elys-alk",r,t) + h2rpt("elys-hts",r,t) + h2rpt("elys-frc",r,t);

hydrogen("Supply","Total Production",r,t) = sum(sankey_diagram(sfl_ind,"Hydrogen Sup","Hydrogen Disp",sankey_flow), sankey_rpt(sfl_ind,"Hydrogen Sup","Hydrogen Disp",sankey_flow,r,t));
hydrogen("Supply","Hydrogen Net Imports",r,t) = sum(sankey_diagram(sfl_ind,"Net Imports (H2)","Hydrogen Disp",sankey_flow), sankey_rpt(sfl_ind,"Net Imports (H2)","Hydrogen Disp",sankey_flow,r,t));
hydrogen("Demand",sink_node,r,t) = sum(sankey_diagram(sfl_ind,"Hydrogen Disp",sink_node,sankey_flow), sankey_rpt(sfl_ind,"Hydrogen Disp",sink_node,sankey_flow,r,t));

hydrogen(supdem,supdem_h2,rpt,t) = sum(xrpt(rpt,r), hydrogen(supdem,supdem_h2,r,t));
hydrogen(supdem,supdem_h2,"us48",t) = sum(r, hydrogen(supdem,supdem_h2,r,t));

hydrogen(supdem,sankey_node,rpt,t) = sum(xrpt(rpt,r), hydrogen(supdem,sankey_node,r,t));
hydrogen(supdem,sankey_node,"us48",t) = sum(r, hydrogen(supdem,sankey_node,r,t));

pipeline_gas("Supply","NG to H2/NH3 via SMR",r,t) = sankey_rpt("28","Natural Gas","Hydrogen Sup","gas",r,t) + sankey_rpt("29","Natural Gas","Hydrogen Sup","gas+CC",r,t);
pipeline_gas("Supply","NG Blend",r,t) = sankey_rpt("37","Natural Gas","Pipeline Gas","gas",r,t);
pipeline_gas("Supply","RNG Blend",r,t) = sankey_rpt("45","Biof Disp","Pipeline Gas","biof",r,t);
pipeline_gas("Supply","SNG Blend",r,t) = sankey_rpt("79","Synfuels Disp","Pipeline Gas","synf",r,t);
pipeline_gas("Supply","Hydrogen Blend",r,t) = sankey_rpt("66","Hydrogen Disp","Pipeline Gas","h2",r,t);

pipeline_gas("Demand","H2/NH3 via SMR",r,t) = pipeline_gas("Supply","NG to H2/NH3 via SMR",r,t);
pipeline_gas("Demand","Power",r,t) = sankey_rpt("8","Pipeline Gas","Thermal Gen","pgas",r,t) + sankey_rpt("9","Pipeline Gas","Thermal Gen","pgas+CC",r,t);
pipeline_gas("Demand","Buildings",r,t) = sankey_rpt("82","Pipeline Gas","Buildings","pgas",r,t);
pipeline_gas("Demand","Industry",r,t) = sankey_rpt("83","Pipeline Gas","Industry","pgas",r,t) + sankey_rpt("84","Pipeline Gas","Industry","pgas+CC",r,t);
pipeline_gas("Demand","Transportation",r,t) = sankey_rpt("85","Pipeline Gas","Transportation","pgas",r,t);
pipeline_gas("Demand","Upstream/DAC",r,t) = sankey_rpt("86","Pipeline Gas","Upstream (gas)","pgas",r,t) + sankey_rpt("87","Pipeline Gas","Upstream (gas)","pgas+CC",r,t) + sankey_rpt("88","Pipeline Gas","DAC (gas)","pgas+CC",r,t);

pipeline_gas(supdem,supdem_ppg,rpt,t) = sum(xrpt(rpt,r), pipeline_gas(supdem,supdem_ppg,r,t));
pipeline_gas(supdem,supdem_ppg,"us48",t) = sum(r, pipeline_gas(supdem,supdem_ppg,r,t));

liquid_fuels("Supply",source_node,r,t) = sum(sankey_diagram(sfl_ind,source_node,"Liquid Fuels",sankey_flow), sankey_rpt(sfl_ind,source_node,"Liquid Fuels",sankey_flow,r,t));
liquid_fuels("Demand",sink_node,r,t) = sum(sankey_diagram(sfl_ind,"Liquid Fuels",sink_node,sankey_flow), sankey_rpt(sfl_ind,"Liquid Fuels",sink_node,sankey_flow,r,t));

liquid_fuels(supdem,sankey_node,rpt,t) = sum(xrpt(rpt,r), liquid_fuels(supdem,sankey_node,r,t));
liquid_fuels(supdem,sankey_node,"us48",t) = sum(r, liquid_fuels(supdem,sankey_node,r,t));

biomass("Supply","Waste Methane",r,t) = sum(bfsc, QS_BFS.L("wsm",bfsc,r,t));
biomass("Supply","Cellulosic Residues",r,t) = sum((bfsc,bfs)$(sameas(bfs,"agr") or sameas(bfs,"frr") or sameas(bfs,"otr")), QS_BFS.L(bfs,bfsc,r,t)) + bio_ex(r,t);
biomass("Supply","Cellulosic Energy Crops and Logs",r,t) = sum((bfsc,bfs)$(sameas(bfs,"cll") or sameas(bfs,"log")), QS_BFS.L(bfs,bfsc,r,t));
biomass("Supply","Corn for Ethanol",r,t) = 1.8 * fuelbal_rpt("QSF","eth",r,t);
biomass("Supply","Biofuel Net Imports",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Net Imports (Biof)","Biof Disp","biof",r,t));
biomass("Demand","Conventional Ethanol",r,t) = fuelbal_rpt("QSF","eth",r,t);
biomass("Demand","Cellulosic Liquid Fuels",r,t) = fuelbal_rpt("QSF","rgl",r,t) + fuelbal_rpt("QSF","rdl",r,t) + fuelbal_rpt("QSF","spk",r,t) - sum(sfl_ind, sankey_rpt(sfl_ind,"Biof Disp","Net Exports (Biof)","biof",r,t));
biomass("Demand","Biofuel Net Exports",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Biof Disp","Net Exports (Biof)","biof",r,t));
biomass("Demand","RNG",r,t) = sum(sankey_diagram(sfl_ind,"Biof Disp","Pipeline Gas",sankey_flow), sankey_rpt(sfl_ind,"Biof Disp","Pipeline Gas",sankey_flow,r,t));
biomass("Demand","Bio-H2",r,t) = hydrogen("Supply","Bio-H2",r,t) + hydrogen("Supply","Bio-H2+CCS",r,t);
biomass("Demand",sink_node,r,t) = sum(sankey_diagram(sfl_ind,"Bioenergy",sink_node,sankey_flow), sankey_rpt(sfl_ind,"Bioenergy",sink_node,sankey_flow,r,t))$(sameas(sink_node,"Buildings") or sameas(sink_node,"Industry") or sameas(sink_node,"Thermal Gen"));

biomass(supdem,supdem_bio,rpt,t) = sum(xrpt(rpt,r), biomass(supdem,supdem_bio,r,t));
biomass(supdem,supdem_bio,"us48",t) = sum(r, biomass(supdem,supdem_bio,r,t));

finalen("Buildings","Biomass",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Bioenergy","Buildings","bio",r,t));
finalen("Buildings","Liquid Fuels",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Liquid Fuels","Buildings","liq",r,t));
finalen("Buildings","Pipeline Gas",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Pipeline Gas","Buildings","pgas",r,t));
finalen("Buildings","Hydrogen",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Hydrogen Disp","Buildings","h2",r,t));
finalen("Buildings","Electricity",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Electricity","Buildings","ele",r,t));

finalen("Industry","Coal",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Coal","Industry","coal",r,t));
finalen("Industry","Coal+CCS",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Coal","Industry","coal+CC",r,t));
finalen("Industry","Biomass",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Bioenergy","Industry","bio",r,t));
finalen("Industry","Biomass+CCS",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Bioenergy","Industry","bio+CC",r,t));
finalen("Industry","Liquid Fuels",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Liquid Fuels","Industry","liq",r,t));
finalen("Industry","Pipeline Gas",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Pipeline Gas","Industry","pgas",r,t));
finalen("Industry","Pipeline Gas+CCS",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Pipeline Gas","Industry","pgas+CC",r,t));
finalen("Industry","Hydrogen",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Hydrogen Disp","Industry","h2",r,t));
finalen("Industry","Ammonia",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Ammonia Disp","Industry","h2",r,t));
finalen("Industry","Electricity",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Electricity","Industry","ele",r,t));

finalen("Transportation","Liquid Fuels",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Liquid Fuels","Transportation","liq",r,t));
finalen("Transportation","Pipeline Gas",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Pipeline Gas","Transportation","pgas",r,t));
finalen("Transportation","Hydrogen",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Hydrogen Disp","Transportation","h2",r,t));
finalen("Transportation","Ammonia",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Ammonia Disp","Transportation","h2",r,t));
finalen("Transportation","Electricity",r,t) = sum(sfl_ind, sankey_rpt(sfl_ind,"Electricity","Transportation","ele",r,t));

finalen("Total",finalfuel,r,t) = sum(finalsec, finalen(finalsec,finalfuel,r,t));

finalen(finalsec,finalfuel,rpt,t) = sum(xrpt(rpt,r), finalen(finalsec,finalfuel,r,t));
finalen(finalsec,finalfuel,"us48",t) = sum(r, finalen(finalsec,finalfuel,r,t));

* * * * * * * * * * * * * * * * * Dual Variable Reporting * * * * * * * * * * * * * * * * *

set
cashflows               Terms of net present value cash flow /revenue,opcost,invcost,net,cumnet/
pf_enduse_problem(kf,f,r,t)	Fuel-sector-region combinations with zero price
phist                   Price histogram values /p0,p5,p10,p15,p20,p25,p30,p35,p40,p45,p50,p55,p60,p65,p70,p75,p80,p85,p90,p95,p100/
lhist                   Load histogram values /l0,l5,l10,l15,l20,l25,l30,l35,l40,l45,l50,l55,l60,l65,l70,l75,l80,l85,l90,l95,l100/
investcat               Investment reporting categories /newgen,retro,irtrans,storage,co2pipe_ele,dac,co2pipe_dac,co2stor_tot,itc/
opcostcat               Operations reporting categories /fuelcost,vom,fom,storage_fom,co2pipe_fom,emit_pp,ptc,45q/
;

parameter
* Segment-level power market prices
elebal_M(s,r,t)         Normalized marginal on elebal equation ($ per MWh)
p_gen_s(s,r,t)          Energy-only electricity generation (before-loss) price by segment and region ($ per MWh)
p_con_s(s,r,t)          Energy-only electricity consumption (after-loss) price by segment and region ($ per MWh)
maxcost(s,r,t)          Highest dispatch cost of operating capacity ($ per MWh)
plcurve(*,s,r,t)        Price and load duration curves over hours

* Reserve margin prices not reflected on marginal on elebal equation
rsvpr(r,t)              Reserve margin price ($ per kW-year)
rsvpr_i(i,v,r,t)        Reserve margin price realized by each unit ($ per kW-year)
rsvpr_ic(i,vv,v,r,t)    Reserve margin price realized by each converted unit ($ per kW-year)
rsv_m(r,t)              Marginal adder associated with reserve margin constraint ($ per MWh)
rsv_m_ldv(r,t)          Marginal adder associated with reserve margin constraint for LDV charging ($ per MWh)
rsv_m_mdhd(r,t)         Marginal adder associated with reserve margin constraint for MD-HD charging ($ per MWh)
rsv_m_nnrd(r,t)         Marginal adder associated with reserve margin constraint for non-road charging ($ per MWh)
rsv_m_dc(r,t)           Marginal adder associated with reserve margin constraint for data centers ($ per MWh)

* Portfolio constraint (RPS/CES) prices not reflected in marginal on elebal equation
strecpr(r,t)            State REC price ($ per MWh)
strecpr_u(t)            National price for unbundled state RECs ($ per MWh)
srps_m(r,t)             Annual price adder to reflect state RPS constraint ($ per MWh)
recpr(t)                Federal RPS REC price ($ per MWh)
fullrecpr(t)            Full (generation-based) federal RPS REC price ($ per MWh)
rps_m(t)                Annual price adder to reflect federal RPS constraint ($ per MWh)
cespr(r,t)              Clean electricity standard price ($ per MWh)
ces_m(r,t)              Annual price adder to reflect federal CES constraint ($ per MWh)
sb100pr(t)              CA SB-100 CES price ($ per MWh)
sb100_m(t)              Annual price adder to reflect CA SB-100 CES ($ per MWh)
zercpr(*,r,t)           Annual average 45V and CFE ZERC prices ($ per MWh)
zercpr_s(*,s,r,t)       Segment-level 45V and CFE Zerc prices ($ per MWh)

* Subsidies based on lower bounds not reflected in marginal on demand equation
ssolpr(r,t)             Incremental state solar carve-out price ($ per MWh)
ssol_m(r,t)             Annual price adder to reflect state solar carve-out constraint ($ per MWh)
wnospr(r,t)             Implied subsidy for off-shore wind mandate ($ per kW)
wnos_m(r,t)             Annual price adder to reflect off-shore wind mandate ($ per MWh)
nuczecpr(r,t)           Implied subsidy for existing nuclear ($ per kW)
nuczec_m(r,t)           Annual price adder to reflect existing nuclear subsidy ($ per MWh)
newunitspr(i,r,t)       Implied subsidy for other lower bound constraints ($ per kW)
newunits_m(r,t)         Annual price adder to reflect other lower bound constraints ($ per MWh)

* Annual average electricity prices (wholesale energy only)
p_con(r,t)              Average price ($ per MWh after losses) for consumption in each region
p_con_ldv(r,t)          Average price ($ per MWh after losses) for consumption for LDV charging
p_con_mdhd(r,t)         Average price ($ per MWh after losses) for consumption for MD-HD charging
p_con_nnrd(r,t)         Average price ($ per MWh after losses) for consumption for non-road charging
p_con_dc(r,t)           Average price ($ per MWh after losses) for consumption for data centers
p_gen(r,t)              Average price ($ per MWh before losses) for generation in each region
p_domexp(r,rr,t)        Average price ($ per MWh before losses) for power exported from r to rr
p_intexp(r,t)           Average price ($ per MWh before losses) for power exported from r internationally
p_domimp(r,rr,t)        Average price ($ per MWh before losses) for power imported from rr into r
p_intimp(r,t)           Average price ($ per MWh before losses) for power imported into r internationally

* p_lse refers to generation price paid by load-serving entities, i.e. wholesale energy plus
* capacity and other compliance payments, or the generation component of the retail price
p_lse(r,t)              Generation electricity price based on adding up marginals ($ per MWh)
p_lse_ldv(r,t)          Generation price (before distribution) for LDV vehicle charging ($ per MWh)
p_lse_mdhd(r,t)         Generation price (before distribution) for MD-HD vehicle charging ($ per MWh)
p_lse_nnrd(r,t)         Generation price (before distribution) for non-road vehicle charging ($ per MWh)
p_lse_dc(r,t)           Generation price (before distribution) for data centers ($ per MWh)
p_lse_dc_avg(t)         US average generation price (before distribution) for data centers ($ per MWh)
prreport(r,t,*,*)       Report showing various annual average electricity prices ($ per MWh)
final4pr(rpt,*,t)       Aggregate regional average generation price ($ per MWh)
usavepr(*,t)            US annual average generation price ($ per MWh)

* CO2 transport and storage prices
cstor_pr(cstorclass,r,t)        Price for storage of captured CO2 ($ per tCO2)

* Fuel prices
pefuel_s(s,f,r,t)       Segment-level price of electrolytic hydrogen and e-fuels ($ per MMBtu)
pefuel(f,r,t)	        Annual average price of electrolytic hydrogen and e-fuels ($ per MMBtu)
price_rpt(f,*,t)        Wholesale fuel price report ($ per MMBtu)
price_blend_rpt(f,*,*,t)        Destination-specific blended wholesale fuel price report ($ per MMBtu)
pf_enduse_rpt(kf,f,*,t)         End-use delivered fuels prices ($ per MMBtu)
pf_enduse_rpt_2015(kf,f,*,t)    End-use delivered fuels prices ($ per MMBtu) (2015$ for end-use model iteration)
pf_elec_rpt(f,r,t)              Electric sector fuel price ($ per MMBtu)
ph2e_s(s,f,r,t)         Segment-level price of hydrogen ($ per MMBtu)
ph2e_ele(f,*,t)         Annual average price of centralized hydrogen for electric generation ($ per MMBtu)
ph2e_ivf(i,v,f,r,t)     Average price of hydrogen paid by specific generators weighted by dispatch ($ per MMBtu)
ph2e_ivvf(i,v,v,f,r,t)  Average price of hydrogen paid by specific (converted) generators weighted by dispatch ($ per MMBtu)
h2elys(*,fi,r,t)        Report on realized capacity factor and input electricity price for electrolysis

* Permit prices
co2pr(t)                Price of CO2 emissions ($ per t CO2)
co2epr(t)               Price of CO2-e emissions ($ per t CO2)
co2pr_rg(r,t)           Regional price of CO2 emissions ($ per t CO2)
co2pr_sec(*,r,t)        Sectoral price of CO2 emissions ($ per t CO2)
co2pr_ele(t)            Price of CO2 emissions under electric sector cap ($ per t CO2)
co2pr_rggi(t)           RGGI CO2 price ($ per t CO2)
co2pr_ny(t)             NY SB6599 economy-wide cap CO2 price ($ per t CO2)
co2pr_ny_ele(t)         NY SB6599 electric sector cap CO2 price ($ per t CO2)
co2pr_ca(t)             CA AB32 economy-wide cap CO2 price ($ per t CO2)
co2pr_tot(r,t)          Total CO2 price by region to the electric sector ($ per metric tonne CO2)
nonpr(pol,*,t)          Price of non-CO2 emissions for annual and seasonal programs ($ per metric tonne)

* Permit allowances
co2allow(t)             CO2 allowances (MtCO2)
co2allow_rg(r,t)        CO2 allowances by region (MtCO2)

* Expenditures
fom_gen(r,t)            Total discounted expenditure on fixed O&M ($B)
fom_gen_i(i,r,t)        Discounted expenditure on fixed O&M by capacity block ($M)
capex_gen(r,t)          Overnight annual capital expenditures on electric generation by region ($B)
uscapex_gen(t)          US Total Overnight annual capital expenditures on electric generation ($B)
invest_perperiod(investcat,*,t) Per period total investment in electric and fuels model ($B)
opcost_perperiod(opcostcat,*,t) Per period total operating cost in electric and fuels model ($B)
usnpvcost(*,t)          US total net present value of system cost by category discounted to 2020 ($B)

* Values
opcost_permwh(i,v,f,r,t)        Variable operating cost (realized) ($ per MWh)
opcost_permwh_c(i,v,v,f,r,t)    Conversions variable operating cost (realized) ($ per MWh)
opcost(i,v,r,t)         Total annual operating costs in $ millions
opcost_c(i,v,v,r,t)             Conversions Total annual operating costs ($M)
invcost_perkw(i,r,t)    New vintage investment cost ($ per kW)
invcost(i,r,t)          Total annualized new vintage investment cost ($M)
convcost_perkw(i,v,r,t) Conversions invesmtent cost ($ per kW)
convcost(i,v,r,t)       Total annualized conversion investment cost ($M)
flh(*,i,v,r,t)          Full-load hours (out of 8760) realized and shadow based on dispatch cost vs price
flh_c(*,i,v,v,r,t)      Conversions full-load hours (out of 8760) realized and shadow based on dispatch cost vs price
revenue_permwh(i,v,r,t) Revenue (energy related) by capacity block (approximates state RPS revenue) ($ per MWh)
revenue_perkw(i,v,r,t)  Revenue (capacity related) by capacity block ($ per kW)
revenue(i,v,r,t)        Total annual revenue by capacity block in $ millions (approximates state RPS revenue)
revenue_permwh_c(i,v,v,r,t)     Conversions revenue (energy related) by capacity block (approximates state RPS revenue) ($ per MWh)
revenue_perkw_c(i,v,v,r,t)      Conversions revenue (capacity related) by capacity block ($ per kW)
revenue_c(i,v,v,r,t)	Conversions total annual revenue by capacity block (approximates state RPS revenue) ($M)
capv(i,v,r)             Active combinations of i v and r in solution (sum of GW over t)
npvcap(*,cashflows,i,v,r)       Net present value of revenue and cost for all capacity blocks ($B)
npvcap_t(*,cashflows,i,v,r,t)   Net present value of revenue and cost for all capacity blocks over time ($B)
pvxcap(*,*,i,r)         Present value of existing capacity in 2010 ($B)
pvxcap_coal(*,i,r)      Total net value for coal blocks ($B)
pvxcap_coal_r(*,r)      Total net value of coal by region ($B)
pvxcap_US(*)            Total US present value of existing capacity ($B)
value_perkw(*,i,v,r)    Realized and shadow value of investments compared to investment cost ($ per kW)
value_perkw_c(*,i,v,v,r)        Conversions Realized and shadow value of investments compared to investment cost ($ per kW)
ira_rpt(*,*)            Annual (and total cumulative) outlay for IRA subsidies ($B)
cestaxrev_i(i,r,t)      Implicit net transfers to individual units from CES ($B)
cestaxrev(*,t)          Implicit net transfers among generation types and regions from CES ($B)
tcost_interlinks(r,t)   Annual cost of inter-regional transmission ($B)
cesflow(*,*,t)          Aggregate regional flows in CES market ($B)
cesflow_i(i,*,*,t)      Aggregate regional flows in CES market by capacity block ($B)
genrev(i,r,t)           Power revenues by capacity block ($B)
rpsflow(*,*,t)          Aggregate regional flows in RPS market ($B)
rpsflow_i(i,*,*,t)      Aggregate regional flows in RPS market by capacity block ($B)
srps_bal(*,r,t)         Expenditure on state RPS credits ($B)
srps_rev(*,r)           Net present value of state RPS rents compared to net revenue from renewables ($B)

* Histogram parameters
minphist(phist)	        Price histogram values /p0 0,p5 5,p10 10,p15 15,p20 20,p25 25,p30 30,p35 35,p40 40,p45 45,p50 50,p55 55,p60 60,p65 65,p70 70,p75 75,p80 80,p85 85,p90 90,p95 95,p100 100/
minlhist(lhist)         Load histogram values /l0 0,l5 5,l10 10,l15 15,l20 20,l25 25,l30 30,l35 35,l40 40,l45 45,l50 50,l55 55,l60 60,l65 65,l70 70,l75 75,l80 80,l85 85,l90 90,l95 95,l100 100/
prcurve_hist(phist,r,t)         Price duration curve histogram (energy-only generation price)
ldcurve_hist(lhist,r,t)         Load duration curve historgram (grid supplied energy for load)

* Retail electricity prices
retailvalue(r)	        Total value of retail sales in 2015 ($B)
tdvalue(r)	        Value of retail sales attributed (by EIA) to transmission and distribution in 2015 ($B)
rtl_ptd_avg(r)          Average T&D price across sectors ($ per MWh)
genvalue(r)             Value of retail sales attributed (by EIA) to generation in 2015 ($B)
genvaluebase(r)         Value of base year generation at model prices ($B)
p_lse_reference(r,t)    Modeled generation price in reference scenario ($ per MWh)
lse_gap(r)              Gap between observed and modeled generation price ($ per MWh)
rtl_pg_regen(r,t)       Generation component of retail price as modeled in REGEN ($ per MWh)
rtl_pg_rpt(rpt,t)       Reporting region average generation component of retail price ($ per MWh)
rtl_pg_usa(t)           US average generation component of retail price ($ per MWh)
rtlpgrpt(*,t)           Generation component of retail price report ($ per MWh)
rtl_ptd_t(r,sec,t)      T&D component of retail prices over time calculated in end-use model ($ per MWh)
rtl_regen(sec,r,t)	Retail price by sector as modeled in REGEN ($ per MWh)
rtl_regen_2015(sec,r,t) Retail price by sector as modeled in REGEN ($ per MWh) (2015$ for end-use model iteration)
rtl_regen_ldv(r,t)      Adjusted retail price for residential LDV charging ($ per MWh)
rtl_regen_mdhd(r,t)     Adjusted retail price for commercial MD-HD charging ($ per MWh)
rtl_regen_nnrd(r,t)     Adjusted retail price for industrial non-road vehicle charging ($ per MWh)
rtl_regen_dc(r,t)       Adjusted retail price for commercial data centers ($ per MWh)
rtl_pg_regen_prev(r,t)	Generation component of retail price in previous iteration of electric model ($ per MWh)
rtl_pg_regen_iter(*,r,t)        Comparison of generation price in current and previous iteration ($ per MWh)
regenelec_exp(*,*,t)	REGEN electric model expenditures broken into gen and trans (and carbon revenue) ($B)
expend_nrg(*,df,r,t)            Expenditures on delivered energy by sector and fuel ($B per year)
expend_nrgtot(*,*,*,t)          Household and Non-household delivered energy expenditures ($B per year)
expend_nrgtot_perhh(*,*,*,t)    Per household direct energy costs ($ thousand per HH per year)
;


* * * Segment-level power market prices

* Normalized marginals on electricity market clearing equation (sign of elebal.M MUST be preserved!)
elebal_M(s,r,t) = elebal.M(s,r,t) / dfact(t);
dspsrpt_r("price",s,r,"mrg",t) = elebal_M(s,r,t);

* Calculate annual adder on reserve margin constraints
rsvpr(r,t) = 0;
rsvpr_i(i,v,r,t) = 0;
rsvpr_ic(i,vv,v,r,t) = 0;
rsv_m(r,t) = 0;
rsv_m_ldv(r,t) = 0;
rsv_m_mdhd(r,t) = 0;
rsv_m_nnrd(r,t) = 0;
rsv_m_dc(r,t) = 0;
$iftheni.res1 NOT %reserve%==no
rsvpr(r,t) = abs(reserve.M(r,t)) / dfact(t);
rsvpr_i(ivrt(i,v,r,t)) = rsvpr(r,t) * rsvcc(i,r) + sum(s, abs(peakgrid.M(s,r,t)) * af(s,i,v,r,t) / dfact(t))$irnw(i);
rsvpr_ic(civrt(i,vv,v,r,t)) = rsvpr(r,t) * rsvcc(i,r) + sum(s, abs(peakgrid.M(s,r,t)) * af(s,i,v,r,t) / dfact(t))$irnw(i);
rsv_m(r,t) = rsvpr(r,t) * ( RMARG.L(r,t) + PKGRID.L(r,t) ) / (GRIDTWH.L(r,t) / localloss);
peakcont_ldv(r,t) = sum(pkgrid_s(s,r,t), load_ldv(s,r,t));
peakcont_mdhd(r,t) = sum(pkgrid_s(s,r,t), load_kf(s,"mdhd",r,t) * (1 / 3.412 / 8.76) * QD_EEU.L("mdhd","ele",r,t));
peakcont_nnrd(r,t) = sum(pkgrid_s(s,r,t), load_kf(s,"ind-sm",r,t) * (1 / 3.412 / 8.76) * QD_EEU.L("ind-sm","ele",r,t));
peakcont_dc(r,t) = sum(pkgrid_s(s,r,t), QD_DC_S.L(s,r,t));
rsv_m_ldv(r,t)$contot_ldv(r,t) = rsvpr(r,t) * (1 + rsvmarg(r)) * peakcont_ldv(r,t) / contot_ldv(r,t);
rsv_m_mdhd(r,t)$contot_mdhd(r,t) = rsvpr(r,t) * (1 + rsvmarg(r)) * peakcont_mdhd(r,t) / contot_mdhd(r,t);
rsv_m_nnrd(r,t)$contot_nnrd(r,t) = rsvpr(r,t) * (1 + rsvmarg(r)) * peakcont_nnrd(r,t) / contot_nnrd(r,t);
rsv_m_dc(r,t)$contot_dc(r,t) = rsvpr(r,t) * (1 + rsvmarg(r)) * peakcont_dc(r,t) / contot_dc(r,t);
$endif.res1

* For portfolio constraints, marginal credit price is part of revenue stream
* Similarly lower bounds reflect implict subsidies
* Note that each separate constraint requires a separate reporting parameter

* * * Portfolio constraints

* Calculate annual price adder on state RPS constraints
strecpr(r,t) = 0;
$ifi not %srps%==no strecpr(r,t) = abs(staterps.M(r,t)) / dfact(t);
srps_m(r,t) = strecpr(r,t) * rpstgt_r(r,t);
strecpr_u(t) = 0;
$if not %srps%==no strecpr_u(t) = abs(recmkt.M(t)) / dfact(t);

* Calculate annual price adder on federal RPS constraint
recpr(t) = 0;
$ifi not %rps%==none recpr(t) = abs(fedrps.M(t)) / dfact(t);
rps_m(t) = recpr(t) * rpstgt(t,"%rps%");
fullrecpr(t) = 0;
$ifi not %rps_full%==none fullrecpr(t)$(rpstgt(t,"%rps_full%") < 1) = abs(fullrps.M(t)) / dfact(t);

* Calculate annual price adder on clean electricity standard constraint
cespr(r,t) = 0;
ces_m(r,t) = 0;
$ifthen.ceson NOT %ces%==none
cespr(r,t) = abs(cesmkt.M(r,t)) / dfact(t) ;
* CES credit price is already embedded in wholesale electricity price for a generation-based CES (%totalload% option)
* For other CES options, calculate CES credit price adder 
$if not %cestot_option%==totalload ces_m(r,t) = cespr(r,t) * cestgt_r(r,t,"%ces%");
$endif.ceson


* Calculate annual price adder on California SB-100 CES constraint
sb100pr(t) = 0;
$ifi not %ca_sb100%==no sb100pr(t) = abs(sb100ces.M(t)) / dfact(t);
sb100_m(t) = sb100pr(t) * sb100tgt(t);

* Calculate segment-level and annual average ZERC prices for both 45V and CFE
zercpr_s("45v",s,r,t) = 0;
zercpr_s("cfe",s,r,t) = 0;
zercpr("45v",r,t) = 0;
zercpr("cfe",r,t) = 0;
con_45v_s(s,r,t) = 0;
$ifthen not %elys45v%==no
con_45v_s(s,r,t) = 1e-3 * hours(s,t) * sum(fivrt(hi,v,r,t)$(himap("h2_45v",hi) and ptctv(t,v)), (1/3.412) * eptrf("ele",hi,v) * HX.L(s,hi,v,r,t));
zercpr_s("45v",s,r,t)$(not %ann45v%) = zercmkt_45v.M(s,r,t) / dfact(t);
zercpr("45v",r,t)$(not %ann45v% and sum(s, con_45v_s(s,r,t))) = sum(s, con_45v_s(s,r,t) * zercmkt_45v.M(s,r,t)) / sum(s, con_45v_s(s,r,t)) / dfact(t);
zercpr("45v",r,t)$(%ann45v% and not %usa45v%) = zercmkt_ann45v.M(r,t) / dfact(t);
zercpr("45v",r,t)$(%ann45v% and %usa45v%) = zercmkt_annusa45v.M(t) / dfact(t);
$endif
$ifthen not %cfe247%==no
zercpr_s("cfe",s,r,t)$(not %anncfe% and not %usacfe%) = zercmkt_cfe.M(s,r,t) / dfact(t);
zercpr_s("cfe",s,r,t)$(not %anncfe% and %usacfe%) = zercmkt_usacfe.M(s,t) / dfact(t);
zercpr("cfe",r,t)$(not %anncfe% and not %usacfe% and sum(s, QD_CFE_S.L(s,r,t))) = sum(s, hours(s,t) * QD_CFE_S.L(s,r,t) * zercmkt_cfe.M(s,r,t)) / sum(s, hours(s,t) * QD_CFE_S.L(s,r,t)) / dfact(t);
zercpr("cfe",r,t)$(%anncfe% and not %usacfe%) = zercmkt_anncfe.M(r,t) / dfact(t);
zercpr("cfe",r,t)$(not %ann45v% and %usacfe% and sum((s,rr), QD_CFE_S.L(s,rr,t))) = sum(s, hours(s,t) * sum(rr, QD_CFE_S.L(s,rr,t)) * zercmkt_usacfe.M(s,t)) / sum(s, hours(s,t) * sum(rr, QD_CFE_S.L(s,rr,t))) / dfact(t);
$endif

* Unless the cestax option is switched on for current scenario, calculate implicit cestax
$iftheni %cestax%==no
cestax(ivfrt(i,v,f,r,t)) = cespr(r,t) * (cestgt_r(r,t,"%ces%")$(not nces(i)) - ces(i,v,f,r,"%ces%"));
cestax_c(civfrt(i,vv,v,f,r,t)) = cespr(r,t) * (cestgt_r(r,t,"%ces%")$(not nces(i)) - ces_c(i,vv,v,f,r,"%ces%"));
$endif
cestaxrev_i(strd(i),r,t) = 1e-3 * sum(ivfrt(i,v,f,r,t), cestax(i,v,f,r,t) * XTWH.L(i,v,f,r,t));
cestaxrev_i(conv(i),r,t) = 1e-3 * sum(civfrt(i,vv,v,f,r,t), cestax_c(i,vv,v,f,r,t) * XTWH_C.L(i,vv,v,f,r,t));
cestaxrev(type,t) = sum((idef(i,type),r), cestaxrev_i(i,r,t));
cestaxrev(r,t) = sum(i, cestaxrev_i(i,r,t));
cestaxrev("total",t) = sum(type, cestaxrev(type,t));

* * Lower bound constraints: Total implied outlay is averaged over regional energy for load

* Calculate annual price adder on state RPS solar carve-outs
ssolpr(r,t) = 0;
$ifi not %srps%==no ssolpr(r,t)$soltgt(r,t) = abs(rpssolar.M(r,t)) / dfact(t);
ssol_m(r,t) = ssolpr(r,t) * soltgt(r,t) / (GRIDTWH.L(r,t) / localloss);

* Calculate annual price adder on off-shore wind mandates
wnosmandate.M(r,t)$(not wnostgt_r(r,t)) = 0;
wnospr(r,t) = abs(wnosmandate.M(r,t)) / dfact(t);
wnos_m(r,t) = wnospr(r,t) * wnostgt_r(r,t) / (GRIDTWH.L(r,t) / localloss);

* Calculate annual price adder on existing nuclear subsidies (equation is excluded from static model)
nuczecpr(r,t) = 0;
$ifi %static%==no nuczecpr(r,t) = abs(nucst.M(r,t)) / dfact(t);
nuczec_m(r,t) = nuczecpr(r,t) * nuczec(r,t) / (GRIDTWH.L(r,t) / localloss);

* Calculate annual price adder on other lower bound constraints
newunitspr(i,r,t)$sum(idef(i,type), newunits(type,r,t)) = abs(IX.M(i,r,t)) / dfact(t);
newunits_m(r,t) = sum(i, newunitspr(i,r,t) * IX.L(i,r,t)) / (GRIDTWH.L(r,t) / localloss);

* Generation price equals shadow price on electricity market equation in each segment
p_gen_s(s,r,t) = elebal_M(s,r,t);

* Energy consumption (after-loss) segment price
p_con_s(s,r,t) = localloss * elebal_M(s,r,t);

* Segment-level hydrogen/e-fuel price
* Note that marginal on fuelbal_eh could be negative if subsidy ptc_h exceeds costs --> Do not use abs()!
* Also note that fuelbal and fuelbal_eh are both binding for electrolytic hydrogen, so need to add together
pefuel_s(s,f,r,t)$(ef(f) and h2f(f) and sum((himap(f,hi),fivrt(hi,v,r,t)), HX.L(s,hi,v,r,t)) > 1e-3) = (fuelbal_eh.M(s,f,r,t) + fuelbal.M(f,r,t)) / dfact(t);
* Annual average e-hydrogen price
pefuel(f,r,t)$(ef(f) and h2f(f) and QSF.L(f,r,t) > 1e-3) = (sum((s,himap(f,hi),fivrt(hi,v,r,t)), 1e-3 * hours(s,t) * HX.L(s,hi,v,r,t) * fuelbal_eh.M(s,f,r,t)) / QSF.L(f,r,t)  + fuelbal.M(f,r,t)) / dfact(t);

* Non-electric fuel prices
price_rpt(f,r,t)$(not blend(f) and not (ef(f) and h2f(f))) = fuelbal.M(f,r,t) / dfact(t);
price_rpt(f,r,t)$(ef(f) and h2f(f)) = pefuel(f,r,t);
price_rpt(f,"us48",t)$(not blend(f) and sum(r, QSF.L(f,r,t))) = sum(r, price_rpt(f,r,t) * QSF.L(f,r,t)) / sum(r, QSF.L(f,r,t));

price_rpt(blend(f),r,t)$sum(dst, QS_BLEND.L(dst,f,r,t)) = sum(dst, fuelbal_blend.M(dst,f,r,t) * QS_BLEND.L(dst,f,r,t)) / sum(dst, QS_BLEND.L(dst,f,r,t)) / dfact(t);
price_rpt(blend(f),"us48",t)$sum((dst,r), QS_BLEND.L(dst,f,r,t)) = sum((dst,r), fuelbal_blend.M(dst,f,r,t) * QS_BLEND.L(dst,f,r,t)) / sum((dst,r), QS_BLEND.L(dst,f,r,t)) / dfact(t);

* Sector-level blending creates sector-specific wholesale prices
price_blend_rpt(blend(f),dst,r,t) = fuelbal_blend.M(dst,f,r,t) / dfact(t);
price_blend_rpt(blend(f),dst,"us48",t)$sum(r, QS_BLEND.L(dst,f,r,t)) = sum(r, fuelbal_blend.M(dst,f,r,t) * QS_BLEND.L(dst,f,r,t)) / sum(r, QS_BLEND.L(dst,f,r,t)) / dfact(t);

pf_enduse_rpt(kf,df(f),r,t)$(dcost(f,kf,r,t) and qd_enduse_rpt(kf,f,r,t)) = price_rpt(f,r,t)$(not blend(f)) + sum(sameas(kf,dst), price_blend_rpt(f,dst,r,t)) + dcost(f,kf,r,t);
* If no end-use demand, ignore sector-blending wholesale price and use economy-wide average
pf_enduse_rpt(kf,df(f),r,t)$(dcost(f,kf,r,t) and not qd_enduse_rpt(kf,f,r,t)) = price_rpt(f,r,t) + dcost(f,kf,r,t);
* If no regional wholesale price, use national average
pf_enduse_rpt(kf,df(f),r,t)$(dcost(f,kf,r,t) and not price_rpt(f,r,t)) = price_rpt(f,"us48",t) + dcost(f,kf,r,t);

* If still no price, report problem
pf_enduse_problem(kf,df(f),r,t)$(dcost(f,kf,r,t) and not (pf_enduse_rpt(kf,f,r,t) > dcost(f,kf,r,t))) = yes;

* Assign hydrogen price separately as blend price already includes distribution costs
pf_enduse_rpt(kf,"h2",r,t) = sum(sameas(kf,dst), price_blend_rpt("h2",dst,r,t));
pf_enduse_rpt(kf,"h2",r,t)$(not pf_enduse_rpt(kf,"h2",r,t) > eps) = sum(sameas(kf,dst), price_blend_rpt("h2",dst,"us48",t));
pf_enduse_rpt(kf,"h2",r,t)$(not pf_enduse_rpt(kf,"h2",r,t) > eps) = price_rpt("h2","us48",t) + hdcost("cnt",kf);

pf_enduse_problem(kf,"h2",r,t)$(not pf_enduse_rpt(kf,"h2",r,t) > eps) = yes;

* Adjust to 2015 dollars for iteration with end-use model
pf_enduse_rpt_2015(kf,f,r,t) = gdpdef("%curryr%","2015") * pf_enduse_rpt(kf,f,r,t);

pf_elec_rpt(f,r,t) = price_rpt(f,r,t)$(not blend(f)) + price_blend_rpt(f,"ele",r,t)$blend(f);

* Combine segment-level e-hydrogen price with non-electric hydrogen price (constant across segments)
ph2e_s(s,h2f(f),r,t) = pefuel_s(s,f,r,t)$ef(f) + price_rpt(f,r,t)$(not ef(f));

* Realized average price of hydrogen for each generator block (annual average weighted by hourly dispatch)
ph2e_ivf(ivfrt(i,v,h2f(f),r,t))$(XC.L(i,v,r,t) > 1e-3 and XTWH.L(i,v,f,r,t) > 1e-3) = 1e-3 * sum(s, ph2e_s(s,f,r,t) * X.L(s,i,v,f,r,t) * hours(s,t)) / XTWH.L(i,v,f,r,t);
ph2e_ivvf(civfrt(i,vv,v,h2f(f),r,t))$(XC_C.L(i,vv,v,r,t) > 1e-3 and XTWH_C.L(i,vv,v,f,r,t) > 1e-3) = 1e-3 * sum(s, ph2e_s(s,f,r,t) * X_C.L(s,i,vv,v,f,r,t) * hours(s,t)) / XTWH_C.L(i,vv,v,f,r,t);

* Annual average price for electric generation
ph2e_ele(f,r,t)$(QD_ELEC.L(f,r,t) > 1e-3) = 1e-3 * sum(s, fuel_s(s,f,r,t) * hours(s,t) * ph2e_s(s,f,r,t)) / QD_ELEC.L(f,r,t);
ph2e_ele(f,"us48",t)$(sum(r, QD_ELEC.L(f,r,t)) > 1e-3) = 1e-3 * sum((s,r), fuel_s(s,f,r,t) * hours(s,t) * ph2e_s(s,f,r,t)) / sum(r, QD_ELEC.L(f,r,t));

h2elys("rlz_CF",elys(hi),r,t)$(sum(v, FX.L(hi,v,r,t)) > 1e-3) = h2cap("rlz_CF",hi,r,t);
h2elys("rlz_PELE",elys(hi),r,t)$(sum(v, FX.L(hi,v,r,t)) > 1e-3) = 1e-3 * sum((s,v), hours(s,t) * elebal_M(s,r,t) * HX.L(s,hi,v,r,t)) / sum(v, FX.L(hi,v,r,t));

* Price and Load Duration curves
plcurve("hours",s,r,t) = hours(s,t);
plcurve("price",s,r,t) = p_gen_s(s,r,t);
plcurve("load",s,r,t) = (load(s,r,t) + QD_EEU_S.L(s,r,t) + sum(flx, QD_FLX_S.L(s,flx,r,t))) * localloss;

* Calculate histograms for price and load (energy for load)
prcurve_hist(phist,r,t) = 0;
ldcurve_hist(lhist,r,t) = 0;

loop(s,
prcurve_hist(phist,r,t) = prcurve_hist(phist,r,t) + plcurve("hours",s,r,t)$(
                            plcurve("price",s,r,t) ge minphist(phist) and (plcurve("price",s,r,t) < minphist(phist+1))$(not ord(phist) eq card(phist)));
ldcurve_hist(lhist,r,t) = ldcurve_hist(lhist,r,t) + plcurve("hours",s,r,t)$(
                            plcurve("load",s,r,t) ge minlhist(lhist) and (plcurve("load",s,r,t) < minlhist(lhist+1))$(not ord(lhist) eq card(lhist)));
);

* * * Annual average prices of consumption, generation, and trade-flows
* Note that these are energy-only prices
p_con(r,t) = 1e-3 * sum(s, con_s(s,r,t) * p_con_s(s,r,t)) / contot(r,t);
p_con_ldv(r,t)$contot_ldv(r,t) = 1e-3 * sum(s, con_ldv_s(s,r,t) * p_con_s(s,r,t)) / contot_ldv(r,t);
p_con_mdhd(r,t)$contot_mdhd(r,t) = 1e-3 * sum(s, con_mdhd_s(s,r,t) * p_con_s(s,r,t)) / contot_mdhd(r,t);
p_con_nnrd(r,t)$contot_nnrd(r,t) = 1e-3 * sum(s, con_nnrd_s(s,r,t) * p_con_s(s,r,t)) / contot_nnrd(r,t);
p_con_dc(r,t)$contot_dc(r,t) = 1e-3 * sum(s, con_dc_s(s,r,t) * p_con_s(s,r,t)) / contot_dc(r,t);
p_gen(r,t) = 1e-3 * sum(s, gen_s(s,r,t) * p_gen_s(s,r,t)) / gentot(r,t);
p_domexp(r,rr,t)$domexp(r,rr,t) = 1e-3 * sum(s, domexp_s(s,r,rr,t) * p_gen_s(s,rr,t)) / domexp(r,rr,t);
p_intexp(r,t)$intexp(r,t) = 1e-3 * sum(s, intexp_s(s,r,t) * p_gen_s(s,r,t)) / intexp(r,t);
p_domimp(r,rr,t)$domimp(r,rr,t) = 1e-3 * sum(s, domimp_s(s,r,rr,t) * p_gen_s(s,r,t)) / domimp(r,rr,t);
p_intimp(r,t)$intimp(r,t) = 1e-3 * sum(s, intimp_s(s,r,t) * p_gen_s(s,r,t)) / intimp(r,t);

* Wholesale electricity prices: Full delivered price of generation adding up all marginals
* Note that p_lse applies to contot, other terms should be scaled accordingly
p_lse(r,t) = p_con(r,t) + rsv_m(r,t) +
              srps_m(r,t) + rps_m(t) + ces_m(r,t) + sb100_m(t)$cal_r(r) +
              ssol_m(r,t) + nuczec_m(r,t) + newunits_m(r,t)
;
p_lse_ldv(r,t) = p_con_ldv(r,t) + rsv_m_ldv(r,t) +
              srps_m(r,t) + rps_m(t) + ces_m(r,t) + sb100_m(t)$cal_r(r) +
              ssol_m(r,t) + nuczec_m(r,t) + newunits_m(r,t)
;
p_lse_mdhd(r,t) = p_con_mdhd(r,t) + rsv_m_mdhd(r,t) +
              srps_m(r,t) + rps_m(t) + ces_m(r,t) + sb100_m(t)$cal_r(r) +
              ssol_m(r,t) + nuczec_m(r,t) + newunits_m(r,t)
;
p_lse_nnrd(r,t) = p_con_nnrd(r,t) + rsv_m_nnrd(r,t) +
              srps_m(r,t) + rps_m(t) + ces_m(r,t) + sb100_m(t)$cal_r(r) +
              ssol_m(r,t) + nuczec_m(r,t) + newunits_m(r,t)
;
p_lse_dc(r,t) = p_con_dc(r,t) + rsv_m_dc(r,t) +
              srps_m(r,t) + rps_m(t) + ces_m(r,t) + sb100_m(t)$cal_r(r) +
              ssol_m(r,t) + nuczec_m(r,t) + newunits_m(r,t)
;
p_lse_dc_avg(t)$sum(r, contot_dc(r,t)) = sum(r, contot_dc(r,t) * p_lse_dc(r,t)) / sum(r, contot_dc(r,t));

* Price comparison report
prreport(r,t,"gen",r) = p_gen(r,t);
prreport(r,t,"imp",rr)= p_domimp(r,rr,t);
prreport(r,t,"imp","int") = p_intimp(r,t);
prreport(r,t,"exp",rr) = p_domexp(r,rr,t);
prreport(r,t,"exp","int") = p_intexp(r,t);
prreport(r,t,"con",r) = p_con(r,t);
prreport(r,t,"lse",r) = p_lse(r,t);

* Maximum dispatch cost by segment (not identical to price)
maxcost(s,r,t) = max(smax(ivfrt(i,v,f,r,t)$(X.L(s,i,v,f,r,t) ge 1.0e-6), icost(i,v,f,r,t)), smax(civfrt(i,vv,v,f,r,t)$(X_C.L(s,i,vv,v,f,r,t) ge 1.0e-6), icost_c(i,vv,v,f,r,t)));

* Average prices for aggregate reporting regions and national values
final4pr(rpt,"gen",t)$sum(xrpt(rpt,r), gentot(r,t)) = sum(xrpt(rpt,r), p_gen(r,t) * gentot(r,t)) / sum(xrpt(rpt,r), gentot(r,t));
final4pr(rpt,"con",t)$sum(xrpt(rpt,r), contot(r,t)) = sum(xrpt(rpt,r), p_con(r,t) * contot(r,t)) / sum(xrpt(rpt,r), contot(r,t));
final4pr(rpt,"lse",t)$sum(xrpt(rpt,r), contot(r,t)) = sum(xrpt(rpt,r), p_lse(r,t) * contot(r,t)) / sum(xrpt(rpt,r), contot(r,t));
usavepr("gen",t) = sum(r, p_gen(r,t) * gentot(r,t)) / sum(r, gentot(r,t));
usavepr("con",t) = sum(r, p_con(r,t) * contot(r,t)) / sum(r, contot(r,t));
usavepr("lse",t) = sum(r, p_lse(r,t) * contot(r,t)) / sum(r, contot(r,t));

* CO2 transport and storage price
cstor_pr(cstorclass,r,t)$INJC.L(cstorclass,r,t) = abs(co2injcapacity.M(cstorclass,r,t)) / dfact(t);

* * * Hydrogen prices

* Total annualized expenditure on hydrogen production ($M)
h2cost_tot("elec",hki(hk,hi),r,t)$sum(v, FX.L(hi,v,r,t)) = 1e-3 * sum(s, hours(s,t) * elebal_M(s,r,t) * (1/3.412) * sum(v, eptrf("ele",hi,v) * HX.L(s,hi,v,r,t)));
h2cost_tot("nele",hki(hk,hi),r,t)$sum(v, FX.L(hi,v,r,t)) = 1e-3 * sum(s, hours(s,t) * sum(v, sum(f, eptrf(f,hi,v) * (pf_elec_rpt(f,r,t) + pfadd_r(f,r,t))) * HX.L(s,hi,v,r,t)));
h2cost_tot("vcost",hki(hk,hi),r,t)$sum(v, FX.L(hi,v,r,t)) = sum(v, vcost_trf(hi,v) * FX.L(hi,v,r,t)) / sum(v, FX.L(hi,v,r,t));

* Levelized hydrogen production cost by component ($ per MMBtu)
h2cost("elec",hk,r,t)$sum((hki(hk,hi),v), FX.L(hi,v,r,t)) = 1e-3 * sum(s, hours(s,t) * elebal_M(s,r,t) * (1/3.412) * sum((hki(hk,hi),v), eptrf("ele",hi,v) * HX.L(s,hi,v,r,t))) / sum((hki(hk,hi),v), FX.L(hi,v,r,t));
h2cost("nele",hk,r,t)$sum((hki(hk,hi),v), FX.L(hi,v,r,t)) = sum((hki(hk,hi),v), sum(f, eptrf(f,hi,v) * (pf_elec_rpt(f,r,t) + pfadd_r(f,r,t))) * FX.L(hi,v,r,t)) / sum((hki(hk,hi),v), FX.L(hi,v,r,t));
h2cost("vcost",hk,r,t)$sum((hki(hk,hi),v), FX.L(hi,v,r,t)) = sum((hki(hk,hi),v), vcost_trf(hi,v) * FX.L(hi,v,r,t)) / sum((hki(hk,hi),v), FX.L(hi,v,r,t));
h2cost("lcoh",hk,r,t)$sum(hkf(hk,f), QSF.L(f,r,t)) = sum(hkf(hk,f), price_rpt(f,r,t) * QSF.L(f,r,t)) / sum(hkf(hk,f), QSF.L(f,r,t));

* * * Permit prices and allowances

* Explicit taxes/prices are captured by pp(pol,t)
* Implicit prices based on quantity constraints are captured by co2pr_*() and nonpr()
* The total realized marginal cost is the sum of the explicit and implicit components
* Note that any new quantity constraint must have a corresponding implicit price report

* Initialize to zero in case constraint switches are inactive
co2pr(t) = 0;
co2pr_rg(r,t) = 0;
co2pr_sec("bld",r,t) = eps;
co2pr_sec("ind",r,t) = eps;
co2pr_sec("trn",r,t) = eps;
co2pr_sec("ele",r,t) = eps;
co2pr_ele(t) = 0;
co2pr_ny(t) = 0;
co2pr_ny_ele(t) = 0;
co2pr_ca(t) = 0;
co2pr_rggi(t) = 0;
co2allow(t) = 0;
co2allow_rg(r,t) = 0;
* Activate %cap% switch in cases where manualcal option has been used
$if set manualcap $set cap %manualcap%
$iftheni NOT %cap%==none
co2pr(t)$(co2cap(t,"%cap%") and (co2cap(t,"%cap%") < inf) or zerocap(t,"%cap%")) = abs(carbonmarket.M(t)) / (dfact(t));
co2allow(t) = co2cap(t,"%cap%");
$endif
$ifthen set rgnz50
co2pr_rg(r,"2050") = abs(CO2_EMIT.M(r,"2050")) / dfact("2050");
$endif

$ifthen set sectorcap
co2pr_sec("bld",r,t) = abs(CO2_BLD.M(r,t)) / dfact(t);
co2pr_sec("ind",r,t) = abs(CO2_BLD.M(r,t)) / dfact(t);
co2pr_sec("trn",r,t) = abs(CO2_BLD.M(r,t)) / dfact(t);
$endif

$ifthen set elergnz50
co2pr_sec("ele",r,"2050") = abs(CO2_ELE.M(r,"2050")) / dfact("2050");
$endif

$iftheni NOT %cap_ele%==none
co2pr_ele(t)$(co2cap_ele(t,"%cap_ele%") and (co2cap_ele(t,"%cap_ele%") < inf)) = abs(carbonmarket_ele.M(t)) / (dfact(t));
$endif

$iftheni NOT %cap_rg%==none
co2pr_rg(r,t)$(co2cap_rg(r,t,"%cap_rg%") and (co2cap_rg(r,t,"%cap_rg%") < inf)) = abs(carbonmarket_rg.M(r,t)) / (dfact(t));
co2allow_rg(r,t) = co2cap_rg(r,t,"%cap_rg%");
$endif

$iftheni.nyco2 NOT %NY_SB6599%==no
co2pr_ny(t) = abs(carbonmarket_ny.M(t)) / (dfact(t));
co2pr_ny_ele(t) = abs(carbonmarket_ny_ele.M(t)) / (dfact(t));
$endif.nyco2

$iftheni.caco2 NOT %CA_AB32%==no
co2pr_ca(t) = abs(carbonmarket_ca.M(t)) / (dfact(t));
$endif.caco2

$iftheni.rggi NOT %RGGI%==off
 co2pr_rggi(t) = abs(rggimarket.M(t)) / (dfact(t));
$endif.rggi

* Combine marginals on all CO2 constraints affecting the electric sector (excludes carbon tax)
co2pr_tot(r,t) = co2pr(t) + co2pr_rg(r,t) + co2pr_ele(t) + co2pr_sec("ele",r,t) + co2pr_rggi(t)$rggi_r(r) + co2pr_ny(t)$nys_r(r) + co2pr_ny_ele(t)$nys_r(r) + co2pr_ca(t)$cal_r(r);

nonpr(pol,r,t)$(not sameas(pol,"co2")) = 0;

* There is a price on annual non-co2 emissions in each trading program
* The price on regional emissions should equal the sum of the market clearing prices in the trading programs
* in which the region participates, except when the assurance level bound is binding
$iftheni not %noncap%==none
nonpr(pol,r,t) = abs(sum(trdprg, csapr_r.M(trdprg,pol,r,t))) / dfact(t);
nonpr(pol,trdprg,t)$sum(r, csaprbudget(trdprg,pol,r,t,"%noncap%")) = abs(csapr_trdprg.M(trdprg,t)) / dfact(t);
$endif

* PConstraint over multiple GHGs expressed in CO2-e terms
co2epr(t) = 0;
* $ifi %nco2%==yes co2epr(t) = abs(co2emkt.M(t)) / (1e3 * dfact(t));

* * * Expenditures

* Total discounted expenditure on fixed O&M for electric generation ($B)
fom_gen(r,t) = 1e-3 * dfact(t) * sum(ivrt(i,v,r,t), XC.L(i,v,r,t) * fomcost(i,r));
fom_gen_i(i,r,t) = 1e-3 * dfact(t) * sum(ivrt(i,v,r,t), XC.L(i,v,r,t) * fomcost(i,r));

* Overnight annual capital expenditures on electric generation by region ($B)
capex_gen(r,t) = 1e-3 * (1/nyrs(t)) * (sum(new(i), IX.L(i,r,t) * sum(tv(t,v), (capcost(i,v,r) + co2pcap("%co2trscn%",i,v,r) + tcostadder("%tdc%",i) - itcval(i,v,r)))) +
                                   sum((conv(i),vv), IX_C.L(i,vv,r,t) * cappr_c(i,vv,r,t) * sum(tv(t,v)$civrt(i,vv,v,r,t), (capcost(i,v,r) + co2pcap("%co2trscn%",i,v,r) + tcostadder("%tdc%",i) - itcval(i,v,r))))); 
uscapex_gen(t) = sum(r, capex_gen(r,t));

* New vintage investment cost and conversion costs ($ per kW)
invcost_perkw(new(i),r,t) = nyrs(t) * cappr_i(i,r,t) * sum(tv(t,v), capcost(i,v,r) + co2pcap("%co2trscn%",i,v,r) + tcostadder("%tdc%",i) - itcval(i,v,r));
convcost_perkw(conv(i),vv,r,t) = nyrs(t) * cappr_c(i,vv,r,t) * sum(tv(t,v), capcost(i,v,r) + co2pcap("%co2trscn%",i,v,r) + tcostadder("%tdc%",i) - itcval(i,v,r));
* In static model nyrs term should be omitted to match objdef, but it is equal to 1, so this is equivalent
invcost(new(i),r,t) =  invcost_perkw(i,r,t) * (1/nyrs(t)) * IX.L(i,r,t);
convcost(conv(i),vv,r,t) =  convcost_perkw(i,vv,r,t) * (1/nyrs(t)) * IX_C.L(i,vv,r,t);

* Total system costs, gross of investment tax, net of tax credits, excluding modlife adjustment for end-effects

* Per period total investment ($B)
invest_perperiod("newgen",r,t) = eps + 1e-3 * (1 + tk) * sum(new(i), IX.L(i,r,t) * sum(tv(t,v), capcost(i,v,r)));
invest_perperiod("retro",r,t) = eps + 1e-3 * (1 + tk) * sum((conv(i),vv), IX_C.L(i,vv,r,t) * sum(tv(t,v), capcost(i,v,r)));
invest_perperiod("irtrans",r,t) = eps + 1e-3 * (1 + tk) * (sum(new(i), IX.L(i,r,t) * tcostadder("%tdc%",i)) + sum(rr, IT.L(r,rr,t) * tcapcost(r,rr)));
invest_perperiod("storage",r,t) = eps + 1e-3 * (1 + tk) * sum(j, IGC.L(j,r,t) * capcost_gc("%stortlc%",j,t) + IGR.L(j,r,t) * capcost_gr("%stortlc%",j,t));
invest_perperiod("co2pipe_ele",r,t) = eps + 1e-3 * (1 + tk) * (sum(new(i), IX.L(i,r,t) * sum(tv(t,v), co2pcap("%co2trscn%",i,v,r))) +
                                                               sum((conv(i),vv), IX_C.L(i,vv,r,t) * sum(tv(t,v), co2pcap("%co2trscn%",i,v,r))));
invest_perperiod("dac",r,t) = eps + 1e-3 * (1 + tk) * sum(dac, IDAC.L(dac,r,t) * sum(tv(t,v), capcost_dac("%dacscn%",dac,v)));
invest_perperiod("co2pipe_dac",r,t) = eps + 1e-3 * (1 + tk) * sum(dac, IDAC.L(dac,r,t) * sum(tv(t,v), co2pcap_dac("%co2trscn%",dac,v)));
invest_perperiod("co2stor_tot",r,t) = eps + 1e-3 * (1 + tk) * sum(cstorclass, IINJ.L(cstorclass,r,t) * capcost_inj("%cstorscen%",cstorclass,r));
invest_perperiod("itc",r,t) = eps - 1e-3 * (1 + tk) * (sum(new(i), IX.L(i,r,t) * sum(tv(t,v), itcval(i,v,r))) +
                                                       sum((conv(i),vv), IX_C.L(i,vv,r,t) * sum(tv(t,v), itcval(i,v,r))) +
                                                       sum(j, (IGC.L(j,r,t) * capcost_gc("%stortlc%",j,t) + IGR.L(j,r,t) * capcost_gr("%stortlc%",j,t)) * sum(tv(t,v), itc_j(j,v))));
invest_perperiod(investcat,"us48",t) = sum(r, invest_perperiod(investcat,r,t));

* Per period total operating cost ($B)
opcost_perperiod("fuelcost",r,t) = eps + 1e-3 * nyrs(t) * sum(f$(not ef(f)),
*                                                    Fuel purchases by electric sector at market prices (excluding e-fuels which are endogenous)
                                                     QD_ELEC.L(f,r,t) * pf_elec_rpt(f,r,t) +
*                                                    Fuel price adders (unit level)
                                                     sum(ivfrt(strd(i),v,f,r,t), htrate(i,v,f,r,t) * XTWH.L(i,v,f,r,t) * pfadd(i,f,r,t)) +
                                                     sum(civfrt(conv(i),vv,v,f,r,t), htrate_c(i,vv,v,f,r,t) * XTWH_C.L(i,vv,v,f,r,t) * pfadd(i,f,r,t)) -
*                                                    Adjustment for CO2 capture (market price has carbon price embedded)
                                                     sum(ivfrt(strd(i),v,f,r,t)$ccs(i), XTWH.L(i,v,f,r,t) * capture(i,v,f,r) * co2pr_tot(r,t)) -
                                                     sum(civfrt(conv(i),vv,v,f,r,t)$ccs(i), XTWH_C.L(i,vv,v,f,r,t) * capture_c(i,vv,v,f,r) * co2pr_tot(r,t)));
opcost_perperiod("vom",r,t) = eps + 1e-3 * nyrs(t) * (sum(ivfrt(strd(i),v,f,r,t), XTWH.L(i,v,f,r,t) * vcost(i,v,r)) +
                                            sum(civfrt(conv(i),vv,v,f,r,t), XTWH_C.L(i,vv,v,f,r,t) * vcost_c(i,vv,v,r)));
opcost_perperiod("fom",r,t) = eps + 1e-3 * nyrs(t) * (sum(ivrt(strd(i),v,r,t), XC.L(i,v,r,t) * fomcost(i,r)) +
                                            sum(civrt(conv(i),vv,v,r,t), XC_C.L(i,vv,v,r,t) * fomcost(i,r)));
opcost_perperiod("storage_fom",r,t) = eps + 1e-3 * nyrs(t) * sum(j, fomcost_g(j,t) * GC.L(j,r,t));
opcost_perperiod("co2pipe_fom",r,t) = eps + 1e-3 * nyrs(t) * (sum(ivrt(strd(i),v,r,t), XC.L(i,v,r,t) * co2pfom("%co2trscn%",i,r)) +
                                                    sum(civrt(conv(i),vv,v,r,t), XC_C.L(i,vv,v,r,t) * co2pfom("%co2trscn%",i,r)));
opcost_perperiod("emit_pp",r,t) = eps + 1e-3 * nyrs(t) * sum(pol, (pp(pol,t) + pp_rg(pol,r,t)) *
                                                   (sum(ivfrt(strd(i),v,f,r,t), emit(i,v,f,pol,r,t) * XTWH.L(i,v,f,r,t)) +
                                                    sum(civfrt(conv(i),vv,v,f,r,t), emit_c(i,vv,v,f,pol,r,t) * XTWH_C.L(i,vv,v,f,r,t))));
opcost_perperiod("ptc",r,t) = eps - 1e-3 * nyrs(t) * (sum(ivfrt(i,v,f,r,t)$ptctv(t,v), XTWH.L(i,v,f,r,t) * ptc(i,f,v)) + sum(civfrt(i,vv,v,f,r,t)$ptctv(t,v), XTWH_C.L(i,vv,v,f,r,t) * ptc(i,f,v)));
opcost_perperiod("45q",r,t) = eps - 1e-3 * nyrs(t) * (sum(ivfrt(i,v,f,r,t), XTWH.L(i,v,f,r,t) * ccs45Q(i,v,f,r,t)) + sum(civfrt(i,vv,v,f,r,t), XTWH_C.L(i,vv,v,f,r,t) * ccs45Q_c(i,vv,v,f,r,t)));
opcost_perperiod(opcostcat,"us48",t) = sum(r, opcost_perperiod(opcostcat,r,t));

* US total net present value of system costs from 2025 time step forward, discounted back to 2020
usnpvcost(investcat,t) = sum(tt$(tt.val ge 2025 and tt.val le t.val), (dfact(tt-1) / nyrs(tt)) * invest_perperiod(investcat,"us48",tt));
usnpvcost(opcostcat,t) = sum(tt$(tt.val ge 2025 and tt.val le t.val), (dfact(tt-1) / nyrs(tt)) * opcost_perperiod(opcostcat,"us48",tt));


* Variable operating cost (realized) ($ per MWh)
opcost_permwh(i,v,f,r,t)$ivfrt(i,v,f,r,t) =
* Fuel costs
        htrate(i,v,f,r,t) * (pf_elec_rpt(f,r,t)$(not h2f(f)) + ph2e_ivf(i,v,f,r,t)$h2f(f) + pfadd(i,f,r,t))
* Variable O&M costs
        + vcost(i,v,r)
* CO2 transport and storage costs (reflects in-region capture)
        + smax(cstorclass, cstor_pr(cstorclass,r,t)) * capture(i,v,f,r)
* Explicit pollutant prices (e.g. carbon tax)
        + sum(pol, (pp(pol,t) + pp_rg(pol,r,t)) * emit(i,v,f,pol,r,t))
* Implicit carbon prices
        + co2pr_tot(r,t) * emit(i,v,f,"co2",r,t)
* Implicit generation-based RPS credit price
        + fullrecpr(t) * max(0, rpstgt(t,"%rps_full%") - rps(i,f,r,"full"))
* Implicit generation-based CES credit price
$ifi %cestot_option%==totalload + cespr(r,t) * max(0, cestgt_r(r,t,"%ces%") - ces(i,v,f,r,"%ces%"))
* Implicit non-GHG prices
        + sum(pol$(not sameas(pol,"co2")), nonpr(pol,r,t) * emit(i,v,f,pol,r,t))
* Implicit CES tax or subsidy (if specified in scenario)
$ifi not %cestax%==no        + cestax(i,v,f,r,t)
* Production Tax Credit (if applicable)
        - ptc(i,f,v)$ptctv(t,v)
* CO2 Storage 45Q Credit (will be 0 if not activated)
        - ccs45Q(i,v,f,r,t)
;

* Variable operating cost for conversions (realized) ($ per MWh)
opcost_permwh_c(i,vv,v,f,r,t)$civfrt(i,vv,v,f,r,t) =
* Fuel costs
        htrate_c(i,vv,v,f,r,t) * (pf_elec_rpt(f,r,t)$(not h2f(f)) + ph2e_ivvf(i,vv,v,f,r,t)$h2f(f) + pfadd(i,f,r,t))
* Variable O&M costs
        + vcost_c(i,vv,v,r)
* CO2 transport and storage costs
        + smax(cstorclass, cstor_pr(cstorclass,r,t)) * capture_c(i,vv,v,f,r)
* Explicit pollutant prices (e.g. carbon tax)
        + sum(pol, (pp(pol,t) + pp_rg(pol,r,t)) * emit_c(i,vv,v,f,pol,r,t))
* Implicit carbon prices
        + co2pr_tot(r,t) * emit_c(i,vv,v,f,"co2",r,t)
* Implicit generation-based RPS credit price
        + fullrecpr(t) * max(0, rpstgt(t,"%rps_full%") - rps(i,f,r,"full"))
* Implicit generation-based CES credit price
$ifi %cestot_option%==totalload + cespr(r,t) * max(0, cestgt_r(r,t,"%ces%") - ces_c(i,vv,v,f,r,"%ces%"))
* Implicit non-GHG prices
        + sum(pol$(not sameas(pol,"co2")), nonpr(pol,r,t) * emit_c(i,vv,v,f,pol,r,t))
* Implicit CES tax or subsidy (if specified in scenario)
$ifi not %cestax%==no        + cestax(i,v,f,r,t)
* Production Tax Credit (if applicable)
        - ptc(i,f,v)$ptctv(t,v)
* CO2 Storage 45Q Credit (will be 0 if not activated)
        - ccs45Q_c(i,vv,v,f,r,t)
;


* Total operating cost ($M per year)
opcost(i,v,r,t)$ivrt(i,v,r,t) =
* Variable cost times dispatch
        sum(ifl(i,f), opcost_permwh(i,v,f,r,t) * XTWH.L(i,v,f,r,t)) +
* Plus fixed O&M costs times installed capacity
        fomcost(i,r) * XC.L(i,v,r,t)
;

* Total operating cost ($M per year)
opcost_c(i,vv,v,r,t)$civrt(i,vv,v,r,t) =
* Variable cost times dispatch
        sum(ifl(i,f), opcost_permwh_c(i,vv,v,f,r,t) * XTWH_C.L(i,vv,v,f,r,t)) +
* Plus fixed O&M costs times installed capacity
        fomcost(i,r) * XC_C.L(i,vv,v,r,t)
;

* Net operating revenues
* Note: It is challenging to include state RPS/CES revenues here, because it is ambiguous which state's price the qualified generation receives
* This (local gen * local price) is only an approximation. To calculate more precisely, the actual revenue
* must be backed out in the state RPS accounting below, and can only be calculated in total, not for each i
* Federal RPS and CES certificates do not have this problem

* Reporting of unit-level revenue sources

* First calculate full-load hours, compare realized versus "shadow" or hypothetical dispatch based on marginal cost vs. price
* Note that ndsp technologies are assumed to dispatch in all segments
flh("rlz",i,v,r,t)$(ivrt(i,v,r,t) and XC.L(i,v,r,t) > 1e-3) = 1e3 * sum(f, XTWH.L(i,v,f,r,t)) / XC.L(i,v,r,t);
flh("shdw",i,v,r,t)$ivrt(i,v,r,t) = sum(s$(elebal_M(s,r,t) > smin(ifl(i,f), opcost_permwh(i,v,f,r,t)) or ndsp(i)), af(s,i,v,r,t) * hours(s,t));
flh_c("rlz",i,vv,v,r,t)$(civrt(i,vv,v,r,t) and XC_C.L(i,vv,v,r,t) > 1e-3) = 1e3 * sum(f, XTWH_C.L(i,vv,v,f,r,t)) / XC_C.L(i,vv,v,r,t);
flh_c("shdw",i,vv,v,r,t)$civrt(i,vv,v,r,t) = sum(s$(elebal_M(s,r,t) > smin(ifl(i,f), opcost_permwh_c(i,vv,v,f,r,t)) or ndsp(i)), af(s,i,v,r,t) * hours(s,t));

* Normalized revenue (energy related) by capacity block (approximates state RPS revenue) ($ per MWh)
revenue_permwh(i,v,r,t)$ivrt(i,v,r,t) =
* Realized revenue from electricity sale (demand equation in each s)
            (1e-3 * sum(s, elebal_M(s,r,t) * sum(f, X.L(s,i,v,f,r,t)) * hours(s,t)) / sum(f, XTWH.L(i,v,f,r,t)))$(sum(f, XTWH.L(i,v,f,r,t)) > 1e-6)
* Hypothetical revenue based on realized price vs. variable operating cost for technologies not in the solution
* Note that ndsp technologies are assumed to dispatch in all segments
            + (sum(s$(elebal_M(s,r,t) > smin(ifl(i,f), opcost_permwh(i,v,f,r,t)) or ndsp(i)), elebal_M(s,r,t) * af(s,i,v,r,t) * hours(s,t)) / flh("shdw",i,v,r,t))$(flh("shdw",i,v,r,t) and sum(f, XTWH.L(i,v,f,r,t)) le 1e-6)
* Plus revenue from REC certificates (load-based)
            + strecpr(r,t) * (sum(f, rps(i,f,r,"state") * XTWH.L(i,v,f,r,t)) / sum(f, XTWH.L(i,v,f,r,t)))$(sum(f, XTWH.L(i,v,f,r,t)) > 1e-6)
            + recpr(t)  * (sum(f, rps(i,f,r,"fed") * XTWH.L(i,v,f,r,t)) / sum(f, XTWH.L(i,v,f,r,t)))$(sum(f, XTWH.L(i,v,f,r,t)) > 1e-6)
* Full RPS (generation-based) certificates are valued relative to the target
            + fullrecpr(t) * (sum(f, max(0, rps(i,f,r,"full") - rpstgt(t,"%rps_full%")) * XTWH.L(i,v,f,r,t)) / sum(f, XTWH.L(i,v,f,r,t)))$(sum(f, XTWH.L(i,v,f,r,t)) > 1e-6)
* Generation-based CES certificates are valued relative to the target
$ifi %cestot_option%==totalload + cespr(r,t) * (sum(f, max(0, ces(i,v,f,r,"%ces%") - cestgt_r(r,t,"%ces%")) * XTWH.L(i,v,f,r,t)) / sum(f, XTWH.L(i,v,f,r,t)))$(sum(f, XTWH.L(i,v,f,r,t)) > 1e-6)
* Load-based CES certificates are valued in absolute terms
$ifi not %cestot_option%==totalload + cespr(r,t) * (sum(f, ces(i,v,f,r,"%ces%") * XTWH.L(i,v,f,r,t)) / sum(f, XTWH.L(i,v,f,r,t)))$(sum(f, XTWH.L(i,v,f,r,t)) > 1e-6)
* California SB-100 is a load-based CES
            + sb100pr(t) * (sum(f, sb100i(i,f,r) * XTWH.L(i,v,f,r,t)) / sum(f, XTWH.L(i,v,f,r,t)))$(sum(f, XTWH.L(i,v,f,r,t)) > 1e-6 and cal_r(r))
* Plus implicit subsidies
            + ssolpr(r,t)$sol(i)
;

* Conversions revenue (energy related) by capacity block (approximates state RPS revenue) ($ per MWh)
revenue_permwh_c(i,vv,v,r,t)$civrt(i,vv,v,r,t) =
* Realized revenue from electricity sale (demand equation in each s)
            (1e-3 * sum(s, elebal_M(s,r,t) * sum(f, X_C.L(s,i,vv,v,f,r,t)) * hours(s,t)) / sum(f, XTWH_C.L(i,vv,v,f,r,t)))$(sum(f, XTWH_C.L(i,vv,v,f,r,t)) > 1e-6)
* Hypothetical revenue based on realized price vs variable operating cost for technologies not in the solution
* Note that ndsp technologies are assumed to dispatch in all segments
            + (sum(s$(elebal_M(s,r,t) > smin(ifl(i,f), opcost_permwh_c(i,vv,v,f,r,t)) or ndsp(i)), elebal_M(s,r,t) * af(s,i,v,r,t) * hours(s,t)) / flh_c("shdw",i,vv,v,r,t))$(flh_c("shdw",i,vv,v,r,t) and sum(f, XTWH_C.L(i,vv,v,f,r,t)) le 1e-6)
* Plus revenue from REC certificates
            + strecpr(r,t) * (sum(f, rps(i,f,r,"state") * XTWH_C.L(i,vv,v,f,r,t)) / sum(f, XTWH_C.L(i,vv,v,f,r,t)))$(sum(f, XTWH_C.L(i,vv,v,f,r,t)) > 1e-6)
            + recpr(t) * (sum(f, rps(i,f,r,"fed") * XTWH_C.L(i,vv,v,f,r,t)) / sum(f, XTWH_C.L(i,vv,v,f,r,t)))$(sum(f, XTWH_C.L(i,vv,v,f,r,t)) > 1e-6)
* Full RPS (generation based) certificates are valued relative to the target
            + fullrecpr(t) * (sum(f, max(0, rps(i,f,r,"full") - rpstgt(t,"%rps_full%")) * XTWH_C.L(i,vv,v,f,r,t)) / sum(f, XTWH_C.L(i,vv,v,f,r,t)))$(sum(f, XTWH_C.L(i,vv,v,f,r,t)) > 1e-6)
* Generation-based CES certificates are valued relative to the target
$ifi %cestot_option%==totalload + cespr(r,t) * (sum(f, max(0, ces_c(i,vv,v,f,r,"%ces%") - cestgt_r(r,t,"%ces%")) * XTWH_C.L(i,vv,v,f,r,t)) / sum(f, XTWH_C.L(i,vv,v,f,r,t)))$(sum(f, XTWH_C.L(i,vv,v,f,r,t)) > 1e-6)
* Load-based CES certificates are valued in absolute terms
$ifi not %cestot_option%==totalload + cespr(r,t) * (sum(f, ces_c(i,vv,v,f,r,"%ces%") * XTWH_C.L(i,vv,v,f,r,t)) / sum(f, XTWH_C.L(i,vv,v,f,r,t)))$(sum(f, XTWH_C.L(i,vv,v,f,r,t)) > 1e-6)
* California SB-100 is a load-based CES
            + sb100pr(t) * (sum(f, sb100i(i,f,r) * XTWH_C.L(i,vv,v,f,r,t)) / sum(f, XTWH_C.L(i,vv,v,f,r,t)))$(sum(f, XTWH_C.L(i,vv,v,f,r,t)) > 1e-6 and cal_r(r))
* Plus implicit subsidies
            + ssolpr(r,t)$sol(i)
;

* Revenue (capacity related) by capacity block ($ per kW)
revenue_perkw(i,v,r,t)$ivrt(i,v,r,t) =
* Revenue from reserve margin
            + rsvpr_i(i,v,r,t)
* Plus implicit subsidies
            + wnospr(r,t)$idef(i,"wnos")
            + nuczecpr(r,t)$sameas(i,"nucl-x")
            + newunitspr(i,r,t)$tv(t,v)
* Less scarcity rent on capacity limits
$if not %statfx%==yes     - abs(capacitylim.M(i,r,t)) / dfact(t)
;

* Conversions revenue (capacity related) by capacity block ($ per kW)
revenue_perkw_c(i,vv,v,r,t)$civrt(i,vv,v,r,t) =
* Revenue from reserve margin
            + rsvpr_ic(i,vv,v,r,t)
* Plus implicit subsidies
            + wnospr(r,t)$idef(i,"wnos")
            + nuczecpr(r,t)$sameas(i,"nucl-x")
            + newunitspr(i,r,t)$tv(t,v)
* Less scarcity rent on capacity limits for conversion of existing technologies
$if not %statfx%==yes     - (abs(capacitylim_c.M(i,r,t)) / dfact(t))$vbase(vv)
;

* Total revenue equals energy revenue plus capacity revenue
revenue(i,v,r,t)$ivrt(i,v,r,t) = revenue_permwh(i,v,r,t) * sum(f, XTWH.L(i,v,f,r,t)) + revenue_perkw(i,v,r,t) * XC.L(i,v,r,t);
revenue_c(i,vv,v,r,t)$civrt(i,vv,v,r,t) = revenue_permwh_c(i,vv,v,r,t) * sum(f, XTWH_C.L(i,vv,v,f,r,t)) + revenue_perkw_c(i,vv,v,r,t) * XC_C.L(i,vv,v,r,t);

* Set up NPV calculation to demonstrate zero-profit condition ("net" should equal zero for all new investments)

* Existing capacity may have residual value = revenue - opcost (does not include value accruing to retrofits)
npvcap_t("ex","revenue",i,"2015",r,t)$xcap(i,r) =  1e-3 * dfact(t) * revenue(i,"2015",r,t);
npvcap_t("ex","opcost",i,"2015",r,t)$xcap(i,r) =  1e-3 * dfact(t) * opcost(i,"2015",r,t);
npvcap_t("ex","cumnet",i,"2015",r,t)$xcap(i,r) = sum(tt$(tt.val le t.val), npvcap_t("ex","revenue",i,"2015",r,tt) - npvcap_t("ex","opcost",i,"2015",r,tt));

npvcap("ex","revenue",i,"2015",r)$xcap(i,r) =  1e-3 * sum(t, dfact(t) * revenue(i,"2015",r,t));
npvcap("ex","opcost",i,"2015",r)$xcap(i,r) =  1e-3 * sum(t, dfact(t) * opcost(i,"2015",r,t));
npvcap("ex","net",i,"2015",r)$xcap(i,r) = npvcap("ex","revenue",i,"2015",r) - npvcap("ex","opcost",i,"2015",r);

capv(new(i),v,r)$(sum(ivrt(i,v,r,t), XC.L(i,v,r,t)) > 1e-3) = sum(ivrt(i,v,r,t), XC.L(i,v,r,t));
capv(conv(i),v,r)$(sum(civrt(i,vv,v,r,t), XC_C.L(i,vv,v,r,t)) > 1e-3) = sum(civrt(i,vv,v,r,t), XC_C.L(i,vv,v,r,t));

npvcap_t("new","revenue",i,v,r,t)$(new(i) and newv(v) and vt(v,t) and capv(i,v,r)) =  1e-3 * dfact(t) * revenue(i,v,r,t);
npvcap_t("new","opcost",i,v,r,t)$(new(i) and newv(v) and vt(v,t) and capv(i,v,r)) =  1e-3 * dfact(t) * opcost(i,v,r,t);
npvcap_t("new","invcost",i,v,r,t)$(new(i) and newv(v) and tv(t,v) and capv(i,v,r)) =  1e-3 * dfact(t) * invcost(i,r,t);
npvcap_t("new","net",i,v,r,t)$(new(i) and newv(v) and vt(v,t) and capv(i,v,r)) = sum(tt$(tt.val le t.val),
        npvcap_t("new","revenue",i,v,r,tt) - npvcap_t("new","opcost",i,v,r,tt) - npvcap_t("new","invcost",i,v,r,tt));

npvcap("new","revenue",i,v,r)$(new(i) and newv(v) and capv(i,v,r)) =  1e-3 * sum(t, dfact(t) * revenue(i,v,r,t));
npvcap("new","opcost",i,v,r)$(new(i) and newv(v) and capv(i,v,r)) =  1e-3 * sum(t, dfact(t) * opcost(i,v,r,t));
npvcap("new","invcost",i,v,r)$(new(i) and newv(v) and capv(i,v,r)) =  1e-3 * sum(tv(t,v), dfact(t) * invcost(i,r,t));
npvcap("new","net",i,v,r)$(new(i) and newv(v) and capv(i,v,r)) = npvcap("new","revenue",i,v,r) - npvcap("new","opcost",i,v,r) - npvcap("new","invcost",i,v,r);

npvcap_t("conv","revenue",i,v,r,t)$(conv(i) and newv(v) and vt(v,t) and capv(i,v,r)) =  1e-3 * dfact(t) * sum(vv, revenue_c(i,vv,v,r,t));
npvcap_t("conv","opcost",i,v,r,t)$(conv(i) and newv(v) and vt(v,t) and capv(i,v,r)) =  1e-3 * dfact(t) * sum(vv, opcost_c(i,vv,v,r,t));
npvcap_t("conv","invcost",i,v,r,t)$(conv(i) and newv(v) and tv(t,v) and capv(i,v,r)) =  1e-3 * dfact(t) * sum(vv, convcost(i,vv,r,t));
npvcap_t("conv","net",i,v,r,t)$(conv(i) and newv(v) and vt(v,t) and capv(i,v,r)) = sum(tt$(tt.val le t.val),
        npvcap_t("conv","revenue",i,v,r,tt) - npvcap_t("conv","opcost",i,v,r,tt) - npvcap_t("conv","invcost",i,v,r,tt));

npvcap("conv","revenue",i,v,r)$(conv(i) and newv(v) and capv(i,v,r)) =  1e-3 * sum((t,vv), dfact(t) * revenue_c(i,vv,v,r,t));
npvcap("conv","opcost",i,v,r)$(conv(i) and newv(v) and capv(i,v,r)) =  1e-3 * sum((t,vv), dfact(t) * opcost_c(i,vv,v,r,t));
npvcap("conv","invcost",i,v,r)$(conv(i) and newv(v) and capv(i,v,r)) =  1e-3 * sum((tv(t,v),vv), dfact(t) * convcost(i,vv,r,t));
npvcap("conv","net",i,v,r)$(conv(i) and newv(v) and capv(i,v,r)) = npvcap("conv","revenue",i,v,r) - npvcap("conv","opcost",i,v,r) - npvcap("conv","invcost",i,v,r);

pvxcap("revenue",xcapmodes,i,r)$xcap(i,r) = 1e-3 * sum((xcapmap(xcapmodes,ii,i),vbase,xcapv(xcapmodes,v),t), dfact(t) * (revenue(ii,v,r,t) + revenue_c(ii,vbase,v,r,t)));
pvxcap("opcost",xcapmodes,i,r)$xcap(i,r) = 1e-3 * sum((xcapmap(xcapmodes,ii,i),vbase,xcapv(xcapmodes,v),t), dfact(t) * (opcost(ii,v,r,t) + opcost_c(ii,vbase,v,r,t)));
pvxcap("invcost",xcapmodes,i,r)$(xcap(i,r) and not sameas(xcapmodes,"asis")) = 1e-3 * sum((xcapmap(xcapmodes,ii,i),vbase,t), dfact(t) * (invcost(ii,r,t) + convcost(ii,vbase,r,t)));

pvxcap("net",xcapmodes,i,r) = pvxcap("revenue",xcapmodes,i,r) - pvxcap("opcost",xcapmodes,i,r) - pvxcap("invcost",xcapmodes,i,r);
pvxcap(cashflows,"total",i,r) = sum(xcapmodes, pvxcap(cashflows,xcapmodes,i,r));

pvxcap_US(type) = sum((idef(i,type),r), pvxcap("net","total",i,r));
pvxcap_US("total") = sum(type, pvxcap_US(type));

pvxcap_coal(cashflows,i,r)$idef(i,"clcl") = pvxcap(cashflows,"total",i,r);
pvxcap_coal("xcap",i,r)$idef(i,"clcl") = xcap(i,r);

pvxcap_coal_r(cashflows,r) = sum(i, pvxcap_coal(cashflows,i,r));

* Demonstrate that:
*       - investment equals realized net revenue operating revenue (normalized per kW and discounted back to first year of vintage)
*       - investment is strictly greater than the shadow value of net operating revenue for any technologies out of the money
value_perkw("inv",new(i),v,r) = sum((ivrt(i,v,r,t),tv(t,v)), invcost_perkw(i,r,t));
value_perkw("netoprev_rlz",new(i),v,r)$sum(tv(t,v), IX.L(i,r,t) > 1e-3) =
        sum(vt(v,t), dfact(t) * (revenue(i,v,r,t) - opcost(i,v,r,t))) / sum(tv(t,v), dfact(t) * (1/nyrs(t)) * IX.L(i,r,t));
value_perkw("netoprev_shdw",new(i),v,r)$(sum(t, ivrt(i,v,r,t)) and sum(tv(t,v), IX.L(i,r,t) le 1e-3)) =
        sum(ivrt(i,v,r,t), dfact(t) * (
        (revenue_permwh(i,v,r,t) - smin(ifl(i,f), opcost_permwh(i,v,f,r,t))) * 1e-3 * flh("shdw",i,v,r,t) +
         revenue_perkw(i,v,r,t) - fomcost(i,r)))
         / sum(tv(t,v), (1/nyrs(t)) * dfact(t))
;
value_perkw_c("inv",conv(i),vv,v,r) = sum((civrt(i,vv,v,r,t),tv(t,v)), convcost_perkw(i,vv,r,t));
value_perkw_c("netoprev_rlz",conv(i),vv,v,r)$sum(tv(t,v), IX_C.L(i,vv,r,t) > 1e-3) =
        sum(vt(v,t), dfact(t) * (revenue_c(i,vv,v,r,t) - opcost_c(i,vv,v,r,t))) / sum(tv(t,v), dfact(t) * (1/nyrs(t)) * IX_C.L(i,vv,r,t));
value_perkw_c("netoprev_shdw",conv(i),vv,v,r)$(sum(t, civrt(i,vv,v,r,t)) and sum(tv(t,v), IX_C.L(i,vv,r,t) le 1e-3)) =
        sum(civrt(i,vv,v,r,t), dfact(t) * (
        (revenue_permwh_c(i,vv,v,r,t) - smin(ifl(i,f), opcost_permwh_c(i,vv,v,f,r,t))) * 1e-3 * flh_c("shdw",i,vv,v,r,t) +
         revenue_perkw_c(i,v,vv,r,t) - fomcost(i,r)))
         / sum(tv(t,v), (1/nyrs(t)) * dfact(t))
;

* Fiscal costs of IRA subsidies (total annual outlay in model year $B)
ira_rpt("45Y_ptc_gen",t) = 1e-3 * (sum(ivfrt(i,v,f,r,t)$ptctv(t,v), XTWH.L(i,v,f,r,t) * ptc(i,f,v)) + sum(civfrt(i,vv,v,f,r,t)$ptctv(t,v), XTWH_C.L(i,vv,v,f,r,t) * ptc(i,f,v)));
ira_rpt("48E_itc_gen",t) = 1e-3 * (sum((new(i),r), IX.L(i,r,t) * cappr_i(i,r,t) * sum(tv(t,v)$ivrt(i,v,r,t), itcval(i,v,r))) + sum((conv(i),vv,r), IX_C.L(i,vv,r,t) * cappr_c(i,vv,r,t) * sum(tv(t,v)$civrt(i,vv,v,r,t), itcval(i,v,r))));
ira_rpt("48E_itc_stor",t) = 1e-3 * sum((j,r), cappr_g(j,r,t) * (IGC.L(j,r,t) * capcost_gc("%stortlc%",j,t) + IGR.L(j,r,t) * capcost_gr("%stortlc%",j,t)) * sum(tv(t,v), itc_j(j,v)));
ira_rpt("45Q_ccs_gen",t) = 1e-3 * (sum(ivfrt(i,v,f,r,t), XTWH.L(i,v,f,r,t) * ccs45Q(i,v,f,r,t)) + sum(civfrt(i,vv,v,f,r,t), XTWH_C.L(i,vv,v,f,r,t) * ccs45Q_c(i,vv,v,f,r,t)));
ira_rpt("45Q_ccs_fuels",t) = 1e-3 * sum((fi,v,r)$vt(v,t), FX.L(fi,v,r,t) * ccs45q_trf(fi,v,t));
ira_rpt("45V_ptc_h2",t) = 1e-3 * sum((v,r)$(vt(v,t) and ptctv(t,v)), FX.L("elys-45v",v,r,t) * ptc_h("elys-45v",v));

* Total cumulative fiscal costs in undiscounted terms (assuming five years per period)
ira_rpt("45Y_ptc_gen","tot_ud") = 5 * sum(t, ira_rpt("45Y_ptc_gen",t));
ira_rpt("48E_itc_gen","tot_ud") = 5 * sum(t, ira_rpt("48E_itc_gen",t));
ira_rpt("48E_itc_stor","tot_ud") = 5 * sum(t, ira_rpt("48E_itc_stor",t));
ira_rpt("45Q_ccs_gen","tot_ud") = 5 * sum(t, ira_rpt("45Q_ccs_gen",t));
ira_rpt("45Q_ccs_h2","tot_ud") = 5 * sum(t, ira_rpt("45Q_ccs_h2",t));
ira_rpt("45V_ptc_h2","tot_ud") = 5 * sum(t, ira_rpt("45V_ptc_h2",t));

* Inter-regional ransmission investments
tcost_interlinks(r,t) = 1e-3 / nyrs(t) * 0.5 * sum(rr, IT.L(r,rr,t) * tcapcost(r,rr) + IT.L(rr,r,t) * tcapcost(rr,r));

* Aggregate regional flows in clean electricity standard market ($B)
cesflow_i(i,"rev",r,t) = 0;
cesflow("rev",r,t) = 0;
$iftheni.ces NOT %ces%==none
cesflow_i(i,"rev",r,t) = 1e-3 * sum((v,f), cespr(r,t) * (ces(i,v,f,r,"%ces%") * XTWH.L(i,v,f,r,t) + sum(vv, ces_c(i,v,vv,f,r,"%ces%") * XTWH_C.L(i,vv,v,f,r,t))));
cesflow("rev",r,t) = sum(i, cesflow_i(i,"rev",r,t));
$endif.ces
cesflow("exp",r,t) = 1e-3 * (cespr(r,t) * cestgt(t,"%ces%") * contot(r,t));
cesflow("net",r,t) = cesflow("rev",r,t) - cesflow("exp",r,t);
cesflow("rev","USA",t) = eps + sum(r, cesflow("rev",r,t));
$ifi NOT %cesacp%==no cesflow("rev","GOVT",t) = eps + 1e-3 * sum(r, CES_ACP.L(r,t) * cesacpr(t,"%ces%"));
cesflow("exp","USA",t) = eps + sum(r, cesflow("exp",r,t));
cesflow("net","USA",t) = eps + sum(r, cesflow("net",r,t));

* Aggregate regional flows in renewable portfolio standard market ($B)
rpsflow_i(i,"rev",r,t) = 1e-3 * sum((v,f), recpr(t) * rps(i,f,r,"fed") * (XTWH.L(i,v,f,r,t) + sum(vv, XTWH_C.L(i,vv,v,f,r,t))));
rpsflow("rev",r,t) = 1e-3 * sum((i,v,f), recpr(t) * rps(i,f,r,"fed") * (XTWH.L(i,v,f,r,t) + sum(vv, XTWH_C.L(i,vv,v,f,r,t))));
rpsflow("exp",r,t) = 1e-3 * recpr(t) * rpstgt(t,"%rps%") * (GRIDTWH.L(r,t) / localloss + rfpv_twh(r,t)$rps("pvrf-xn","rnw",r,"fed"));
rpsflow("net",r,t) = rpsflow("rev",r,t) - rpsflow("exp",r,t);
rpsflow("rev","USA",t) = eps + sum(r, rpsflow("rev",r,t));
rpsflow("exp","USA",t) = eps + sum(r, rpsflow("exp",r,t));
rpsflow("net","USA",t) = eps + sum(r, rpsflow("net",r,t));

* Expenditure on state REC credits by LSE ($B)
srps_bal("lse-exp",r,t) = eps + 1e-3 * strecpr(r,t) * rpstgt_r(r,t) * (GRIDTWH.L(r,t) / localloss + rfpv_twh(r,t)$rps("pvrf-xn","rnw",r,"state"));
* Alternative compliance payments for State RPS
srps_bal("acp",r,t) = eps + 1e-3 * ACP.L(r,t) * acpcost(r);
* Unbundled REC payments to other regions (negative is earnings)
srps_bal("nmr",r,t) = eps + 1e-3 * NMR.L(r,t) * strecpr_u(t);
* Bundled REC payments to other regions
srps_bal("rpc-imp",r,t) = eps + 1e-3 * sum(rr, RPC.L(rr,r,t)) * strecpr(r,t);
* Bundled REC earnings from other regions
srps_bal("rpc-exp",r,t) = eps + 1e-3 * sum(rr, RPC.L(r,rr,t) * strecpr(rr,t));
* Net import value of REC transfers
srps_bal("net-imp",r,t) = eps + srps_bal("nmr",r,t) + srps_bal("rpc-imp",r,t) - srps_bal("rpc-exp",r,t);
* Total state REC-related earnings accruing to generators in region r
srps_bal("gen-earn",r,t) = eps + srps_bal("lse-exp",r,t) - srps_bal("acp",r,t) - srps_bal("net-imp",r,t);

* Compare to net operating revenue for RPS qualified generation
srps_rev("gen-earn",r) = sum(t, dfact(t) * srps_bal("gen-earn",r,t));
srps_rev("net-rev",r) = sum((irnw(i),v), npvcap("ex","net",i,v,r) + npvcap("new","net",i,v,r));
srps_rev("net-rev-ex",r) = sum((irnw(i),v), npvcap("ex","net",i,v,r));
srps_rev("net-rev-new",r) = sum((irnw(i),v), npvcap("new","net",i,v,r));

genrev(i,r,t) = 1e-6 * sum(s, p_gen_s(s,r,t) * hours(s,t) * (sum(ivfrt(i,v,f,r,t), (X.L(s,i,v,f,r,t) - hyps(s,r,t)$sameas(i,"hydr-x"))) + sum(civfrt(i,vv,v,f,r,t), X_C.L(s,i,vv,v,f,r,t))));

* * * Base year retail prices and value

* Total value of retail sales
retailvalue(r) = 1e-3 * sum(sec, rtl_q(r,sec) * rtl_p(r,sec));

* Value of T&D cost component of retail sales
tdvalue(r) = 1e-3 * sum(sec, rtl_ptd(r,sec) * rtl_q(r,sec));
rtl_ptd_avg(r) = tdvalue(r) / (1e-3 * sum(sec, rtl_q(r,sec)));

* Value of generation cost component of retail sales
genvalue(r) = 1e-3 * rtl_pg(r) * sum(sec, rtl_q(r,sec));

* Value of generation in model (includes all compliance payments as well as energy and capacity)
genvaluebase(r) = 1e-3 * sum(tbase, p_lse(r,tbase) * contot(r,tbase));

* * * Construct retail price for end-use model
$if set iter $eval iter_p %iter%-1
$if not set iter $set iter_p none

* Read in electricity generation price from reference scenario (or other previously run scenario)
$ifthen exist %elecrpt%\..\..\reference\report\reference.elec_rpt.gdx
execute_load '%elecrpt%\..\..\reference\report\reference.elec_rpt.gdx', p_lse_reference=p_lse;
$else
p_lse_reference(r,t) = p_lse(r,t);
$endif

lse_gap(r) = 0;
rtl_pg_regen(r,t) = 0;
rtl_regen(sec,r,t) = 0;

* First, calculate T&D cost based on electric model calculations (base year T&D adder adjusted for distributed/self-generation)
$iftheni.stno2 %static%==no
loop(tbase,
rtl_ptd_t(r,sec,t) = rtl_ptd(r,sec) * contot(r,t) / retail(r,t) / (contot(r,tbase) / retail(r,tbase));
);
$else.stno2
rtl_ptd_t(r,sec,t) = rtl_ptd(r,sec);
$endif.stno2

* Alternatively, T&D cost can be based on calculations in end-use model accounting for load shape changes as well as distributed/self-generation
$ifthen %tdcost%==end
rtl_ptd_t(r,sec,t) = rtl_ptd_end("%tdc_rtl%",r,sec,t);
$endif

* Calculation for dynamic mode
$iftheni.stno %static%==no
* Measure gap between the generation price in 2020 (includes capacity cost) from a previous reference run and the observed generation price
* This gap implicitly reflects the existing rate base, which is not modeled explicitly here but assumed to decline over time
lse_gap(r) = rtl_pg(r) - p_lse_reference(r,"2020");

* Generation component of retail price starts at observed price and gradually converges to REGEN generation electricity price (75% gone by 2050)
rtl_pg_regen(r,t) = (p_lse(r,t) + (p_lse_reference(r,"2020") - p_lse(r,"2015"))$sameas(t,"2015")) + lse_gap(r) * ((2050 - t.val) / (2050 - 2015) + 0.25 * (t.val - 2015) / (2050 - 2015));
rtl_pg_rpt(rpt,t)$sum(xrpt(rpt,r), contot(r,t)) = sum(xrpt(rpt,r), contot(r,t) * rtl_pg_regen(r,t)) / sum(xrpt(rpt,r), contot(r,t));
rtl_pg_usa(t) = sum(r, contot(r,t) * rtl_pg_regen(r,t)) / uscontot(t);
rtlpgrpt(r,t) = rtl_pg_regen(r,t);
rtlpgrpt(rpt,t) = rtl_pg_rpt(rpt,t);
rtlpgrpt("us48",t) = rtl_pg_usa(t);

* REGEN electric model expenditures broken into generation and transmission ($B)
regenelec_exp("gen",r,t) = 1e-3 * (contot(r,t) * rtl_pg_regen(r,t) - (1/nyrs(t)) * sum(new, IX.L(new,r,t) * tcostadder("%tdc%",new))) + tcost_interlinks(r,t);
regenelec_exp("trans",r,t) = 1e-3 * (1/nyrs(t)) * sum(new, IX.L(new,r,t) * tcostadder("%tdc%",new)) + tcost_interlinks(r,t);
regenelec_exp("totelec",r,t) = 1e-3 * contot(r,t) * rtl_pg_regen(r,t);
* Account for carbon payments, embedded in total expenditure, potentially subject to exogenous assumptions about revenue recycling
regenelec_exp("carbon",r,t) = -1e-3 * emitlev("co2",r,t) * (
*       Revenue from national carbon market
        co2pr(t)$(co2cap(t,"%cap%") < inf) +
*       Revenue from regional carbon markets
        co2pr_rg(r,t)$(co2cap_rg(r,t,"%cap%") < inf) +
*       Revenue from RGGI carbon market
        co2pr_rggi(t)$(rggi_r(r) and rggicap(t) < inf) +
*       Revenue from NY and CA carbon markets
        co2pr_ny(t)$(nys_r(r) and nys6599(t) < inf) +
        co2pr_ny_ele(t)$(nys_r(r) and nys6599(t) < inf) +
        co2pr_ca(t)$(cal_r(r) and caab32(t) < inf) +
*       Revenue from national carbon tax
        pp("co2",t) +
*       Revenue from regional carbon tax
        pp_rg("co2",r,t)
);
regenelec_exp("gen",rpt,t) = sum(xrpt(rpt,r), regenelec_exp("gen",r,t));
regenelec_exp("trans",rpt,t) = sum(xrpt(rpt,r), regenelec_exp("trans",r,t));
regenelec_exp("totelec",rpt,t) = sum(xrpt(rpt,r), regenelec_exp("totelec",r,t));
regenelec_exp("carbon",rpt,t) = sum(xrpt(rpt,r), regenelec_exp("carbon",r,t));
regenelec_exp("gen","us48",t) = sum(r, regenelec_exp("gen",r,t));
regenelec_exp("trans","us48",t) = sum(r, regenelec_exp("trans",r,t));
regenelec_exp("totelec","us48",t) = sum(r, regenelec_exp("totelec",r,t));
regenelec_exp("carbon","us48",t) = sum(r, regenelec_exp("carbon",r,t));

* Add T&D expenditure as derived in end-use model
rtl_regen(sec,r,t) = rtl_pg_regen(r,t) + rtl_ptd_t(r,sec,t);
rtl_regen_ldv(r,t) = p_lse_ldv(r,t) + rtl_ptd_t(r,"res",t);
rtl_regen_mdhd(r,t) = p_lse_mdhd(r,t) + rtl_ptd_t(r,"com",t);
rtl_regen_nnrd(r,t) = p_lse_nnrd(r,t) + rtl_ptd_t(r,"ind",t);
rtl_regen_dc(r,t) = p_lse_dc(r,t) + rtl_ptd_t(r,"com",t);

* Adjust to 2015 dollars for iteration with end-use model
rtl_regen_2015(sec,r,t) = gdpdef("%curryr%","2015") * rtl_regen(sec,r,t);

* Load previous iteration prices, if they exist
$ifthen exist %endusedata%\elecfuelscen\%scen%\elecfuels_enduse_%scen%_it%iter_p%.gdx
execute_load '%endusedata%\elecfuelscen\%scen%\elecfuels_enduse_%scen%_it%iter_p%.gdx', rtl_pg_regen_iter;
$endif
rtl_pg_regen_iter("%iter%",r,t) = rtl_pg_regen(r,t);

execute_unload '%endusedata%\elecfuelscen\%scen%\elecfuels_enduse_%scen%_it%iter%.gdx', rtl_pg_regen, rtl_pg_regen_iter, rtl_regen_2015=rtl_regen, pf_enduse_rpt_2015=pf_t, co2pr_tot, co2pr_sec, fuels_tot, emitlev, emittype, annual_rnw, tcost_interlinks, regenelec_exp;
$else.stno
rtlpgrpt(r,t) = p_lse(r,t);
rtlpgrpt("us48",t) = usavepr("lse",t);
execute_unload '%endusedata%\elecfuelscen\%scen%\elecfuels_enduse_%scen%_it%iter%.gdx', p_con_s, p_lse, pf_enduse_rpt_2015=pf_t, co2pr_tot, co2pr_sec, fuels_tot, emitlev, emittype, annual_rnw, tcost_interlinks, regenelec_exp;
$endif.stno

* * * Direct energy expenditures by sector

expend_nrg("res",df,r,t) = qd_enduse_rpt("res",df,r,t) * (pf_enduse_rpt("res",df,r,t) + (1/3.412) * rtl_regen("res",r,t)$sameas(df,"ele"));
expend_nrg("ldv",df,r,t) = qd_enduse_rpt("ldv",df,r,t) * (pf_enduse_rpt("ldv",df,r,t) + (1/3.412) *
* Include split between residential and commercial charging, but also include public charging equipment costs in electricity expenditures
                                (rtl_regen("res",r,t) * ldvrescom_shr("res",r,t) + rtl_regen("com",r,t)  * ldvrescom_shr("com",r,t))$sameas(df,"ele")) +
                                expend_ldvpubchrg(r,t)$sameas(df,"ele")
;
expend_nrg("com",df,r,t) = qd_enduse_rpt("com",df,r,t) * (pf_enduse_rpt("res",df,r,t) + (1/3.412) * rtl_regen("com",r,t)$sameas(df,"ele"));

* Include expenditure on charging infrastructure for MD-HD/Non-Road electric vehicles in electricity expenditures
expend_fleetchrg("mdhd",r,t) = sum((vc,vht)$(vc_mdhd(vc) or kfvc("mdhd",vc)), IV.L(vc,vht,r,t) * refuel_cost(vc,vht,r,t)) / nyrs(t);
expend_fleetchrg("ind-sm",r,t) = sum((kfvc("ind-sm",vc),vht), IV.L(vc,vht,r,t) * refuel_cost(vc,vht,r,t)) / nyrs(t);

expend_nrg("mdhd",df,r,t) = qd_enduse_rpt("mdhd",df,r,t) * (pf_enduse_rpt("res",df,r,t) + (1/3.412) * rtl_regen("com",r,t)$sameas(df,"ele")) +
                                expend_fleetchrg("mdhd",r,t)$sameas(df,"ele")
;
expend_nrg("ind",df,r,t) = qd_enduse_rpt("ind-sm",df,r,t) * (pf_enduse_rpt("ind-sm",df,r,t) + (1/3.412) * rtl_regen("ind",r,t)$(sameas(df,"ele"))) +
                           qd_enduse_rpt("ind-lg",df,r,t) * (pf_enduse_rpt("ind-lg",df,r,t) + (1/3.412) * rtl_regen("ind",r,t)$(sameas(df,"ele"))) +
                                expend_fleetchrg("ind-sm",r,t)$sameas(df,"ele")
;

* Aggregate categories (household and non-household)

expend_nrgtot("res+ldv","ele",r,t) = expend_nrg("res","ele",r,t) + expend_nrg("ldv","ele",r,t);
expend_nrgtot("res+ldv","ppg",r,t) = expend_nrg("res","ppg",r,t);
expend_nrgtot("res+ldv","mgs",r,t) = expend_nrg("ldv","mgs",r,t);
expend_nrgtot("res+ldv","oth",r,t) = sum(df$(not sameas(df,"ele") and not sameas(df,"ppg") and not sameas(df,"mgs")), expend_nrg("res",df,r,t) + expend_nrg("ldv",df,r,t));
expend_nrgtot("non-hh","tot-fuel",r,t) = sum(df, expend_nrg("com",df,r,t) + expend_nrg("mdhd",df,r,t) + expend_nrg("ind",df,r,t));

expend_nrgtot("res+ldv","ele","us48",t) = sum(r, expend_nrgtot("res+ldv","ele",r,t));
expend_nrgtot("res+ldv","ppg","us48",t) = sum(r, expend_nrgtot("res+ldv","ppg",r,t));
expend_nrgtot("res+ldv","mgs","us48",t) = sum(r, expend_nrgtot("res+ldv","mgs",r,t));
expend_nrgtot("res+ldv","oth","us48",t) = sum(r, expend_nrgtot("res+ldv","oth",r,t));
expend_nrgtot("non-hh","tot-fuel","us48",t) = sum(r, expend_nrgtot("non-hh","tot-fuel",r,t));

* Normalize by household

expend_nrgtot_perhh("res+ldv","ele",r,t)$hu_total(r,t) = expend_nrgtot("res+ldv","ele",r,t) / hu_total(r,t);
expend_nrgtot_perhh("res+ldv","ppg",r,t)$hu_total(r,t) = expend_nrgtot("res+ldv","ppg",r,t) / hu_total(r,t);
expend_nrgtot_perhh("res+ldv","mgs",r,t)$hu_total(r,t) = expend_nrgtot("res+ldv","mgs",r,t) / hu_total(r,t);
expend_nrgtot_perhh("res+ldv","oth",r,t)$hu_total(r,t) = expend_nrgtot("res+ldv","oth",r,t) / hu_total(r,t);
expend_nrgtot_perhh("non-hh","tot-fuel",r,t)$hu_total(r,t) = expend_nrgtot("non-hh","tot-fuel",r,t) / hu_total(r,t);

expend_nrgtot_perhh("res+ldv","ele","us48",t)$sum(r, hu_total(r,t)) = expend_nrgtot("res+ldv","ele","us48",t) / sum(r, hu_total(r,t));
expend_nrgtot_perhh("res+ldv","ppg","us48",t)$sum(r, hu_total(r,t)) = expend_nrgtot("res+ldv","ppg","us48",t) / sum(r, hu_total(r,t));
expend_nrgtot_perhh("res+ldv","mgs","us48",t)$sum(r, hu_total(r,t)) = expend_nrgtot("res+ldv","mgs","us48",t) / sum(r, hu_total(r,t));
expend_nrgtot_perhh("res+ldv","oth","us48",t)$sum(r, hu_total(r,t)) = expend_nrgtot("res+ldv","oth","us48",t) / sum(r, hu_total(r,t));
expend_nrgtot_perhh("non-hh","tot-fuel","us48",t)$sum(r, hu_total(r,t)) = expend_nrgtot("non-hh","tot-fuel","us48",t) / sum(r, hu_total(r,t));

* * * * * * * * * * * * * * * * * Export reporting parameters to separate file * * * * * * * * * * * * * * * * *

execute_unload '%rptgdx%.gdx', xgg,xgc,xcapmap, con_s, contot, uscontot, contot_fuels, uscontot_fuels, gridsup, en4load, en4int, netstor, netload, backstop, gen_s, gentot, usgentot, dsp_si, dsp_si_45v, gen_i, gen_45v, usgen_45v, gen_cfe, usgen_cfe, gen_iv, gen, usgen, genrpt_r, genrpt, natrpt, check_gen_r, trnlossrpt, biorpt, gencaprpt
                               domexp_s, intexp_s, domimp_s, intimp_s, domexp, intexp, domimp, intimp, balance_qs, balance_q, ntxelec, ntmelec, trdrpt_r, trdrpt, trnrpt, trntotal, dspsrpt_r,h2rpt,h2conrpt,h2rpt_45v,h2cap,h2cap_con,h2cap_eu,h2storcap,h2cost,h2cost_tot,h2con,h2con_nele,h2con_blend,h2elys,pefuel_s,pefuel,ph2e_ele,ph2e_ivf,ph2e_ivvf
                               coaldisp_r, coaldisp_i, clncdisprpt, supcurve, cuminv, cumconv, uscuminv, uscumconv, retirement, ncap_i, acap_si, opcap, usopcap, curtailment, nuccap, windutil, caputil,share_spin,share_inv,share_inv_hours,share_inv_hours_ic,gascap,gascap_eu
                               fuel_s, fuelbal_rpt, fuelbal_rpt2, fuelbal_ups_rpt2, fuelbal_trf_rpt2, fuelbal_blend_rpt, blend_shr, h2nh3_shr, emitlev, emittype, usemit, dactot, usdactot, useleco2, secco2_rpt, netco2_rpt, polint_r, uspolint, rnwshr, usrnwshr, srnwgen, srpsrpt, ceshr, ceshr_us, cesrpt, cesrpt_rpt, cesrpt_us,
                               qd_eeu_kf, qd_eeu_vc, vmt_vc, mdhd_rpt, qd_enduse_rpt, eleconrpt, elec_fuels_rpt, enduse_chk, enduse_chk_twh_r, k2vc, qdr_tot_x, qdr_tot_e, qdr_chk, ele_det_r, ele_det_us, rfp_rpt, gas_rpt, gastrade_rpt, ppg_rpt, trf_rpt, trf_cap_rpt, bfs_rpt, biopr_rpt, bio_ex, sankey_rpt, sankey_bal_check,
                               elebal_M, p_lse, rsv_m, strecpr, srps_m, recpr, rps_m, fullrecpr, cespr, ces_m, sb100pr, sb100_m, zercpr_s, zercpr, ssolpr, ssol_m, wnospr, wnos_m, nuczecpr, nuczec_m, newunitspr, newunits_m,
                               p_con_s, p_gen_s, plcurve, prcurve_hist, ldcurve_hist, maxcost, p_con, p_gen, p_domexp, p_intexp, p_domimp, p_intimp,
                               price_rpt, price_blend_rpt, pf_enduse_rpt, pf_enduse_problem, pf_elec_rpt, prreport, rsvpr, rsvpr_i, final4pr, usavepr, cstor_pr, co2pr, co2pr_rg, co2pr_ele, co2pr_sec, co2pr_rggi, co2pr_ny, co2pr_ny_ele, co2pr_ca, co2pr_tot, nonpr, recpr, cespr, ces_m, cestax, cestax_c, fom_gen, fom_gen_i, capex_gen, uscapex_gen, p_lse
                               flh, revenue, revenue_permwh, revenue_perkw, opcost_permwh, opcost, invcost_perkw, invcost, invest_perperiod, opcost_perperiod, npvcap, npvcap_t, pvxcap, pvxcap_coal, pvxcap_coal_r, pvxcap_US, value_perkw
                               flh_c, revenue_c, revenue_permwh_c, revenue_perkw_c, opcost_permwh_c, opcost_c, convcost_perkw, convcost, value_perkw_c
                               ira_rpt, cestaxrev, cestaxrev_i
                               natcaprpt, caprpt, caprpt_r, uspeakload, peakload, peakload_r, netpkbal, srps_bal,srps_rev
                               wtrdraw, wtrcons, lse_gap, rtl_pg_regen, rtl_pg_rpt, rtl_pg_usa, rtlpgrpt, regenelec_exp, rtl_ptd, rtl_ptd_t, rtl_regen, annual_rnw, tcost_interlinks, expend_ldvpubchrg, expend_fleetchrg, expend_nrg, expend_nrgtot, expend_nrgtot_perhh, hu_total
                               rsv_m_ldv, rsv_m_mdhd, rsv_m_nnrd, rsv_m_dc, p_con_ldv, p_con_mdhd, p_con_nnrd, p_con_dc, p_lse_ldv, p_lse_mdhd, p_lse_nnrd, p_lse_dc, p_lse_dc_avg, rtl_regen_ldv, rtl_regen_mdhd, rtl_regen_nnrd, rtl_regen_dc
                               peakcont_ldv, peakcont_mdhd, peakcont_nnrd, peakcont_dc, contot_ldv, contot_mdhd, contot_nnrd, con_ldv_s, con_mdhd_s, con_nnrd_s, con_45v_s, pkgrid_s, peakgrid_report, peakgrid_bind
                               ivrt, storrpt, rtl_pg_regen_iter
                               ccs_rpt, co2_capt_rpt, co2_capt_rpt_f, co2_capt_full, prim_elec, prim_rpt, fuels_tot qsec_elec, qsec_h2, report_co2_pipe
;

* Reporting for graphical spreadsheet template is latest model run, iter not specified
execute_unload '%reportelec%\%scen%.gdx', r, t, gencaprpt, clncdisprpt, rtlpgrpt, regenelec_exp, co2pr, co2pr_sec, co2pr_ele, pp, polint_r, uspolint, supcurve, plcurve, prcurve_hist, ldcurve_hist
                               emitlev, storrpt, netpkbal, h2rpt, h2conrpt, h2cap, h2cap_con, h2cap_eu, h2cost, h2elys, eleconrpt, secco2_rpt, sankey_rpt, sankey_bal_check, fuelbal_rpt, fuelbal_blend_rpt, blend_shr
                               price_rpt, pf_enduse_rpt, price_blend_rpt, fuel_i, usopcap, zercpr, usgen_45v, usgen_cfe, ele_det_us, ele_det_r, invest_perperiod, opcost_perperiod, gascap, gascap_eu
                               p_lse_dc, p_lse_dc_avg, p_lse, rtl_regen_dc, rtl_regen, expend_nrgtot, expend_nrgtot_perhh
;

* Reporting for Sankey diagram
execute_unload '%reportsankey%\%scen%.gdx', r, t, sankey_rpt, sankey_bal_check, hydrogen, pipeline_gas, liquid_fuels, biomass, finalen, prim_rpt, eleconrpt;

* Reporting for transmission
execute_unload '%reporttrn%\%scen%.gdx', r, t, trnrpt, trntotal, report_co2_pipe;

* Installed capacity for hour choice iterative updating of hydro shape
execute_unload '%hoursdata%\elecfuelscen\%scen%\elecfuels_hours_%scen%_it%iter%.gdx', XC;
