package com.ludens.redesigntool.model
{
	import com.ludens.redesigntool.controller.Notifications;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class AppSettingsProxy extends Proxy implements IProxy
	{
		//--------------------------------------------------------------------------
	    //
	    //  Class constants
	    //
	    //--------------------------------------------------------------------------
		
		// the proxy name for use in PureMVC
		public static const NAME:String = "AppSettingsProxy";
		
		public static const BASE_PATH:String = "http://www.redesignme.com/";
		public static const IMAGE_UPLOAD_PATH:String = "http://www.redesignme.com/redesignme/upload.php";
		public static const REDESIGN_SAVE_PATH:String = "http://www.redesignme.com/redesignme/save.php";
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public Properties
	  	//
		//--------------------------------------------------------------------------
		
		public var path				:String;
		public var sessionId		:String;
		public var ixItem			:String;
		public var imgIndex			:String;
		
		public function set scaleRatio( value:Number ):void {
			
			if( value > 0 ) {
				_scaleRatio = value;
				sendNotification( Notifications.SCALE_RATIO_CHANGED, _scaleRatio );
			}
			else
				trace( "[P] scale ratio cannot be <= 0" );
		}
		
		public function get scaleRatio():Number {
			
			return (_scaleRatio) ? _scaleRatio
								 : 100;
		}
		
		
		//--------------------------------------------------------------------------
		//
		// 	Private Properties
		//
		//--------------------------------------------------------------------------
		
		private var _scaleRatio:Number;
		
		
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------
	    
		public function AppSettingsProxy(  )
		{
			super( NAME );
		}
		
	}
}