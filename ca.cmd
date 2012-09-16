@echo off
set currdir=%CD%
cd /d %~dp0

set config=-config %~dp0\openssl.cnf
set DAYS=365
set CADAYS=3650
set REQ=openssl req %config%
set CA=openssl ca %config%
set VERIFY=openssl verify %config%
set X509=openssl x509 %config%
set PKCS12=openssl pkcs12 %config%

set CATOP=%~dp0\CA
set CAKEY=dfca2.pem
set CAREQ=dfca2-req.pem
set CACERT=dfca2.pem

if "%1"=="" call :help
if "%1"=="-newcert" call :newcert
if "%1"=="-newreq" call :newreq
if "%1"=="-newrequest-nodes" call :newrequest-nodes
if "%1"=="-newca" call :newca
if "%1"=="-pkcs12" call :pkcs12 %2
if "%1"=="-xsign" call :xsign
if "%1"=="-sign" call :sign %2
if "%1"=="-signca" call :signca
if "%1"=="-signcert" call :signcert
cd /d %currdir%
goto :EOF

:help
echo -newcert
echo -newreq
echo -newrequest-nodes
echo -newca
echo -pkcs12
echo -xsign
echo -sign
echo -signca
echo -signcert
goto :EOF

:newcert
REM create a certificate
echo Error: untested
got :EOF
%REQ% -new -x509 -keyout newkey.pem -out newcert.pem -days %DAYS%
echo Certificate is in newcert.pem, private key is in newkey.pem
goto :EOF

:newreq
REM create a certificate request
echo Error: untested
got :EOF
%REQ% -new -keyout newkey.pem -out newreq.pem -days %DAYS%
echo Request is in newreq.pem, private key is in newkey.pem
goto :EOF

:newrequest-nodes
REM create a certificate request
echo Error: untested
got :EOF
%REQ% -new -nodes -keyout newkey.pem -out newreq.pem -days %DAYS%
echo Request is in newreq.pem, private key is in newkey.pem

:newca
mkdir %CATOP%
mkdir %CATOP%\certs
mkdir %CATOP%\crl
mkdir %CATOP%\csr
mkdir %CATOP%\newcerts
mkdir %CATOP%\private
echo. >nul 2>%CATOP%\index.txt
echo 01>%CATOP%\crlnumber
echo Making CA certificate...
%REQ% -new -keyout %CATOP%\private\%CAKEY% -out %CATOP%\%CAREQ%
%CA% -create_serial -out %CATOP%\%CACERT% -days %CADAYS% -batch -keyfile %CATOP%\private\%CAKEY% -selfsign -extensions v3_ca -infiles %CATOP%\%CAREQ%
goto :EOF

:pkcs12
echo Error: untested
got :EOF
set cname = %1
%PKCS12% -in newcert.pem -inkey newkey.pem -certfile ${CATOP}\$CACERT -out newcert.p12 -export -name %cname%
echo PKCS #12 file is in newcert.p12
goto :EOF

:xsign
echo Error: untested
got :EOF
%CA% -policy policy_anything -infiles newreq.pem
goto :EOF

:sign
%CA% -notext -in %CATOP%\csr\%1 -out %CATOP%\certs\%~n1.crt
echo Signed certificate is in %CATOP%\certs\%~n1.crt
goto :EOF

:signca
echo Error: untested
got :EOF
%CA% -policy policy_anything -out newcert.pem -extensions v3_ca -infiles newreq.pem
echo Signed CA certificate is in newcert.pem
goto :EOF

:signcert
echo Error: untested
got :EOF
%X509% -x509toreq -in newreq.pem -signkey newreq.pem -out tmp.pem
%CA% -policy policy_anything -out newcert.pem -infiles tmp.pem
echo Signed certificate is in newcert.pem
goto :EOF
