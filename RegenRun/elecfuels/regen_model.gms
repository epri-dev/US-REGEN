* ----------------------
* regen_model.gms
* ----------------------
* REGEN Electric+Fuels Model
* Model variable, equation, and model declarations

* * * * * * * * * * * * * * * * MODEL FORMULATION:  Variables and Equations * * * * * * * * * * * * *  *

positive variable
* Electricity generation and capacity
X(s,i,v,f,r,t)                  Electric generation dispatch by segment (GW)
X_C(s,i,v,v,f,r,t)              Converted electric generation dispatch by segment (GW)
XT(s,i,v,f,r,t)	                Thermal dispatch of electric generation capacity by segment (BBtu per hour)
XT_C(s,i,v,v,f,r,t)             Converted electric generation capacity thermal dispatch by segment (BBtu per hour)
XC(i,v,r,t)                     Installed (standard) electric generation capacity (GW)
XC_C(i,v,v,r,t)                 Installed converted electric generation capacity (GW)
XCS(s,i,v,r,t)                  Copies of XC for sparsity purposes (capacity in GW)
XCS_C(s,i,v,v,r,t)              Copies of XC_C for sparsity purposes (capacity in GW)
XTWH(i,v,f,r,t)                 Total annual electric generation (TWh)
XTWH_C(i,v,v,f,r,t)             Total annual electric generation for conversions (TWh)
IX(i,r,t)                       New vintage investment in electric generation capacity (total GW to be added from t-1 to t)
IX_C(i,v,r,t)                   New vintage conversion investment in electric generation capacity (total GW to be converted from t-1 to t)
NUPR(r,t)                       Existing nuclear capacity uprates in period t (GW)
RC(i,v,r,t)                     Cumulative retired convertible electric generation capacity (GW)
DR(s,r,t)                       Demand response (hypothetical backstop demand option) (GW)
DRC(s,r,t)                      Curtailment of distributed resource (negative demand response) (GW)
GRID(s,r,t)                     Total grid-based energy for load by segment (GW)
GRIDTWH(r,t)                    Total annual grid-based energy for load (TWh)
PKGRID(r,t)                     Peak grid-supplied residual load (net of variable renewables and storage) by region (GW)
RMARG(r,t)                      Planning reserve margin by region (GW additional above peak load)

* Electricity transmission and storage
E(s,r,r,t)                      Bilateral transmission flow by load segment (GW)
TC(r,r,t)                       New transmission flow capacity (GW)
IT(r,r,t)                       Investment in transmission capacity (total GW to be added from t-1 to t)
G(s,j,r,t)                      Electricity storage charge by segment (GW)
GD(s,j,r,t)                     Electricity storage discharge by segment (GW)
GC(j,r,t)                       Electricity storage power capacity (size of door) (GW)
GR(j,r,t)                       Electricity storage energy capacity (size of room) (GWh)
IGC(j,r,t)                      Investment in electricity storage charge-discharge capacity (total GW added from t-1 to t)
IGR(j,r,t)                      Investment in electricity storage size of room (total GWh added from t-1 to t)
GB(s,j,r,t)                     Electricity storage accumulated balance (GWh)

* Separate variables for CSP (if included)
X_CSP_CR(s,i,r,t)               CSP power reaching receiver from incoming DNI (GW-th)
C_CSP_CR(i,r,t)                 Installed (rented) CSP collector + receiver capacity (GW-th)
G_CSP(s,i,r,t)                  Storage charge from CSP receiver (after losses) (GW-th)
GD_CSP(s,i,r,t)                 Storage discharge from CSP TES (GW-th)
GR_CSP(i,r,t)                   Installed (rented) CSP storage capacity (size of room) (GWh-th)
GB_CSP(s,i,r,t)                 Dynamic balance of installed CSP storage capacity utilization (GWh-th)

* Operating reserve variables (if included)
SR(s,i,v,r,t)                   Spinning reserve provided by capacity block in a segment (GW)
SR_C(s,i,v,v,r,t)               Spinning reserve provided by conversion capacity block in a segment (GW)
SRJ(s,j,r,t)                    Spinning reserve provided by storage (GW)
SPINREQ(s,r,t)                  Spinning reserve requirement in a segment (GW)
QS(s,i,v,r,t)                   Quick start reserve provided by capacity block in a segment (GW)
QS_C(s,i,v,v,r,t)               Quick start reserve provided by conversion capacity block in a segment (GW)
QSJ(s,j,r,t)                    Quick start reserve provided by storage (GW)
QSREQ(s,r,t)                    Quick start reserve requirement (GW)

* Electric sector policy variables
RPC(r,r,t)                      Renewable power contract bundled RECs under state RPS (TWh)
ACP(r,t)                        Alternative compliance payment certificates for state RPS (TWh)
ER(s,r,r,t)                     Exportable renewable power under state RPS by load segment (GW)
EC(s,r,r,t)                     Exportable clean energy under federal CES by load segment (GW)
BCE(r,r,t)                      Bundled clean electricity credits under federal CES (TWh)
CESTOT(r,t)                     Total System TWh under federal CES policy (TWh)
CES_ACP(r,t)                    Alternative compliance payment certificates under federal CES (TWh)
EC_CA(s,r,t)                    Exportable clean energy under CA SB100 by load segment into CA (GW)
UI_CA(r,t)                      Unspecified imports into CA under SB100 (TWh)
BCE_CA(r,t)                     Bundled clean electricity credits under CA SB100 (TWh)
SV(t)                           Safety valve allowance purchases under economy-wide CO2 cap (MtCO2)
SV_EQ(t)                        Safety valve allowance purchases under economy-wide CO2-eq cap (MtCO2-eq)
SV_ELE(t)                       Safety valve allowance purchases under electric sector CO2 cap (MtCO2)

* Zero-emission resource certificates (ZERCs, or 'energy attribute certificates' = EACs) for clean electricity procurement
HZERC_45V(s,i,v,f,r,t)          Hourly ZERCs for 45V compliance (GW)
ZERC_45V(i,v,f,r,t)             Annual ZERCs for 45V compliance (TWh)
HZERC_CFE(s,i,v,f,r,t)          Hourly ZERCs for voluntary CFE procurement (GW)
ZERC_CFE(i,v,f,r,t)             Annual ZERCs for voluntary CFE procurement (TWh)

* Electricity demand variables
QD_FLX_S(s,flx,r,t)             Flexible electricity demand (GW)
C_FLX(flx,r,t)                  Flexible electricity demand capacity (GW)
CXS_FLX(s,flx,r,t)              Segment-level copies of flexible electricity demand capacity for sparsity (GW)
QD_DC_S(s,r,t)                  Total data center load by segment (GW)
QD_CFE_S(s,r,t)                 Load subject to voluntary CFE procurement (GW)

* Economy-wide fuel balance components
QSF(f,r,t)                      Annual quantity of fuels output supplied (TBtu per year)
QS_BLEND(dst,f,r,t)             Annual quantity of output supplied for blended fuels to each destination (TBtu per year)
QD_BLEND(f,dst,f,r,t)           Annual fuel inputs (f1) to blended fuel (f2) (TBtu per year)
QD_UPS(f,r,t)                   Annual fuel demands for upstream fossil production (TBtu per year)
QD_ELEC(f,r,t)                  Annual fuel demands for electric generation (TBtu per year)
QD_ELEC_PPGU(r,t)               Annual uncaptured pipeline gas demands for electric generation (TBtu per year)
QD_TRF(f,f,r,t)	                Annual fuel inputs (f1) to transformation sector output (f2) (TBtu per year)
QD_DAC(f,r,t)                   Annual fuel inputs to direct air capture (TBtu per year)
QD_CO2(f,r,t)                   Annual fuel inputs for CO2 transport and storage (TBtu per year)
QD_EEU(kf,f,r,t)                Annual fuel demands in endogenous enduse sectors (TBtu per year)

* Final energy accounting by end-use sector
FE_BLD(f,r,t)                   Final energy in buildings sectors (res + com) (not additive across fuels) (TBtu per year)
FE_IND(f,r,t)                   Final energy in (non-energy) industrial sectors (not additive across fuels) (TBtu per year)
FE_TRN(f,r,t)                   Final energy in transportation sectors (ldv + mdhd) (not additive across fuels) (TBtu per year)

* Non-electric fuels transformation sectors
FC(fi,v,r,t)                    Fuel transformation output capacity (BBtu per hour)
IFC(fi,r,t)                     New vintage investment in fuel transformation output capacity (BBtu per hour)
RFC(fi,v,r,t)                   Cumulative retired convertible fuel transformation capacity (GW)
FX(fi,v,r,t)                    Annual fuel transformation sector production (TBtu per year)
* Electrolytic hydrogen and e-fuels have segment level dispatch and disposition
HX(s,fi,v,r,t)                  Dispatch of e-hydrogen and e-fuel production capacity (BBtu per hour)
HCS(s,fi,v,r,t)                 Copies of FC(hi) for sparsity purposes (BBtu per hour)
HDU_BLEND_S(s,f,r,t)            E-hydrogen blended into NG pipeline (rate by segment) (BBtu per hour)
QD_TRF_S(s,f,f,r,t)             Energy inputs to e-fuel production (rate by segment) (BBtu per hour)
QD_H2I_S(s,r,t)                 Electric load for hydrogen storage and transmission by segment (GW)
QD_DAC_S(s,r,t)                 Electric load for direct air capture by segment (GW)
QD_EEU_S(s,r,t)                 Electric load for endogenous end-use (MD-HD and non-road vehicles) (GW)

* Bioenergy feedstocks
QS_BFS(bfs,bfsc,r,t)            Annual supply of biomass feedstocks by supply class (TBtu)
QD_BFS(bfs,fi,r,t)              Annual demand for biomass feedstocks by bio-conversion technology (TBtu)

* Hydrogen infrastructure
HE(s,f,r,r,t)                   Inter-region transmission of hydrogen (e-hydrogen only) (BBtu per hour)
TC_H(r,r,t)                     Inter-region hydrogen transmission capacity (BBtu per hour)
IT_H(r,r,t)                     New vintage investment in inter-region hydrogen transmission capacity (BBtu per hour)
G_H(s,hk,f,r,t)                 Hydrogen storage charge (injection) (BBtu per hour)
GD_H(s,hk,f,r,t)                Hydrogen storage discharge (withdrawal) (BBtu per hour)
GC_H(hk,r,t)                    Hydrogen storage charge capacity (size of door) (BBtu per hour)
IGC_H(hk,r,t)                   New investment in hydrogen storage charge capacity (size of door) (BBtu per hour)
IGR_H(hk,r,t)                   New investment in hydrogen reservoir capacity (size of room) (BBtu)
GR_H(hk,r,t)                    Hydrogen storage reservoir capacity (size of room) (BBtu)
GB_H(s,hk,r,t)                  Dynamic balance of hydrogen storage (working gas) (BBtu)

* Direct air capture
DACC(dac,v,r,t)                 Direct air capture capacity (MtCO2 net removal per year)
IDAC(dac,r,t)                   New vintage investment in direct air capture capacity (MtCO2 per year)
DACX(s,dac,v,r,t)               Dispatch of CO2 from electric-only direct air capture (thousand tCO2 per hour)
DACANN(dac,v,r,t)               Total annual net removal from dac (MtCO2 per year)

* CO2 pipeline and storage
PC(r,r,t)                       Total CO2 pipeline capacity (MtCO2 per year)
IP(r,r,t)                       Investment in CO2 pipelines (MtCO2 per year to be added from t-1 to t)
PX(r,r,t)                       CO2 pipeline flow between regions (MtCO2 per year)
INJC(cstorclass,r,t)            Total CO2 injection capacity (MtCO2 per year)
IINJ(cstorclass,r,t)            Investment in CO2 injection (MtCO2 per year to be added from t-1 to t)
CSTOR(cstorclass,r,t)           CO2 injected into geologic reservoirs (MtCO2 per year)

* Carbon flows (positive only)
CO2_SYN(r,t)                    CO2 input to synthetic fuel production (MtCO2 per year)
CO2_NAT(ncr,r,t)                CO2 removed by natural sytems by supply category (regional credits) (MtCO2 per year)
CO2_DAC(r,t)                    Annual total net CO2 removal from DAC (MtCO2 per year)
CO2_CAPT_UPS(f,r,t)             Captured CO2 from upstream (MtCO2 per year)
CH4_EMIT(r,t)                   Energy-related CH4 emissions (MtCO2-eq per year)
* Sector-level allocated direct emissions (industrial could be negative)
CO2_BLD(r,t)                    Direct CO2 emissions in buildings sectors (MtCO2 per year)
CO2_TRN(r,t)                    Direct CO2 emissions in transportation sectors (MtCO2 per year)

* End-use sector activity levels
VDI(vc,vht,v_e,di,r,t)          Allocation of vehicles to driving intensity classes (millions)
XV(vc,vht,v_e,r,t)              Active vehicles by class technology and vintage (millions)
IV(vc,vht,r,t)                  New vehicles investment (total purchased from t-1 to t) (millions)
NNRD_BFS(vc,r,t)                Incremental non-road service demand for bioenergy feedstock production (millions of vehicle-eq)
;

variable
Z                               Objective value - total costs in $ million

NTX(f,r,t)                      Annual net fuel exports (domestic plus international) (TBtu)

* Carbon flows (could be negative)
CO2_ELE(r,t)                    Annual total (net) CO2 emissions from electric generation (MtCO2)
CO2_UPS(r,t)                    Annual total CO2 emissions from upstream production and refining (MtCO2)
CO2_TRF(r,t)                    Annual total CO2 emissions from non-electric fuel transformation (MtCO2)
CO2_IND(r,t)                    Direct CO2 emissions in (non-energy) industrial sectors (MtCO2 per year)
CO2_EMIT(r,t)                   Regional economy-wide net CO2 emissions (MtCO2 per year)
CO2E_EMIT(r,t)                  Regional economy-wide net CO2-eq emissions (MtCO2-eq per year)
CO2_US(t)                       National economy-wide net CO2 emissions (MtCO2 per year)
CO2E_US(t)                      National economy-wide net CO2-eq emissions (MtCO2-eq per year)
* CO2 and other credits
NBC(t)                          Net banked credits for economy-wide cap (MtCO2 per year)
NBC_EQ(t)                       Net banked credits for economy-wide CO2-eq cap (MtCO2-eq per year)
NBC_ELE(t)			Net banked credits for electric sector cap (MtCO2 per year)
NBC_RG(r,t)                     Net banked credits for regional economy-wide cap (MtCO2 per year)
NBC_RGGI(t)                     Net banked credits in RGGI market (MtCO2 per year)
NBC_CSAPR(trdprg,t)             Net banked credits in CSAPR trading markets (Mt per year)
NTX_CSAPR(trdprg,pol,r,t)       Net exported credits in CSAPR trading markets (Mt per year)
CBC(t)                          Cumulative banked credits for economy-wide cap (MtCO2)
CBC_EQ(t)                       Cumulative banked credits for economy-wide CO2-eq cap (MtCO2-eq)
CBC_ELE(t)                      Cumulative banked credits for electric sector cap (MtCO2)
CBC_RG(r,t)                     Cumulative banked credits for regional economy-wide cap (MtCO2)
CBC_RGGI(t)                     Cumulative banked credits in RGGI market (MtCO2)
CBC_CSAPR(trdprg,t)             Cumulative banked credits in CSAPR trading markets (Mt)
NMR(r,t)                        Net imports of unbundled RECs for state RPS (TWh)
H2G(s,hk,f,r,t)	                Net injections of electrolytic hydrogen storage (BBtu per hour)
* Clean Electricity Standard (CES)
CES_NTX(r,t)                    Net unbundled CES credit imports by region per period (TWh)
CES_NBC(t)                      Banking of CES credits per period (TWh)
CES_CBC(t)                      Cumulative banked CES credits (TWh)
;

equation
objdef                          Objective function -- definition of total cost (million dollars)

* Electricity market and planning reserve margin
elebal(s,r,t)                   Electricity market clearing condition (TWh)
enduseload(s,r,t)               Disposition of electricity supply to end-use demand (TWh)
reserve(r,t)                    Planning reserve requirement by region (GW)
peakgrid(s,r,t)                 Define peak residual load for grid-supplied energy (net of variable renewables and storage) by region (GW)
resmargin(s,r,t)                Define required planning reserve margin by region (GW)

* Electricity dispatch and capacity
xtwhdef(i,v,f,r,t)              Calculate XTWH from X (TWh)
xtwhdef_c(i,v,v,f,r,t)          Calculate XTWH_C from X_C (TWh)
gridtwhdef(r,t)                 Calculate GRIDTWH from GRID (TWh)
copyxc(s,i,v,r,t)               Make copies of XC in XCS (GW)
copyxc_c(s,i,v,v,r,t)           Make copies of XC_C in XCS_C (GW)
invest(i,v,r,t)                 Accumulation of annual electric generation capacity investment flows (GW)
invest_c(i,v,v,r,t)             Accumulation of annual electric generation conversion capacity investment flows (GW)
investstatic(i,v,r,t)           Rental investment of electric generation capacity in static mode (GW)
capacity(s,i,v,r,t)             Electric generation capacity constraint on dispatch (GW)
capacity_c(s,i,v,v,r,t)         Converted electric generation capacity constraint on dispatch (GW)
capacitymin(s,i,v,r,t)          Electric generation capacity lower bound on dispatch for for certain capacity blocks (GW)
capacitymin_c(s,i,v,v,r,t)      Converted electric generation capacity lower bound on dispatch for certain converted capacity blocks (GW)
capacityfx(s,i,v,r,t)           Electric generation capacity with fixed dispatch factor (GW)
capacityfx_c(s,i,v,v,r,t)       Converted electric generation capacity with fixed dispatch factor (GW)
fuellim(s,i,v,f,r,t)	        Limit on blending share for dual-fuel electric generation dispatch (GW)
fuellim_c(s,i,vv,v,f,r,t)	Limit on blending share for dual-fuel converted electric generation dispatch (GW)
htseprod(s,i,v,f,r,t)	        Constraint on thermal output (used for HTSE) from electric generation capacity (BBtu per hour)
htseprod_c(s,i,v,v,f,r,t)	Constraint on thermal output (used for HTSE) from converted electric generation capacity (BBtu per hour)
elecfueldemand(f,r,t)           Electric generation claims on fuels (TBtu)
elecppgudemand(r,t)             Electric generation claims on uncaptured pipeline gas (TBtu)
cflim(i,v,r,t)                  Limit on annual capacity factor for certain electric generation capacity (TWh)
cflim_dfcc(i,v,r,t)             Limit on annual capacity factor for liquid fuels in dual fuel combined cycle electric generation capacity (TWh)
cflim_c(i,v,v,r,t)              Limit on annual capacity factor for certain converted electric generation capacity (TWh)
cflim_111b(i,v,r,t)             Limit on annual capacity factor for new gas-fired electric generation capacity imposed by 111b NSPS (TWh)
capacitylim(i,r,t)              Limit on total installed electric generation capacity for certain types (GW)
capacitylim_c(i,r,t)	        Limit on total conversions of existing electric generation capacity for certain types (GW)
investlim(type,r,t)             Limit on per period regional electric generation capacity investment by type (GW)
solarlim(class,r,t)             Joint capacity constraint on PV and CSP resource potential (GW)
windrepowerlim(r,t)             Sum of existing and repowered wind capacity cannot exceed base year wind capacity (GW)
usinvestlim(tech,t)             Limit on per period national total electric generation capacity investment by technology category (GW)
retire(i,v,r,t)                 Monotonicity constraint on installed electric generation capacity vintages (capacity cannot be unretired) (GW)
retire_c(i,vv,v,r,t)            Monotonicity constraint on converted electric generation capacity vintages (capacity cannot be unretired) (GW)
convbalance(i,v,r,t)            Disposition of convertible electric generation capacity (GW)
retiremon(i,v,r,t)              Monotonicity of cumulative retirement of convertible electric generation capacity (GW)
retirelife(i,v,r,t)             Cumulative retirement of existing convertible capacity subject to lifetime (GW)
convert1(i,v,r,t)               New conversions of electric generation capacity must decrease base capacity (GW)
convgassch(i,r,t)               Planned coal to gas conversions for electric generation capacity (GW)
convbiosch(i,r,t)               Planned coal to biomass conversions for electric generation capacity (GW)
coal2020                        Lower bound on coal capacity in 2020 for calibration (GW)
gas2020_25(t)	                Upper bound on gas additions in 2020 and 2025 for calibration (GW)
newunitslo(type,r,t)	        Lower bound on new capacity additions based on historical and planned additions (GW)

