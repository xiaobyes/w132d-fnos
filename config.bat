rem ============================================================
rem   W132D   CONFIG   --   EDIT THE TWO LINES AT THE BOTTOM
rem ============================================================
rem
rem   Before using any of the scripts, make sure:
rem     1) fnOS is activated   (open http://DEVICE-IP in a browser,
rem        finish the first-run wizard)
rem     2) SSH is ON           (fnOS web -> Settings -> SSH -> enable)
rem     3) the two lines below are correct
rem
rem   IP  : fnOS web -> Settings -> Network -> IPv4 address
rem   USR : the account created during activation (usually admin)
rem   NEWGB: how many GB to free for a fnOS storage pool (step 7 only)
rem          recommended 10  ->  root stays ~18GB on a 32GB eMMC
rem
rem   Save this file as-is (ANSI / UTF-8 both fine, it is pure ASCII).
rem ============================================================

set "IP=192.168.0.141"
set "USR=admin"
set "NEWGB=10"
