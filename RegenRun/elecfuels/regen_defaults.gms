* ----------------------
* regen_defaults.gms
* ----------------------
* REGEN Electric+Fuels Model
* Control parameter default values and alternative options

* Scenario definition
$if not set endusescen    $setglobal endusescen    %scen%    !! The end-use model scenario for load should be the same as the current scenario except for static runs starting from the results of an integrated run
$if not set enduseiter    $setglobal enduseiter    0         !! The end-use model output filenames will include 'it0' if an iteration number was not specified 
* endusesceniter option - if set to yes, then endusescen is used only if end-use model input files for %scen% do not exist
* this allows a sensitivity case to start based on an existing run but use the new run for subsequent iterations
$if set endusesceniter $if exist %elecdata%\endusescen\%scen%\enduse_elecfuels_%scen%_it1.gdx $setglobal endusescen %scen%

* Currency year for dollar figures (should be consistent with setting in upstream)
$if not set curryr        $setglobal curryr        2023

* Static model controls
$if not set static        $setglobal static        no        !! If set to a year, runs static model for that year (default is no)
$if not set dynfx         $setglobal dynfx         no        !! If set to yes, static model is run with some capacity fixed to results from a previous dynamic run (need to set dynfx_scen)
$if not %dynfx%==no       $setglobal static        %dynfx_year%  !! If dynfx is set to yes, dynfx_year must also be specified
$if not set gdynfx        $setglobal gdynfx        no        !! If set to yes, uses electricity storage capacity from dynamic model solution in the static model (need to set dynfx_scen)
$if not set dynfx_prev	  $setglobal dynfx_prev    no	     !! Set to previous static run to use earlier investments for certain technologies as lower bounds in dynfx run
$if not set dynfx8760     $setglobal dynfx8760     no        !! Combined switch for static + dynfx + seg=8760
$if not set statfx        $setglobal statfx        no        !! If set to yes, static model is run with all capacity fixed to results from a previous dynamic run (need to set statfx_scen)
$if not %statfx%==no      $setglobal static        %statfx_year%  !! If statfx is set to yes, statfx_year must also be specified
$if not set statfx8760    $setglobal statfx8760    no        !! Combined switch for static + statfx + seg=8760
$if not set baseyronly    $setglobal baseyronly    no        !! Set to 'yes' to run only the base year

* Control Variable dynfx8760 -> This is set to the year in dynamic model run that you want to run in static dynfx 8760 mode
* Turning this on also turns on storage by default
$ifthen not %dynfx8760%==no
$setglobal static %dynfx8760%
$setglobal dynfx yes
$setglobal seg 8760
$setglobal storage yes
$endif

* Control Variable statfx8760 -> This is set to the year in dynamic model run that you want to run in static statfx 8760 mode
* Turning this on also turns on storage by default
$ifthen not %statfx8760%==no
$setglobal static %statfx8760%
$setglobal statfx yes
$setglobal seg 8760
$setglobal storage yes
$endif

* Dynamic model chronology controls
$if not set seg           $setglobal seg           120       !! Default segments should match resolution of hour choice algorithm
* In some cases, need to use %tbase% rather than the set tbase(t) to ensure compatibility with static mode
$if not set tbase         $setglobal tbase         2015
$if not set modlife       $setglobal modlife       yes       !! Apply model time horizon adjustment to capital costs to mitigate end effects
$if not %static%==no      $setglobal modlife       no        !! Turn off modlife adjustment in static mode

* General economic assumptions
$if not set drate         $setglobal drate         0.07      !! Annual discount rate
$if not set tk            $setglobal tk            0.2       !! Investment tax rate
* tk represents a tax on returns to capital, applied to new investments, recognizing that
* the NPV of returns equals investment cost in the optimality conditions