* Transmission
tinvest(r,r,t)                  Accumulation of annual transmission capacity investment flows (GW)
tinveststatic(r,r,t)            Rental investment of transmission capacity in static mode (GW)
tcapacity(s,r,r,t)              Transmission capacity constraint on hourly transmission flow (GW)
tinvestlim(r,r,t)               Regional growth rate limits on per period transmission capacity investment (GW)
tinvestlimstatic(r,r,t)         Regional growth rate limits on accumulated transmission capacity investment in static mode (GW)
tusinvestlim(t)                 National limit on per period transmission capacity investment (GW-miles)

* Concentrated solar power (CSP)
capacity_csp_cr(s,i,r,t)        Capture of DNI by CSP solar collector and receiver capacity constraint (GW-th)
dispatch_csp(s,i,r,t)           CSP dispatch must come from solar collector or storage (GW-th)
storagebal_csp(s,i,r,t)         CSP dynamic storage balance (GWh-th)
storagelim_csp(s,i,r,t)         CSP dynamic balance cannot exceed size of room (GWh-th)

* Electricity storage
ginvestc(j,r,t)                 Accumulation of annual investment in electricity storage power capacity (size of door) (GW)
ginvestr(j,r,t)                 Accumulation of annual investment in electricity storage energy capacity (size of room) (GWh)
chargelim(s,j,r,t)              Electricity storage charge cannot exceed capacity (size of door) (GW)
dischargelim(s,j,r,t)           Electricity storage discharge cannot exceed capacity (size of door) (GW)
storagebal_ann(j,r,t)           Annual electricity storage charge-discharge energy balance (GWh)
storagebal(s,j,r,t)             Dynamic storage balance accumulation (GWh)
storagelim(s,j,r,t)             Electricity storage reservoir capacity constraint (size of room) (GWh)
storageratio(j,r,t)             Size of room relative to size of door (option to fix) (GWh)
storagefx(t)                    Fixed exogenous target for installed electricity storage power capacity (GW)
storagefxlo(j,r,t)              Lower bound on relative size of room with exogenous target for door (GWh)

* State and regional electric sector CO2 constraints
carbonmarket_ny(t)              Carbon target for NY (economy-wide) (MtCO2)
carbonmarket_ny_ele(t)          Carbon target for NY (electric sector only) (MtCO2)
carbonmarket_ca(t)              Carbon target for CA (economy-wide) (MtCO2)
rggimarket(t)                   Regional GHG Initiative (RGGI) joint CO2 cap across participating regions (MtCO2)
itnbc_rggi                      Intertemporal budget constraint on net banked credits for RGGI market (MtCO2)
cbcdf_rggi(t)                   Definition of cumulative banked credits for RGGI market (MtCO2)

* Elecrtic sector non-CO2 constraints (CSAPR)
csapr_r(trdprg,pol,r,t)         CSAPR policy constraint on annual and seasonal NOx and SO2 by region and trading program (Mt)
csapr_trdprg(trdprg,t)          CSAPR policy trading program market equation (Mt)
itnbc_csapr(trdprg)             Intertemporal budget constraint on net banked NOx and SO2 credits for CSAPR annual markets (Mt)
cbcdf_csapr(trdprg,t)           Definition of cumulative banked credits for CSAPR annual NOx and SO2 markets (Mt)

* Qualified clean generation targets
zercmkt_45v(s,r,t)              Zero emissions resource credit (ZERC) market for 45V-qualified sources for hydrogen production (hourly) (TWh)
zercmkt_ann45v(r,t)             Annually-cleared ZERC market for 45V-qualified sources for hydrogen production (TWh)
zercmkt_annusa45v(t)            Annually-cleared national ZERC market for 45V-qualified sources for hydrogen production (TWh)
zercmkt_cfe(s,r,t)              Hourly voluntary CFE ZERC market (TWh)
zercmkt_anncfe(r,t)             Annually-cleared voluntary CFE ZERC market (TWh)
zercmkt_usacfe(s,t)             Hourly national ZERC market for voluntary CFE (TWh)
cfe_nz(t)                       Constraint on carbon emissions for voluntary CFE market (MtCO2)
hourly_zerc(s,i,v,f,r,t)        Supply of hourly ZERCs (TWh)
hourly_zerc_sum45v(i,v,f,r,t)   Annual sum of hourly ZERCs for 45V compliance (TWh)
hourly_zerc_sumcfe(i,v,f,r,t)   Annual sum of hourly ZERCs for voluntary CFE procurement (TWh)
annual_zerc(i,v,f,r,t)          Supply of annual ZERCs (TWh)

* Renewable Portfolio Standards (RPS)
fedrps(t)                       Federal renewable portfolio standard (RPS) constraint (TWh)
fullrps(t)                      Federal RPS forcing generation to be fully renewable (TWh)
fullrps_h(t)                    Federal RPS forcing hydrogen production to be entirely from electrolysis (TBtu)
staterps(r,t)                   State and regional level RPS constraints (TWh)
recmkt(t)                       Unbundled REC market balance for state RPS (TWh)
rpcgen(s,r,t)                   Exportable renewable power cannot exceed simultaneous qualified generation (GW)
rpctrn(s,r,r,t)                 Exportable renewable power cannot exceed simultaneous transmission flow (GW)
rpcflow(r,r,t)                  RECs bundled with RPCs must be supported by exportable renewable power (TWh)
rpsimports(r,t)                 Upper bound on total imported compliance with state RPS (TWh)
rpssolar(r,t)                   Carve-outs for solar PV in state RPS (TWh)
wnosmandate(r,t)                Offshore wind mandate (GW)

* Clean Energy Standards (CES)
cesmkt(r,t)                     Clean Energy Standard credit supply-credit demand balance equation (TWh)
cestrade(t)                     Clean Energy Standard regional (unbundled) credit trading market (TWh)
cestotdef(r,t)                  Definition of system total for CES compliance (i.e. denominator of the CES credit balance equation) (TWh)
cesmkt_h(r,t)		        Clean energy standard applied to hydrogen production (TBtu)
bcegen(s,r,t)                   Exportable clean electricity cannot exceed simultaneous qualified generation (GW)
bcetrn(s,r,r,t)                 Exportable clean electricity cannot exceed simultaneous transmission (GW)
bceflow(r,r,t)                  Bundled CES credits must be supported by exportable clean electricity (TWh)
cesexport(r,t)                  Upper bound on total exported CES compliance instruments (TWh)
sb100ces(t)                     California SB100 clean electricity standard (CES) constraint (TWh)
bcegen_ca(s,r,t)                Exportable clean energy for CA SB100 cannot exceed simultaneous qualified generation (GW)
bcetrn_ca(s,r,t)                Exportable clean energy for CA SB100 cannot exceed simultaneous transmission (GW)
bceflow_ca(r,t)                 Bundled clean energy credits for CA SB100 must be supported by exportable clean electricity (TWh)
uidef_ca(r,t)                   Definition of unspecified imports for California SB100 (TWh)

* Nuclear policy incentives
nucst(r,t)                      State nuclear support constraint (GW)
nuc_iija45u(r,t)                Existing nuclear subsidy support from IIJA and IRA (45U) (GW)
nuc_nzlo(r,t)                   Lower bound on existing nuclear capacity for utilities with net-zero target (GW)


* Equations relating to operating reserves
srav(s,i,v,r,t)                 Ensure spinning reserve is only available when unit is generating (GW)
srreqt(s,r,t)                   Spinning reserve market (GW)
spinreqdef(s,r,t)               Definition of spinning reserve requirement (GW)
qsreqdef(s,r,t)                 Definition of quickstart reserve requirement (GW)
qsreqt(s,r,t)                   Quickstart reserve market (GW)
srramp(s,i,v,r,t)               Limit on amount of spinning reserve capacity some units can provide (GW)
stordef(s,j,r,t)                Storage definition mutually exclusive provision of services (GW)

* Non-electric fuel balances and blending constraints
fuelbal(f,r,t)                  Non-electric fuel market balance (TBtu)
fuelbal_blend(dst,f,r,t)        Blended non-electric fuel market balance by destination (TBtu)
blend_tot(dst,f,r,t)            Blend constituents sum to total delivery of blend for non-electric fuels  (TBtu)
blend_max(f,dst,f,r,t)          Limit on blend share by destination for non-electric fuels (TBtu)
blend_h2(dst,r,t)               Limit on hydrogen blend share in pipeline gas (sum across hydrogen pathways) (TBtu)
blend_mgs(dst,t)                Lower bound blend limit for ethanol and renewable gasoline motor gasoline (TBtu)
blend_eleppgu(r,t)              Lower bound on non-fossil gas covering uncaptured gas use in electric sector (TBtu)
fueltrade(f,t)			Domestic and international net export balance constraint for non-electric fuels (TBtu)
buildings_fe(f,r,t)		Annual final energy in buildings sectors (TBtu)
industry_fe(f,r,t)		Annual final energy in industrial sectors (TBtu)
transport_fe(f,r,t)		Annual final energy in transportation sectors (TBtu)

* Non-electric fuels transformation sector constraints
capacity_trf(fi,v,r,t)          Capacity constraint on annual fuel transformation sector production (TBtu)
invest_trf(fi,v,r,t)		Accumulation of annual investment in fuel transformation production capacity (BBtu per hour)
retire_trf(fi,v,r,t)		Retirement (monotoncity) constraint on fuel transformation sector production capacity (BBtu per hour)
convbalance_trf(fi,v,r,t)       Disposition of convertible fuel transformation capacity (BBtu per hour)
retiremon_trf(fi,v,r,t)         Monotonicity of cumulative retirement of convertible fuel transformation capacity (BBtu per hour)
retirelife_trf(fi,v,r,t)        Cumulative retirement of existing fuel transformation capacity subject to lifetime (BBtu per hour)
convert1_trf(fi,v,r,t)          New conversions must decrease base fuel transformation capacity (BBtu per hour)
supply_trf(f,r,t)               Annual supply of fuel transformation sector output (TBtu)
inputs_trf(f,f,r,t)             Annual energy and feedstock inputs to fuel transformation sector production (TBtu)
ups_inputs(f,r,t)               Energy inputs into upstream fuel production (TBtu)
* Electrolytic hydrogen and E-fuels constraints
hcapacity(s,fi,v,r,t)           Capacity constraint on segment-level e-hydrogen e-fuel production (BBtu per hour)
hproddef(fi,v,r,t)              Annual total e-hydrogen e-fuel production by technology and vintage (TBtu)
copyhc(s,fi,v,r,t)              Make copies of FC in HCS for e-hydrogen e-fuel (BBtu per hour)
fuelbal_eh(s,f,r,t)             E-Hydrogen market clearing condition (TBtu)
henduse_blend_s(s,r,t)          Regional demand for hydrogen blended into pipeline gas at segment level (BBtu per hour)
segment_blend(f,r,t)		Linking segment level hydrogen blending with annual total blend (TBtu)
inputs_h2efuel(s,f,r,t)	        E-hydrogen inputs to e-fuel production (BBtu per hour)
inputs_eleefuel(s,f,r,t)        Electric inputs to e-fuel production (including e-hydrogen) (BBtu per hour)
carbon_syn(r,t)			Carbon inputs to synthetic fuel production (MtCO2)
hthermal(s,v,r,t)               Thermal input to HTSE production (BBtu per hour)

* Bioenergy feedstocks
bfs_balance(bfs,r,t)		Supply demand balance for bioenergy feedstocks (TBtu)
bfsinputs_bfl(fi,r,t)		Bioenergy feedstock inputs to biofuel production (TBtu)
nreinputs_bfs(vc,r,t)           Non-road energy service demand inputs to biofeedstock production (millions of vehicle-eq)

* Hydrogen infrastructure
tcapacity_h(s,r,r,t)            Hydrogen transmission capacity constraint (BBtu per hour)
tinvest_h(r,r,t)                Accumulation of annual hydrogen transmission capacity investment flows (BBtu per hour)
ginvestc_h(hk,r,t)              Investment in hydrogen storage charge capacity (BBtu per hour)
ginvestr_h(hk,r,t)              Investment in hydrogen storage reservoir capacity (BBtu)
chargelim_h(s,hk,r,t)           Capacity constraint on hydrogen storage charge capacity (BBtu per hour)
dischargelim_h(s,hk,r,t)        Capacity constraint on hydrogen storage discharge capacity (BBtu per hour)
netcharge_h(s,hk,f,r,t)         Net charge of hydrogen storage (BBtu per hour)
storagebal_ann_h(hk,f,r,t)      Annual hydrogen storage balance constraint (BBtu)
storagebal_h(s,hk,r,t)          Dynamic hydrogen storage balance constraint (BBtu)
storagelim_h(s,hk,r,t)          Capacity constraint on hydrogen storage reservoir capacity (BBtu)
storageratio_h(hk,r,t)          Size of room relative to size of door for hydrogen storage (option to fix) (BBtu)
einputs_h2i(s,r,t)              Segment level electricity inputs to hydrogen storage and transmission (GW)

* Direct air capture
daccapacity(dac,v,r,t)          Utilization of non-electric DAC must not exceed installed capacity (annual) (MtCO2 per year)
edaccapacity(s,dac,v,r,t)       Utilization of electric-only DAC must not exceed installed capacity (segment level) (thousand tCO2 per hour)
annualdac(dac,v,r,t)            Annual total net CO2 removal from electric-only DAC (MtCO2 per year)
dacinvest(dac,v,r,t)            Accumulation of DAC capacity investment (MtCO2 per year)
dacretire(dac,v,r,t)            Monotonicity constraint on installed DAC capacity (MtCO2 per year)
inputs_dac(f,r,t)		Non-electric fuel inputs into DAC (TBtu)
einputs_dac(s,r,t)		Segment-level electricity inputs into DAC (GW)

* CO2 Storage and Transport
co2balance(r,t)                 Balancing constraint on CO2 sources and sinks in each region (MtCO2)
co2storcap(cstorclass,r)        Constraint on CO2 storage in each region and class (MtCO2)
co2pinvest(r,r,t)               Accumulation of CO2 pipeline capacity investment (MtCO2 per year added between t-1 and t)
co2pcapacity(r,r,t)             CO2 pipeline capacity constraint (MtCO2 per year)
co2injinvest(cstorclass,r,t)    Accumulation of CO2 injection capacity investment (MtCO2 per year added between t-1 and t)
co2injcapacity(cstorclass,r,t)  CO2 injection capacity constraint (MtCO2 per year)
co2_inputs(f,r,t)               Fuel demands for CO2 transport and storage (TBtu)

* End-use sectors
allocation_vdi(vc,di,r,t)	Allocation of vehicles to driving intensity classes for MD-HD (millions)
allocation_xv(vc,vht,v_e,r,t)	Total vehicle balance for MD-HD (millions)
market_nnrd(vc,r,t)		Allocation of non-road services (millions of vehicle-eq)
lifetime_new(vc,vht,v_e,r,t)	Lifetime constraint on new vintages for MD-HD and non-road vehicles (millions)
retire_eu(vc,vht,v_e,r,t)	Retirement monotonicity for MD-HD and non-road vehicles (millions)
changerate(vc,vht,r,t)	        Rate of change for alternative vehicle sales for MD-HD and non-road vehicles (millions)
fueluse_eu(kf,f,r,t)            Fuel use for MD-HD and non-road vehicles (TBtu)
elecuse_eu(s,r,t)               Segment-level electricity use for MD-HD and non-road (GW)
flexload_twh(flx,r,t)           Flexible load must meet annual target (TWh)
flexload_gw(s,flx,r,t)          Flexible load must not exceed capacity (GW)
copycflx(s,flx,r,t)             Make copies of flexible demand capacity to aid solver (GW)
dc_demand(s,r,t)                Total data center electric load by segment (GW)
cfe_demand(s,r,t)               Total electricity load by segment subject to voluntary CFE procurement (GW)

* Emissions balances
co2emit_ele(r,t)                Electric sector emissions definition (MtCO2)
co2emit_ups(r,t)                Upstream sectors emissions definition (MtCO2)
co2capt_ups(f,r,t)              CO2 captured in upstream sectors (MtCO2)
co2emit_trf(r,t)                Fuel transformation sectors emissions definition (MtCO2)
co2emit_dac(r,t)                Direct air capture net removal (MtCO2)
co2natlim(ncr,t)                Supply of natural CO2 removal (MtCO2)
buildings_co2(r,t)		Definition of direct buildings CO2 emissions (MtCO2)
industry_co2(r,t)		Definition of direct industry CO2 emissions (MtCO2)
transport_co2(r,t)		Definition of direct transport CO2 emissions (MtCO2)

emissions_co2(r,t)		Definition of economy-wide CO2 emissions (MtCO2)
emissions_ch4(r,t)		Definition of energy-related CH4 emissions (MtCO2)
emissions_co2e(r,t)		Definition of economy-wide CO2-eq emissions (MtCO2)
ustotal_co2(t)                  Definition of US total CO2 emissions (MtCO2)
ustotal_co2e(t)                 Definition of US total CO2-eq emissions (MtCO2-eq)

* Economy-wide and national CO2 constraints
carbonmarket(t)                 Policy constraint on economy-wide carbon emissions (MtCO2)
carboneqmarket(t)               Policy constraint on economy-wide carbon equivalent emissions (MtCO2-eq)
carbonmarket_rg(r,t)            Policy constraint(s) on economy-wide carbon emissions for individual regions (MtCO2)
carbonmarket_ele(t)             Policy constraint(s) on carbon emissions for electric sector only (MtCO2) (MtCO2-eq)
itnbc                           Intertemporal budget constraint on net banked credits for economy-wide CO2 cap (MtCO2)
itnbceq                         Intertemporal budget constraint on net banked credits for economy-wide CO2-eq cap (MtCO2-eq)
itnbc_rg(r)                     Intertemporal budget constraint on net banked credits for regional CO2 cap (MtCO2)
itnbc_ele                       Intertemporal budget constraint on net banked credits for electric sector CO2 cap (MtCO2)
cbcdf(t)                        Definition of cumulative banked credits for economy-wide CO2 cap (MtCO2)
cbcdfeq(t)                      Definition of cumulative banked credits for economy-wide CO2-eq cap (MtCO2-eq)
cbcdf_rg(r,t)                   Definition of cumulative banked credits for regional cap (MtCO2)
cbcdf_ele(t)                    Definition of cumulative banked credits for electric sector cap (MtCO2)
;

