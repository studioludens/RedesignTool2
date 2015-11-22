package com.ludens.redesigntool.events
{
	import flash.events.Event;

	/**
	 * The class for the Event fired when data is loaded from the backend server
	 *  
	 * @author ludens
	 * 
	 */
	public class DataLoadedEvent extends Event
	{
		
		public static const UPLOADED_IMAGE:String = "uploadedImage";
		
		public var imageUrl:String;
		public var imageWidth:Number;
		public var imageHeight:Number;
		
		public function DataLoadedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			//TODO: implement function
			super(type, bubbles, cancelable);
		}
		
	}
}