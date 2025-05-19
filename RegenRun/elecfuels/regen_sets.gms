* ----------------------
* regen_sets.gms
* ----------------------
* REGEN Electric+Fuels Model
* Set declarations and load (from upstream)

set
intorder                Universal integer ordering /0*10000/
;

* * * Time
set
s                       Load segments corresponding to representative hours
h                       All hours
w                       Weeks /1*53/
m                       Months /1*12/
v                       Vintages of electric generation and fuel transformation capacity
vbase(v)                First vintage for existing electric generation and fuel transformation capacity and anything older
newv(v)                 New vintages of electric generation and fuel transformation capacity
acv(v)                  Active vintages of electric generation and fuel transformation capacity
v_e                     Vintages for end-use sectors /1985,1990,1995,2000,2005,2010,2015,2020,2025,2030,2035,2040,2045,2050,2055,2060/
exv_e(v_e)              Existing vintages for end-use sectors /1985,1990,1995,2000,2005,2010,2015,2020/
newv_e(v_e)	        New vintages for end-use sectors /2025,2030,2035,2040,2045,2050,2055,2060/
t_all                   All possible time periods used in the model /
                        2015,2020,2025,2030,2035,2040,2045
                        2050,2055,2060,2065,2070,2075,2080,2085,2090,2095,2100
                        /

$iftheni not %static%==no
*       In static mode, a single time period is specified by the user
t(t_all)                Time periods /%static%/
vstatic(v)              Potentially active post-base-year vintages in static run
tbase_all(t_all)        Base year /%static%/
tbase(t)	        Base year /%static%/
$else
*       In dynamic mode, time periods included in model are identified here
$iftheni.onlybase %baseyronly%==yes
        t(t_all)        Time periods /2015/
$else.onlybase
        t(t_all)        Time periods /2015,2020,2025,2030,2035,2040,2045,2050/
$endif.onlybase
tbase_all(t_all)        Base year /2015/
tbase(t)	        Base year /2015/
$endif
sw(s,w,t)               Map between segments and weeks
sm(s,m,t)               Map between segments and months
ssm(s,s,t)              State space matrix approximating chronology between segments
tv(t,v)		        Time period in which vintage v is installed
tv_e(t,v_e)             Time period in which end-use sector vintage is installed
vt(v,t)                 Vintages active in time period t
;

parameter
tyr(t_all)              Time period year
vyr(v)                  Vintage year
;

$gdxin %elecdata%\elecgen_data
$load v, vbase, vyr

* New vintages are defined as all except base vintage
newv(v) = yes$(not vbase(v));

* Define tv (year associate with new vintage)
tyr(t_all) = t_all.val;
tv(t,v) = yes$sameas(t,v);
tv(t,"2050+") = yes$(tyr(t) ge 2050);
tv_e(t,v_e)$sameas(t,v_e) = yes;

* Define active vintages
acv(vbase(v)) = yes;
loop(t, acv(v)$tv(t,v) = yes;);

* Define vt over active vintages
$iftheni.staticv %static%==no
vt(acv(v),t) = yes$(vyr(v) le tyr(t));
$else.staticv
vt(acv(v),"%static%") = yes$(vyr(v) le %static%);
vstatic(v)$(vyr(v) le %static% and (not vbase(v))) = yes;
$endif.staticv


* * * Regions and Geographies
set
r                       Regions
csp_r(r)                Regions that can support concentrated solar power
sb100(r)                Regions in or adjacent to California with SB-100 eligible resources
cal_r(r)                Regions wholly included within California
nys_r(r)                Regions wholly included within New York state
rggi_r(r)	        Regions subject to RGGI CO2 Program
rpt                     Final four reporting regions
xrpt(rpt,r)             Map between regions and final four reporting regions
intrcon                 Interconnections
xintrcon(intrcon,r)     Map between regions and interconnections
linked(r,r)	        Adjacent regions potentially linked by fuel pipelines
;

* * * Electric Generation Technologies
set
i                       Electric generation technologies (capacity blocks)
type                    Electric generation capacity types
tech                    Aggregate technology categories
xcl(type)               Existing coal electric generation capacity types
class                   Capacity classes for certain electric generation types
idef(i,type)            Map from individual generation technologies to types
itech(i,tech)           Map from individual generation technologies to aggregate category
iclass(i,type,class)    Map to capacity classes
strd(i)	                Generation technologies before possible conversion (standard)
orig(i)	                Generation technologies eligible for conversion (original)
conv(i)                 Generation technologies that are conversions or retrofits
convmap(i,i)            Possible conversions (i1) for underlying eligible capacity blocks (i2)
new(i)                  New vintage generation technologies (excluding conversions)
xtech(i)                Existing technologies in use in base year
dspt(i)                 Dispatchable generation technologies (including variable renewables that can be curtailed)
ndsp(i)                 Non-Dispatchable generation technologies (fixed dispatch)
sol(i)                  Solar generation technologies
cspi(i)                 Concentrated solar thermal generation technologies
tsi(i)	                Generation technologies that can provide thermal output (for HTSE)
irnw(i)                 Variable renewable generation technologies
nuc(i)                  Nuclear generation technologies
ccs(i)                  CCS-equipped generation technologies
h2i(i)	                Hydrogen-fired electric generation technologies

