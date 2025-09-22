/**
 * @author Michael Archbold (https://github.com/marchbold)
 * @created 28/07/2018
 */
package io.branch.nativeExtensions.branch.controller;

import org.json.JSONObject;

import java.util.Iterator;

import io.branch.referral.util.BRANCH_STANDARD_EVENT;
import io.branch.referral.util.BranchEvent;
import io.branch.referral.util.CurrencyType;

public class BranchEventUtils
{

	public static BranchEvent eventFromJSONObject( JSONObject eventObject ) throws Exception
	{
		BranchEvent event;
		String      eventName = eventObject.getString( "eventName" );

		BRANCH_STANDARD_EVENT stdEvt = getStandardEventByName( eventName );
		if (stdEvt != null)
		{
			event = new BranchEvent( stdEvt );
		}
		else
		{
			event = new BranchEvent( eventName );
		}

		for (Iterator<String> iter = eventObject.keys(); iter.hasNext(); )
		{
			String key = iter.next();
			switch (key)
			{
				case "transaction_id":
					event.setTransactionID( eventObject.getString( key ) );
					break;
				case "currency":
					event.setCurrency( CurrencyType.getValue( eventObject.getString( key ) ) );
					break;
				case "revenue":
					event.setRevenue( eventObject.getDouble( key ) );
					break;
				case "shipping":
					event.setShipping( eventObject.getDouble( key ) );
					break;
				case "tax":
					event.setTax( eventObject.getDouble( key ) );
					break;
				case "coupon":
					event.setCoupon( eventObject.getString( key ) );
					break;
				case "affiliation":
					event.setAffiliation( eventObject.getString( key ) );
					break;
				case "description":
					event.setDescription( eventObject.getString( key ) );
					break;
				case "search_query":
					event.setSearchQuery( eventObject.getString( key ) );
					break;

				case "customData":
				{
					JSONObject customDataObject = eventObject.getJSONObject( key );
					for (Iterator<String> customDataIter = customDataObject.keys(); customDataIter.hasNext(); )
					{
						String propertyName = customDataIter.next();
						event.addCustomDataProperty(
								propertyName,
								customDataObject.getString( propertyName )
						);
					}
					break;
				}
			}
		}
		return event;
	}


	public static BRANCH_STANDARD_EVENT getStandardEventByName( String name )
	{
		for (BRANCH_STANDARD_EVENT event : BRANCH_STANDARD_EVENT.values())
		{
			if (event.getName().equals( name ))
			{
				return event;
			}
		}
		return null;
	}


}
