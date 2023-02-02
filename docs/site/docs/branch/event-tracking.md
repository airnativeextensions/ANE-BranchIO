---
title: Event Tracking
sidebar_label: Event Tracking
---

To track user events you will use the `BranchEventBuilder` to construct an event and then pass the output from this to the `logEvent` function. The builder has a range of helper functions to allow you to correctly construct the event data.


```actionscript
var builder:BrancEventBuilder = new BranchEventBuilder( eventName );

// build your event and then pass to logEvent

Branch.instance.logEvent( builder.build() );
```


## Standard Event

You construct a "standard" event by using one of the predefined constant event names in the BranchEventBuilder class: `STANDARD_EVENT_*`. These names are matched to standard events in the Branch dashboard.

For example:

```actionscript
Branch.instance.logEvent(
        new BranchEventBuilder( BranchEventBuilder.STANDARD_EVENT_PURCHASE )
                .setRevenue( 1.23 )
                .setTax( 0.12 )
                .setTransactionID( "XXDDCCFFDD" )
                .setCurrency("USD")
                .setShipping(0)
                .build()
);
```


## Custom Event

To construct a custom event you can use your own event name when creating your builder. Events named `open`, `close`, `install`, and `referred session` are Branch restricted along with the standard event names.

For example:

```actionscript
Branch.instance.logEvent(
        new BranchEventBuilder( "your_custom_event" )
                .addCustomDataProperty("your_custom_key", "your_custom_value")
                .build()
);
```




