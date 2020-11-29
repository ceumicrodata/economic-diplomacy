capture here
if _rc {
	net install here, from("https://raw.githubusercontent.com/korenmiklos/here/master/")
}

capture ado uninstall reghdfe
net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/")

cap ado uninstall moresyntax
cap ado uninstall ftools
net install ftools, from("https://raw.githubusercontent.com/sergiocorreia/ftools/master/src/")

cap ado uninstall ppmlhdfe
ssc install ppmlhdfe

cap ado uninstall coefplot
ssc install coefplot
