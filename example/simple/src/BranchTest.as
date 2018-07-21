package {

	import io.branch.nativeExtensions.branch.Branch;
	import io.branch.nativeExtensions.branch.BranchConst;
	import io.branch.nativeExtensions.branch.BranchEvent;

	import flash.display.Sprite;

	/**
	 * @author Aymeric
	 */
	public class BranchTest extends Sprite {
		
		private var _branch:Branch;

		public function BranchTest() {
			
			_branch = new Branch();

			_branch.addEventListener(BranchEvent.INIT_FAILED, _branchEventCallback);
			_branch.addEventListener(BranchEvent.INIT_SUCCESSED, _initSuccessed);

			_branch.addEventListener(BranchEvent.SET_IDENTITY_FAILED, _branchEventCallback);
			_branch.addEventListener(BranchEvent.SET_IDENTITY_SUCCESSED, _branchEventCallback);

			_branch.addEventListener(BranchEvent.GET_SHORT_URL_FAILED, _branchEventCallback);
			_branch.addEventListener(BranchEvent.GET_SHORT_URL_SUCCESSED, _branchEventCallback);

			_branch.addEventListener(BranchEvent.GET_CREDITS_FAILED, _branchEventCallback);
			_branch.addEventListener(BranchEvent.GET_CREDITS_SUCCESSED, _branchEventCallback);

			_branch.addEventListener(BranchEvent.REDEEM_REWARDS_FAILED, _branchEventCallback);
			_branch.addEventListener(BranchEvent.REDEEM_REWARDS_SUCCESSED, _branchEventCallback);

			_branch.addEventListener(BranchEvent.GET_CREDITS_HISTORY_FAILED, _branchEventCallback);
			_branch.addEventListener(BranchEvent.GET_CREDITS_HISTORY_SUCCESSED, _branchEventCallback);

			_branch.addEventListener(BranchEvent.GET_REFERRAL_CODE_FAILED, _branchEventCallback);
			_branch.addEventListener(BranchEvent.GET_REFERRAL_CODE_SUCCESSED, _branchEventCallback);
			
			_branch.addEventListener(BranchEvent.CREATE_REFERRAL_CODE_FAILED, _branchEventCallback);
			_branch.addEventListener(BranchEvent.CREATE_REFERRAL_CODE_SUCCESSED, _branchEventCallback);
			
			_branch.addEventListener(BranchEvent.VALIDATE_REFERRAL_CODE_FAILED, _branchEventCallback);
			_branch.addEventListener(BranchEvent.VALIDATE_REFERRAL_CODE_SUCCESSED, _branchEventCallback);
			
			_branch.addEventListener(BranchEvent.APPLY_REFERRAL_CODE_FAILED, _branchEventCallback);
			_branch.addEventListener(BranchEvent.APPLY_REFERRAL_CODE_SUCCESSED, _branchEventCallback);

			_branch.init();
		}

		private function _initSuccessed(bEvt:BranchEvent):void {
			trace("BranchEvent.INIT_SUCCESSED", bEvt.informations);
			
			// params are the deep linked params associated with the link that the user clicked before showing up
			// params will be empty if no data found
			
			var referringParams:Object = JSON.parse(bEvt.informations);
			//trace(referringParams.user);
			
			_branch.setIdentity("Bob");
			
			var dataToInclude:Object = {
				user:"Joe",
				profile_pic:"https://avatars3.githubusercontent.com/u/7772941?v=3&s=200",
				description:"Joe likes long walks on the beach...",
				
				// customize the display of the Branch link
				"$og_title":"Joe's My App Referral",
				"$og_image_url":"https://branch.io/img/logo_white.png",
				"$og_description":"Join Joe in My App - it's awesome"
			};
			
			var tags:Array = ["version1", "trial6"];
			
			_branch.getShortUrl(tags, "text_message", BranchConst.FEATURE_TAG_SHARE, "level_3", JSON.stringify(dataToInclude));
			
			_branch.getCredits();
			
			_branch.getCreditsHistory();
			
			_branch.getReferralCode();
			
			//_branch.createReferralCode(prefix, amount, expiration, bucket, calculationType, location)
			//_branch.validateReferralCode(code);
			//_branch.applyReferralCode(code);
			
			var sessionParams:String = _branch.getLatestReferringParams();
			trace("sessionParams: " + sessionParams);
			
			var installParams:String = _branch.getFirstReferringParams();
			trace("installParams: " + installParams);
		}
		
		private function _branchEventCallback(bEvt:BranchEvent):void {
			
			trace(bEvt.type, bEvt.informations);
			
			if (bEvt.type == BranchEvent.GET_CREDITS_SUCCESSED)
				_branch.redeemRewards(5);
		}
	}
}