* Load/fuel price assumptions
$if not set baseline      $setglobal baseline      no        !! Sets both load and fuel prices from the same source
$if not %baseline%==no    $setglobal baseline_pf   %baseline%
$if not %baseline%==no    $setglobal baseline_ld   %baseline%
$if not set baseline_pf   $setglobal baseline_pf   aeo23     !! Sets fuel prices (alternatives are 'aeo2023hogr' and 'aeo2023logr')
$if not set pf_shock      $setglobal pf_shock      no        !! Combine with fixIX for a fuel price shock at time fixIX
$if not set flatgas       $setglobal flatgas       no        !! Override natual gas price path with a specific number in $ per MMBtu (flat in real dollar terms through time)
$if not set reserve       $setglobal reserve       yes       !! Set to 'no' to turn off planning reserve margin requirement
$if not set rsvmarg       $setglobal rsvmarg       0.12      !! Value of planning reserve margin (applied to all regions)
$if not set bs            $setglobal bs            yes       !! Backstop (demand response) turned on (alternative is 'no')

* Technology assumptions
$if not set htrate	  $setglobal htrate	   a	     !! Use 'a' for average (default) and 'f' for fully loaded heat rate (also affects emissions and capture rates)
$if not set rnwtlc        $setglobal rnwtlc        regen_mid !! Renewable technology learning curves default to 'regen_mid' (alternatives are currently regen* and abt* scenarios)
$if not set stortlc       $setglobal stortlc       regen_mid !! Electricity storage technology learning curves default to 'regen_mid' (alternatives are currently regen* and abt* scenarios)
$if not set advnuc	  $setglobal advnuc	   no        !! Advanced nuclear technology with optimistic cost declines (alternative is 'yes' to make available)
$if not set h2gen	  $setglobal h2gen	   yes	     !! Hydrogen use for generation in combustion and combined cycle turbines (alternative is 'no' to make unavailable)
$if not set drcost        $setglobal drcost        50000     !! Demand response (backstop demand) cost ($ per MWh)
$if not set dacscn        $setglobal dacscn        ref       !! DAC cost and performance scenario (alternative is 'adv')
$if not set cstorscen     $setglobal cstorscen     pess      !! CO2 storage cost and resource scenario (alternatives are 'ref' and 'opt', or 'old' for earlier formulation)
$if not set co2trscn	  $setglobal co2trscn	   high	     !! CO2 transport cost scenario (alternative is 'low')
$if not set windcstadj    $setglobal windcstadj    1         !! Scale the capital costs of wind (relative to reference values)
$if not set solcstadj     $setglobal solcstadj     1         !! Scale the capital costs of solar (relative to reference values)
$if not set ngcapadj      $setglobal ngcapadj      1         !! Scale the capital costs of natural gas combined cycle and combustion turbines (relative to reference values)
$if not set ccscost       $setglobal ccscost       1         !! Scale the capital costs of CCS for power generation (relative to reference values)
$if not set biofcost      $setglobal biofcost      2         !! Scale the capital costs of biofuel costs (relative to reference values) (default is 2x, optimistic alternative is 1x)
$if not set elyscost      $setglobal elyscost      1         !! Scale the capital costs of electrolysis technologies (relative to reference values)
$if not set elystlc	  $setglobal elystlc	   regen_hi  !! Technology learning curves for electrolysis (alternatives are 'regen_mid' and 'regen_lo')
$if not set hhg           $setglobal hhg           no        !! Force higher (forecourt-scale) hydrogen storage costs (alternative is 'yes')
$if not set croplim       $setglobal croplim       0.14      !! Scalar on energy crop supply curve (default is limited to 0.14, alternative is up to 1 for full supply curve)
$if not set credit_bio    $setglobal credit_bio    1         !! Fraction of bioenergy credited as carbon neutral
$if not set opres         $setglobal opres         no        !! Operating reserve requirements turned off by default due to computational cost (alternative is 'yes')
$if not set orvre         $setglobal orvre         0.1       !! Operating reserve requirement for variable renewable output
$if not set tdc           $setglobal tdc           tdc_md    !! T&D cost scenarios (for adder to renewables)
$if not set tdc_rtl       $setglobal tdc_rtl       tdc_md    !! T&D cost scenarios (for adder to retail prices)
$if not set tdcost	  $setglobal tdcost	   elec	     !! Source of retail T&D costs (use 'end' for iteratively updated retail adders from end-use model and alternative of 'elec')
$if not set mdhd_rate     $setglobal mdhd_rate     0.1       !! Upper bound on rate of change in MD-HD technology adoption
$if not set y_shp         $setglobal y_shp         2015      !! Representative year for wind solar load shapes
$if not set flexload	  $setglobal flexload	   no	     !! Can be set to a value between 0 and 1 to allow flexible allocation of corresponding share of data center load
$if not set cfadj         $setglobal cfadj         no        !! Adjusts the availability factors of variable technologies to better match the hourly data (alternative is 'yes')
$if not set fomx0         $setglobal fomx0         no        !! Remove fixed O&M costs on existing capacity if specified (alternative is 'yes')

