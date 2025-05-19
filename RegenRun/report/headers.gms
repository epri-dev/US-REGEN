* Define set names for chart output
set
header_card /Cardinality,Scenarios,Regions,Timesteps/
header_s /Scenarios/
header_r /Regions/
header_t /Timesteps/
scenarios
regions
timesteps
;

parameter
num_scenarios
num_regions
num_timesteps
;

$gdxin %regenreport%\%report%\%report%_report_%rptgroup%
$load scenarios=merged_set_1
$gdxin

$ifthen exist %regenreport%\%report%\%group%\reference.gdx
$gdxin %regenreport%\%report%\%group%\reference
$load regions=r, timesteps=t
$gdxin
$else
abort "Update reference filename in headers.gms"
$endif

regions("US48") = yes;

regions("east_rpt") = yes;
regions("south_rpt") = yes;
regions("midwest_rpt") = yes;
regions("west_rpt") = yes;


num_scenarios = card(scenarios);
num_regions = card(regions);
num_timesteps = card(timesteps);

execute_unload '%regenreport%\%report%\temp\headers_%report%_%rptgroup%.gdx', header_card, header_s, header_r, header_t, scenarios, regions, timesteps, num_scenarios, num_regions, num_timesteps;

$onecho >temp\headers.rsp
set=header_s   rng=scenarios!a1
set=scenarios  rng=scenarios!a3 cdim=0 rdim=1
set=header_r   rng=regions!a1
set=regions    rng=regions!a3 cdim=0 rdim=1
set=header_t   rng=timesteps!a1
set=timesteps  rng=timesteps!b2 cdim=1 rdim=0
set=header_card    rng=cardinality!a1 cdim=0 rdim=1
par=num_scenarios  rng=cardinality!b2
par=num_regions    rng=cardinality!b3
par=num_timesteps  rng=cardinality!b4
$offecho
;
