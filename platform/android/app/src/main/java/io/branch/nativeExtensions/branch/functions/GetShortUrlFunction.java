package io.branch.nativeExtensions.branch.functions;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.distriqt.core.utils.FREUtils;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

import io.branch.indexing.BranchUniversalObject;
import io.branch.nativeExtensions.branch.BranchExtension;
import io.branch.nativeExtensions.branch.events.BranchEvent;
import io.branch.nativeExtensions.branch.utils.Errors;
import io.branch.referral.Branch.BranchLinkCreateListener;
import io.branch.referral.BranchError;
import io.branch.referral.util.ContentMetadata;
import io.branch.referral.util.LinkProperties;

public class GetShortUrlFunction implements FREFunction
{

	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		FREObject result = null;
		try
		{
			String[] tags    = FREUtils.GetObjectAsArrayOfStrings( (FREArray) args[0] );
			String   channel = args[1].getAsString();
			String   feature = args[2].getAsString();
			String   stage   = args[3].getAsString();
			String   json    = args[4].getAsString();
			String   alias   = args[5].getAsString();
			int      type    = args[6].getAsInt();

			JSONObject obj;
			try
			{
				obj = new JSONObject( json );
			}
			catch (JSONException e)
			{
				BranchExtension.context.dispatchStatusEventAsync( "GET_SHORT_URL_FAILED", "Could not parse malformed JSON" );
				Errors.handleException( e );
				return null;
			}


			// https://github.com/BranchMetrics/android-branch-deep-linking#creating-a-deep-link
			LinkProperties linkProperties = new LinkProperties()
					.setChannel( channel )
					.setFeature( feature )
					.setStage( stage );

			if (alias.length() != 0) linkProperties.setAlias( alias );

			for (String tag : tags)
			{
				linkProperties.addTag( tag );
			}

			BranchUniversalObject branchUniversalObject = new BranchUniversalObject();

			if (obj != null)
			{
				if (obj.has( "$og_title" )) branchUniversalObject.setTitle( obj.getString( "$og_title" ) );
				if (obj.has( "$og_image_url" )) branchUniversalObject.setContentImageUrl( obj.getString( "$og_image_url" ) );
				if (obj.has( "$og_description" )) branchUniversalObject.setContentDescription( obj.getString( "$og_description" ) );

				ContentMetadata contentMetadata = new ContentMetadata();
				for (Iterator<String> iter = obj.keys(); iter.hasNext(); )
				{
					String key = iter.next();

					// Ignore BUO properties
					if (key.equals( "$og_title" ) || key.equals( "$og_image_url" ) || key.equals( "$og_description" ))
						continue;

					try
					{
						contentMetadata.addCustomMetadata( key, obj.getString( key ) );
					}
					catch (Exception e)
					{
					}
				}
				branchUniversalObject.setContentMetadata( contentMetadata );
			}

			branchUniversalObject.generateShortUrl(
					context.getActivity(),
					linkProperties,
					new BranchLinkCreateListener()
					{

						@Override
						public void onLinkCreate( String url, BranchError error )
						{
							if (error == null)
							{
								BranchExtension.context.dispatchStatusEventAsync(
										BranchEvent.GET_SHORT_URL_SUCCESS,
										url
								);
							}
							else
							{
								BranchExtension.context.dispatchStatusEventAsync(
										BranchEvent.GET_SHORT_URL_FAILED,
										error.getMessage()
								);
							}
						}
					} );

		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
		return result;
	}

}

