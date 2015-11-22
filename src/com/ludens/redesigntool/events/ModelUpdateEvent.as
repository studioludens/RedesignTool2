package com.ludens.redesigntool.events
{
	import flash.events.Event;

	/**
	 * 
	 *  
	 * @author ludens
	 * 
	 */
	public class ModelUpdateEvent extends Event
	{
		public static const UPDATE_MODEL:String = "updateModel";
		
		public var data		:Object;
		
		public function ModelUpdateEvent(type:String, data:Object = null, 
										 bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
		}
		
		public override function clone( ):Event {
			return new ModelUpdateEvent(type, data, bubbles, cancelable );
		}		
	}
}