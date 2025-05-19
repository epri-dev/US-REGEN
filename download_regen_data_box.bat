@echo off

REM This script copies input data files to corresponding locations in the user's local directory

REM The Box link for direct download is:
REM https://epri.box.com/s/c97ncbyc7wvezs8239mjcafln9629w3g
REM - Click the down-arrow icon in the upper right corner to download all files and directory tree as
REM   a zip file called REGEN_Box.zip
REM - Extract this folder into the REGEN root directory, with RegenData and RegenReport as 
REM   parallel subfolders to RegenRun

REM This resets ERRORLEVEL environment variable to 0
REM doing 'set ERRORLEVEL=0' was resulting in errors with curl
cd.

echo:
echo --------- DOWNLOADING REGEN DATA FROM https://epri.app.box.com/ ------------
echo:

REM Create folders for downloaded data
if not exist ".\RegenData\elecfuels\sup16" mkdir ".\RegenData\elecfuels\sup16"
if not exist ".\RegenData\elecfuels\sup16\endusescen\nzby50_ref_def" mkdir ".\RegenData\elecfuels\sup16\endusescen\nzby50_ref_def"
if not exist ".\RegenData\elecfuels\sup16\endusescen\ref_ref_def" mkdir ".\RegenData\elecfuels\sup16\endusescen\ref_ref_def"
if not exist ".\RegenReport\Electric\template" mkdir ".\RegenReport\Electric\template"
if not exist ".\RegenReport\Sankey\template" mkdir ".\RegenReport\Sankey\template"


echo:
echo Downloading model input files...

echo Downloading "elecgen_data.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\elecgen_data.gdx" "https://epri.box.com/shared/static/zbk03wto5gy0yxnefu722db4qylginm7.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "elecgen_data.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "elecgen_data.gdx"!!!
goto eof
)
echo:

echo Downloading "h2fuels_data.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\h2fuels_data.gdx" "https://epri.box.com/shared/static/77dwzk55bcu1e0c32se0r78734mcb5dz.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "h2fuels_data.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "h2fuels_data.gdx"!!!
goto eof
)
echo:

