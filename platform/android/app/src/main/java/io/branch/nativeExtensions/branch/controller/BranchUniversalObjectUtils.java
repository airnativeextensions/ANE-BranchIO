/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * https://distriqt.com
 *
 * @brief
 * @author Michael Archbold (https://github.com/marchbold)
 * @created 22/09/2020
 * @copyright https://distriqt.com/copyright/license.txt
 */
package io.branch.nativeExtensions.branch.controller;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.Iterator;

import io.branch.indexing.BranchUniversalObject;
import io.branch.nativeExtensions.branch.utils.Errors;
import io.branch.referral.util.ContentMetadata;
import io.branch.referral.util.LinkProperties;

public class BranchUniversalObjectUtils
{


	public static LinkProperties linkPropertiesFromJSONObject( JSONObject linkProperties )
	{
		LinkProperties lp = new LinkProperties();
		try
		{
			Iterator<String> keys = linkProperties.keys();
			while (keys.hasNext())
			{
				String key = keys.next();
				switch (key)
				{
					case "channel":
						lp.setChannel( linkProperties.getString( key ) );
						break;
					case "feature":
						lp.setFeature( linkProperties.getString( key ) );
						break;
					case "campaign":
						lp.setCampaign( linkProperties.getString( key ) );
						break;
					case "alias":
						lp.setAlias( linkProperties.getString( key ) );
						break;
					case "duration":
						lp.setDuration( linkProperties.getInt( key ) );
						break;
					case "stage":
						lp.setStage( linkProperties.getString( key ) );
						break;

					case "controlParameters":
					{
						JSONObject       cpJSON = linkProperties.getJSONObject( key );
						Iterator<String> cpKeys = cpJSON.keys();
						while (cpKeys.hasNext())
						{
							String cpKey   = cpKeys.next();
							String cpValue = cpJSON.getString( cpKey );

							lp.addControlParameter( cpKey, cpValue );
						}
						break;
					}

					case "tags":
					{
						JSONArray tagsArray = linkProperties.getJSONArray( key );
						for (int i = 0; i < tagsArray.length(); i++)
						{
							lp.addTag( tagsArray.getString( i ) );
						}
						break;
					}

				}
			}

		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
		return lp;
	}


	public static BranchUniversalObject buoFromJSONObject( JSONObject buoProperties )
	{
		BranchUniversalObject buo = new BranchUniversalObject();

		try
		{
			Iterator<String> keys = buoProperties.keys();
			while (keys.hasNext())
			{
				String key = keys.next();
				switch (key)
				{
					case "canonicalIdentifier":
						buo.setCanonicalIdentifier( buoProperties.getString( key ) );
						break;
					case "canonicalUrl":
						buo.setCanonicalUrl( buoProperties.getString( key ) );
						break;
					case "title":
						buo.setTitle( buoProperties.getString( key ) );
						break;
					case "contentDescription":
						buo.setContentDescription( buoProperties.getString( key ) );
						break;
					case "contentImageUrl":
						buo.setContentImageUrl( buoProperties.getString( key ) );
						break;

					case "contentIndexingMode":
					{
						String mode = buoProperties.getString( key );
						buo.setContentIndexingMode(
								mode.equals( "public" ) ?
										BranchUniversalObject.CONTENT_INDEX_MODE.PUBLIC :
										BranchUniversalObject.CONTENT_INDEX_MODE.PRIVATE
						);
						break;
					}

					case "localIndexMode":
					{
						String mode = buoProperties.getString( key );
						buo.setLocalIndexMode(
								mode.equals( "public" ) ?
										BranchUniversalObject.CONTENT_INDEX_MODE.PUBLIC :
										BranchUniversalObject.CONTENT_INDEX_MODE.PRIVATE
						);
						break;
					}

					case "metadata":
					{
						ContentMetadata metadata = new ContentMetadata();

						JSONObject       metadataJSON = buoProperties.getJSONObject( key );
						Iterator<String> metadataKeys = metadataJSON.keys();
						while (metadataKeys.hasNext())
						{
							String metadataKey   = metadataKeys.next();
							String metadataValue = metadataJSON.getString( metadataKey );

							metadata.addCustomMetadata( metadataKey, metadataValue );
						}

						buo.setContentMetadata( metadata );
						break;
					}

				}
			}
		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
		return buo;
	}


}