nrps(i)                 Generation technologies not included in federal RPS denominator
nces(i)                 Generation technologies not included in federal CES denominator
i_end(i)                Capacity blocks for which new capacity rental is endogenous in static mode
i_end_lo(i)             Capacity blocks in i_end subject to lower bounds from previous rental solutions
iv_fix(i,v)             Capacity blocks and vintages for which capacity is fixed in static mode
capcost_zero(i,v)       Technology vintages with missing capital cost data

j		        Electric storage technologies
batt(j)                 Battery electric storage technologies

* Operating reserves formulation (optional)
sri(i)                  Set of units that can provide spinning reserve
qsi(i)                  Set of units that can provide quick start capability
;

* * * Non-electric fuels
set
f                       Fuels
prf(f)                  Primary fuels (excluding bio-feedstocks) 
fos(f)                  Primary fossil fuels
bfl(f)                  Biofuels derived from bio-feedstocks
rfp(f)                  Refined petroleum products
syn(f)                  Fuels produced from CO2-H2 synthesis
ef(f)                   E-fuels (electrolytic hydrogen and derivatives)
h2f(f)                  Hydrogen fuel pathways
trf(f)                  Transformation fuels (hydrogen ammonia biofuels synthesis or blends)
trf_nb(f)               Transformation sectors (excluding blends)
blend(f)                Fuels produced by blending
trfmap(f,f)             Map of eligible input fuels to transformation sectors (synthesis or blending)
blendmap(f,f)           Map from blending feedstocks to output fuels
f_ups(f)                Fuels that are inputs to upstream coal oil and gas and refining
f_ele(f)	        Fuels that are inputs to electric generation
f_dac(f)                Fuels that are inputs to direct air capture
f_trd(f)                Fuels that can be traded domestically or internationally (blends excluded)

df(f)                   Delivered fuels for end-use sectors

bfs                     Biomass feedstocks
bfsc                    Biomass feedstock supply classes
sec                     Economy model sectors
kf                      End-use sectors for fuel delivery
hk                      Hydrogen distribution points (central vs distributed)
hkf(hk,f)               Mapping between hydrogen distribution points and fuel versions
dst                     Delivered fuel destinations for blending decisions
dst_f(dst,f)            Eligible destinations for blended fuels
;

* * * Fuels transformation technologies
set
fi                      Fuel transformation technologies
fi_conv(fi)             Fuel transformation technologies that are conversions (retrofits)
fi_orig(fi)             Fuel transformation technologies that are eligible for conversion (original)
convmap_fi(fi,fi)       Map between original and conversion fuel transformation technologies
hi(fi)                  Electrolytic hydrogen and e-fuel technologies
elys(fi)                Electrolysis hydrogen production technologies
bi(fi)                  Biofuel transformation technologies
fi_ccs(fi)              Transformation technologies using CCS
himap(f,fi)             Mapping from fuels to technologies for e-fuels
hki(hk,fi)              Mapping between hydrogen production technologies and distribution points
bfsmap(fi,bfs)          Mapping from biofuel technologies to eligible feedstocks
dac                     Direct air capture technologies
edac(dac)		Electric-only direct air capture technologies
cstorclass              CO2 geologic storage resource classes
ncr                     Natural carbon removal options
;

* * * End-use sectors with endogenous representation in electric-fuels model
* Currently medium-/heavy-duty and non-road vehicles are the only endogenous sectors
* other sectors are represented as exogenous demands from separate end-use models
* Some exogenous demands can be represented with flexible dispatch in electric-fuels model
set
k2                      Detailed end-use sector categories
b(k2)                   Building sector categories
kfmap(kf,k2)            Mapping between end-use fuels sectors and detailed end-use sectors
u                       End-use service categories
vc                      Vehicle classes MD-HD and non-road
vc_mdhd(vc)             Vehicle classes MD-HD
vc_nnrd(vc)             Vehicle classes non-road
kfvc(kf,vc)             Mapping from end-use fuels sectors to vehicle classes for MD-HD and non-road
k2vc(k2,vc)             Mapping from detailed end-use sectors to vehicle classes for MD-HD and non-road
vht                     Vehicle technologies for MD-HD and non-road sectors
di                      Driving intensity classes MD-HD
vc_di(vc,di)            Eligible combinations 
vcht(vc,vht,v_e,t)      Eligible combinations
icevban(t)              Years in which ICEV ban is imposed on new sales
incumb(vc,vht)          Base year incumbent technologies
incumbban(t)            Years during which new sales of incumbent technology are banned
flx                     Flexible demand categories (only data centers for now) /dat/
;