* Restriction on new generation additions and retirements
$if not set usinvscn      $setglobal usinvscn      ref       !! US per-period investment limits for all technologies (alternative is 'unlim')
$if not set xcllife       $setglobal xcllife       default   !! Existing coal lifetimes (specified in years or use 'default')
$if not set nonewcoal     $setglobal nonewcoal     2015      !! This is the year after which no new coal without CCS can be built
$if not set nonewgas      $setglobal nonewgas      2080      !! This is the year after which no new NGCC capacity (or dual-fuel CC capacity) without CCS can be built
$if not set noelecgasu    $setglobal noelecgasu    2080      !! This is the year after which no fossil gas can be used for electric generation
$if not set coalgas20     $setglobal coalgas20     yes       !! Set to 'yes' to restrict coal subtractions / gas additions in 2020 and 2025 for calibration
$if not set ccslim        $setglobal ccslim        no        !! Turns off all CCS technologies if set to 'yes'
$if not set crb4          $setglobal crb4          no        !! Restrict coal CCS retrofits before given year if specified
$if not set nuc60         $setglobal nuc60         no        !! Set to 'yes' to set all existing nuclear unit lifetimes to 60 years (or planned retirement if earlier)
$if not set nuclim        $setglobal nuclim        no	     !! Set to 'yes' to turn all of new nuclear from 2025 forward

* Restriction on transmission
$if not set allowtrans    $setglobal allowtrans    yes       !! Set to 'no' to fix transmission as exogenous in the static model
$if not set tgrow         $setglobal tgrow	   yes	     !! Alternative is 'no', which turns off limits on rate of transmission growth
$if not set tuslimscn     $setglobal tuslimscn     unlim     !! Upper bound on US total per-period inter-regional capacity additions (alternative is 'none' without new transmission)
$if not set notrn         $setglobal notrn         no        !! Set to 'yes' to turn off all new transmission investments
$if not set texasent      $setglobal texasent      no        !! Restricts transmission additions in and out of Texas to 1 GW per period

* Restrictions on other technologies
$if not set storage       $setglobal storage       yes       !! Include electricity storage ('yes' by default, set to 'yes' automatically in static dynfx mode, alternative is 'no')
$if not set cspstorage    $setglobal cspstorage    no        !! CSP thermal storage turned off by default (only turn on with static model)
$if not set hstorage      $setglobal hstorage      yes       !! Hydrogen storage door constraints 
$if not set h2trans	  $setglobal h2trans       no	     !! Hydrogen inter-regional transport (off by default due to computational cost)
$if not set stortgt       $setglobal stortgt       0         !! Exogenous lower bound for national total electricity storage capacity (GW excluding existing pumped hydro)
$if not set fixghours     $setglobal fixghours     no        !! Fixes electricity storage hours (relative size of room and door)
$if not set fixIX         $setglobal fixIX         no        !! Fixes generation and transmission investments up to the year specified by fixIX
$if not set pssm          $setglobal pssm          no        !! Approximate state space matrix for chronology to model electricity storage is off by default (alternative is 'yes')
$if not set htse	  $setglobal htse	   yes	     !! Include HTSE option for hydrogen production by default
$if not set nodac	  $setglobal nodac	   no	     !! Include direct air capture options (alternative is 'yes')

