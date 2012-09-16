@echo off
title OpenSSL-CA
set openssldir=OpenSSL-Win32\bin\
set Path=%~dp0;%~dp0%openssldir%
echo Path has been set to: %PATH%
cd /d %~dp0\CA\csr
%ComSpec% /k
