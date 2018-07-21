package io.branch.nativeExtensions.branch {

	public class BranchConst {

		static public const FEATURE_TAG_SHARE:String = "share";
		static public const FEATURE_TAG_REFERRAL:String = "referral";
		static public const FEATURE_TAG_INVITE:String = "invite";
		static public const FEATURE_TAG_DEAL:String = "deal";
		static public const FEATURE_TAG_GIFT:String = "gift";

		static public const REDEEM_CODE:String = "$redeem_code";
		static public const REFERRAL_BUCKET_DEFAULT:String = "default";
		static public const REFERRAL_CODE_TYPE:String = "credit";
		static public const REFERRAL_CODE:String = "referral_code";

		static public const REDIRECT_DESKTOP_URL:String = "$desktop_url";
		static public const REDIRECT_ANDROID_URL:String = "$android_url";
		static public const REDIRECT_IOS_URL:String = "$ios_url";
		static public const REDIRECT_IPAD_URL:String = "$ipad_url";
		static public const REDIRECT_FIRE_URL:String = "$fire_url";
		static public const REDIRECT_BLACKBERRY_URL:String = "$blackberry_url";
		static public const REDIRECT_WINDOWS_PHONE_URL:String = "$windows_phone_url";

		static public const OG_TITLE:String = "$og_title";
		static public const OG_DESC:String = "$og_description";
		static public const OG_IMAGE_URL:String = "$og_image_url";
		static public const OG_VIDEO:String = "$og_video";
		static public const OG_URL:String = "$og_url";
		static public const OG_APP_ID:String = "$og_app_id";

		static public const DEEPLINK_PATH:String = "$deeplink_path";
		static public const ALWAYS_DEEPLINK:String = "$always_deeplink";

		static public const REFERRAL_CODE_LOCATION_REFERREE:uint = 0;
		static public const REFERRAL_CODE_LOCATION_REFERRING_USER:uint = 2;
		static public const REFERRAL_CODE_LOCATION_BOTH:uint = 3;

		static public const REFERRAL_CODE_AWARD_UNLIMITED:uint = 1;
		static public const REFERRAL_CODE_AWARD_UNIQUE:uint = 0;
		
		static public const LINK_TYPE_UNLIMITED_USE:uint = 0;
		static public const LINK_TYPE_ONE_TIME_USE:uint = 1;

		public function BranchConst() {
		}
	}
}
