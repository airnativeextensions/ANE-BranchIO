/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * http://distriqt.com
 *
 * @brief  		
 * @author 		marchbold
 * @created		19/9/20
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package io.branch.nativeExtensions.branch.buo 
{
	import flash.events.IEventDispatcher;
	
	
	public interface BranchUniversalObject extends IEventDispatcher
    {
 		////////////////////////////////////////////////////////
        //  FUNCTIONALITY
        //
	
		/**
		 *
		 * @param properties
		 * @param callback
		 */
		function generateShortUrl( properties:LinkProperties, callback:Function=null ):void;
  
		
//		function userCompletedAction( event:String ):void;
	
	
		//
		//	PROPERTIES
		//
		
		/**
		 * <strong>(Required)</strong>
		 * This is the unique identifier for content that will help Branch dedupe across
		 * many instances of the same thing.
		 * <br/>
		 * Suitable options: a website with pathing, or a database with identifiers for entities
		 *
		 * @param identifier
		 *
		 * @return <code>BranchUniversalObject</code> instance for chaining calls
		 */
		function setCanonicalIdentifier( identifier:String ):BranchUniversalObject;
	
	
		/**
		 * The canonical URL, used for SEO purposes
		 *
		 * @param canonicalUrl
		 *
		 * @return <code>BranchUniversalObject</code> instance for chaining calls
		 */
		function setCanonicalUrl( canonicalUrl:String ):BranchUniversalObject;
	
	
		/**
		 * The name for the piece of content
		 *
		 * @param title
		 * @return <code>BranchUniversalObject</code> instance for chaining calls
		 */
		function setTitle( title:String ):BranchUniversalObject;
	
	
		/**
		 * A description for the content
		 *
		 * @param contentDescription
		 * @return <code>BranchUniversalObject</code> instance for chaining calls
		 */
		function setContentDescription( contentDescription:String ):BranchUniversalObject;
	
	
		/**
		 * The image URL for the content. Must be an absolute path
		 *
		 * @param contentImageUrl
		 * @return <code>BranchUniversalObject</code> instance for chaining calls
		 */
		function setContentImageUrl( contentImageUrl:String ):BranchUniversalObject;
	
	
		/**
		 * Can be set to either "public" or "private". Public indicates that you'd like this content to be discovered by other apps.
		 *
		 * @param contentIndexingMode
		 * @return <code>BranchUniversalObject</code> instance for chaining calls
		 */
		function setContentIndexingMode( contentIndexingMode:String ):BranchUniversalObject;
	
	
		/**
		 *
		 * @param title
		 * @return <code>BranchUniversalObject</code> instance for chaining calls
		 */
		function setLocalIndexMode( title:String ):BranchUniversalObject;
	
	
		/**
		 * 
		 * @param metadata
		 * @return <code>BranchUniversalObject</code> instance for chaining calls
		 */
		function setContentMetadata( metadata:ContentMetadata ):BranchUniversalObject;
	
	
	
	}
	
}