* Restriction on flexibility of dispatch
$if not set free          $setglobal free          no        !! Set to 'yes' to make all generation dispatchable
$if not set nucxmin	  $setglobal nucxmin	   0.7	     !! Minimum dispatch factor for existing nuclear (between 0 and 1 converts to 0 after 2030)

* CO2 policies
$if not set incl111       $setglobal incl111       no        !! Set to 'yes' to include updated Clean Air Act Section 111 rules for existing coal and new gas
$if not set cap           $setglobal cap           none      !! Set to a name (e.g. nzby50) corresponding to a target defined in regen_runtime.gms to implement a cap on U.S. economy-wide CO2
$if not set capeq         $setglobal capeq         none      !! Set to a name (e.g. nzby50) corresponding to a target defined in regen_runtime.gms to implement a cap on U.S. economy-wide CO2-eq
$if not set cap_rg        $setglobal cap_rg        none      !! No regional economy-wide CO2 caps used by default
$if not set cap_ele       $setglobal cap_ele       none      !! Set to a name (e.g. cap80) corresponding to a target defined in policydata.xlsx to implement a cap on U.S. wide electric sector CO2
$if not set ncrlim        $setglobal ncrlim        0.25      !! Scale allowable natural CO2 removal offsets, alternative values up to 1 (could increase for feasibility in early iterations)
$if not set bank          $setglobal bank          no        !! Allow banking of credits for economy-wide CO2 cap (alternative is 'yes')
$if not set borrow        $setglobal borrow        no        !! Allow borrowing of credits for economy-wide CO2 cap (alternative is 'yes')
$if not set CA_AB32       $setglobal CA_AB32       yes       !! Set to 'no' to turn off AB32 (CA economy-wide net-zero by 2045)
$if not set CA_SB100      $setglobal CA_SB100      yes       !! Set to 'no' to turn off SB100 (CA clean energy standard for electric sector)
$if not set NY_SB6599     $setglobal NY_SB6599     yes       !! Set to 'no' to turn off SB6599 (NY zero electric sector CO2 by 2040 and economy-wide 2050 cap)
$if not set RGGI          $setglobal RGGI          yes       !! RGGI is turned on by default (alternative is 'off')
$if not set becslim       $setglobal becslim       no        !! Restrict bioenergy with CCS in the power sector (alternative is 'yes')
$if not set ctaxrate      $setglobal ctaxrate      %drate%   !! Annual growth rate of carbon tax (use discount rate as default)
$if not set ch4tax        $setglobal ch4tax        no        !! Apply CO2 tax to energy-related methane
$if not set svpr          $setglobal svpr          no        !! Safety valve emissions price for alternative compliance payments (if specified) ($ per tCO2)

* RPS and CES policies
$if not set rps           $setglobal rps           none      !! Federal RPS constraint ('none' by default, otherwise specify target scenario)
$if not set rps_full	  $setglobal rps_full	   none	     !! Federal RPS constraint forcing fully renewable generation
$if not set srps          $setglobal srps          yes       !! Existing state RPS constraints including offshore wind mandates (alternative is 'no')
* If running static statfx mode or dynfx mode without endogenous capacity investments, turn off state RPS to ensure feasibility
$if not %dynfx8760%==no $if not %i_end%==yes $setglobal srps no
$if not %statfx8760%==no                     $setglobal srps no
$if not set ces           $setglobal ces           none      !! Federal CES constraint ('none' by default, otherwise specify target and crediting scenario)
$if not set cestot_option $setglobal cestot_option totalload !! Definition of CES denominator (other options are 'en4load' and 'retailload')
$if not set cestax        $setglobal cestax        no        !! Specify scenario to reproduce CES with tax instrument
$if not set cesbecs	  $setglobal cesbecs	   no	     !! Set to 'yes' to allow a credit > 1 for BECCS under the CES
$if not set cesacp        $setglobal cesacp        no        !! Set minimum alternative compliance payment price for CES if not set to 'no'
$if not set cesbnk        $setglobal cesbnk        no        !! Set to 'yes' to turn on CES credit banking

