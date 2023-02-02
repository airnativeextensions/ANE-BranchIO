---
title: Branch Universal Objects
sidebar_label: Branch Universal Objects
---

This is the BranchUniversalObject (or BUO for short). Think of it like an empty box.

The BUO is used to tell Branch about a piece of content within your application, whether it’s a pair of shoes for sale, a hotel room in Prague, a recipe for veal picatta, or tonight’s Earthquakes game. Branch uses the BUO to send data from one user who wants to share a piece of content within your app to another users who wants to view it.


## Create `BranchUniversalObject`

The Branch Universal Object encapsulates the thing you want to share (content or user). You create an instance of a `BranchUniversalObject` by calling the `createUniversalObject()` function. At a minimum it should have a unique identifier and a title:

```actionscript
var buo:BranchUniversalObject = Branch.instance.createUniversalObject()
        .setCanonicalIdentifier( "content/12345" )
        .setTitle( "My Content Title" )
;
```

There are many other common properties and extended metadata that you can set on this object:

```actionscript
var buo:BranchUniversalObject = Branch.instance.createUniversalObject()
        .setCanonicalIdentifier( "content/12345" )
        .setTitle( "My Content Title" )
        .setContentDescription( "My Content Description")
        .setContentImageUrl("https://lorempixel.com/400/400")
        .setContentIndexingMode("public")
        .setLocalIndexMode("public")
        .setContentMetadata( new ContentMetadata()
            .addCustomMetadata("key1", "value1" )
        )
;
```



### Properties

There are a series of properties that you can set on a BUO within your app integration. You can see them all listed in the Branch documatation:

- [https://help.branch.io/using-branch/docs/creating-a-deep-link#section-universal-object](https://help.branch.io/using-branch/docs/creating-a-deep-link#section-universal-object)




## Create Deep Link

Once you have created the BUO identifying your content, you can generate a link to the content using the `generateShortUrl()` function. This function can take a series of link properties defined in a `LinkProperties` instance passed to the `generateShortUrl()` function. 

When complete the function will execute the callback function passed as the second parameter to the `generateShortUrl()` with 2 parameters, the first is the url representing the generated link and the second is an error (`BranchError`) and will be `null` if no error occurred.


```actionscript
var properties:LinkProperties = new LinkProperties()
        .setChannel( "facebook" )
        .setFeature( "sharing" )
        .setCampaign( "content 123 launch" )
        .setStage( "new user" )
        .addControlParameter( "$desktop_url", "http://example.com/home" )
        .addControlParameter( "custom", "data" )
;

buo.generateShortUrl(
        properties,
        function ( url:String, error:BranchError ):void 
        {
            trace( "short url: " + url );
        }
);
```







