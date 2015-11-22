package com.ludens.utilities
{
	public class StringUtil
	{
		public function StringUtil()
		{
			
		}
		
		public static function inArray( needle:String, hayStack:Array):Boolean {
			
			for each( var item:String in hayStack){
				if( item == needle) return true;
			}
			
			 return false;
		}

	}
}