* Other policy assumptions
$if not set noncap        $setglobal noncap        csapr     !! CSAPR policy constraint (alternative is 'none')
$if not set ira           $setglobal ira           yes       !! Include IRA incentives (alternative is 'no', where PTC/ITC/45Q revert to 2022 values and other incentives are turned off)
$if not set irarepeal	  $setglobal irarepeal     no        !! IRA repeal in 2026 (alternative is 'yes')
$if not set itc           $setglobal itc           yes       !! IRA 48E Investment tax credit (alternative is 'no' to remove entirely; use %ira%==no to revert to pre-IRA values)
$if not set ptc           $setglobal ptc           yes       !! IRA 45Y Production tax credit (alternative is 'no' to remove entirely; use %ira%==no to revert to pre-IRA values)
$if not set iraecbon_sol  $setglobal iraecbon_sol  0.5	     !! IRA energy communities bonus for solar (number between 0 and 1)
$if not set iraecbon_nuc  $setglobal iraecbon_nuc  0.5	     !! IRA energy communities bonus for nuclear (number between 0 and 1)
$if not set iraecbon_stor $setglobal iraecbon_stor 0.5	     !! IRA energy communities bonus for storage (number between 0 and 1)
$if not set cred45q       $setglobal cred45q       yes       !! 45Q CO2 subsidy (alternative is 'no')
$if not set cred45q35     $setglobal cred45q35     yes       !! IRA 45Q CO2 subsidy 2035 vintage eligibile (alternative is 'no')
$if not set elys45v       $setglobal elys45v       yes       !! IRA 45V hydrogen production subsidy for electrolysis (alternative is 'no')
$if not set ann45v        $setglobal ann45v	   no        !! IRA 45V subsidy could be based on annual (rather than hourly) carbon-free generation (alternative is 'yes')
$if not set ex45v         $setglobal ex45v	   no        !! IRA 45V subsidy could be based on existing (rather than new) carbon-free generation (alternative is 'yes')
$if not set usa45v        $setglobal usa45v	   no        !! IRA 45V subsidy could be based on national (rather than local) carbon-free generation and must be used with ann45v (alternative is 'yes')
$if not set free45v       $setglobal free45v	   no        !! IRA 45V subsidy could apply regardless of input generation (alternative is 'yes')
$if not set iija45u	  $setglobal iija45u       yes       !! IIJA and IRA 45U support for existing nuclear (alternative is 'no')
$if not set nuczec        $setglobal nuczec        yes       !! State nuclear ZEC support (alternative is 'no')
$if not set nucexlb       $setglobal nucexlb       yes       !! Stops nuclear from retiring in areas with zero emissions targets (alternative is 'no')

* Voluntary CFE procurement
$if not set cfe247	  $setglobal cfe247	   no	     !! Voluntary CFE procurement (24/7 or not) turned off by default (alternative is 'yes')
$if not set cfe247yr	  $setglobal cfe247yr      2035	     !! If CFE activated, first year of voluntary CFE procurement target
$if not set cfeshr_dc	  $setglobal cfeshr_dc     0.5	     !! If CFE activated, share of data center demand subject to voluntary CFE procurement
$if not set anncfe        $setglobal anncfe	   no        !! Voluntary CFE could be based on annual (rather than hourly or 24/7) carbon-free generation (alternative is 'yes')
$if not set usacfe        $setglobal usacfe	   no        !! Voluntary CFE could be based on national (rather than local) carbon-free generation and must be used with anncfe (alternative is 'yes')
$if not set excfe         $setglobal excfe	   no        !! Voluntary CFE could be based on existing (rather than new) carbon-free generation (alternative is 'yes')
$if not set cfem	  $setglobal cfem	   1	     !! Voluntary 24/7 CFE match share when hourly matching is specified (default is 1 = 100%)
$if not set cfe_vre	  $setglobal cfe_vre	   no	     !! Voluntary CFE could be based on variable renewables and batteries only (alternative is 'yes')
$if not set cfe_cdr	  $setglobal cfe_cdr	   no	     !! Allow CDR for 24/7 CFE procurement (alternative is 'yes')

* <><><><><><><><><><><><><>
* regen_defaults.gms <end>
* <><><><><><><><><><><><><>