objdef..
*       Objective function is total (going-forward) costs
                Z =e= sum(t, dfact(t) *
        (sum(r,
* *     Capital costs for new investment
*       Capital cost of electric generation capacity
                sum((new(i),ir(i,r)), IX(i,r,t) * cappr_i(i,r,t) * sum(tv(t,v)$ivrt(i,v,r,t), (capcost(i,v,r) + co2pcap("%co2trscn%",i,v,r) + tcostadder("%tdc%",i) - itcval(i,v,r)))) +
                sum((conv(i),vv), IX_C(i,vv,r,t) * cappr_c(i,vv,r,t) * sum(tv(t,v)$civrt(i,vv,v,r,t), (capcost(i,v,r) + co2pcap("%co2trscn%",i,v,r) + tcostadder("%tdc%",i) - itcval(i,v,r)))) 
*       Capital cost of electric transmission capacity
              + sum(rr$tcapcost(r,rr), IT(r,rr,t) * cappr_inf(r,t) * tcapcost(r,rr))
*       Capital cost of CO2 pipeline capacity
              + sum(rr$capcost_pc("%co2trscn%",r,rr), IP(r,rr,t) * cappr_inf(r,t) * capcost_pc("%co2trscn%",r,rr))
*       Capital cost of CO2 injection capacity
              + sum(cstorclass, IINJ(cstorclass,r,t) * cappr_inf(r,t) * capcost_inj("%cstorscen%",cstorclass,r))
*	Capital cost of direct air capture capacity
	      + sum(dac, IDAC(dac,r,t) * cappr_dac(dac,r,t) * sum(tv(t,v), capcost_dac("%dacscn%",dac,v) + co2pcap_dac("%co2trscn%",dac,v)))
*	Capital cost of fuel transformation sector production/conversion capacity
	+ sum(fi, IFC(fi,r,t) * cappr_trf(fi,r,t) * sum(tv(t,v), capcost_trf(fi,v) + co2pcap_trf("%co2trscn%",fi,v))) 
*       Capital cost of hydrogen transmission capacity
$ifi not %h2trans%==no  + sum(rr$tcapcost_h(r,rr), IT_H(r,rr,t) * cappr_inf(r,t) * tcapcost_h(r,rr))
*	Capital cost of hydrogen door storage capacity
$ifi not %hstorage%==no	+ sum(hk, IGC_H(hk,r,t) * cappr_hg(hk,r,t) * capcost_gch(hk))
*	Capital cost of hydrogen storage reservoir (room) cost
$ifi not %storage%==no  + sum(hk, IGR_H(hk,r,t) * cappr_hg(hk,r,t) * capcost_grh(hk))
*	Capital cost of total period investment in electricity storage cost (door and room)
$ifi not %storage%==no  + sum(j, cappr_g(j,r,t) * (IGC(j,r,t) * capcost_gc("%stortlc%",j,t) + IGR(j,r,t) * capcost_gr("%stortlc%",j,t)) * (1 - sum(tv(t,v), itc_j(j,v))))
*       Capital cost of storage thermal capacity for CSP
$ifi not %cspstorage%==no + sum(cspi(i), GR_CSP(i,r,t) * cappr_i(i,r,t) * irg_csp(i))
*       Capital cost of CSP receiver/collector
$ifi not %cspstorage%==no + sum(cspi(i), C_CSP_CR(i,r,t) * cappr_i(i,r,t) * ic_csp_cr(i))
* *     Exogenously specified variable costs
*       Variable costs include:  non-energy O&M, fuel price adjustments, production or capture subsidies
*       Variable costs exclude:  purchases from endogenous fuel and carbon markets
*       Variable cost for electric generation
              + sum(ivfrt(strd(i),v,f,r,t), icost(i,v,f,r,t) * XTWH(i,v,f,r,t))
              + sum(civfrt(conv(i),vv,v,f,r,t), icost_c(i,vv,v,f,r,t) * XTWH_C(i,vv,v,f,r,t))
*       Variable cost for electricity storage (CAES only)
$ifi not %storage%==no + 1e-3 * sum(j, vcg(j,r,t) * sum(s, GD(s,j,r,t) * hours(s,t)))
*	Variable costs of fuel transformation sector production/conversion
              + sum(fivrt(fi,v,r,t), FX(fi,v,r,t) * fcost(fi,v,r,t))
*       Variable cost for CO2 injection
              + vcost_inj(r) * sum(cstorclass, CSTOR(cstorclass,r,t))
*	Variable cost for direct air capture
	      + sum((dac,vt(v,t)), daccost(dac,v,r,t) * DACANN(dac,v,r,t))
* *     Fixed maintenance costs
*       Fixed maintenance cost for electric generation capacity (including CO2 pipeline FOM for CCS)
              + sum(ivrt(i,v,r,t), XC(i,v,r,t) * (fomcost(i,r) + co2pfom("%co2trscn%",i,r)))
              + sum(civrt(i,vv,v,r,t), XC_C(i,vv,v,r,t) * (fomcost(i,r) + co2pfom("%co2trscn%",i,r)))
*       Fixed maintenance cost for electricity storage capacity
$ifi not %storage%==no + sum(j, fomcost_g(j,t) * GC(j,r,t))
*       Fixed maintenance cost for CSP collector + receiver (power block cost included in fomcost)
$ifi not %cspstorage%==no  + sum(cspi, fc_csp_cr * C_CSP_CR(cspi,r,r))
*	Fixed maintenance costs for fuel transformation sector production/conversion capacity
*       (including CO2 pipeline FOM for CCS and elec T&D for distributed electrolysis)
              + sum((fi,vt(v,t)), FC(fi,v,r,t) * (fomcost_trf(fi,v) + co2pfom_trf("%co2trscn%",fi,v) + tdcost_h(fi,v)))
*       Fixed maintenance cost for hydrogen transmission capacity
$ifi not %h2trans%==no     + sum(rr$tcapcost_h(r,rr), TC_H(r,rr,t) * tfomcost_h(r,rr))
*       Fixed maintenance cost for CO2 pipeline capacity
              + sum(rr$capcost_pc("%co2trscn%",r,rr), PC(r,rr,t) * fomcost_pc("%co2trscn%",r,rr))
*       Fixed maintenance cost for CO2 injection capacity
              + sum(cstorclass, INJC(cstorclass,r,t) * fomcost_inj("%cstorscen%",cstorclass,r))
*	Fixed maintenance cost for direct air capture
	      + sum((dac,vt(v,t)), DACC(dac,v,r,t) * (fomcost_dac("%dacscn%",dac,v) + co2pfom_dac("%co2trscn%",dac,v)))
* *     External fuel markets
*	Fossil fuels
	      + sum(fos(f), QSF(f,r,t) * pf_ups(f,r,t))
*	Bio feedstocks
	      + sum((bfs,bfsc), QS_BFS(bfs,bfsc,r,t) * biocost(bfsc))
* *     Policy costs
*	Carbon tax (could potentially be specified on a regional, sectoral basis, or a single tax could be applied uniformly)
              + CO2_ELE(r,t) * ctax_kr("ele",r,t)
	      + CO2_UPS(r,t) * ctax_kr("ups",r,t)
	      + CO2_BLD(r,t) * ctax_kr("bld",r,t)
	      + CO2_IND(r,t) * ctax_kr("ind",r,t)
	      + CO2_TRN(r,t) * ctax_kr("trn",r,t)
	      + CO2_TRF(r,t) * ctax_kr("trf",r,t)
              - CO2_DAC(r,t) * ctax_kr("dac",r,t)
*       CO2 tax associated with unspecified imports for CA SB100
$ifi %CA_SB100%==yes + UI_CA(r,t) * sb100impcost(t)
*       Tax applied to energy-related methane emissions
              + CH4_EMIT(r,t) * ch4tax(r,t)
*	Natural CDR options
              + sum(ncr, CO2_NAT(ncr,r,t) * ncrcost(ncr))
*       Alternative compliance payments for state RPS
              + ACP(r,t) * acpcost(r)
*       Alternative compliance payments for CES
$ifi not %cesacp%==no  + CES_ACP(r,t) * cesacpr(t,"%ces%")

*       Cost of providing operating reserves
$ifi not %opres%==no + sum(s, sum((i,v), (SR(s,i,v,r,t) * sum(idef(i,type), orcost(type))) + sum(j, orcostg(j) * SRJ(s,j,r,t))) * hours(s,t) * 1e-3)
*       Cost of demand response
$ifi not %bs%==no    + sum(s, DR(s,r,t) * drcost(r) * hours(s,t) * 1e-3)
*       Cost of distributed resource curtailment
              + sum(s, DRC(s,r,t) * drccost(r) * hours(s,t) * 1e-3)
* *     Variable T&D costs
*       Transaction cost for inter-region electric transmission flows
              + sum((s,rr)$tcapcost(r,rr), E(s,r,rr,t) * tcost(r,rr) * hours(s,t) * 1e-3)
*	Distribution cost for hydrogen to non-electric uses (depends on central vs forecourt production)
	      + sum((hkf(hk,f),sameas(dst,kf)), hdcost(hk,kf) * QD_BLEND(f,dst,"h2",r,t))
	      + sum(hkf("cnt",f), hdcost_trf * (QD_BLEND(f,"ups","h2",r,t) + sum(ff, QD_TRF(f,ff,r,t)) + sum(dst, QD_BLEND(f,dst,"ppg",r,t))))
* *     End-use sectors (if endogenous)
$ifthen not %eeusolve%==no
*	New purchases (MD/HD and non-road vehicles, parameter and variable units are scaled differently)
              + 1e3 * sum((vc_mdhd(vc),vht), cappr_eu(vc,r,t) * IV(vc,vht,r,t) * newcap_cost(vc,vht,r,t))
              +       sum((vc_nnrd(vc),vht), cappr_eu(vc,r,t) * IV(vc,vht,r,t) * newcap_cost(vc,vht,r,t))
*	Operating costs (MD/HD vehicles and non-road vehicles)
              + 1e3 * sum((di,vcht(vc_mdhd(vc),vht,v_e,t)), VDI(vc,vht,v_e,di,r,t) * annual_cost_mdhd(vc,vht,v_e,di,r,t))
              +       sum(vcht(vc_nnrd(vc),vht,v_e,t), XV(vc,vht,v_e,r,t) * annual_cost_nnrd(vc,vht,v_e,r,t))
$endif
* *     Flexible demand (if endogenous)
$ifthen not %flexload%==no
*       Cost of flexible demand capacity rental (over exogenous endowment) in $ per kW-year or $M per GW-year
              + sum(flx, caprent_flx(flx) * C_FLX(flx,r,t))
$endif
        )  !! end regional sum
* *     Other policy costs      
*       Safety valve allowance purchases for federal cap or intensity standard
$ifi not %svpr%==no  + (SV(t) + SV_EQ(t) + SV_ELE(t)) * svpr(t,"%svpr%")
        ))
;

* The electricity market clearing equation sets grid-based generation equal to grid-based energy for load in each segment
elebal(s,r,t)..
*       Scale from GW to TWh so that marginal value is denominated in $ per MWh (discounted)
        1e-3 * hours(s,t) * (
*       Dispatched generation in region
                sum(ivfrt(strd(i),v,f,r,t), X(s,i,v,f,r,t)) + sum(civfrt(conv(i),vv,v,f,r,t), X_C(s,i,vv,v,f,r,t))
*       Plus inter-region imports
              + sum(rr$tcapcost(rr,r), E(s,rr,r,t))
*       Less inter-region exports (including loss penalty)
              - sum(rr$tcapcost(r,rr), trnspen(r,rr) * E(s,r,rr,t))
*       Less net international exports (fixed annual TWh scaled uniformly to segment level GW)
              - (ntxintl(r) / 8.76)
*       Plus discharges from storage less charges (including penalty) (include 45V-associated storage after subsidy period)
$ifi not %storage%==no  + sum(j$(not sameas(j,"li-ion-45v")), GD(s,j,r,t) - chrgpen(j) * G(s,j,r,t))
$ifi not %storage%==no  + sum(j$(sameas(j,"li-ion-45v") and t.val > 2040 and %elys45v%), GD(s,j,r,t) - chrgpen(j) * G(s,j,r,t))
*       Less fixed net charge of existing pumped storage (if exogenous, otherwise this term is zero)
              - hyps(s,r,t)
*       Components of electricity load associated with other energy system activities (assumed to be connected to the bulk system)
*       Less electricity consumed for e-fuel production
	      - sum(ef(f)$(not sameas(f,"h2-de")), (1/3.412) * QD_TRF_S(s,"ele",f,r,t))
*	Less electricity consumed for other non-electric fuels production
              - sum(trf(f)$(not ef(f)), (1/3.412) * QD_TRF("ele",f,r,t)) / 8.76
*	Less electricity consumed for DAC (including flexible segment-level dispatch of e-DAC)
              - QD_DAC_S(s,r,t)
*	Less electricity consumed for upstream fossil production (annual TBtu scaled uniformly to segment level GW)
              - (1/3.412) * QD_UPS("ele",r,t) / 8.76
*	Less electricity consumed for (central-scale) hydrogen storage injection and inter-region transmission (export) of hydrogen
	      - QD_H2I_S(s,r,t)
*	Less electricity consumed for CO2 transport and storage
              - (1/3.412) * QD_CO2("ele",r,t) / 8.76
        )
*       Equals total local grid-supplied energy for end-use load
            =e= 1e-3 * hours(s,t) * GRID(s,r,t)
;

* Disposition of electricity supply to end-use demand
enduseload(s,r,t)..
*       Scale from GW to TWh so that marginal value is denominated in $ per MWh (discounted)
*       Grid-supplied energy minus local T&D losses plus net supply from distributed resources plus demand response equals
        1e-3 * hours(s,t) * (GRID(s,r,t) / localloss + netder(s,r,t) - DRC(s,r,t) + DR(s,r,t))
*       Total end-use consumption
         =e= 1e-3 * hours(s,t) * (load(s,r,t)
*       Plus flexibly allocated load
              + sum(flx, QD_FLX_S(s,flx,r,t))
*	Plus electricity consumed in endogenous end-use sectors (exogenous component has been subtracted from load parameter)
              + QD_EEU_S(s,r,t)
*       Plus electricity consumed for distributed electrolysis hydrogen production and storage (convert billion btu per hour to GW)
              + (1/3.412) * QD_TRF_S(s,"ele","h2-de",r,t)
	      + sum(hkf("frc",f), (1/3.412) * epchrg_h("frc",t) * G_H(s,"frc",f,r,t))
);

* Flexible load (e.g. data centers) must sum to total annual target, subject to a segment level peak capacity (which could be endogenous on the margin)
flexload_twh(flx,r,t).. sum(s, hours(s,t) * QD_FLX_S(s,flx,r,t)) =e= flex_twh(flx,r,t);

flexload_gw(s,flx,r,t).. QD_FLX_S(s,flx,r,t) =l= flex_gw(flx,r,t) + CXS_FLX(s,flx,r,t);

* Translate capacity variable to a "copy" indexed by segment to aid solver
copycflx(s,flx,r,t).. CXS_FLX(s,flx,r,t) =e= C_FLX(flx,r,t)$(ord(s) eq 1) + CXS_FLX(s-1,flx,r,t)$(ord(s) > 1);

* Planning reserve margin requirement (secondary capacity constraint in peak segment)
* "Define" PKGRID as peak residual load:
* When this equation is binding, PKGRID on the LHS is equal to the peak (over segments) of the
* RHS expression, which equals residual load net of dynamic contribution of renewables and storage
peakgrid(s,r,t).. PKGRID(r,t) =g= GRID(s,r,t) - sum(ivfrt(irnw(i),v,f,r,t), X(s,i,v,f,r,t))
*	Pumped hydro discharge (minus negative of charge)
					      + hyps(s,r,t)
*	Net discharge from other storage technologies if included
$ifi not %storage%==no                        - sum(j, GD(s,j,r,t) - chrgpen(j) * G(s,j,r,t))
*	Electricity for e-fuel production and hydrogen injection/transmission (central scale) (will likely be zero in binding peak hour)
	                                      + sum(ef(f)$(not sameas(f,"h2-de")), (1/3.412) * QD_TRF_S(s,"ele",f,r,t))
                                              + QD_H2I_S(s,r,t)
*	Electricity for flexible DAC operation (will likely be zero in binding peak hour)
					      + QD_DAC_S(s,r,t)
*       Electricity for fuel transformation sectors demand (not flexible)
                                              + sum(trf(f)$(not ef(f)), (1/3.412) * QD_TRF("ele",f,r,t)) / 8.76
                                              + (1/3.412) * QD_UPS("ele",r,t) / 8.76
;

* "Define" RMARG as absolute value of required planning reserve margin:
* When this equation is binding, RMARG on the LHS is equal to the required margin on the peak (over segments) of
* total grid-supplied load on the RHS
resmargin(s,r,t).. RMARG(r,t) =g= rsvmarg(r) * GRID(s,r,t);

* Planning reserve constraint:  sum of firm capacity from non-renewables must be greater than or equal to peak residual load plus required reserve margin
reserve(r,t)$(t.val > 2015)..
        sum(ivrt(i,v,r,t), XC(i,v,r,t) * rsvcc(i,r)) + sum(civrt(i,vv,v,r,t), XC_C(i,vv,v,r,t) * rsvcc(i,r))  + rsvoth(r)
                     =g= RMARG(r,t) + PKGRID(r,t);

* Structural equations to aid solver
* Define annual sum of segment-level energy variables
xtwhdef(ivfrt(i,v,f,r,t))..  XTWH(i,v,f,r,t) =e= 1e-3 * sum(s, X(s,i,v,f,r,t) * hours(s,t));

xtwhdef_c(civfrt(i,vv,v,f,r,t))..  XTWH_C(i,vv,v,f,r,t) =e= 1e-3 * sum(s, X_C(s,i,vv,v,f,r,t) * hours(s,t));

gridtwhdef(r,t).. GRIDTWH(r,t) =e= 1e-3 * sum(s, GRID(s,r,t) * hours(s,t));

* Translate capacity variables to corresponding "copies" indexed by segment to aid solver
copyxc(s,ivrt(i,v,r,t))..  XCS(s,i,v,r,t) =e= XC(i,v,r,t)$(ord(s) eq 1) + XCS(s-1,i,v,r,t)$(ord(s) > 1);

copyxc_c(s,civrt(i,vv,v,r,t))..  XCS_C(s,i,vv,v,r,t) =e= XC_C(i,vv,v,r,t)$(ord(s) eq 1) + XCS_C(s-1,i,vv,v,r,t)$(ord(s) > 1);

* Investment flows in electric generation capacity accumulate as new vintage capacity
invest(new(i),newv(v),r,t)$(ir(i,r) and tv(t,v))..
        XC(i,v,r,t) =e= IX(i,r,t)
*       Allow accumulation of 2050+ capacity
                        + XC(i,v,r,t-1)$(sameas(v,"2050+") and tyr(t) > 2050);

* Endogenous rental investment of electric generation capacity in static mode
investstatic(i_end(i),newv(v),r,t)$(ir(i,r) and tv(t,v))..
        XC(i,v,r,t) =e= IX(i,r,t);

* Conversion flows for electric generation capacity accumulate as new vintage capacity (no conversions allowed to 2050+ vintage)
invest_c(conv(i),vv,newv(v),r,t)$(tv(t,v) and vyr(v) > vyr(vv))..
        XC_C(i,vv,v,r,t) =e= IX_C(i,vv,r,t);

* Nominal capacity is de-rated to determine availability constraint on potential dispatch.

* Dispatch of electric generation technologies cannot exceed available capacity
capacity(s,ivrt(strd(i),v,r,t))$dspt(i)..
* Dispatch decision can be allocated across eligible fuel types (single fuel for most technologies)
        sum(ivfrt(i,v,f,r,t), X(s,i,v,f,r,t))
* Switch to include dispatch of thermal energy for eligible technologies
$ifi not %htse%==no    + sum(ivfrt(i,v,f,r,t)$tsi(i), XT(s,i,v,f,r,t) / htrate_m(i,v,r))
* Switch to include capacity claims for spinning reserve and quickstart
$ifi not %opres%==no   + SR(s,i,v,r,t)$sri(i) + QS(s,i,v,r,t)$qsi(i)
        =l=  XCS(s,i,v,r,t) * af(s,i,v,r,t)

*        =l=  XCS(s,i,v,r,t) * (1 + (af(s,i,v,r,t)-1)$af(s,i,v,r,t)) *
*                              (1 + (af_t(i,v,r,t)-1)$af_t(i,v,r,t)) *
*                              (1 + (vrsc_t(i,r,t)-1)$vrsc_t(i,r,t))
;

* Dispatch of converted electric generation capacity (with additional index over original vintage vv) cannot exceed available capacity
capacity_c(s,civrt(conv(i),vv,v,r,t))$dspt(i)..
* Dispatch decision can be allocated across eligible fuel types (single fuel for most technologies)
        sum(civfrt(i,vv,v,f,r,t), X_C(s,i,vv,v,f,r,t))
* Switch to include dispatch of thermal energy for eligible technologies
$ifi not %htse%==no    + sum(ivfrt(i,v,f,r,t)$tsi(i), XT_C(s,i,vv,v,f,r,t) / htrate_m(i,v,r))
* Switch to include capacity claims for spinning reserve and quickstart
$ifi not %opres%==no   + SR_C(s,i,vv,v,r,t)$sri(i) + QS_C(s,i,vv,v,r,t)$qsi(i)
        =l=  XCS_C(s,i,vv,v,r,t) * af(s,i,v,r,t)

