package com.ludens.redesigntool.events
{
	import flash.events.Event;

	/**
	 * 
	 *  
	 * @author ludens
	 * 
	 */
	public class PropertyUpdateEvent extends Event
	{
		public static const UPDATE:String = "update";
		
		public var propertyName	:String;
		public var newValue		:Object;
		
		public function PropertyUpdateEvent(type:String, propertyName:String = null, newValue:Object = null, 
											bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.propertyName = propertyName;
			this.newValue	  = newValue;
		}
		
		public override function clone( ):Event {
			return new PropertyUpdateEvent(type, propertyName, newValue, bubbles, cancelable );
		}		
	}
}