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
 * @created		28/7/18
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package io.branch.nativeExtensions.branch.tracking 
{
	import io.branch.nativeExtensions.branch.Branch;
	
	
	/**
	 * <p>
	 * Class for creating Branch events for tracking and analytical purpose.
	 * This class can construct both standard and custom Branch events.
	 * </p>
	 * <p>
	 * Standard Branch events are defined with a name from the predefined constants
	 * <code>STANDARD_EVENT_...</code>.
	 * </p>
	 * <p>
	 * Please use <code>Branch.instance.logEvent()</code> method to log the events for tracking.
	 * </p>
	 *
	 * @example
	 *
	 *
	 * @see io.branch.nativeExtensions.branch.Branch#logEvent()
	 */
    public class BranchEventBuilder 
    {
 		////////////////////////////////////////////////////////
        //  CONSTANTS
        //
        
        private static const TAG : String = "BranchEventBuilder";
	
		// Commerce events
		public static const STANDARD_EVENT_ADD_TO_CART : String = "ADD_TO_CART";
		public static const STANDARD_EVENT_ADD_TO_WISHLIST : String = "ADD_TO_WISHLIST";
		public static const STANDARD_EVENT_VIEW_CART : String = "VIEW_CART";
		public static const STANDARD_EVENT_INITIATE_PURCHASE : String = "INITIATE_PURCHASE";
		public static const STANDARD_EVENT_ADD_PAYMENT_INFO : String = "ADD_PAYMENT_INFO";
		public static const STANDARD_EVENT_PURCHASE : String = "PURCHASE";
		public static const STANDARD_EVENT_SPEND_CREDITS : String = "SPEND_CREDITS";
		
		// Content events
		public static const STANDARD_EVENT_SEARCH : String = "SEARCH";
		public static const STANDARD_EVENT_VIEW_ITEM : String = "VIEW_ITEM";
		public static const STANDARD_EVENT_VIEW_ITEMS : String = "VIEW_ITEMS";
		public static const STANDARD_EVENT_RATE : String = "RATE";
		public static const STANDARD_EVENT_SHARE : String = "SHARE";
		
		// User lifecycle events
		public static const STANDARD_EVENT_COMPLETE_REGISTRATION : String = "COMPLETE_REGISTRATION";
		public static const STANDARD_EVENT_COMPLETE_TUTORIAL : String = "COMPLETE_TUTORIAL";
		public static const STANDARD_EVENT_ACHIEVE_LEVEL : String = "ACHIEVE_LEVEL";
		public static const STANDARD_EVENT_UNLOCK_ACHIEVEMENT : String = "UNLOCK_ACHIEVEMENT";
		
		
		
		
		
 		////////////////////////////////////////////////////////
        //  VARIABLES
        //
        
		private var _event : Object;
		private var _customData : Object;
		
		
		
 		////////////////////////////////////////////////////////
        //  FUNCTIONALITY
        //
	
		/**
		 * Class constructor
		 *
		 * @param eventName
		 */
		public function BranchEventBuilder( eventName:String )
        {
			_event = {};
        	_event["eventName"] = eventName;
			_event["isStandardEvent"] = isStandardEvent(eventName);
	
			_customData = {};
		}

		
		private function isStandardEvent( eventName:String ):Boolean
		{
			switch (eventName)
			{
				case STANDARD_EVENT_ADD_TO_CART:
				case STANDARD_EVENT_ADD_TO_WISHLIST:
				case STANDARD_EVENT_ADD_PAYMENT_INFO:
				case STANDARD_EVENT_VIEW_CART:
				case STANDARD_EVENT_INITIATE_PURCHASE:
				case STANDARD_EVENT_ADD_PAYMENT_INFO:
				case STANDARD_EVENT_PURCHASE:
				case STANDARD_EVENT_SPEND_CREDITS:
				case STANDARD_EVENT_SEARCH:
				case STANDARD_EVENT_VIEW_ITEM:
				case STANDARD_EVENT_VIEW_ITEMS:
				case STANDARD_EVENT_RATE:
				case STANDARD_EVENT_SHARE:
				case STANDARD_EVENT_ADD_TO_CART:
				case STANDARD_EVENT_COMPLETE_REGISTRATION:
				case STANDARD_EVENT_COMPLETE_TUTORIAL:
				case STANDARD_EVENT_ACHIEVE_LEVEL:
				case STANDARD_EVENT_UNLOCK_ACHIEVEMENT:
					return true;
			}
			return false;
		}
	
		
		/**
		 * Set the transaction id associated with this event if there in any
		 *
		 * @param transactionID
		 * @return This object for chaining builder methods
		 */
		public function setTransactionID( transactionId:String ):BranchEventBuilder
		{
			_event["transaction_id"] = transactionId;
			return this;
		}
	
	
		/**
		 * Set the currency related with this transaction event
		 *
		 * @param iso4217Code	ISO 4217 currency code (eg USD, EUR, JPY)
		 * @return This object for chaining builder methods
		 */
		public function setCurrency( iso4217Code:String ):BranchEventBuilder
		{
			_event["currency"] = iso4217Code;
			return this;
		}
	
	
		/**
		 * Set the revenue value related with this transaction event
		 *
		 * @param revenue 		revenue value
		 * @return This object for chaining builder methods
		 */
		public function setRevenue( revenue:Number ):BranchEventBuilder
		{
			_event["revenue"] = revenue;
			return this;
		}
	
	
		/**
		 * Set the shipping value related with this transaction event
		 *
		 * @param shipping 		shipping value
		 * @return This object for chaining builder methods
		 */
		public function setShipping( shipping:Number ):BranchEventBuilder
		{
			_event["shipping"] = shipping;
			return this;
		}
	
	
		/**
		 * Set the tax value  related with this transaction event
		 *
		 * @param tax 		tax value
		 * @return This object for chaining builder methods
		 */
		public function setTax( tax:Number ):BranchEventBuilder
		{
			_event["tax"] = tax;
			return this;
		}
	
		
		/**
		 * Set any coupons associated with this transaction event
		 *
		 * @param coupon 		with any coupon value
		 * @return This object for chaining builder methods
		 */
		public function setCoupon( coupon:String ):BranchEventBuilder
		{
			_event["coupon"] = coupon;
			return this;
		}
		
	
		/**
		 * Set any affiliation for this transaction event
		 *
		 * @param affiliation 	any affiliation value
		 * @return This object for chaining builder methods
		 */
		public function setAffiliation( affiliation:String ):BranchEventBuilder
		{
			_event["affiliation"] = affiliation;
			return this;
		}
	
		
		/**
		 * Set description for this transaction event
		 *
		 * @param description 	transaction description
		 * @return This object for chaining builder methods
		 */
		public function setDescription( description:String ):BranchEventBuilder
		{
			_event["description"] = description;
			return this;
		}
		
	
		/**
		 * Set any search query associated with the event
		 *
		 * @param searchQuery 		Search Query value
		 * @return This object for chaining builder methods
		 */
		public function setSearchQuery( searchQuery:String ):BranchEventBuilder
		{
			if (searchQuery == null) delete _event[ "search_query" ];
			else _event[ "search_query" ] = searchQuery;
			return this;
		}
	
		
		/**
		 * Adds a custom data property associated with this Branch Event
		 *
		 * @param propertyName  Name of the custom property
		 * @param propertyValue Value of the custom property
		 *
		 * @return This object for chaining builder methods
		 */
		public function addCustomDataProperty( propertyName:String, propertyValue:String ):BranchEventBuilder
		{
			_customData[propertyName] = propertyValue;
			return this;
		}
	
		
		
		
		
	
		/**
		 * Creates an object representing an event for the extension.
		 */
		public function build():Object
		{
			_event["customData"] = _customData;
			return _event;
		}
		
		
        
    }
}