*        =l=  XCS_C(s,i,vv,v,r,t) * (1 + (af(s,i,v,r,t)-1)$af(s,i,v,r,t)) *
*                                   (1 + (af_t(i,v,r,t)-1)$af_t(i,v,r,t)) *
*                                   (1 + (vrsc_t(i,r,t)-1)$vrsc_t(i,r,t))
;

* Some electric generation capacity has a minimum dispatch factor (i.e. limited flexibility)
capacitymin(s,ivrt(strd(i),v,r,t))$dismin(i,t)..
        sum(ivfrt(i,v,f,r,t), X(s,i,v,f,r,t))
$ifi not %htse%==no    + sum(ivfrt(i,v,f,r,t)$tsi(i), XT(s,i,v,f,r,t) / htrate_m(i,v,r))
        =g=  XCS(s,i,v,r,t) * af(s,i,v,r,t)

*        =g=  XCS(s,i,v,r,t) * (1 + (af(s,i,v,r,t)-1)$af(s,i,v,r,t)) *
*                              (1 + (af_t(i,v,r,t)-1)$af_t(i,v,r,t)) *
*                              (1 + (vrsc_t(i,r,t)-1)$vrsc_t(i,r,t))
                            * dismin(i,t)
;

* Some converted electric generation capacity (with additional index over original vintage vv) has a minimum dispatch factor (i.e. limited flexibility)
capacitymin_c(s,civrt(conv(i),vv,v,r,t))$dismin(i,t)..
        sum(civfrt(i,vv,v,f,r,t), X_C(s,i,vv,v,f,r,t))
$ifi not %htse%==no    + sum(ivfrt(i,v,f,r,t)$tsi(i), XT_C(s,i,vv,v,f,r,t) / htrate_m(i,v,r))
        =g=  XCS_C(s,i,vv,v,r,t) * af(s,i,v,r,t)

*        =g=  XCS_C(s,i,vv,v,r,t) * (1 + (af(s,i,v,r,t)-1)$af(s,i,v,r,t)) *
*                                   (1 + (af_t(i,v,r,t)-1)$af_t(i,v,r,t)) *
*                                   (1 + (vrsc_t(i,r,t)-1)$vrsc_t(i,r,t))
                                   * dismin(i,t)
;

* Some electric generation capacity is "must-run" (i.e. no flexibility)
capacityfx(s,ivrt(strd(i),v,r,t))$ndsp(i)..
        sum(ivfrt(i,v,f,r,t), X(s,i,v,f,r,t))
$ifi not %htse%==no    + sum(ivfrt(i,v,f,r,t)$tsi(i), XT(s,i,v,f,r,t) / htrate_m(i,v,r))
        =e= XCS(s,i,v,r,t) * af(s,i,v,r,t)

*        =e= XCS(s,i,v,r,t) * (1 + (af(s,i,v,r,t)-1)$af(s,i,v,r,t)) *
*                             (1 + (af_t(i,v,r,t)-1)$af_t(i,v,r,t)) *
*                             (1 + (vrsc_t(i,r,t)-1)$vrsc_t(i,r,t))
;

* Some converted electric generation capacity (with additional index over original vintage vv) is "must-run" (i.e. no flexibility)
capacityfx_c(s,civrt(conv(i),vv,v,r,t))$ndsp(i)..
        sum(civfrt(i,vv,v,f,r,t), X_C(s,i,vv,v,f,r,t))
$ifi not %htse%==no    + sum(ivfrt(i,v,f,r,t)$tsi(i), XT_C(s,i,vv,v,f,r,t) / htrate_m(i,v,r))
        =e= XCS_C(s,i,vv,v,r,t) * af(s,i,v,r,t)

*        =e= XCS_C(s,i,vv,v,r,t) * (1 + (af(s,i,v,r,t)-1)$af(s,i,v,r,t)) *
*                                  (1 + (af_t(i,v,r,t)-1)$af_t(i,v,r,t)) *
*                                  (1 + (vrsc_t(i,r,t)-1)$vrsc_t(i,r,t))
;

* Some dual-fuel capacity has limits on share of secondary fuel (e.g. biomass co-firing or hydrogen blending)
fuellim(s,ivfrt(i,v,f,r,t))$(ifuel(i,f) < 1)..
	X(s,i,v,f,r,t)
$ifi not %htse%==no    + (XT(s,i,v,f,r,t) / htrate_m(i,v,r))$tsi(i)
	=l= ifuel(i,f) * (
	sum(ifl(i,ff), X(s,i,v,ff,r,t))
$ifi not %htse%==no    + sum(ifl(i,ff)$tsi(i), XT(s,i,v,ff,r,t) / htrate_m(i,v,r))
	)
;

* Dual-fuel capacity limits for converted capacity (with additional index over original vintage vv)
fuellim_c(s,civfrt(i,vv,v,f,r,t))$(ifuel(i,f) < 1)..
	X_C(s,i,vv,v,f,r,t)
$ifi not %htse%==no    + (XT_C(s,i,vv,v,f,r,t) / htrate_m(i,v,r))$tsi(i)
	=l= ifuel(i,f) * (
	sum(ifl(i,ff), X_C(s,i,vv,v,ff,r,t))
$ifi not %htse%==no    + sum(ifl(i,ff)$tsi(i), XT_C(s,i,vv,v,ff,r,t) / htrate_m(i,v,r))
	)
;

* Thermal output for high-temperature steam electrolysis (HTSE) must not exceed proportional electricity input to HTSE
htseprod(s,ivfrt(tsi(i),v,f,r,t))..
	XT(s,i,v,f,r,t) =l= htse_ratio * X(s,i,v,f,r,t) * 3.412;

* Thermal output for HTSE from converted electric generation capacity
htseprod_c(s,civfrt(conv(i),vv,v,f,r,t))$tsi(i)..
	XT_C(s,i,vv,v,f,r,t) =l= htse_ratio * X_C(s,i,vv,v,f,r,t) * 3.412;

* Fuel demand for electric generation
elecfueldemand(f_ele(f),r,t)..
	QD_ELEC(f,r,t) =e=
	sum(ivfrt(strd(i),v,f,r,t), htrate(i,v,f,r,t) * XTWH(i,v,f,r,t)) +
	sum(civfrt(conv(i),vv,v,f,r,t), htrate_c(i,vv,v,f,r,t) * XTWH_C(i,vv,v,f,r,t))
* Include CAES fuel use
$ifi not %storage%==no	+ sum(j, 1e-3 * htrate_g(j) * sum(s, GD(s,j,r,t) * hours(s,t)))$sameas(f,"ppg")
;

* Uncaptured gas demand for electric generation
elecppgudemand(r,t)..
	QD_ELEC_PPGU(r,t) =e=
	sum(ivfrt(strd(i),v,"ppg",r,t)$(not ccs(i)), htrate(i,v,"ppg",r,t) * XTWH(i,v,"ppg",r,t)) +
	sum(civfrt(conv(i),vv,v,"ppg",r,t)$(not ccs(i)), htrate_c(i,vv,v,"ppg",r,t) * XTWH_C(i,vv,v,"ppg",r,t))
* Include CAES fuel use
$ifi not %storage%==no	+ sum(j, 1e-3 * htrate_g(j) * sum(s, GD(s,j,r,t) * hours(s,t)))
;

* Limit on annual capacity factor for certain electric generation technologies
cflim(ivrt(strd(i),v,r,t))$cf_y(i,r)..
       sum(ivfrt(i,v,f,r,t), XTWH(i,v,f,r,t)) =l= cf_y(i,r) * XC(i,v,r,t) * 1e-3 * 8760;

* Limit on annual capacity factor for certain converted electric generation technologies
cflim_c(civrt(conv(i),vv,v,r,t))$cf_y(i,r)..
       sum(civfrt(i,vv,v,f,r,t), XTWH_C(i,vv,v,f,r,t)) =l= cf_y(i,r) * XC_C(i,vv,v,r,t) * 1e-3 * 8760;

* Additional constraint limiting liquid fuel use in combined cycle dual fuel units (which are not constrained by cflim)
cflim_dfcc(ivrt(i,v,r,t))$idef(i,"dfcc")..
       sum(ivfrt(i,v,"dsl",r,t), XTWH(i,v,"dsl",r,t)) =l= cf_y("dfgt-n",r) * XC(i,v,r,t) * 1e-3 * 8760;

* 111b NSPS for gas limits capacity factor to 40% for all new vintages (starting with 2025) beginning in 2030 time step
cflim_111b(ivrt(i,v,r,t))$((sameas(i,"ngcc-n") or sameas(i,"nggt-n") or sameas(i,"dfcc-n") or sameas(i,"dfgt-n")) and vyr(v) ge 2025 and t.val ge 2030)..
       sum(ivfrt(i,v,f,r,t), XTWH(i,v,f,r,t)) =l= 0.4 * XC(i,v,r,t) * 1e-3 * 8760;

* Disposition of convertible capacity: original plus conversion (minus penalty) plus retired must equal original installed
convbalance(ivrt(orig(i),vv,r,t))$(t.val > vyr(vv))..
	XC(i,vv,r,t) + sum(civrt(conv,vv,v,r,t)$convmap(conv,i), XC_C(conv,vv,v,r,t) * convadj(conv)) + RC(i,vv,r,t)
                 =e= sum(tv(tt,vv), XC(i,vv,r,tt));

* Cumluative retirements of convertible capacity must be monotonic
retiremon(ivrt(orig(i),v,r,t))$(t.val > vyr(v))..
        RC(i,v,r,t) =g= RC(i,v,r,t-1);

* Cumulative retirements of convertible capacity of existing vintages must be consistent with lifetime
retirelife(ivrt(orig(i),vbase(v),r,t))$(t.val > vyr(v) and xtech(i))..
	RC(i,v,r,t) =g= sum(tbase, XC(i,v,r,tbase)) * (1 - lifetime(i,r,t));

* New conversions must decrease base capacity relative to previous period (to prevent "re-conversion" to a different type)
convert1(ivrt(orig(i),vv,r,t))$(t.val > vyr(vv))..
	XC(i,vv,r,t) =l= XC(i,vv,r,t-1) - sum(convmap(conv,i), IX_C(conv,vv,r,t) * convadj(conv));

* Lower bound on coal-gas conversions based on planned future projects
convgassch(conv(i),r,t)$idef(i,"clng")..
       sum(civrt(i,vbase,v,r,t), XC_C(i,vbase,v,r,t) * convadj(i)) =g= sum(convmap(i,orig), xcap(orig,r) * convertgas(orig,r,t));

* Lower bound on coal-bio conversions based on planned future projects
convbiosch(conv(i),r,t)$idef(i,"bioc")..
       sum(civrt(i,vbase,v,r,t), XC_C(i,vbase,v,r,t) * convadj(i)) =g= sum(convmap(i,orig), xcap(orig,r) * convertbio(orig,r,t));

* Lower bound on installed coal capacity in 2020 based on based on observed national level
coal2020.. sum(ivrt(i,v,r,t)$(sameas(t,"2020") and idef(i,"clcl")), XC(i,v,r,t)) =g= uscoal20_gw;

* Upper bound on total additions of gas to 50 GW per time step in 2020 and 2025
gas2020_25(t)$(sameas(t,"2020") or sameas(t,"2025")).. sum(ir(new(i),r)$(idef(i,"ngcc") or idef(i,"nggt") or idef(i,"dfgt")), IX(i,r,t)) =l= 50;

* Lower bound on new capacity additions based on historical and planned additions (GW)
newunitslo(type,r,t)..
	sum(idef(i,type)$(new(i) and ir(i,r)), IX(i,r,t)) =g= newunits(type,r,t);

* Absolute limits on installed electric generation capacity for certain technologies (e.g. on-shore and off-shore wind resource limits)
capacitylim(strd(i),r,t)$(caplim(i,r) < inf)..
        sum(ivrt(i,v,r,t), XC(i,v,r,t)) =l= caplim(i,r);

* Absolute limits on conversion of existing electric generation capacity
capacitylim_c(conv(i),r,t)$(sum(convmap(i,orig), xtech(orig)) and convlim(i,r) < inf)..
        sum(civrt(i,vbase,v,r,t), XC_C(i,vbase,v,r,t) * convadj(i)) =l= convlim(i,r);

* Joint limit on total solar PV (multiple types) and CSP based on solar resource potential within each region-class
solarlim(class,r,t)$(solarcap(class,r) < inf)..
       sum(ivrt(i,v,r,t)$iclass(i,"pvft",class), XC(i,v,r,t))
       + sum(ivrt(i,v,r,t)$iclass(i,"pvsx",class), XC(i,v,r,t))
       + sum(ivrt(i,v,r,t)$iclass(i,"pvdx",class), XC(i,v,r,t))
       + sum(ivrt(i,v,r,t)$iclass(i,"cspr",class), cspwt * XC(i,v,r,t))
       =l= solarcap(class,r);

* Sum of existing and repowered wind capacity within each region cannot exceed base year capacity
windrepowerlim(r,t)$xcap("wind-x",r)..
         sum(ivrt("wind-x",v,r,t), XC("wind-x",v,r,t))
       + sum(ivrt("wind-r",v,r,t), XC("wind-r",v,r,t))
       =l= xcap("wind-x",r);

* Regional limits on electric generation capacity investment per period based on current pipeline or other regional constraints (by technology type)
investlim(type,r,t)$(invlim(type,r,t) < inf)..
        sum(idef(i,type)$(new(i) and ir(i,r)), IX(i,r,t)) =l= invlim(type,r,t);

* National limit on electric generation capacity investment per period based on historical max build rates or other assumptions (by technology category)
usinvestlim(tech,t)$(usinvlim("%usinvscn%",tech,t) < inf)..
        sum((r,itech(new,tech))$ir(new,r), IX(new,r,t)) =l= usinvlim("%usinvscn%",tech,t);

* Regional limits on inter-regional electricity transmission capacity investment per period based on maximum allowed growth rate from previous period
tinvestlim(r,rr,t)$(tcapcost(r,rr) and tgrow(r,rr) < inf).. IT(r,rr,t) + IT(rr,r,t) =l= tgrow(r,rr) * (tcap(r,rr) + TC(r,rr,t-1));

* In static mode, inter-regional electricity transmission capacity investment/rental is interpreted as cumulative additions from base year
* Apply maximum allowed growth rate accordingly
tinvestlimstatic(r,rr,t)$(tcapcost(r,rr) and tgrow(r,rr) < inf).. IT(r,rr,t) + IT(rr,r,t) =l= ((1 + tgrow(r,rr))**((t.val - 2015) / 5) - 1) * tcap(r,rr);

* National limit on total inter-regional electricity transmission capacity investment per period, denominated in nominal GW-miles
tusinvestlim(t)$(tusinvlim("%tuslimscn%",t) < inf)..
        sum((r,rr), IT(r,rr,t) * tlinelen(r,rr)) =l= tusinvlim("%tuslimscn%",t);

* Installed capacity must be monotonically decreasing (allow exception for exogenous uprates of existing nuclear)
retire(ivrt(i,v,r,t))$(not sameas(v,"2050+"))..
        XC(i,v,r,t+1) =l= XC(i,v,r,t) + NUPR(r,t+1)$sameas(i,"nucl-x");

* Converted capacity must be monotonically decreasing
retire_c(civrt(i,vv,v,r,t))$(not sameas(v,"2050+"))..
        XC_C(i,vv,v,r,t+1) =l= XC_C(i,vv,v,r,t);

* Flows of inter-regional electricity transmission cannot exceed available capacity
tcapacity(s,r,rr,t)$tcapcost(r,rr)..
        E(s,r,rr,t) =l= tcap(r,rr) + TC(r,rr,t)$tcapcost(r,rr);

* Investment flows in electricity transmission capacity accumulate as new vintage capacity
tinvest(r,rr,t)$tcapcost(r,rr)..
        TC(r,rr,t) =e= IT(r,rr,t) + IT(rr,r,t) + TC(r,rr,t-1);

* Endogenous rental investment of incremental electricity transmission capacity in static mode (with installed capacity from dynamic model solve as a fixed endowment if specified)
tinveststatic(r,rr,t)$tcapcost(r,rr)..
        TC(r,rr,t) =e= IT(r,rr,t) + IT(rr,r,t) + tcfx(r,rr,t);

* * CSP Equations (only included in model statement if specified)

* Thermal dispatch of CSP solar collector + receiver cannot exceed available capacity
capacity_csp_cr(s,cspi,r,t).. X_CSP_CR(s,cspi,r,t) =l= dni(s,cspi,r) * C_CSP_CR(cspi,r,t);

* Dispatch of CSP power block comes from either storage discharge or net direct transfer from receiver (after losses)
dispatch_csp(s,cspi,r,t).. sum(vt(v,t), X(s,cspi,v,"rnw",r,t))
            =e= (GD_CSP(s,cspi,r,t) + (X_CSP_CR(s,cspi,r,t) * csp_eff_r - G_CSP(s,cspi,r,t))) * csp_eff_p;

* Dynamic accumulation of thermal storage balance for CSP (note that no charge penalty or roundtrip efficiency loss parameter is included for CSP TES)
storagebal_csp(s,cspi,r,t)..
                 GB_CSP(s,cspi,r,t)
             =e= (1 - csp_loss_g) * (GB_CSP(s-1,cspi,r,t) + GB_CSP("%seg%",cspi,r,t)$(sameas(s,"1"))) + hours(s,t) * (G_CSP(s,cspi,r,t) - GD_CSP(s,cspi,r,t));

* CSP thermal storage blanace cannot exceed thermal storage reservoir capacity
storagelim_csp(s,cspi,r,t)..   GB_CSP(s,cspi,r,t) =l= GR_CSP(cspi,r,t);

* * Electricity storage

* Investment flows in electricity storage power/door capacity accumulate as total installed capacity (not vintaged)
ginvestc(j,r,t)..       GC(j,r,t) =e= IGC(j,r,t) + GC(j,r,t-1);

* Investment flows in electricity storage energy/room capacity accumulate as total installed capacity (including degradation loss factor)
ginvestr(j,r,t)..       GR(j,r,t) =e= IGR(j,r,t) + (1 - loss_d(j)) * GR(j,r,t-1);

* Electricity storage charge must not exceed charge capacity (size of door)
chargelim(s,j,r,t)..    G(s,j,r,t) =l= GC(j,r,t);

* Electricity storage discharge must not exceed discharge capacity (charge and discharge capacity assumed to be equal, both represented by GC variable)
dischargelim(s,j,r,t).. GD(s,j,r,t) =l= GC(j,r,t);

* Annual electricity storage balance constraint:  total charge must equal total discharge (net of penalty)
* Note that this constraint is not needed with 8760 hour resolution, but is needed with PSSM formulation using representative hours
storagebal_ann(j,r,t)..     sum(s, hours(s,t) * G(s,j,r,t)) =e= sum(s, hours(s,t) * GD(s,j,r,t));

* Dynamic accumulation of electricity storage energy balance
storagebal(s,j,r,t)..   GB(s,j,r,t) =e= (1 - loss_g(j)) * 
$ifthen.pssm not %pssm%==yes
* With chronological segments (e.g. 8760 hour resolution), dynamic energy balance is augmented from preceding segment
                       (GB(s-1,j,r,t) + GB("%seg%",j,r,t)$sameas(s,"1")) + hours(s,t) * (G(s,j,r,t) - GD(s,j,r,t))
$else.pssm
* Otherwise, PSSM formulation is used, in which the dynamic energy balance is calculated using approximate state space matrix instead of hourly chronology
                        sum(ssm(s,ss,t), p_ssm(s,ss,t) * GB(ss,j,r,t))
                        + (1 + pstay("max",s,t) * hours(s,t)) * (G(s,j,r,t) - GD(s,j,r,t))
$endif.pssm
;

