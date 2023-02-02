---
title: Deep Links
sidebar_label: Deep Links
---

If your application is launched from a branch link you will receive an event with the branch parameters associated with that link.

When this occurs the `BranchEvent.INIT_SUCCESS` will be dispatched with the params exactly the same as after the initial `initSession` call.

So in order to process deep links it is important that your `BranchEvent.INIT_SUCCESS` handler is not removed and that you can handle this event being dispatched at any time in your application.

We recommend using the `clicked_branch_link` and `match_guaranteed` params to be able to determine how the link was used and whether it is a guaranteed link click. 

For example:

```actionscript
function init_successHandler( event:BranchEvent ):void
{
    trace( event.type + "::" + event.data );
    try
    {
        var sessionParams:Object = JSON.parse(event.data);
        
        var clicked_branch_link:Boolean = false;
        if (sessionParams.hasOwnProperty("+clicked_branch_link"))
            clicked_branch_link = sessionParams["+clicked_branch_link"];
        
        var match_guaranteed:Boolean = = false;
        if (sessionParams.hasOwnProperty("+match_guaranteed"))
            match_guaranteed = sessionParams["+match_guaranteed"];
            
        
        if (clicked_branch_link && match_guaranteed)
        {
            trace( "CLICKED BRANCH LINK" );
        }
    }
    catch (e:Error)
    {
    }
}
```
