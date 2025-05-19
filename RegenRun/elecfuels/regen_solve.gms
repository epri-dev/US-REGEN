* ----------------------
* regen_solve.gms
* ----------------------
* REGEN Electric+Fuels Model
* Solve model

$setlocal marker "%titlelead% solve"
put putscr;
put_utility  "title" / "%marker%" /  "msg" / "==== %marker% ====" /  "msg" / " " /;

$if not set solver $set solver cplex
option qcp=%solver%;

regenelecfuels.optfile = 1;
regenelecfuels.holdfixed = 1;
regenelecfuels.reslim=72000;
solve regenelecfuels using qcp minimizing Z;

$ontext
if(regenelecfuels.solvestat gt %Solvestat.Normal Completion%,
  display "Solver %solver% execution failed with status:", regenelecfuels.solvestat;
  abort "";
);
if(regenelecfuels.modelstat gt %ModelStat.Locally Optimal%,
  display "Solver %solver% found no optimal solution:",    regenelecfuels.modelstat;
  abort "";
);
$offtext

* * * * * * * * * * * * * * * * * * * Report solution * * * * * * * * * * * * * * *
$label report

put putscr;
$setlocal marker "%titlelead% reporting"
put_utility  "title" / "%marker%" /  "msg" / "==== %marker% ====" /  "msg" / " " /;

* Reporting calculations occur in a separate file restarting from regenelecfuels
$setglobal rptgdx %elecrpt%\%scen%_it%iter%.elec_rpt

* <><><><><><><><><><><><><>
* regen_solve.gms <end>
* <><><><><><><><><><><><><>