* Dynamic electricity storage energy balance must not exceed storage energy capacity (size of room)
storagelim(s,j,r,t)..   GB(s,j,r,t) =l= GR(j,r,t);

* If specified, fix electricity storage duration for each technology (energy capacity/size of room relative to power capacity/size of door)
storageratio(j,r,t)$(%fixghours%)..     GR(j,r,t) =e= ghours(j,r) * GC(j,r,t);

* Exogenous target for electricity storage power capacity 
storagefx(t)..         sum((j,r)$(not sameas(j,"hyps-x")), GC(j,r,t)) =e= %stortgt%;

* With exogenous electricity storage power capacity, apply lower bound to associated energy capacity (minimum 2 hour duration)
storagefxlo(j,r,t)..   GR(j,r,t) =g= 2 * GC(j,r,t);

* * State and regional carbon market policies

* RGGI joint electric sector CO2 emissions market
rggimarket(t)$rggicap(t)..
        1e3 * rggicap(t) - NBC_RGGI(t) =g= sum(rggi_r(r), CO2_ELE(r,t));

* Intertemporal budget constraint on net banked credits for RGGI CO2 market
itnbc_rggi..
        sum(t$(rggicap(t) and t.val le 2050), NBC_RGGI(t) * nyrs(t)) =e= 0;

* Definition of cumulative banked credits for RGGI CO2 market
cbcdf_rggi(t)..
        CBC_RGGI(t) =e= sum(tt$(rggicap(t) and tt.val le t.val), NBC_RGGI(tt) * nyrs(tt));

* If New York is represented by one or more separate regions, then NY SB6599 (economy-wide and electric sector CO2 targets) can be required
carbonmarket_ny(t)$nys6599(t)..
        1e3 * nys6599(t) =g= sum(nys_r(r), CO2_EMIT(r,t));

* Carbon target for NY (electric sector only)
carbonmarket_ny_ele(t)$nys6599(t)..
        1e3 * nys6599_ele(t) =g= sum(nys_r(r), CO2_ELE(r,t) - CO2_DAC(r,t));

* If California is represented by one or more separate regions, then CA AB32 (economy-wide net-zero by 2045) can be required
carbonmarket_ca(t)$caab32(t)..
        1e3 * caab32(t) =g= sum(cal_r(r), CO2_EMIT(r,t));

* * Regional non-CO2 pollutant markets
* CSAPR enforces caps ("budgets") on certain states/regions for SO2 and NOx. There are separate caps for annual NOx and ozone-season NOx.
* - Trading is allowed for certain state/regional groupings which vary by pollutant and annual/seasonal.
* - Banking before borrowing is also allowed within the trading programs.
* - However, for each capped region in each trading program there is an upper bound on physical emissions ("assurance level").
*   The difference between the assurance level and the budget is implicitly an upper bound on imports + bank withdrawals.
*   Or equivalently a lower (negative) bound on net exports.
*   This constraint is included in regen_bounds.gms.
csapr_r(trdprg,pol,r,t)$csaprbudget(trdprg,pol,r,t,"%noncap%")..
        1e-3 * sum(csapr_s(trdprg,s,t), sum(ivfrt(i,v,f,r,t)$csapr_iv(pol,i,v), emit(i,v,f,pol,r,t) * X(s,i,v,f,r,t) * hours(s,t)) +
					sum(civfrt(i,vv,v,f,r,t)$csapr_iv(pol,i,v), emit_c(i,vv,v,f,pol,r,t) * X_C(s,i,vv,v,f,r,t) * hours(s,t)))	
	=l= csaprbudget(trdprg,pol,r,t,"%noncap%") * csapradj_s(trdprg,r,t) - NTX_CSAPR(trdprg,pol,r,t)
;

* CSAPR policy trading program market equation (sum of net exports equals net banked credits) 
csapr_trdprg(trdprg,t)..
        sum((pol,r)$csaprbudget(trdprg,pol,r,t,"%noncap%"), NTX_CSAPR(trdprg,pol,r,t)) =e= NBC_CSAPR(trdprg,t);

* CSAPR emission banking
itnbc_csapr(trdprg)..
         sum(t$(sum((pol,r), csaprbudget(trdprg,pol,r,t,"%noncap%")) and t.val le 2050), NBC_CSAPR(trdprg,t) * nyrs(t)) =e= 0;

cbcdf_csapr(trdprg,t)..
         CBC_CSAPR(trdprg,t) =e= sum(tt$(sum((pol,r), csaprbudget(trdprg,pol,r,tt,"%noncap%")) and tt.val le t.val), NBC_CSAPR(trdprg,tt) * nyrs(tt));

* * Qualified input generation for CFE or other compliance/incentive eligibility (e.g. 45V)
*   must be accompanied by zero-emissions resource credits (ZERCs)

* ZERC market equations for 45V incentives for electrolytic hydrogen production with carbon-free electricity
* In most stringent case, ZERCs must coincide both temporally and spatially with production
zercmkt_45v(s,r,t)$(not %ann45v%)..
*       Scale from GW to TWh so that marginal value is denominated in $ per MWh (discounted)
        1e-3 * hours(s,t) * (
*       Certified input generation for 45V qualified hydrogen production
		sum(ivfrt(i,v,f,r,t)$ifvt_45v(i,f,v,t), HZERC_45V(s,i,v,f,r,t))
*       Plus discharges from dedicated electricity storage less charges (including penalty)
$ifi not %storage%==no  + (GD(s,"li-ion-45v",r,t) - chrgpen("li-ion-45v") * G(s,"li-ion-45v",r,t))$(t.val ge 2030 and t.val le 2040)
	)
*	Equals electricity demand from 45V-qualified hydrogen production (note that fivrt is conditional on ptc_h applying to that vintage)
	=e= 1e-3 * hours(s,t) * (
		sum(fivrt(hi,v,r,t)$(himap("h2_45v",hi) and ptctv(t,v)), (1/3.412) * eptrf("ele",hi,v) * HX(s,hi,v,r,t))
	)
;

* Annually-cleared 45V ZERC market: Less stringent cases require only annual matching
zercmkt_ann45v(r,t)$(%ann45v% and not %usa45v%)..
*       Certified input generation for 45V qualified hydrogen production
	    sum(ivfrt(i,v,f,r,t)$ifvt_45v(i,f,v,t), ZERC_45V(i,v,f,r,t))
*	Equals demand from 45V qualified hydrogen production (note that fivrt is conditional on ptc_h applying to that vintage)
	=e= sum(fivrt(hi,v,r,t)$(himap("h2_45v",hi) and ptctv(t,v)), (1/3.412) * eptrf("ele",hi,v) * FX(hi,v,r,t));
;

* Annual-cleared national 45V ZERC market: Even less stringent cases allow annual matching and national level
zercmkt_annusa45v(t)$(%ann45v% and %usa45v%)..
*       Certified input generation for 45V qualified hydrogen production
	    sum(ivfrt(i,v,f,r,t)$ifvt_45v(i,f,v,t), ZERC_45V(i,v,f,r,t))
*	Equals demand from 45V qualified hydrogen production (note that fivrt is conditional on ptc_h applying to that vintage)
	=e= sum(fivrt(hi,v,r,t)$(himap("h2_45v",hi) and ptctv(t,v)), (1/3.412) * eptrf("ele",hi,v) * FX(hi,v,r,t));
;

* Segment level data center demand (could be endogenously flexible)
dc_demand(s,r,t).. QD_DC_S(s,r,t) =e=
$if     %flexload%==no load_flx(s,"dat",r,t)
$if not %flexload%==no QD_FLX_S(s,"dat",r,t) + (1 - %flexload%) * load_flx(s,"dat",r,t)
;

* Segment level demand subject to voluntary 24/7 CFE procurement (just consider DC load for now)
cfe_demand(s,r,t)$(t.val ge %cfe247yr%).. QD_CFE_S(s,r,t) =e= %cfeshr_dc% * QD_DC_S(s,r,t);

* ZERC market equations for voluntary carbon-free electricity (CFE) targets
* In most stringent case, ZERCs must coincide both temporally and spatially with production
zercmkt_cfe(s,r,t)$(not %anncfe% and not %usacfe% and t.val ge %cfe247yr%)..
*       Scale from GW to TWh so that marginal value is denominated in $ per MWh (discounted)
	1e-3 * hours(s,t) * (
*       Certified input generation for CFE demand
		sum(ivfrt(i,v,f,r,t)$ifvt_cfe(i,f,v,t), HZERC_CFE(s,i,v,f,r,t))
*       Plus discharges from dedicated electricity storage less charges (including penalty)
$ifi not %storage%==no  + (GD(s,"li-ion-cfe",r,t) - chrgpen("li-ion-cfe") * G(s,"li-ion-cfe",r,t))
	)
*	Equals CFE-qualified electricity demand
	=e= 1e-3 * hours(s,t) * %cfem% * QD_CFE_S(s,r,t)
;
* Annually-cleared voluntary CFE ZERC market: Less stringent cases require only annual matching
zercmkt_anncfe(r,t)$(%anncfe% and not %usacfe% and t.val ge %cfe247yr%)..
*       Certified input generation for CFE demand
		sum(ivfrt(i,v,f,r,t)$ifvt_cfe(i,f,v,t), ZERC_CFE(i,v,f,r,t))
*	Equals CFE-qualified electricity demand
	=e= 1e-3 * sum(s, QD_CFE_S(s,r,t) * hours(s,t))
;
* Hourly-cleared national ZERC market for voluntary CFE: Less stringent cases allow national level (but hourly matching)
zercmkt_usacfe(s,t)$(not %anncfe% and %usacfe% and t.val ge %cfe247yr%)..
*       Scale from GW to TWh so that marginal value is denominated in $ per MWh (discounted)
	1e-3 * hours(s,t) * sum(r,
*       Certified input generation for CFE demand
		sum(ivfrt(i,v,f,r,t)$ifvt_cfe(i,f,v,t), HZERC_CFE(s,i,v,f,r,t))
*       Plus discharges from dedicated storage less charges (including penalty)
$ifi not %storage%==no  + (GD(s,"li-ion-cfe",r,t) - chrgpen("li-ion-cfe") * G(s,"li-ion-cfe",r,t))
	)
*	Equals CFE-qualified electricity demand
	=e= 1e-3 * hours(s,t) * %cfem% * sum(r, QD_CFE_S(s,r,t))
;

* Constraint on carbon emissions for voluntary CFE market: Emissions from qualified resources must reach net-zero levels on annual basis (assumes national market)
* Equation is scaled to Mt-CO2
cfe_nz(t)$(%cfe_cdr% and t.val ge %cfe247yr%)..
	0 =g= sum(r, sum(ivfrt(i,v,f,r,t)$ifvt_cfe(i,f,v,t), emit(i,v,f,"co2",r,t) * ZERC_CFE(i,v,f,r,t)) - CO2_DAC(r,t))
;

* Hourly ZERCs (from both 45V and CFE markets) must not exceed generation
hourly_zerc(s,ivfrt(i,v,f,r,t))$(ifvt_45v(i,f,v,t) or ifvt_cfe(i,f,v,t))..
*	Scale to TWh so that marginal is denominated in $/MWh
	1e-3 * hours(s,t) * (
*	Hourly ZERCs used for 45V compliance (hourly matching required by default)
	HZERC_45V(s,i,v,f,r,t)$(ifvt_45v(i,f,v,t) and not %ann45v%) +
*	Hourly ZERCs used for 24/7 CFE demand (hourly matching required by default)
	HZERC_CFE(s,i,v,f,r,t)$(ifvt_cfe(i,f,v,t) and not %anncfe%)
	)
	=l= 1e-3 * hours(s,t) * X(s,i,v,f,r,t)$((ifvt_45v(i,f,v,t) and not %ann45v%) or (ifvt_cfe(i,f,v,t) and not %anncfe%));

* Calculate annual ZERC supply from hourly matched ZERCs from each market
hourly_zerc_sum45v(ivfrt(i,v,f,r,t))$(ifvt_45v(i,f,v,t) and not %ann45v%)..
	ZERC_45V(i,v,f,r,t) =e= 1e-3 * sum(s, HZERC_45V(s,i,v,f,r,t) * hours(s,t));

hourly_zerc_sumcfe(ivfrt(i,v,f,r,t))$(ifvt_cfe(i,f,v,t) and not %anncfe%)..
	ZERC_CFE(i,v,f,r,t) =e= 1e-3 * sum(s, HZERC_CFE(s,i,v,f,r,t) * hours(s,t));

* Annual ZERCs must not exceed generation
* Note that the sum of hourly ZERCs must be included here to avoid double counting in a scenario where
* some demand is covered by hourly matching and some by annual matching
annual_zerc(ivfrt(i,v,f,r,t))$(ifvt_45v(i,f,v,t) or ifvt_cfe(i,f,v,t) and (%ann45v% or %anncfe%))..
*	Annual ZERCs used for 45V compliance (if eligible)
	ZERC_45V(i,v,f,r,t)$ifvt_45v(i,f,v,t) +
*	Annual ZERCs used for 24/7 CFE demand (if eligible)
	ZERC_CFE(i,v,f,r,t)$ifvt_cfe(i,f,v,t)
	=l= XTWH(i,v,f,r,t);

* * Renewable Portfolio Standard (RPS) constraints

* Hypothetical federal RPS constraint
fedrps(t)..
* Qualified renewable generation in TWh (less ZERCs used for 45V compliance and voluntary CFE procurement)
        sum(ivfrt(strd(i),v,f,r,t), rps(i,f,r,"fed") * (XTWH(i,v,f,r,t) - ZERC_45V(i,v,f,r,t)$(%elys45v% and ifvt_45v(i,f,v,t)) - ZERC_CFE(i,v,f,r,t)$(%cfe247% and ifvt_cfe(i,f,v,t))))
* Plus distributed PV (if eligible)
	+ sum(r, rfpv_twh(r,t)$rps("pvrf-xn","rnw",r,"fed"))
* Must satisfy adjusted target as a percentage of retail sales (net of generation used for 45V compliance and voluntary CFE procurement) (plus rooftop PV if included)
        =g= rpstgt(t,"%rps%") * 
            sum(r, (GRIDTWH(r,t) - sum(ivfrt(i,v,f,r,t), ZERC_45V(i,v,f,r,t)$(%elys45v% and ifvt_45v(i,f,v,t)) + ZERC_CFE(i,v,f,r,t)$(%cfe247% and ifvt_cfe(i,f,v,t)))) / localloss +
                   rfpv_twh(r,t)$rps("pvrf-xn","rnw",r,"fed"))
;

* Hypothetical federal RPS constraint expressed as share of generation (rather than a share of retail load)
* Note that when target equals 100%, the constraint is replaced by upper bounds of zero on non-qualified sources (see regen_bounds.gms)
* Also note that when the target is expressed as a constraint on x as a share of x, the marginal cost is embedded in the demand
* equation marginal, i.e. it is not necessary to add a portion of the credit price to the power price 
fullrps(t)$(rpstgt(t,"%rps_full%") < 1)..
	sum(ivfrt(strd(i),v,f,r,t), rps(i,f,r,"full") * (XTWH(i,v,f,r,t) - ZERC_45V(i,v,f,r,t)$(%elys45v% and ifvt_45v(i,f,v,t)) - ZERC_CFE(i,v,f,r,t)$(%cfe247% and ifvt_cfe(i,f,v,t))))
        =g= rpstgt(t,"%rps_full%") * sum(ivfrt(i,v,f,r,t), (XTWH(i,v,f,r,t) - ZERC_45V(i,v,f,r,t)$(%elys45v% and ifvt_45v(i,f,v,t)) - ZERC_CFE(i,v,f,r,t)$(%cfe247% and ifvt_cfe(i,f,v,t))));

* In hypothetical "full" federal RPS (as a share of generation), apply similar constraint to hydrogen production (only electrolysis is considered renewable)
fullrps_h(t)$(rpstgt(t,"%rps_full%") < 1)..
	sum(fivrt(elys(hi),v,r,t)$hki("cnt",hi), FX(hi,v,r,t)) =g= rpstgt(t,"%rps_full%") * sum(fivrt(hi,v,r,t)$hki("cnt",hi), FX(hi,v,r,t));

* State RPS constraints
staterps(r,t)..
* In-state qualified renewable generation in TWh (less ZERCs used for 45V compliance and voluntary CFE procurement)
        sum(ivfrt(strd(i),v,f,r,t), rps(i,f,r,"state") * (XTWH(i,v,f,r,t) - ZERC_45V(i,v,f,r,t)$(%elys45v% and ifvt_45v(i,f,v,t)) - ZERC_CFE(i,v,f,r,t)$(%cfe247% and ifvt_cfe(i,f,v,t))))
* Plus in-state distributed PV (if eligible)
	+ rfpv_twh(r,t)$rps("pvrf-xn","rnw",r,"state")
* Plus imports less exports of RECs bundled with renewable power contracts (RPC)
        + sum(rr$tcapcost(r,rr), RPC(rr,r,t) - RPC(r,rr,t))
* Plus net imports of unbundled RECs (NMR) 
        + NMR(r,t)
* Plus alternative compliance payments (ACP)
        + ACP(r,t)
* Plus RECs from Canadian hydro
        + canhyd_r(r)
* Must satisfy adjusted target as a percentage of retail sales (net of generation used for 45V compliance and voluntary CFE procurement) (plus rooftop PV if included)
        =g= rpstgt_r(r,t) * (
            (GRIDTWH(r,t) - sum(ivfrt(i,v,f,r,t), ZERC_45V(i,v,f,r,t)$(%elys45v% and ifvt_45v(i,f,v,t)) + ZERC_CFE(i,v,f,r,t)$(%cfe247% and ifvt_cfe(i,f,v,t)))) / localloss +
             rfpv_twh(r,t)$rps("pvrf-xn","rnw",r,"state"))
;

* Unbundled REC market for state RPS credits must balance (no geographic constraints)
recmkt(t)..
        sum(r, NMR(r,t)) =e= 0;

* Exportable renewable power for state RPS credits must be temporally aligned with both eligible generation (net of hourly 45V/CFE ZERCs if applicable) and transmission
rpcgen(s,r,t)..
        sum(rr$tcapcost(r,rr), ER(s,r,rr,t)) =l= sum(ivfrt(strd(i),v,f,r,t), rps(i,f,r,"state") * (X(s,i,v,f,r,t) - HZERC_45V(s,i,v,f,r,t)$(%elys45v% and not %ann45v% and ifvt_45v(i,f,v,t)) - HZERC_CFE(s,i,v,f,r,t)$(%cfe247% and not %anncfe% and ifvt_cfe(i,f,v,t))));

rpctrn(s,r,rr,t)$tcapcost(r,rr)..
        ER(s,r,rr,t) =l= E(s,r,rr,t);

* Bilateral trade flows in RECs bundled with renewable power contracts must not exceed exportable renewable power
rpcflow(r,rr,t)$tcapcost(r,rr)..
        RPC(r,rr,t) =l= 1e-3 * sum(s, ER(s,r,rr,t) * hours(s,t));

* Upper bound on total state RPS compliance imports to reflect certain states' constraints
rpsimports(r,t)..
        sum(rr$tcapcost(r,rr), RPC(rr,r,t)) + NMR(r,t) =l= rcmlim(r,t);

* Solar carve-outs in certain states force in solar energy (assume rooftop PV counts towards carve-out)
rpssolar(r,t)$soltgt(r,t)..
        sum(ivfrt(sol(i),v,f,r,t)$sol(i), XTWH(i,v,f,r,t)) =g= soltgt(r,t) - rfpv_twh(r,t);

* State-level offshore wind mandates
wnosmandate(r,t)$wnostgt_r(r,t)..
        sum(ivrt(i,v,r,t)$idef(i,"wnos"), XC(i,v,r,t)) =g= wnostgt_r(r,t);

* * Clean Electricity Standard (CES) constraints
 
* Hypothetical federal CES constraint (lower bound on qualified generation as a share of system total)
* Note that different versions of the CES vary in terms of
*   - what is qualified / credited (i.e. numerator)
*   - what metric is used as the system total (i.e. denominator)
* Constraint is applied at regional level with bundled and unbundled credit trading

