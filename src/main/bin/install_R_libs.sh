#!/bin/sh
export R_LIBS=~/R/x86_64-redhat-linux-gnu-library/3.0
export http_proxy=http://www-proxy.osc.au.oracle.com:80

mkdir -p ~/R/x86_64-redhat-linux-gnu-library/3.0

R CMD INSTALL --library="~/R/x86_64-redhat-linux-gnu-library/3.0" ../Rlibs/Matrix_1.0-12.tar.gz
R CMD INSTALL --library="~/R/x86_64-redhat-linux-gnu-library/3.0" ../Rlibs/plyr_1.8.tar.gz
R CMD INSTALL --library="~/R/x86_64-redhat-linux-gnu-library/3.0" ../Rlibs/iterators_1.0.6.tar.gz
R CMD INSTALL --library="~/R/x86_64-redhat-linux-gnu-library/3.0" ../Rlibs/foreach_1.4.1.tar.gz
R CMD INSTALL --library="~/R/x86_64-redhat-linux-gnu-library/3.0" ../Rlibs/stringr_0.6.2.tar.gz
R CMD INSTALL --library="~/R/x86_64-redhat-linux-gnu-library/3.0" ../Rlibs/reshape2_1.2.2.tar.gz
R CMD INSTALL --library="~/R/x86_64-redhat-linux-gnu-library/3.0" ../Rlibs/caret_5.17-7.tar.gz
R CMD INSTALL --library="~/R/x86_64-redhat-linux-gnu-library/3.0" ../Rlibs/glmnet_1.9-5.tar.gz
