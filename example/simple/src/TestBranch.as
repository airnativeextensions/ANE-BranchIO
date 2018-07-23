package {
	
	import io.branch.nativeExtensions.branch.Branch;
	import io.branch.nativeExtensions.branch.BranchConst;
	import io.branch.nativeExtensions.branch.BranchEvent;
	
	import flash.display.Sprite;
	
	/**
	 * @author Aymeric
	 */
	public class TestBranch extends Sprite {
		
		
		public function TestBranch() {
			
			Branch.instance.addEventListener(BranchEvent.INIT_FAILED, _branchEventCallback);
			Branch.instance.addEventListener(BranchEvent.INIT_SUCCESSED, _initSuccessed);
			
			Branch.instance.addEventListener(BranchEvent.SET_IDENTITY_FAILED, _branchEventCallback);
			Branch.instance.addEventListener(BranchEvent.SET_IDENTITY_SUCCESSED, _branchEventCallback);
			
			Branch.instance.addEventListener(BranchEvent.GET_SHORT_URL_FAILED, _branchEventCallback);
			Branch.instance.addEventListener(BranchEvent.GET_SHORT_URL_SUCCESSED, _branchEventCallback);
			
			Branch.instance.addEventListener(BranchEvent.GET_CREDITS_FAILED, _branchEventCallback);
			Branch.instance.addEventListener(BranchEvent.GET_CREDITS_SUCCESSED, _branchEventCallback);
			
			Branch.instance.addEventListener(BranchEvent.REDEEM_REWARDS_FAILED, _branchEventCallback);
			Branch.instance.addEventListener(BranchEvent.REDEEM_REWARDS_SUCCESSED, _branchEventCallback);
			
			Branch.instance.addEventListener(BranchEvent.GET_CREDITS_HISTORY_FAILED, _branchEventCallback);
			Branch.instance.addEventListener(BranchEvent.GET_CREDITS_HISTORY_SUCCESSED, _branchEventCallback);
			
			Branch.instance.addEventListener(BranchEvent.GET_REFERRAL_CODE_FAILED, _branchEventCallback);
			Branch.instance.addEventListener(BranchEvent.GET_REFERRAL_CODE_SUCCESSED, _branchEventCallback);
			
			Branch.instance.addEventListener(BranchEvent.CREATE_REFERRAL_CODE_FAILED, _branchEventCallback);
			Branch.instance.addEventListener(BranchEvent.CREATE_REFERRAL_CODE_SUCCESSED, _branchEventCallback);
			
			Branch.instance.addEventListener(BranchEvent.VALIDATE_REFERRAL_CODE_FAILED, _branchEventCallback);
			Branch.instance.addEventListener(BranchEvent.VALIDATE_REFERRAL_CODE_SUCCESSED, _branchEventCallback);
			
			Branch.instance.addEventListener(BranchEvent.APPLY_REFERRAL_CODE_FAILED, _branchEventCallback);
			Branch.instance.addEventListener(BranchEvent.APPLY_REFERRAL_CODE_SUCCESSED, _branchEventCallback);
			
			Branch.instance.init();
		}
		
		private function _initSuccessed(bEvt:BranchEvent):void {
			trace("BranchEvent.INIT_SUCCESSED", bEvt.informations);
			
			// params are the deep linked params associated with the link that the user clicked before showing up
			// params will be empty if no data found
			
			var referringParams:Object = JSON.parse(bEvt.informations);
			//trace(referringParams.user);
			
			Branch.instance.setIdentity("Bob");
			
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
			
			Branch.instance.getShortUrl(tags, "text_message", BranchConst.FEATURE_TAG_SHARE, "level_3", JSON.stringify(dataToInclude));
			
			Branch.instance.getCredits();
			
			Branch.instance.getCreditsHistory();
			
			Branch.instance.getReferralCode();
			
			//Branch.instance.createReferralCode(prefix, amount, expiration, bucket, calculationType, location)
			//Branch.instance.validateReferralCode(code);
			//Branch.instance.applyReferralCode(code);
			
			var sessionParams:String = Branch.instance.getLatestReferringParams();
			trace("sessionParams: " + sessionParams);
			
			var installParams:String = Branch.instance.getFirstReferringParams();
			trace("installParams: " + installParams);
		}
		
		private function _branchEventCallback(bEvt:BranchEvent):void {
			
			trace(bEvt.type, bEvt.informations);
			
			if (bEvt.type == BranchEvent.GET_CREDITS_SUCCESSED)
				Branch.instance.redeemRewards(5);
		}
	}
}