* Regional balance of CES compliance credits
cesmkt(r,t)$(not sameas(t,"2015"))..
*        In-region qualified / credited generation
         sum(ivfrt(strd(i),v,f,r,t), ces(i,v,f,r,"%ces%") * XTWH(i,v,f,r,t)) + 
         sum(civfrt(conv(i),vv,v,f,r,t), ces_c(i,vv,v,f,r,"%ces%") * XTWH_C(i,vv,v,f,r,t))
*        Plus credits for in-region distributed PV
         + rfpv_twh(r,t) * ces_oth("rfpv",r,"%ces%")
*        Plus credits from Direct Air Capture
         + sum((dac,vt(v,t)), ces_oth("dac",r,"%ces%") * DACANN(dac,v,r,t))
*        Plus imports less exports of bundled clean energy credits (BCE)
        + sum(rr$tcapcost(r,rr), BCE(rr,r,t) - BCE(r,rr,t))
*        Plus net imports of unbundled CES credits
         + CES_NTX(r,t)
*        Plus alternative compiance payments (ACP)
         + CES_ACP(r,t)
*        Plus net international clean energy imports
*         - ntxintl(r) * ces_oth("ntmintl",r,"%ces%")
*        Is greater than or equal to target share of system total
     =g= cestgt_r(r,t,"%ces%") * CESTOT(r,t)
;

* Definition of system total for CES compliance (i.e. denominator)
cestotdef(r,t)..
                 CESTOT(r,t) =e=
*                                rooftopPV (TWh) is included in all options
                                 rfpv_twh(r,t)
* "totalload" option = total generation (except electrolytic hydrogen, interpreted as storage discharge), adjusted for net trade
* this definition of the denominator is used in the Default CES implementation
$iftheni %cestot_option%==totalload
*                               total generation (TWh) excluding electrolytic hydrogen
                                + sum(ivfrt(strd(i),v,f,r,t)$(not sameas(f,"h2-e") and not sameas(f,"h2_45v")), XTWH(i,v,f,r,t))
                                + sum(civfrt(conv(i),vv,v,f,r,t)$(not sameas(f,"h2-e") and not sameas(f,"h2_45v")), XTWH_C(i,vv,v,f,r,t))
*                                plus net inter-region imports (sums to zero across regions)
                                + 1e-3 * sum((s,rr)$tcapcost(rr,r), hours(s,t) * (E(s,rr,r,t) - E(s,r,rr,t)))
$endif
* "en4load" option = all grid-supplied energy (including electricity consumed for intermediate energy sector uses)
* equivalent to "totalload" excluding storage losses for both batteries/pumped hydro and electrolysis/hydrogen (still gross of delivery losses)
$iftheni %cestot_option%==en4load
*                               total electricity delivered from grid for end-use load
                                + GRIDTWH(r,t)
*                                include net international exports (for equivalency with totalload option; CES analysis is domestic)
                                + ntxintl(r)
*                               electricity consumed for non-electrolytic fuel production
	                        sum(f$(not sameas(f,"h2-e") and not sameas(f,"h2_45v") and not sameas(f,"h2-de")), (1/3.412) * QD_TRF(s,"ele",f,r,t))
*	                        electricity consumed for DAC (including flexible segment-level dispatch of e-DAC)
                                + (1/3.412) * QD_DAC(s,r,t)
*	                        electricity consumed for upstream fossil production
                                + (1/3.412) * QD_UPS("ele",r,t)
*	                        electricity consumed for (central-scale) storage injection and inter-region transmission (export) of hydrogen
	                        + 1e-3 * sum(s, hours(s,t), QD_H2I_S(s,r,t))
*	                        electricity consumed for CO2 transport and storage
                                + (1/3.412) * QD_CO2("ele",r,t)
$endif
* "retailload" option = grid-supplied energy adjusted for localloss (intermediate energy sector uses are assumed to have zero delivery loss)
$iftheni %cestot_option%==retailload
*                               total electricity delivered from grid for end-use load, adjusted for delivery loss
                                + GRIDTWH(r,t) / localloss
*                                include net international exports (for equivalency with totalload option; CES analysis is domestic)
                                + ntxintl(r) / localloss
*                               electricity consumed for non-electrolytic fuel production
	                        sum(f$(not sameas(f,"h2-e") and not sameas(f,"h2_45v") and not sameas(f,"h2-de")), (1/3.412) * QD_TRF(s,"ele",f,r,t))
*	                        electricity consumed for DAC (including flexible segment-level dispatch of e-DAC)
                                + (1/3.412) * QD_DAC(s,r,t)
*	                        electricity consumed for upstream fossil production
                                + (1/3.412) * QD_UPS("ele",r,t)
*	                        electricity consumed for (central-scale) storage injection and inter-region transmission (export) of hydrogen
	                        + 1e-3 * sum(s, hours(s,t), QD_H2I_S(s,r,t))
*	                        electricity consumed for CO2 transport and storage
                                + (1/3.412) * QD_CO2("ele",r,t)
$endif
;

* Hydrogen production must meet CES target as well (all technologies except conventional SMR and coal gasification are considered clean)
cesmkt_h(r,t)$(not sameas(t,"2015"))..
	sum(fivrt(hi,v,r,t)$(hki("cnt",hi) and not sameas(hi,"gsst") and not sameas(hi,"clgs")), FX(hi,v,r,t)) =g= cestgt_r(r,t,"%ces%") * sum(fivrt(hi,v,r,t)$hki("cnt",hi), FX(hi,v,r,t));


* Regional (unbundled) CES trading
* If banking/borrowing credits is allowed, then sum of exports could be non-zero
cestrade(t)$sum(r, cestgt_r(r,t,"%ces%"))..
        sum(r, CES_NTX(r,t)) =e= CES_NBC(t);

* Exportable clean energy must be generated concurrently with transmission
bcegen(s,r,t)..
        sum(rr$tcapcost(r,rr), EC(s,r,rr,t)) =l=  sum(ivfrt(strd(i),v,f,r,t), ces(i,v,f,r,"%ces%") * X(s,i,v,f,r,t))
						+ sum(civfrt(conv(i),vv,v,f,r,t), ces_c(i,vv,v,f,r,"%ces%") * X_C(s,i,vv,v,f,r,t));

bcetrn(s,r,rr,t)$tcapcost(r,rr)..
        EC(s,r,rr,t) =l= E(s,r,rr,t);

* Bilateral trade flows in bundled clean energy credits must not exceed exportable clean energy
bceflow(r,rr,t)$tcapcost(r,rr)..
        BCE(r,rr,t) =l= 1e-3 * sum(s, EC(s,r,rr,t) * hours(s,t));


* California SB-100 clean electricity standard constraint
sb100ces(t)..
* In-state qualified "eligible renewable energy resources and zero-carbon resources" in TWh
        sum(ivfrt(strd(i),v,f,cal_r(r),t), sb100i(i,f,r) * XTWH(i,v,f,r,t)) +
        sum(civfrt(conv(i),vv,v,f,cal_r(r),t), sb100i(i,f,r) * XTWH_C(i,vv,v,f,r,t))
* California rooftop PV
      + sum(cal_r(r), rfpv_twh(r,t))
* Plus imports of bundled clean electricity (new builds and existing hydro/nuclear)
      + sum(sb100(r), BCE_CA(r,t))
* Must satisfy adjusted target as a percentage of retail sales (plus rooftop PV)
    =g= sb100tgt(t) * sum(cal_r(r), (GRIDTWH(r,t) / localloss + rfpv_twh(r,t)))
;

* Exportable clean electricity (defined via SB-100) must be generated concurrently with transmission
bcegen_ca(s,r,t)$sb100(r)..
         EC_CA(s,r,t) =l=
*        New builds for neighboring regions (this formulation does not enforce resource shuffling provisions)
         sum(ivfrt(strd(i),v,f,r,t), sb100i(i,f,r) * X(s,i,v,f,r,t)) +
         sum(civfrt(conv(i),vv,v,f,cal_r(r),t), sb100i(i,f,r) * X_C(s,i,vv,v,f,r,t))
*        Existing nuclear and hydro
         + sum(i, sb100enh(i,r) * sum((vbase,f), X(s,i,vbase,f,r,t)))
;

bcetrn_ca(s,r,t)$sb100(r)..
        EC_CA(s,r,t) =l= sum(cal_r(rr)$tcapcost(r,rr), E(s,r,rr,t));

bceflow_ca(r,t)$sb100(r)..
        BCE_CA(r,t) =l= 1e-3 * sum(s, EC_CA(s,r,t) * hours(s,t));

* Unspecified imports into CA (in TWh per year)
uidef_ca(cal_r(r),t)..
         UI_CA(r,t) =e= sum((s,sb100(rr))$tcapcost(rr,r), (E(s,rr,r,t) - EC_CA(s,rr,t)) * hours(s,t) * 1e-3);


* * Nuclear policy incentives

* Nuclear state policy constraint
nucst(r,t)$(not rpstgt(t,"%rps_full%") eq 1)..
         sum(ivrt("nucl-x",v,r,t), XC("nucl-x",v,r,t)) =g= nuczec(r,t);

* Incentives for existing nuclear in the IIJA Civil Nuclear Credit Program and the IRA (45U) are essentially assumed
* to ensure no early retirements during the subsidy period
nuc_iija45u(r,t_iija45u(t))..
	sum(ivrt("nucl-x",v,r,t), XC("nucl-x",v,r,t)) =g= xcap("nucl-x",r) * lifetime("nucl-x",r,t);

* Assume no unit retired before 60 years if majority owned by utility with net-zero target
nuc_nzlo(r,t)..
	sum(ivrt("nucl-x",v,r,t), XC("nucl-x",v,r,t)) =g= xcap("nucl-x",r) * lifetime_nucnz60(r,t);

* * Non-electric fuel supply

* Approximate upstream energy demands for fossil production
ups_inputs(f_ups(f),r,t)..  QD_UPS(f,r,t) =e= sum((fos(ff),rr), epups_fuels(f,r,ff,rr,t) * QSF(ff,rr,t));

* Fuel balance for non-blended non-electric fuels
fuelbal(f,r,t)$(not blend(f) and not sameas(f,"ele"))..
* Annual quantity supplied equals...
	QSF(f,r,t) =e=  
* Upstream energy demands for fossil production
	QD_UPS(f,r,t)$f_ups(f) +
* Annual quantity consumed in blending sectors plus
	sum((blendmap(f,ff),dst_f(dst,ff)), QD_BLEND(f,dst,ff,r,t)) +
* Annual quantity consumed in transformation sectors plus
	sum(trfmap(f,ff), QD_TRF(f,ff,r,t)) +
* Annual quantity consumed in production of bio feedstocks
	sum((bfs,bfsc), epbfs(f,bfs) * QS_BFS(bfs,bfsc,r,t)) +
* Annual quantity consumed for direct air capture
	QD_DAC(f,r,t)$f_dac(f) +
* Annual quantity consumed in electric sector plus
	QD_ELEC(f,r,t)$f_ele(f) +
* Annual quantity consumed in end-use sectors (exogenous) plus
	qd_enduse(f,r,t) +
* Annual quantity consumed in end-use sectors (endogenous) plus
	sum(kf, QD_EEU(kf,f,r,t))$df(f) +
* Net exports (sum of domestic and international)
	NTX(f,r,t)$f_trd(f)
;


* Fuel balance for blended fuels by destination
fuelbal_blend(dst_f(dst,blend(f)),r,t)..
* Annual quantity supplied equals...
	QS_BLEND(dst,f,r,t) =e=  
* Upstream energy demands for fossil production
	QD_UPS(f,r,t)$sameas(dst,"ups") +
* Annual quantity consumed in transformation sectors plus
	sum(trfmap(f,ff)$sameas(dst,ff), QD_TRF(f,ff,r,t)) +
* Annual quantity consumed in production of bio feedstocks
	sum((bfs,bfsc), epbfs(f,bfs) * QS_BFS(bfs,bfsc,r,t))$sameas(dst,"bfs") +
* Annual quantity consumed for direct air capture
	QD_DAC(f,r,t)$sameas(dst,"dac") +
* Annual quantity consumed in electric sector (fixed) plus
	QD_ELEC(f,r,t)$sameas(dst,"ele") +
* Annual quantity consumed in end-use sectors (fixed) plus
	sum(kf$sameas(dst,kf), qd_enduse_kf(kf,f,r,t)) +
* Annual quantity consumed in end-use sectors (endogenous) plus
	sum(kf$sameas(dst,kf), QD_EEU(kf,f,r,t))
* Gross exports (sum of domestic and international)
*	+ GRX(f,r,t)$(f_dom(f) or f_int(f) and sameas(dst,"exp"))
;

* Allocated blend constituents must sum to total blend supply for each eligible destination
blend_tot(dst_f(dst,blend(f)),r,t).. sum(blendmap(ff,f), QD_BLEND(ff,dst,f,r,t)) =e= QS_BLEND(dst,f,r,t);

* Upper bound on blended shares for constituents by destination
blend_max(ff,dst,f,r,t)$blendmap(ff,f).. QD_BLEND(ff,dst,f,r,t) =l= blend_lim(ff,f,dst) * QS_BLEND(dst,f,r,t);

* Upper bound on total hydrogen share in pipeline gas
blend_h2(dst,r,t)$dst_f(dst,"ppg").. sum(h2f(f), QD_BLEND(f,dst,"ppg",r,t)) =l= blend_lim("h2","ppg",dst) * QS_BLEND(dst,"ppg",r,t);

* Lower bound on renewable share in gasoline (including ethanol) to reflect evolution of federal RFS
blend_mgs(dst,t).. sum(r, QD_BLEND("eth",dst,"mgs",r,t) + QD_BLEND("rgl",dst,"mgs",r,t)) =g= 0.07 * sum(r, QS_BLEND(dst,"mgs",r,t));

* Consider policy scenario where no fossil gas is allowed in electric sector without capture starting in specified year
blend_eleppgu(r,t)$(t.val ge %noelecgasu%).. sum(blendmap(f,"ppg")$(not sameas(f,"gas")), QD_BLEND(f,"ele","ppg",r,t)) =g= QD_ELEC_PPGU(r,t);

* Net exports by region includes international trade (exogenously fixed for now)
fueltrade(f_trd(f),t).. sum(r, NTX(f,r,t)) =e= ntxintl_f(f,t);

* * Final energy by sector (by source fuel and delivered fuel - not additive across f)
buildings_fe(f,r,t)..
	FE_BLD(f,r,t) =e=
* Blend constituents
	sum(blendmap(f,ff), QD_BLEND(f,"res",ff,r,t) + QD_BLEND(f,"com",ff,r,t)) +
* Fuels delivered directly (including blended fuels)
	qd_enduse_kf("res",f,r,t) + qd_enduse_kf("com",f,r,t)
;

industry_fe(f,r,t)..
	FE_IND(f,r,t) =e=
* Blend constituents
	sum(blendmap(f,ff), QD_BLEND(f,"ind-sm",ff,r,t) + QD_BLEND(f,"ind-lg",ff,r,t)) +
* Fuels delivered directly (including blended fuels)
	qd_enduse_kf("ind-sm",f,r,t) + QD_EEU("ind-sm",f,r,t) + qd_enduse_kf("ind-lg",f,r,t)
;

transport_fe(f,r,t)..
	FE_TRN(f,r,t) =e=
* Fuels blended into annually delivered fuels
	sum(blendmap(f,ff), QD_BLEND(f,"ldv",ff,r,t) + QD_BLEND(f,"mdhd",ff,r,t)) +
* Fuels delivered directly (including blended fuels)
	qd_enduse_kf("ldv",f,r,t) + qd_enduse_kf("mdhd",f,r,t) + QD_EEU("mdhd",f,r,t)
;


* Transformation fuels sectors
* Segment-level dispatch and disposition for e-hydrogen
* Segment-level dispatch and annual disposition for other e-fuels (nh3-e, sng, sjf)
* Annual dispatch and disposition for other fuels (h2-n, nh3-n, biofuels, coke)

* The set hi(fi) corresponds to technologies for producing e-fuels (e-hydrogen and derivatives)

* Annual production/conversion for non-e-fuel transformation sectors must not exceed capacity
* Capacity is in bbtu per hour, output is in trbtu per year (8760 hours per year)
capacity_trf(fivrt(fi,v,r,t))$(not hi(fi)).. FX(fi,v,r,t) =l= 8.76 * af_trf(fi) * FC(fi,v,r,t);

* E-fuels capacity is dispatched at segment level (hi = electrolysis and linked technologies such as e-fuels)
hcapacity(s,fivrt(hi,v,r,t))..
        HX(s,hi,v,r,t) =l= af_trf(hi) * HCS(s,hi,v,r,t);

* Annual production of e-fuels is sum of segment-level dispatch
hproddef(fivrt(hi,v,r,t))..  FX(hi,v,r,t) =e= 1e-3 * sum(s, HX(s,hi,v,r,t) * hours(s,t));

* Segment level copies of capacity for sparsity
copyhc(s,fivrt(hi,v,r,t))..  HCS(s,hi,v,r,t) =e= FC(hi,v,r,t)$(ord(s)=1) + HCS(s-1,hi,v,r,t)$(ord(s)>1);

* Supply is the sum of output over technologies and vintages
supply_trf(trf(f),r,t).. QSF(f,r,t) =e= sum((fivrt(fi,v,r,t)), fimap(f,fi) * FX(fi,v,r,t))
* Plus net imports for electrolytic hydrogen
$if not %h2trans%==no                 + 1e-3 * sum((s,rr)$tcapcost_h(rr,r), hours(s,t) * (HE(s,f,rr,r,t) - HE(s,f,r,rr,t)))$(sameas(f,"h2-e") or sameas(f,"h2_45v"))
; 

* Energy and other feedstock (excluding biofeedstock) inputs to transformation sector production/conversion
inputs_trf(ff,trf(f),r,t).. QD_TRF(ff,f,r,t) =e= sum(fivrt(fi,v,r,t), fimap(f,fi) * (eptrf(ff,fi,v) + fptrf(ff,fi,v)) * FX(fi,v,r,t));

* Accumulation of transformation sector production/conversion capacity
invest_trf(fi,newv(v),r,t)$tv(t,v)..	FC(fi,v,r,t) =e= IFC(fi,r,t)
*       Allow accumulation of 2050+ capacity
                        + FC(fi,v,r,t-1)$(sameas(v,"2050+") and t.val > 2050);

* Monotonicity constraint on transformation sector production/conversion capacity
retire_trf(fi,v,r,t)$(vt(v,t) and not sameas(v,"2050+")).. FC(fi,v,r,t+1) =l= FC(fi,v,r,t);

* Conversions allowed for existing fuel transformation capacity (vbase) only (currently only ethanol CCS retrofits)

* Disposition of convertible capacity: original plus conversion (minus penalty) plus retired must equal original installed
convbalance_trf(fi_orig(fi),vbase(vv),r,t)$vt(vv,t)..
	FC(fi,vv,r,t) + sum(fivrt(fi_conv,v,r,t)$convmap_fi(fi_conv,fi), FC(fi_conv,v,r,t) * convadj_fi(fi_conv)) + RFC(fi,vv,r,t)
                 =e= sum(tv(tt,vv), FC(fi,vv,r,tt));

* Cumluative retirements of convertible capacity must be monotonic
retiremon_trf(fi_orig(fi),vbase(v),r,t)$(t.val > vyr(v))..
        RFC(fi,v,r,t) =g= RFC(fi,v,r,t-1);

* Cumulative retirements of convertible capacity of existing vintages must be consistent with lifetime
retirelife_trf(fi_orig(fi),vbase(v),r,t)$(t.val > vyr(v))..
	RFC(fi,v,r,t) =g= sum(tbase, FC(fi,v,r,tbase)) * (1 - lifetime_trf(fi,r,t));

* New conversions must decrease base capacity relative to previous period (to prevent "re-conversion" to a different type)
convert1_trf(fi_orig(fi),vbase(vv),r,t)$(t.val > vyr(vv))..
	FC(fi,vv,r,t) =l= FC(fi,vv,r,t-1) - sum(convmap_fi(fi_conv,fi), IFC(fi_conv,r,t) * convadj_fi(fi_conv));