echo Downloading "enduse_elecfuels_nzby50_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\nzby50_ref_def\enduse_elecfuels_nzby50_ref_def_it1.gdx" "https://epri.box.com/shared/static/pgyp4y0cpalbiuwcvy8xdfpgoi5v49kn.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "enduse_elecfuels_nzby50_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "enduse_elecfuels_nzby50_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "load_g_2015_nzby50_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\nzby50_ref_def\load_g_2015_nzby50_ref_def_it1.gdx" "https://epri.box.com/shared/static/sqw1wbl0am2tgp6tramz5s4yphpk0lwr.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "load_g_2015_nzby50_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "load_g_2015_nzby50_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "mdhd_elecfuels_nzby50_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\nzby50_ref_def\mdhd_elecfuels_nzby50_ref_def_it1.gdx" "https://epri.box.com/shared/static/b7lu9q45elb140hs5puze9fwaugzpq06.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "mdhd_elecfuels_nzby50_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "mdhd_elecfuels_nzby50_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "nnrd_elecfuels_nzby50_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\nzby50_ref_def\nnrd_elecfuels_nzby50_ref_def_it1.gdx" "https://epri.box.com/shared/static/g2t9nftskc4yywjx07l9n80hkj0tsqj5.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "nnrd_elecfuels_nzby50_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "nnrd_elecfuels_nzby50_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "rfpv_nzby50_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\nzby50_ref_def\rfpv_nzby50_ref_def_it1.gdx" "https://epri.box.com/shared/static/stl3bhv50xgpth2fgdthl6i0z81jlyji.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "rfpv_nzby50_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "rfpv_nzby50_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "segdata_120_nzby50_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\nzby50_ref_def\segdata_120_nzby50_ref_def_it1.gdx" "https://epri.box.com/shared/static/wvpk39z4ykehxrjhd2ummfjbtl1152zu.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "segdata_120_nzby50_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "segdata_120_nzby50_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "segdata_120_pssm_nzby50_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\nzby50_ref_def\segdata_120_pssm_nzby50_ref_def_it1.gdx" "https://epri.box.com/shared/static/muiu9pjpeq29v8rx4ouxp0yfep968stt.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "segdata_120_pssm_nzby50_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "segdata_120_pssm_nzby50_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "segdata_8760_nzby50_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\nzby50_ref_def\segdata_8760_nzby50_ref_def_it1.gdx" "https://epri.box.com/shared/static/9k66gvawevcwr0ms1urnkphtok7b72ct.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "segdata_8760_nzby50_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "segdata_8760_nzby50_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "tdcost_2015_nzby50_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\nzby50_ref_def\tdcost_2015_nzby50_ref_def_it1.gdx" "https://epri.box.com/shared/static/3d7ha65ncag8whyq5anqjd5bgu4uvw4p.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "tdcost_2015_nzby50_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "tdcost_2015_nzby50_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "enduse_elecfuels_ref_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\ref_ref_def\enduse_elecfuels_ref_ref_def_it1.gdx" "https://epri.box.com/shared/static/qgdo2bzkrdwoca318rk2ryqzgxb9ceuq.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "enduse_elecfuels_ref_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "enduse_elecfuels_ref_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "load_g_2015_ref_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\ref_ref_def\load_g_2015_ref_ref_def_it1.gdx" "https://epri.box.com/shared/static/y8z57egeuhnjwk5bhyko59licwfmx2eo.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "load_g_2015_ref_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "load_g_2015_ref_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "mdhd_elecfuels_ref_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\ref_ref_def\mdhd_elecfuels_ref_ref_def_it1.gdx" "https://epri.box.com/shared/static/8n8kts5yrssrjo84kizndcnwjtw07oq9.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "mdhd_elecfuels_ref_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "mdhd_elecfuels_ref_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "nnrd_elecfuels_ref_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\ref_ref_def\nnrd_elecfuels_ref_ref_def_it1.gdx" "https://epri.box.com/shared/static/09qlgfl2l5emmtx192t9g17uvba17hns.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "nnrd_elecfuels_ref_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "nnrd_elecfuels_ref_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "rfpv_ref_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\ref_ref_def\rfpv_ref_ref_def_it1.gdx" "https://epri.box.com/shared/static/n1sa0i6grs0h1duzf4vymptjia2s4iy4.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "rfpv_ref_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "rfpv_ref_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "segdata_120_pssm_ref_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\ref_ref_def\segdata_120_pssm_ref_ref_def_it1.gdx" "https://epri.box.com/shared/static/d913vck6i6t7bu72kksvka7nqddg6v6s.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "segdata_120_pssm_ref_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "segdata_120_pssm_ref_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "segdata_120_ref_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\ref_ref_def\segdata_120_ref_ref_def_it1.gdx" "https://epri.box.com/shared/static/ocvivp40mq13ajbcz8m5cwkrxltbrk6d.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "segdata_120_ref_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "segdata_120_ref_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "segdata_8760_ref_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\ref_ref_def\segdata_8760_ref_ref_def_it1.gdx" "https://epri.box.com/shared/static/han8cvd0fepogeq5wshwsks5oq5phjb8.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "segdata_8760_ref_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "segdata_8760_ref_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "tdcost_2015_ref_ref_def_it1.gdx"...
curl -k --location-trusted --http1.1 -o ".\RegenData\elecfuels\sup16\endusescen\ref_ref_def\tdcost_2015_ref_ref_def_it1.gdx" "https://epri.box.com/shared/static/vv058abimu24814mw9ju8zi79xxqwdc6.gdx"
if %ERRORLEVEL%==0 (
echo Download of file "tdcost_2015_ref_ref_def_it1.gdx" ok.
) else (
echo ERROR DOWNLOADING FILE "tdcost_2015_ref_ref_def_it1.gdx"!!!
goto eof
)
echo:

echo Downloading "electric_report.xlsm"...
curl -k --location-trusted --http1.1 -o ".\RegenReport\Electric\template\electric_report.xlsm" "https://epri.box.com/shared/static/8ytu5iimnaxqxsxv49r2162jh6947i67.xlsm"
if %ERRORLEVEL%==0 (
echo Download of file "electric_report.xlsm" ok.
) else (
echo ERROR DOWNLOADING FILE "electric_report.xlsm"!!!
goto eof
)
echo:

echo Downloading "sankey_report.xlsm"...
curl -k --location-trusted --http1.1 -o ".\RegenReport\Sankey\template\sankey_report.xlsm" "https://epri.box.com/shared/static/1s2cgaompnwyjr8jdehv8ig1egofj8f2.xlsm"
if %ERRORLEVEL%==0 (
echo Download of file "sankey_report.xlsm" ok.
) else (
echo ERROR DOWNLOADING FILE "sankey_report.xlsm"!!!
goto eof
)
echo:


echo:
echo:
echo --------- REGEN DATA DOWNLOAD FINISHED ------------
echo:


:eof
