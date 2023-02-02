---
title: User Identity
sidebar_label: User Identity
---

## Set Identity 

Often, you might have your own user IDs, or want referral and event data to persist across platforms or uninstall/reinstall. It's helpful if you know your users access your service from different devices. This where we introduce the concept of an 'identity'.

To identify a user, just call:

```actionscript
Branch.instance.setIdentity("your user id");
```

This can be used to set the identity of a user (email, ID, UUID, etc) for events, deep links, and referrals.




## Logout

If you provide the functionality to logout or disconnect a user you can call `logout` to clear any identity information you may have set.

```actionscript
Branch.instance.logout();
```

>
> **Warning** this call will clear the referral credits and attribution on the device.  
>