* E-fuels segment level balance
* ef is set of e-fuels:  h2-de (distributed), h2-e, h2_45v, nh3-e, sng, sjf
* himap links e-fuel to production technologies
* note that nh3-e, sng, and sjf all use h2-e as input

* Electrolytic hydrogen supply-demand balance

fuelbal_eh(s,f,r,t)$(ef(f) and h2f(f))..
*       Scale from hourly to aggregate
        1e-3 * hours(s,t) * (
*       Dispatched e-hydrogen production in region
                sum((himap(f,hi),fivrt(hi,v,r,t)), HX(s,hi,v,r,t))
*       Plus net imports of e-hydrogen from a neighboring region (if allowed) (no loss penalty on hydrogen transmission, assuming electric energy input)
$if not %h2trans%==no   + sum(rr$tcapcost_h(rr,r), HE(s,f,rr,r,t) - HE(s,f,r,rr,t))$(not sameas(f,"h2-de"))
        )
*       Equals demand for
        =e= 1e-3 * hours(s,t) * (
*       Dispatched electric generation using e-hydrogen
                (sum(ivfrt(strd(i),v,"h2-e",r,t), htrate(i,v,"h2-e",r,t) * X(s,i,v,"h2-e",r,t)) +
		 sum(civfrt(conv(i),vv,v,"h2-e",r,t), htrate_c(i,vv,v,"h2-e",r,t) * X_C(s,i,vv,v,"h2-e",r,t)) )$sameas(f,"h2-e") +
*	Dispatch from e-hydrogen that qualifies for 45V subsidy
                (sum(ivfrt(strd(i),v,"h2_45v",r,t), htrate(i,v,"h2_45v",r,t) * X(s,i,v,"h2_45v",r,t)) +
		 sum(civfrt(conv(i),vv,v,"h2_45v",r,t), htrate_c(i,vv,v,"h2_45v",r,t) * X_C(s,i,vv,v,"h2_45v",r,t)) )$sameas(f,"h2_45v")
*	Delivered e-hydrogen for other e-fuel production
		 + sum(ef(ff)$(not h2f(ff)), QD_TRF_S(s,f,ff,r,t))$(not sameas(f,"h2-de"))
*	Delivered e-hydrogen for blending in non-electric natural gas deliveries (constrained by share of weekly average gas consumption rate in each segment)
                 + HDU_BLEND_S(s,f,r,t)$(not sameas(f,"h2-de"))
*	Delivered e-hydrogen for direct non-electric use 
		 + sum(dst$(not sameas(dst,"ele") and not sum(ef, sameas(dst,ef))), QD_BLEND(f,dst,"h2",r,t)) / 8.76
*       Net injection of e-hydrogen into storage (central scale/cost for h2-e and h2_45v, forecourt scale/cost for h2-de)
		 + sum(hkf(hk,f), H2G(s,hk,f,r,t))
		 );

* Upper bound on segment-level hydrogen blending based on corresponding weekly non-electric gas use (h2-e and h2_45V are fungible)
henduse_blend_s(s,r,t)..
	sum(f$(sameas(f,"h2-e") or sameas(f,"h2_45v")), HDU_BLEND_S(s,f,r,t)) =l= blend_lim("h2","ppg","ind-lg") * sum(sw(s,w,t), 1e3 * qd_ppg_nele(w,r,t) / (24 * 7));

* Linking segment level blending of e-hydrogen with annual blended total
segment_blend(f,r,t)$(sameas(f,"h2-e") or sameas(f,"h2_45v")).. sum(s, hours(s,t) * HDU_BLEND_S(s,f,r,t)) =e= sum(dst, QD_BLEND(f,dst,"ppg",r,t));


* Segment-level hydrogen inputs to hydrogen-derived e-fuel production (h2-e and h2_45v are fungible)
inputs_h2efuel(s,ef(f),r,t)$(not h2f(f))..
	sum(ff$(sameas(ff,"h2-e") or sameas(ff,"h2_45v")), QD_TRF_S(s,ff,f,r,t)) =e=
	sum((himap(f,hi),fivrt(hi,v,r,t)), (eptrf("h2-e",hi,v) + fptrf("h2-e",hi,v)) * HX(s,hi,v,r,t))
;

* Segment-level electricity inputs to e-fuel production (hydrogen and hydrogen-derived fuels)
inputs_eleefuel(s,ef(f),r,t)..
	QD_TRF_S(s,"ele",f,r,t) =e= sum((himap(f,hi),fivrt(hi,v,r,t)), eptrf("ele",hi,v) * HX(s,hi,v,r,t))
;

* Annual carbon feedstock inputs to e-fuels (not segment-based)
carbon_syn(r,t).. CO2_SYN(r,t) =e= sum(fivrt(hi,v,r,t), cpsyn(hi,v) * FX(hi,v,r,t)); 

* Segment-level thermal inputs to high-temp electrolysis
hthermal(s,v,r,t)$fivrt("elys-hts",v,r,t)..
*	Supply of thermal energy (diverted from electric dispatch)
	sum(ivfrt(tsi(i),vv,f,r,t), XT(s,i,vv,f,r,t)) + sum(civfrt(conv(i),vvv,vv,f,r,t)$tsi(i), XT_C(s,i,vvv,vv,f,r,t))
*	Equals demand for high-temp electrolysis
	=e= tph2("elys-hts",v) * HX(s,"elys-hts",v,r,t);

* * Hydrogen Infrastructure

*       Enforce capacity constraint on inter-region hydrogen flows
tcapacity_h(s,r,rr,t)$(tcapcost_h(r,rr) and %h2trans%)..
        sum(f$(sameas(f,"h2-e") or sameas(f,"h2_45v")), HE(s,f,r,rr,t)) =l= TC_H(r,rr,t)$tcapcost_h(r,rr);

*       Allow accumulation of hydrogen transmission capacity investments
tinvest_h(r,rr,t)$(tcapcost_h(r,rr) and %h2trans%)..
        TC_H(r,rr,t) =e= IT_H(r,rr,t) + IT_H(rr,r,t) + TC_H(r,rr,t-1);

* Accumulation of hydrogen storage charge capacity investments
ginvestc_h(hk,r,t)..       GC_H(hk,r,t) =e= IGC_H(hk,r,t) + GC_H(hk,r,t-1);

* Accumulation of storage size of room investments
ginvestr_h(hk,r,t)..       GR_H(hk,r,t) =e= IGR_H(hk,r,t) + GR_H(hk,r,t-1);

* Storage charge must not exceed charge capacity (size of door)
chargelim_h(s,hk,r,t)..    sum(hkf(hk,f), G_H(s,hk,f,r,t)) =l= GC_H(hk,r,t);

* Storage discharge must not exceed charge capacity (size of door)
dischargelim_h(s,hk,r,t).. sum(hkf(hk,f), GD_H(s,hk,f,r,t)) =l= GC_H(hk,r,t);

* Net injection (charge of hydrogen storage) 
netcharge_h(s,hkf(hk,f),r,t).. H2G(s,hk,f,r,t) =e= G_H(s,hk,f,r,t) - GD_H(s,hk,f,r,t);

* Annual storage balance (not needed with 8760, is needed in addition to PSSM segment-level balance)
storagebal_ann_h(hkf(hk,f),r,t)..
	sum(s, hours(s,t) * H2G(s,hk,f,r,t)) =e= 0;

* Dynamic accumulation of hydrogen storage balance
* (h2-e and h2_45v are fungible in hk="cnt"), only h2-de can be used for hk="frc")
storagebal_h(s,hk,r,t)..   GB_H(s,hk,r,t) =e=
$ifthen.pssm not %pssm%==yes
* With chronological segments (e.g. 8760 hour resolution), dynamic energy balance is augmented from previous segment
                          (GB_H(s-1,hk,r,t) + GB_H("%seg%",hk,r,t)$sameas(s,"1")) + hours(s,t) * sum(hkf(hk,f), H2G(s,hk,f,r,t));
$else.pssm
* Otherwise, PSSM formulation is used, in which dynamic balance is calculated using approximate state space matrix instead of hourly chronology
                          sum(ssm(s,ss,t), p_ssm(s,ss,t) * GB_H(ss,hk,r,t))
                        + (1 + pstay("max",s,t) * hours(s,t)) * sum(hkf(hk,f), H2G(s,hk,f,r,t));
$endif.pssm

* Dynamic hydrogen storage balance must not exceed storage capacity (size of room)
storagelim_h(s,hk,r,t)..    GB_H(s,hk,r,t) =l= GR_H(hk,r,t);

* If specified, fix hydrogen storage duration (reservoir capacity/size of room relative to injection capacity/size of door)
storageratio_h(hk,r,t)$(%fixghours%)..     GR_H(hk,r,t) =e= ghours_h(hk,r) * GC_H(hk,r,t);

* Electricity consumed for (central-scale) hydrogen storage injection and inter-region transmission (export) of hydrogen
einputs_h2i(s,r,t).. QD_H2I_S(s,r,t) =e=
                          sum(hkf("cnt",f), (1/3.412) * epchrg_h("cnt",t) * G_H(s,"cnt",f,r,t))
$if not %h2trans%==no	+ sum(rr$tcapcost_h(r,rr), (1/3.412) * eptrns_h(r,rr,t) * sum(f$(sameas(f,"h2-e") or sameas(f,"h2_45v")), HE(s,f,r,rr,t)))
;

* * Direct air capture (DAC)

* Utilization of DAC must not exceed installed capacity
* Non-electric DAC dispatches at annual level
daccapacity(dac,v,r,t)$(vt(v,t) and not edac(dac))..
	DACANN(dac,v,r,t) =l= af_dac(dac) * DACC(dac,v,r,t);

* Electric-only DAC has segment-level flexible dispatch
edaccapacity(s,edac(dac),v,r,t)$vt(v,t)..
	DACX(s,dac,v,r,t) =l= af_dac(dac) * DACC(dac,v,r,t) / 8.76;

* Annual total CO2 captured from electric-only DAC (million t-CO2 per year)
annualdac(edac(dac),v,r,t)$vt(v,t)..
	DACANN(dac,v,r,t) =e= 1e-3 * sum(s, DACX(s,dac,v,r,t) * hours(s,t));

* Accumulation of DAC capacity investment
dacinvest(dac,newv(v),r,t)$tv(t,v)..
	DACC(dac,v,r,t) =e= IDAC(dac,r,t)
*       Allow accumulation of 2050+ capacity
                        + DACC(dac,v,r,t-1)$(sameas(v,"2050+") and tyr(t) > 2050);

* Monotonicity constraint on installed DAC capacity
dacretire(dac,v,r,t)$(vt(v,t) and not sameas(v,"2050+"))..
	DACC(dac,v,r,t+1) =l= DACC(dac,v,r,t);

* Non-electric fuel inputs into DAC 
inputs_dac(f,r,t).. QD_DAC(f,r,t) =e= sum((dac,vt(v,t)), epdac("%dacscn%",f,dac,v) * DACANN(dac,v,r,t)); 

* Electric inputs into DAC (assume non-electric DAC is not flexible at segment level)
einputs_dac(s,r,t).. QD_DAC_S(s,r,t) =e=
	      sum((edac(dac),vt(v,t)), (1/3.412) * epdac("%dacscn%","ele",dac,v) * DACX(s,dac,v,r,t)) +
	      sum((dac,vt(v,t))$(not edac(dac)), (1/3.412) * epdac("%dacscn%","ele",dac,v) * DACANN(dac,v,r,t)) / 8.76
;

* * CO2 transport and storage

* Ensures conservation of annual captured CO2 flows in each region and period
co2balance(r,t)..
*       CO2 captured by power plants with CCS
        sum(ivfrt(strd(i),v,f,r,t)$ccs(i), XTWH(i,v,f,r,t) * capture(i,v,f,r)) +
        sum(civfrt(conv(i),vv,v,f,r,t)$ccs(i), XTWH_C(i,vv,v,f,r,t) * capture_c(i,vv,v,f,r)) 
*       CO2 captured by transformation production/conversion technologies with CCS
        + sum(fivrt(fi_ccs(fi),v,r,t), FX(fi,v,r,t) * capture_trf(fi,v))
*	CO2 captured by direct air capture (DAC) technologies (gross of flue gas)
	+ sum((dac,vt(v,t)), DACANN(dac,v,r,t) * capture_dac("%dacscn%",dac,v))
*	CO2 captured in upstream model (scaled by endogenous fuel use)
	+ sum(f, CO2_CAPT_UPS(f,r,t))
*	CO2 captured in industrial model (exogenous)
	+ co2_capt_ind(r,t)
*       Plus net inter-region CO2 imports
        + sum(rr$capcost_pc("%co2trscn%",rr,r), PX(rr,r,t) - PX(r,rr,t))
*       Equals CO2 injected to geologic storage + CO2 utilized for synthetic fuels
        =e= sum(cstorclass, CSTOR(cstorclass,r,t)) + CO2_SYN(r,t);

* CO2 stored over all time periods must be less than regional storage capacity
* or must be restricted to exogenous capture only (zero endogenous) in scenarios where CO2 storage is not available
co2storcap(cstorclass,r)..
        sum(t, CSTOR(cstorclass,r,t) * nyrs(t)) =l=  
$if     %ccslim%==no                                1e3 * injcap("%cstorscen%",cstorclass,r)
$if not %ccslim%==no                                co2_capt_ind(r,t)
;
	
* Fuel inputs to transport and storage of CO2 (electric only, zero for now)
co2_inputs(f,r,t)$epco2inj(f)..
	QD_CO2(f,r,t) =e= sum(linked(r,rr), epco2trn(f,r,rr) * PX(r,rr,t)) + epco2inj(f) * sum(cstorclass, CSTOR(cstorclass,r,t))
;

*       Allow accumulation of CO2 pipeline capacity investments
co2pinvest(r,rr,t)$capcost_pc("%co2trscn%",r,rr)..
        PC(r,rr,t) =e= IP(r,rr,t) + IP(rr,r,t) + PC(r,rr,t-1);

*       Enforce capacity constraint on inter-region CO2 pipeline flows
co2pcapacity(r,rr,t)$capcost_pc("%co2trscn%",r,rr)..
        PX(r,rr,t) =l= PC(r,rr,t);

*       Allow accumulation of CO2 injection capacity investments
co2injinvest(cstorclass,r,t)$injcap("%cstorscen%",cstorclass,r)..
        INJC(cstorclass,r,t) =e= IINJ(cstorclass,r,t) + INJC(cstorclass,r,t-1);

*       Enforce capacity constraint on CO2 injection
co2injcapacity(cstorclass,r,t)$injcap("%cstorscen%",cstorclass,r)..
        CSTOR(cstorclass,r,t) =l= INJC(cstorclass,r,t);

* * Bioenergy feedstocks

* Bio feedstock supply based on exogenous supply curves by region (each supply step has limited quantity, see regen_bounds.gms)
bfs_balance(bfs,r,t)..  sum(bi, QD_BFS(bfs,bi,r,t)) =l= sum(bfsc, QS_BFS(bfs,bfsc,r,t));

* Bio feedstock inputs to biofuel production
* Each technology has a total feedstock input requirement (bfspbfl) and a set of eligible feedstocks (bfsmap)
bfsinputs_bfl(bi,r,t).. sum(bfsmap(bi,bfs), QD_BFS(bfs,bi,r,t)) =e= sum(fivrt(bi,v,r,t), bfspbfl(bi,v) * FX(bi,v,r,t));

* Bio feedstock production drives incremental non-road vehicle service demand (and ammonia demand)
nreinputs_bfs(vc,r,t).. NNRD_BFS(vc,r,t) =e= sum((bfs,bfsc), nnrdpbfs(vc,bfs) * QS_BFS(bfs,bfsc,r,t));

* * Endogenous End-Use Sectors (Medium- and Heavy-Duty and Non-road vehicles only for now)

* Allocation of MD-HD vehicle service demand to driving intensity classes
allocation_vdi(vc_di(vc,di),r,t)$vc_mdhd(vc)..
sum(vcht(vc,vht,v_e,t), VDI(vc,vht,v_e,di,r,t)) =e= mdhd_tot(vc,r,t) * di_shr(vc,di);

* Total MD-HD vehicles
allocation_xv(vc_mdhd(vc),vht,v_e,r,t)$vcht(vc,vht,v_e,t)..
sum(vc_di(vc,di), VDI(vc,vht,v_e,di,r,t)) =e= XV(vc,vht,v_e,r,t);

* Non-road vehicle services include endogenous demand from new bio-feedstock production
market_nnrd(vc,r,t)$vc_nnrd(vc)..
sum(vcht(vc,vht,v_e,t), XV(vc,vht,v_e,r,t)) =e= nnrd_tot(vc,r,t) + NNRD_BFS(vc,r,t);

* New vintages of MD-HD and non-road vehicles
lifetime_new(vc,vht,newv_e(v_e),r,t)$vcht(vc,vht,v_e,t)..
XV(vc,vht,v_e,r,t) =l= sum(tv_e(tt,v_e), IV(vc,vht,r,tt)) * vt_life(vc,v_e,t);

* Retirement monotonicity of MD-HD and non-road vehicles
retire_eu(vc,vht,v_e,r,t)$vcht(vc,vht,v_e,t)..
XV(vc,vht,v_e,r,t+1) =l= XV(vc,vht,v_e,r,t);

* Rate of change constraint for MD-HD and non-road vehicles (default limit on increase in new vintage is 10% of total)
changerate(vc,vht,r,t)$(sum(v_e, vcht(vc,vht,v_e,t)) and not incumb(vc,vht) and not tbase(t))..
(IV(vc,vht,r,t) - IV(vc,vht,r,t-1)) =l= %mdhd_rate% * (mdhd_tot(vc,r,t)$vc_mdhd(vc) + nnrd_tot(vc,r,t)$vc_nnrd(vc));

* Annual fuel use in trillion btu = mmtbu per 1000 miles * 1000 miles / vehicle * millions of vehicles
fueluse_eu(kf,df(f),r,t)..
QD_EEU(kf,f,r,t) =e= sum((vcht(vc_mdhd(vc),vht,v_e,t),di), epvmt_r(vc,vht,f,r,v_e,t) * di_vmt(vc,di) * vmti(vc) * VDI(vc,vht,v_e,di,r,t))$sameas(kf,"mdhd") +
		     sum((kfvc(kf,vc),vcht(vc_nnrd(vc),vht,v_e,t)), epsrv_r(vc,vht,f,r,v_e,t) * XV(vc,vht,v_e,r,t));

* Translate endogenous electricity demand to segment level shape (convert Tbtu to GWh per hour)
* load_kf represents indexed segment load relative to annual average load
elecuse_eu(s,r,t)..
QD_EEU_S(s,r,t) =e= sum(kf, load_kf(s,kf,r,t) * (1 / 3.412 / 8.76) * QD_EEU(kf,"ele",r,t));


* * * Emissions
* * Electric Sector Emissions

* Define CO2 emissions from electric sector based on carbon content of fuel demands, which will
* capture blending ratios for gas and liquid fuels; less captured CO2
co2emit_ele(r,t)..
	CO2_ELE(r,t) =e=
* Carbon content of blend constituents
	sum(blendmap(f,ff), cc_ff(f) * QD_BLEND(f,"ele",ff,r,t)) +
* Carbon content of non-blended fuels
        sum(f$(not blend(f)), cc_ff(f) * QD_ELEC(f,r,t))
* Less CO2 captured and stored in electric sector
        - sum(ivfrt(strd(i),v,f,r,t)$ccs(i), XTWH(i,v,f,r,t) * capture(i,v,f,r))
        - sum(civfrt(conv(i),vv,v,f,r,t)$ccs(i), XTWH_C(i,vv,v,f,r,t) * capture_c(i,vv,v,f,r))
;

* Define CO2 emissions from upstream production and refining
* (based on upstream fuel use and capture rate coefficients, so that emissions are scaled to
* endgenous demands in electric-fuels model)
co2emit_ups(r,t)..
	CO2_UPS(r,t) =e=
