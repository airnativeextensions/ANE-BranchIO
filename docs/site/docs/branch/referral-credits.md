---
title: Referral Credits
sidebar_label: Referral Credits
---
## Referral system rewarding functionality

In a standard referral system, you have 2 parties: the original user and the invitee. Our system is flexible enough to handle rewards for all users. Here are a couple example scenarios:

1) Reward the original user for taking action (eg. inviting, purchasing, etc)

2) Reward the invitee for installing the app from the original user's referral link

3) Reward the original user when the invitee takes action (eg. give the original user credit when their the invitee buys something)

These reward definitions are created on the dashboard, under the 'Reward Rules' section in the 'Referrals' tab on the dashboard.

Warning: For a referral program, you should not use unique awards for custom events and redeem pre-identify call. This can allow users to cheat the system.

>
> Branch Referral Documentation: https://docs.branch.io/pages/dashboard/analytics/#referrals
>

### Get reward balance


Reward balances change randomly on the backend when certain actions are taken (defined by your rules), so you'll need to make an asynchronous call to retrieve the balance. Here is the syntax:

```actionscript
Branch.instance.addEventListener( BranchCreditsEvent.GET_CREDITS_SUCCESS, getCreditsEvent );
Branch.instance.addEventListener( BranchCreditsEvent.GET_CREDITS_FAILED, getCreditsEvent );

function getCreditsEvent( event:BranchCreditsEvent ):void 
{
	trace( event.data );
}

Branch.instance.getCredits();
```


### Redeem all or some of the reward balance (store state)

We will store how many of the rewards have been deployed so that you don't have to track it on your end. In order to save that you gave the credits to the user, you can call redeem. Redemptions will reduce the balance of outstanding credits permanently.

```actionscript
Branch.instance.redeemRewards(5);
```


### Get credit history

This call will retrieve the entire history of credits and redemptions from the individual user. To use this call, implement like so:

```actionscript
Branch.instance.addEventListener( BranchCreditsEvent.GET_CREDITS_HISTORY_SUCCESS, getCreditsHistoryEvent );
Branch.instance.addEventListener( BranchCreditsEvent.GET_CREDITS_HISTORY_FAILED, getCreditsHistoryEvent );

function getCreditsHistoryEvent( event:BranchCreditsEvent ):void 
{
	trace( event.data );
}

Branch.instance.getCreditsHistory();
```

The response will return an array that has been parsed from the following JSON:
```json
[
    {
        "transaction": {
                           "date": "2014-10-14T01:54:40.425Z",
                           "id": "50388077461373184",
                           "bucket": "default",
                           "type": 0,
                           "amount": 5
                       },
        "event" : {
            "name": "event name",
            "metadata": { your event metadata if present }
        },
        "referrer": "12345678",
        "referree": null
    },
    {
        "transaction": {
                           "date": "2014-10-14T01:55:09.474Z",
                           "id": "50388199301710081",
                           "bucket": "default",
                           "type": 2,
                           "amount": -3
                       },
        "event" : {
            "name": "event name",
            "metadata": { your event metadata if present }
        },
        "referrer": null,
        "referree": "12345678"
    }
]
```

**referrer**
: The id of the referring user for this credit transaction. Returns null if no referrer is involved. Note this id is the user id in developer's own system that's previously passed to Branch's identify user API call.

**referree**
: The id of the user who was referred for this credit transaction. Returns null if no referree is involved. Note this id is the user id in developer's own system that's previously passed to Branch's identify user API call.

**type**
: This is the type of credit transaction

1. _0_ - A reward that was added automatically by the user completing an action or referral
1. _1_ - A reward that was added manually
2. _2_ - A redemption of credits that occurred through our API or SDKs
3. _3_ - This is a very unique case where we will subtract credits automatically when we detect fraud


