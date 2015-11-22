package com.ludens.redesigntool.events
{
	import flash.events.Event;

	/**
	 * The class for the Event fired when data is saved to the backend server
	 *  
	 * @author ludens
	 * 
	 */
	public class DataSavedEvent extends Event
	{
		
		public function DataSavedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}