* Carbon content of blend constituents
	sum(blendmap(f,ff), cc_ff(f) * (1 - capt_ups(f,r,t)) * QD_BLEND(f,"ups",ff,r,t)) +
* Carbon content of non-blended fuels
        sum(f$(not blend(f)), cc_ff(f) * (1 - capt_ups(f,r,t)) * QD_UPS(f,r,t))
;

* CO2 capture in upstream fossil sectors
co2capt_ups(f,r,t)..
	CO2_CAPT_UPS(f,r,t) =e=
* Carbon content of blend constituents
	sum(blendmap(f,ff), cc_ff(f) * capt_ups(f,r,t) * QD_BLEND(f,"ups",ff,r,t)) +
* Carbon content of non-blended fuels
        (cc_ff(f) * capt_ups(f,r,t) * QD_UPS(f,r,t))$(not blend(f))
;

* Define CO2 emissions from non-electric fuel transformation
co2emit_trf(r,t)..
	CO2_TRF(r,t) =e=
* Carbon content of blend constituents
	sum((sameas(dst,trf),blendmap(f,ff)), cc_ff(f) * QD_BLEND(f,dst,ff,r,t)) +
* Carbon content of non-blended fuels
        sum((trf,f)$(not blend(f)), cc_ff(f) * QD_TRF(f,trf,r,t))
* Plus non-atmosphere-neutral carbon content of biomass feedstocks
	+ sum(bfs, cc_bfs(bfs) * (1 - credit_bio(bfs)) * sum(bi, QD_BFS(bfs,bi,r,t)))
* Less CO2 captured and stored in transformation sectors
        - sum(fivrt(fi_ccs(fi),v,r,t), FX(fi,v,r,t) * capture_trf(fi,v))
* Assume any CO2 utilization comes out of this sector
	+ CO2_SYN(r,t)
;

* Define net CO2 removals from DAC
co2emit_dac(r,t)..
	CO2_DAC(r,t) =e= sum((dac,vt(v,t)), DACANN(dac,v,r,t));

* Supply of natural systems CDR (e.g. afforestation)
co2natlim(ncr,t).. sum(r, CO2_NAT(ncr,r,t)) =l= ncrcap(ncr,t);

* Direct CO2 emissions by end-use sector
buildings_co2(r,t)..
	CO2_BLD(r,t) =e= sum(f, cc_ff(f) * FE_BLD(f,r,t));

industry_co2(r,t)..
	CO2_IND(r,t) =e= sum(f, cc_ff(f) * FE_IND(f,r,t)) + co2_proc_ind(r,t) - co2_capt_ind(r,t) - sum(kf$(sameas(kf,"ind-sm") or sameas(kf,"ind-lg")), co2_fne(kf,r,t));
* In future may want to break out industrial capture by fuel
* - sum(f, co2_capt_ind(f,r,t));

transport_co2(r,t)..
	CO2_TRN(r,t) =e= sum(f, cc_ff(f) * FE_TRN(f,r,t)) - co2_fne("mdhd",r,t);

* National economy-wide CO2 emissions accounting
* CO2_EMIT is equal to:
*   sectoral sum (CO2_ELE + CO2_UPS + CO2_TRF + CO2_BLD + CO2_TRN + CO2_IND)
*   less non-sector-level removals (- CO2_DAC - CO2_NAT)
* This identity is confirmed in secco2_rpt

emissions_co2(r,t).. CO2_EMIT(r,t) =e=
* Carbon content of primary fuels (included flaring)
	sum(fos(f), cc_ff(f) * (QSF(f,r,t) - NTX(f,r,t)$f_trd(f)))
* plus non-atmosphere-neutral carbon content of biomass feedstocks
	+ sum(bfs, cc_bfs(bfs) * (1 - credit_bio(bfs)) * sum(bi, QD_BFS(bfs,bi,r,t)))
* plus industrial process emissions (e.g. limestone in cement, before capture) 
	+ co2_proc_ind(r,t)
* less CO2 fixed in non-energy products (reported from enduse model by sector)
	- sum(kf, co2_fne(kf,r,t))
* less captured CO2 injected into underground geologic storage
	- sum(cstorclass, CSTOR(cstorclass,r,t))
* less captured CO2 exported to a neighboring region
        - sum(rr$capcost_pc("%co2trscn%",rr,r), PX(r,rr,t) - PX(rr,r,t))
* less CO2 fixed in natural systems (credits purchased by region)
	- sum(ncr, CO2_NAT(ncr,r,t))
;

* Energy-related methane (assumed emissions rates associated with primary production and delivered gas)
* With additional data this could vary by region
emissions_ch4(r,t).. CH4_EMIT(r,t) =e= sum(fos(f), ch4_rate(f,t) * QSF(f,r,t)) + sum(dst, ch4_rate("ppg",t) * QS_BLEND(dst,"ppg",r,t));

* Calculate a variable for CO2 plus energy-related CH4
emissions_co2e(r,t).. CO2E_EMIT(r,t) =e= CO2_EMIT(r,t) + CH4_EMIT(r,t);

* Calculate US total emissions
ustotal_co2(t).. CO2_US(t) =e= sum(r, CO2_EMIT(r,t));
ustotal_co2e(t).. CO2E_US(t) =e= sum(r, CO2E_EMIT(r,t));

* * CO2 cap policies

* National economy-wide CO2 market
carbonmarket(t)$(co2cap(t,"%cap%") and (co2cap(t,"%cap%") < inf) or zerocap(t,"%cap%"))..
        co2cap(t,"%cap%") - NBC(t) + SV(t) =g= CO2_US(t)
;

* National economy-wide CO2-eq market
carboneqmarket(t)$(co2eqcap(t,"%capeq%") and (co2eqcap(t,"%capeq%") < inf) or zeroeqcap(t,"%capeq%"))..
        co2eqcap(t,"%capeq%") - NBC_EQ(t) + SV_EQ(t) =g= CO2E_US(t)
;

* Regional economy-wide CO2 markets (California AB32 and NY SB6559 specified separately)
carbonmarket_rg(r,t)$(co2cap_rg(r,t,"%cap_rg%") and (co2cap_rg(r,t,"%cap_rg%") < inf) or zerocap_r(r,t,"%cap_rg%"))..
        co2cap_rg(r,t,"%cap_rg%") - NBC_RG(r,t) =g= CO2_ELE(r,t) + CO2_UPS(r,t) + CO2_TRF(r,t) + CO2_BLD(r,t) + CO2_TRN(r,t) + CO2_IND(r,t) - CO2_DAC(r,t)
;

* National electric sector CO2 market
carbonmarket_ele(t)$(co2cap_ele(t,"%cap_ele%") and (co2cap_ele(t,"%cap_ele%") < inf) or zerocap_ele(t,"%cap_ele%"))..
        co2cap_ele(t,"%cap_ele%") - NBC_ELE(t) + SV_ELE(t) =g= sum(r, CO2_ELE(r,t))
;
* Intertemporal constraints on banked credits for CO2

itnbc..
        sum(t$((co2cap(t,"%cap%") or zerocap(t,"%cap%")) and t.val le 2050), NBC(t) * nyrs(t)) =e= 0;

itnbceq..
        sum(t$((co2eqcap(t,"%capeq%") or zeroeqcap(t,"%capeq%")) and t.val le 2050), NBC_EQ(t) * nyrs(t)) =e= 0;

itnbc_rg(r)..
        sum(t$(co2cap_rg(r,t,"%cap_rg%") and t.val le 2050), NBC_RG(r,t) * nyrs(t)) =e= 0;

itnbc_ele..
        sum(t$((co2cap_ele(t,"%cap_ele%") or zerocap_ele(t,"%cap_ele%")) and t.val le 2050), NBC_ELE(t) * nyrs(t)) =e= 0;


* Cumulative banked credits for CO2 - when CBC is constrained to be positive, borrowing is not allowed

cbcdf(t)..
        CBC(t) =e= sum(tt$((co2cap(tt,"%cap%") or zerocap(tt,"%cap%")) and tt.val le t.val), NBC(tt) * nyrs(tt));

cbcdfeq(t)..
        CBC_EQ(t) =e= sum(tt$((co2eqcap(tt,"%capeq%") or zeroeqcap(tt,"%capeq%")) and tt.val le t.val), NBC_EQ(tt) * nyrs(tt));

cbcdf_rg(r,t)..
        CBC_RG(r,t) =e= sum(tt$(co2cap_rg(r,tt,"%cap_rg%") and tt.val le t.val), NBC_RG(r,tt) * nyrs(tt));

cbcdf_ele(t)..
        CBC_ELE(t) =e= sum(tt$((co2cap_ele(tt,"%cap_ele%") or zerocap_ele(tt,"%cap_ele%")) and tt.val le t.val), NBC_ELE(tt) * nyrs(tt));


* * Operating Reserves Constraints
$iftheni.opconstraints not %opres%==no

* Spinning reserve requirement (GW)
spinreqdef(s,r,t)..
        SPINREQ(s,r,t) =e=
*       Contingency reserves (fixed % of load in each segment, spinning fraction)
                orreq_ld("cont") * orfrac("spin") * load(s,r,t)
*       Frequency regulation reserves (fixed % of load in each segment)
              + orreq_ld("freq") * load(s,r,t)
*       VRE forecast error reserves (fixed % of wind/solar output in each segment)
              + orfrac("spin") * orreq_vr * sum(ivfrt(irnw,v,f,r,t), X(s,irnw,v,f,r,t))
;

* Quick-start reserve requirement (GW)
qsreqdef(s,r,t)..
        QSREQ(s,r,t) =e=
*       Contingency reserves (6% of load in each segment, quick-start fraction)
                orreq_ld("cont") * orfrac("quik") * load(s,r,t)
*       Frequency regulation reserves (assumed to be spinning only)
*       VRE forecast error reserves (fixed % of wind/solar output in each segment)
              + orfrac("quik") * orreq_vr * sum(ivfrt(irnw,v,f,r,t), X(s,irnw,v,f,r,t))
;

* Spinning reserve market in each segment
srreqt(s,r,t)$(t.val > %tbase%)..
        hours(s,t) * (sum(ivrt(sri,v,r,t), SR(s,sri,v,r,t)) + sum(j, SRJ(s,j,r,t))) =g= hours(s,t) * SPINREQ(s,r,t);

* Quick-start reserve market in each segment
qsreqt(s,r,t)$(t.val > %tbase%)..
        hours(s,t) * (sum(ivrt(qsi,v,r,t), QS(s,qsi,v,r,t)) + sum(j, QSJ(s,j,r,t))) =g= hours(s,t) * QSREQ(s,r,t);

* Spinning reserve only available when unit is generating (assume that amount of spinning reserve cannot be more than what is being generated in a given segment)
* Implicit that a unit can provide up to half its capacity as spinning reserve (tempered by srramp constraint below)
srav(s,ivrt(i,v,r,t))$sri(i)..
        SR(s,i,v,r,t) =l= sum(ivfrt(i,v,f,r,t), X(s,i,v,f,r,t));

* Spinning reserves can only be provided up to a fraction of nameplate capacity corresponding to ramp capability
srramp(s,ivrt(i,v,r,t))$(sri(i) and ramprate(i))..
        SR(s,i,v,r,t) =l= (ramprate(i) / 100) * XCS(s,i,v,r,t);

* Storage definition for mutually exclusive provision of energy and reserve services
stordef(s,j,r,t)..      SRJ(s,j,r,t) + QSJ(s,j,r,t) + GD(s,j,r,t) + G(s,j,r,t) =l= GC(j,r,t);

$endif.opconstraints



* * * * * * * * Model Statement * * * * * * * * * * *

model regenelecfuels /
* * * * Objective function
        objdef

* * * * Electricity market clearance conditions
        elebal, enduseload

* * * * Constraints on electricity dispatch
        capacity, capacity_c, capacitymin, capacitymin_c, tcapacity, 
* Option to fix capacity factor for some technologies
$ifi %free%==no	    capacityfx, capacityfx_c
        fuellim, fuellim_c, cflim, cflim_dfcc, cflim_c
$ifi not %incl111%==no cflim_111b
        peakgrid, xtwhdef, xtwhdef_c, gridtwhdef, copyxc, copyxc_c
        elecfueldemand, elecppgudemand, blend_eleppgu
* Reserve requirements if switched on
$ifi not %reserve%==no resmargin, reserve
* Electricity storage
* %storage% switch 
$iftheni.store not %storage%==no
            chargelim, dischargelim, storagebal, storagelim, storageratio
* Storage can be represented with full chronology (requires 8760) or approximate chronology with p_ssm, or no chronology (annual sum only, no room constraint)
* Annual storage balance constraint must be applied if PSSM is used
$ifi not %pssm%==no storagebal_ann
* If specified include fixed storage capacity (only sensible in static mode as same target applied for all years)
$ife %stortgt%>0 storagefx, storagefxlo
$endif.store

* * * * Fuels market clearance conditions
        fuelbal, fuelbal_blend, fuelbal_eh, blend_tot, segment_blend 
        fueltrade, ups_inputs
* * * * Constraints on fuels dispatch
        blend_max, blend_h2, blend_mgs, buildings_fe, industry_fe, transport_fe
        capacity_trf, hcapacity, tcapacity_h, hproddef, copyhc, supply_trf, inputs_trf
        henduse_blend_s, inputs_h2efuel, inputs_eleefuel, carbon_syn
        bfs_balance, bfsinputs_bfl, nreinputs_bfs
$ifi not %htse%==no htseprod, htseprod_c, hthermal
* Hydrogen storage        
* %hstorage% switch refers to inclusion of hydrogen door constraints
* note these can be included even if hydrogen room constraint is not
$ifthen.hstor not %hstorage%==no
            chargelim_h, dischargelim_h, netcharge_h, storageratio_h, einputs_h2i
* %storage% switch refers to electric storage door/room constraint and hydrogen room constraint
$ifthen.hstorroom not %storage%==no
                storagebal_h, storagelim_h
* Annual hydrogen storage balance constraint must be applied if %storage% is on but PSSM is used
$ifi %pssm%==yes storagebal_ann_h
* or if %storage% is off
$else.hstorroom
                storagebal_ann_h
$endif.hstorroom
$endif.hstor

* * * * Constraints on dispatch of CO2 transport and storage and DAC
        co2balance, co2storcap, co2_inputs, co2pcapacity, co2injcapacity
        daccapacity, edaccapacity, annualdac, inputs_dac, einputs_dac

* * * * End-use sectors (if specified as endogenous, generally only in dynamic model)
$if not %eeusolve%==no allocation_vdi, allocation_xv, market_nnrd, lifetime_new, retire_eu, changerate, fueluse_eu, elecuse_eu
$if not %flexload%==no flexload_twh, flexload_gw, copycflx
* Data center demand
        dc_demand

* * * * Capacity and Investment Constraints depend on mode
* dynamic mode (default):      intertemporal optimization of capacity and dispatch
* dynfx mode (%dynfx%==yes):   single year optimization of capacity rental and dispatch (some capacity fixed)
* statfx mode (%statfx%==yes): single year optimization of dispatch only (all capacity fixed) 

* *  Constraints included in dynamic and dynfx modes but excluded in statfx mode
$iftheni.statfx %statfx%==no
* Electric sector (constraints on new capacity additions)
            capacitylim, capacitylim_c, solarlim, windrepowerlim
            investlim, usinvestlim, tinvestlim, tusinvestlim
$endif.statfx

* *  Investment constraints (included in dynamic mode, modified in dynfx mode, excluded in statfx mode)
$iftheni.dfinv %dynfx%==no
$iftheni.statfx %statfx%==no
* Dynamic mode investment constraints:
* Electric sector
                invest, invest_c, tinvest, newunitslo
                convbalance, retire, retire_c, retiremon, retirelife, convert1, convgassch, convbiosch, dacretire
$ifi not %storage%==no ginvestc, ginvestr
* State nuclear support equation and coal/gas share equations only apply in dynamic model
$ifi %nuczec%==yes  nucst
$ifi not %iija45u%==no	nuc_iija45u
$ifi %nucexlb%==yes     nuc_nzlo
$ifi not %coalgas20%==no coal2020, gas2020_25
* Fuels sector
                invest_trf, tinvest_h
                convbalance_trf, retire_trf, retiremon_trf, retirelife_trf, convert1_trf 
$ifi not %hstorage%==no ginvestc_h
$ifi not %storage%==no ginvestr_h
* CO2 transport and DAC
                co2injinvest, co2pinvest, dacinvest            
$endif.statfx
* In dynfx mode, some investment/rental is allowed (different versions for electric sector)	
$elseifi.dfinv %dynfx%==yes
            investstatic, tinveststatic, tinvestlimstatic
$ifi not %storage%==no ginvestc, ginvestr
            invest_trf, tinvest_h, co2injinvest, co2pinvest, dacinvest
$ifi not %hstorage%==no ginvestc_h
$ifi not %storage%==no ginvestr_h
$endif.dfinv


* * * * Emissions tracking
        co2emit_ele, co2emit_ups, co2capt_ups, co2emit_trf, co2emit_dac, co2natlim
        buildings_co2, industry_co2, transport_co2
        emissions_co2, emissions_ch4, emissions_co2e, ustotal_co2, ustotal_co2e
* * * * Policy constraints

* When an emissions cap is specified, carbon and non-co2 market conditions are included:
$ifi not %RGGI%==off     rggimarket, itnbc_rggi, cbcdf_rggi
$ifi not %NY_SB6599%==no carbonmarket_ny, carbonmarket_ny_ele
$ifi not %CA_AB32%==no   carbonmarket_ca
$ifi not %cap%==none     carbonmarket, itnbc, cbcdf
$ifi not %capeq%==none   carboneqmarket, itnbceq, cbcdfeq
$ifi not %cap_rg%==none  carbonmarket_rg, itnbc_rg, cbcdf_rg
$ifi not %cap_ele%==none carbonmarket_ele, itnbc_ele, cbcdf_ele
$ifi not %noncap%==none  csapr_r, csapr_trdprg, itnbc_csapr, cbcdf_csapr

* When 45V is specified, associated ZERC markets are included
$ifi not %elys45v%==no    zercmkt_45v, zercmkt_ann45v, zercmkt_annusa45v, hourly_zerc_sum45v
* When voluntary CFE procurement is included, associated ZERC markets are included
$ifi not %cfe247%==no	  zercmkt_cfe, zercmkt_anncfe, zercmkt_usacfe, hourly_zerc_sumcfe, cfe_demand
$ifi not %cfe_cdr%==no	  cfe_nz
* When either 45V or voluntary CFE is included, joint ZERC markets are included
$iftheni.zerc not %elys45v%==no
	hourly_zerc, annual_zerc
$elseifi.zerc not %cfe247%==no
	hourly_zerc, annual_zerc
$else.zerc
$endif.zerc

* A Federal RPS constraint can be included if indicated:
$ifi not %rps%==none      fedrps
$ifi not %rps_full%==none fullrps, fullrps_h

* State RPS constraints can be included if indicated:
$ifi %srps%==yes     staterps, recmkt, rpcgen, rpctrn, rpcflow, rpsimports, rpssolar, wnosmandate

* A Federal Clean Energy Standard can be included if indicated:
$iftheni.ces NOT %ces%==none
       cesmkt, cestotdef, cestrade, cesmkt_h, bcegen, bcetrn, bceflow
$endif.ces

* California SB100 can be included if indicated:
$ifi %CA_SB100%==yes         sb100ces, bcegen_ca, bcetrn_ca, bceflow_ca, uidef_ca

* CSP thermal storage equations can be included if indicated (requires static model):
$iftheni.cspstore %cspstorage%==yes
$iftheni.staticcspstore not %static%==no
capacity_csp_cr, storagebal_csp, dispatch_csp, storagelim_csp
$else.staticcspstore
$abort 'Cannot use CSP thermal storage equations without the static model'
$endif.staticcspstore
$endif.cspstore

* * * * Operational reserve constraints can be included if indicated:
$ifi not %opres%==no    srav, srreqt, spinreqdef, qsreqdef, qsreqt, srramp, stordef
/;

* <><><><><><><><><><><><><>
* regen_model.gms <end>
* <><><><><><><><><><><><><>
