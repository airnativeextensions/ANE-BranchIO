---
title: Link Parameters
sidebar_label: Link Parameters
---


## Latest Referring Parameters


The session parameters refer to the latest available parameters that were used to open the application. 
They will be available at any point later on with this command. 

If no params, the dictionary will be empty. This refreshes with every new session (app installs AND app opens).

These parameters are retrieved by using the `getLatestReferringParams()` function.


```actionscript
var sessionParams:String = Branch.instance.getLatestReferringParams();
var sessionParamsObj:Object = JSON.parse(sessionParams);
```



## Install Parameters

Install parameters refer to the original session parameters used to first install / launch the application.

If you ever want to access the original session params (the parameters passed in for the first install event only), you can use this line. 

This is useful if you only want to reward users who newly installed the app from a referral link.

These parameters are retrieved by using the `getFirstReferringParams()` function.


```actionscript
var installParams:String = Branch.instance.getFirstReferringParams();
var installParamsObj:Object = JSON.parse(installParams);
```



