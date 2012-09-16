windows-ca
==========

A Windows Certificate Authority based on openssl and only using files. Suited for putting on a USB stick.


Usage
=====
1. Extract to the top level of a USB stick. You might want to replace the OpenSSL-Win32 directory with a more trustable source.
2. Edit the top of ca.cmd to suit your needs. You need to update the variables CAKEY, CAREQ and CACERT. You may also want to edit the variables DAYS and CADAYS.
3. Edit openssl.cnf to suit your needs (especially the names and Locations...)
4. Start openssl-shell.cmd (ignore the possible error about a missing directory)
5. Create a new CA by running the command:
 # ca -newca
After answering the data, you have a usable certificate authority and can now start to sign certificate requests.
You can now find the public certificate of your CA in %CATOP%\%CACERT% (in my case \CA\dfca2.pem). You need to install that certificate everywhere you want to use your signed certificates.

Signing certificates:
1. Put the CSR file into the \CA\csr directory
2. Run openssl-shell.cmd
3. Sign the certificate by running this command:
 # ca -sign file.csr
You can find the signed certificate in \CA\certs.
