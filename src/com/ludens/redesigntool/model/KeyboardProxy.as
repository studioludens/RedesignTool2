package com.ludens.redesigntool.model
{
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class KeyboardProxy extends Proxy implements IProxy
	{
		// the proxy name for use in PureMVC
		public static const NAME:String = "KeyboardProxy";
		
		
		public function KeyboardProxy(proxyName:String=null, data:Object=null)
		{
			//TODO: implement function
			super(NAME, data);
		}
		
		
		private var _shiftKey:Boolean = false;
		
		public function get shiftKey():Boolean {
			
			return _shiftKey;
		}
		
		public function set shiftKey(value:Boolean):void {
			//trace("[P] Keyboard shift: " + value); 
			_shiftKey = value;
		}
		
		
	}
}