* * * Policy eligibility
set
ptctv(t_all,v)          Time periods t in which vintage v can claim PTC
if_45v(i,f)             Technology-fuels qualified as zero carbon for 45V incentive
ifvt_45v(i,f,v,t)       Technology-fuel-vintages qualified for 45V incentive during subsidy period
if_cfe(i,f)             Technology-fuels qualified as zero carbon for CFE procurement targets
ifvt_cfe(i,f,v,t)       Technology-fuel-vintages qualified for CFE procurement targets
if_45y(i,f)             Technology-fuels qualified as zero carbon for 45Y incentive
t_iija45u(t)            Time periods where IIJA and 45U subsidies for existing nuclear are active
pol                     Pollutants /co2,ch4,so2,nox,co,nh3,voc,pm10-pri,pm25-pri/
ghg(pol)                Greenhouse gases /co2,ch4/
ogg(ghg)                Non-CO2 (other) greenhouse gases /ch4/
trdprg                  Trading programs for annual and seasonal emissions of non-co2 pollutants
trdprg_oz(trdprg)       Trading programs for ozone season emissions of non-CO2 pollutants
ozs(s,t)                Segments in ozone season
csapr_s(trdprg,s,t)     Segments covered by annual and seasonal non-CO2 trading programs
csapr_iv(pol,i,v)       Technologies covered by CSAPR constraints
zerocap(t,*)            Time steps in which a net-zero CO2 target is enforced
zeroeqcap(t,*)          Time steps in which a net-zero CO2-eq target is enforced
zerocap_r(r,t,*)        Time steps in which a net-zero CO2 target on regional economy-wide emissions is enforced
zerocap_ele(t,*)        Time steps in which a net-zero CO2 target on electric sector is enforced
;

* * * Cross dimension eligibility and identifiers
set
ir(i,r)	                Eligible technology-region combinations
ifl(i,f)                Eligible technology-fuel combinations
ivrt(i,v,r,t)           Active vintage-capacity blocks for standard technologies
ivfrt(i,v,f,r,t)        Active vintage-capacity block-fuel combinations for standard technologies 
civrt(i,v,v,r,t)        Active vintage-capacity blocks for conversion technologies
civfrt(i,v,v,f,r,t)     Active vintage-capacity block-fuel combinations for conversion technologies
fivrt(fi,v,r,t)         Active vintage-capacity blocks for fuel transformation technologies
peak(s,r,t)             Segment in which peak load occurs for each region and time step
;

* * * Assumption sensitivity cases
set
tlc                     Technology learning curve pathways
tdcscen	                Electricity transmission and distribution cost scenarios
co2trscn                CO2 transport cost scenarios
cstorscen               CO2 geologic storage scenarios
dacscn                  Direct air capture technology scenarios
;

* * * Data and reporting categories
set
xr                      Dispatch reporting categories (in order)
kr                      Capacity reporting categories (in order)
;

$load i, type, class, tech, sol, cspi, r, csp_r, sb100, rpt, xrpt, intrcon, xintrcon, trdprg, trdprg_oz, xr, kr, tlc, tdcscen, j, batt
$load sec, cal_r, nys_r, rggi_r, ptctv
$load sri, qsi
$load xcl, idef, iclass, itech, dspt, ndsp, strd, orig, conv, convmap, new, xtech, tsi
$load irnw, nuc, ccs, h2i, csapr_iv, nrps, nces
$load zerocap, zeroeqcap, zerocap_ele
$gdxin

$gdxin %elecdata%\h2fuels_data
$load linked, f, fos, bfl, rfp, syn, ef, trf=trf_nb, blend, trfmap, blendmap, f_ups, f_ele, f_dac, f_trd, df, hk, hkf
$load bfs, bfsc, kf, dst, dst_f, fi, fi_conv, fi_orig, convmap_fi, hi, elys, bi, fi_ccs, himap, hki, bfsmap, dac, edac, cstorclass, ncr
$load dacscn, co2trscn, cstorscen
$gdxin

h2f(f)$blendmap(f,"h2") = yes;

* Electric model sets indexed over fuels need to be read in after h2fuels_data
$gdxin %elecdata%\elecgen_data
$load if_45v
$gdxin

alias(f,ff);
alias(r,rr);
alias(s,ss);
alias(t,tt);
alias(i,ii);
alias(v,vv);
alias(v,vvv);

* <><><><><><><><><><><><><>
* regen_sets.gms <end>
* <><><><><><><><><><><><><>
