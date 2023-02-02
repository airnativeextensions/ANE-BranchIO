---
title: Initialisation
sidebar_label: Initialisation
---

## Initialise the Branch SDK


To initialise the Branch SDK you will need to call the `initSession` function.

```actionscript
Branch.instance.initSession();
```

This process will dispatch one of two events:

- `BranchEvent.INIT_FAILED`: Dispatched when initialisation failed
- `BranchEvent.INIT_SUCCESS`: Dispatched when initialisation succeeded

```actionscript
Branch.instance.addEventListener( BranchEvent.INIT_FAILED, init_failedHandler );
Branch.instance.addEventListener( BranchEvent.INIT_SUCCESS, init_successHandler );
				
function init_successHandler( event:BranchEvent ):void
{
    trace( event.type + "::" + event.data );
    
    // params are the deep linked params associated with the link that the user clicked before showing up
    // params will be empty if no data found
}
		
function init_failedHandler( event:BranchEvent ):void
{
    trace( event.type + "::" + event.data );
}
```


### Options

You can specify options for the SDK and session by using an instance of the `BranchOptions` class as the first parameter to the `initSession` function.

For example, to force the SDK to use your test key:

```actionscript
Branch.instance.initSession(
        new BranchOptions()
                .setUseTestKey()
);
```

You can also set the option to delay init to check for search ads:

```actionscript
Branch.instance.initSession(
        new BranchOptions()
                .setDelayInitToCheckForSearchAds()
);
```

The `BranchOptions` functionality is designed to be chained so you can set multiple parameters simply:

```actionscript
Branch.instance.initSession(
    new BranchOptions()
        .setUseTestKey()
        .setDelayInitToCheckForSearchAds()
);
```




### Imports

If you manually manage imports you will need to add the following:

```actionscript
import io.branch.nativeExtensions.branch.Branch;
import io.branch.nativeExtensions.branch.BranchOptions;
import io.branch.nativeExtensions.branch.events.BranchEvent;
```




