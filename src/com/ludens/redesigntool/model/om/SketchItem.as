package com.ludens.redesigntool.model.om
{
	import mx.utils.UIDUtil;
	
	/**
	 * The base class implementation for SketchItem objects. 
	 * objects used in a Redesign Sketch should extend this class
	 * 
	 * <p>All SketchItems have an id that has to be unique. The
	 * RedesignProxy class will take care of assigning all items
	 * a unique id. </p>
	 * @author ludens
	 * 
	 */	
	public class SketchItem
	{
		
		// the unique identifier of this item
		public var id:String;
		
		
		public var x:Number;
		public var y:Number;
		
		public var width:Number;
		public var height:Number;
		
		public var rotation:Number;
		
		/**
		 * a textual representation of the skin
		 */
		public var skinName:String = "DEFAULT_SKIN";

		public function SketchItem(data:Object = null)
		{
			// generate a unique id
			id = UIDUtil.createUID();
			
			if(data){
				if(data.x is Number)
					x = data.x;
				
				if(data.y is Number)
					y = data.y;
					
				if(data.width is Number)
					width = data.width;
				
				if(data.height is Number)
					height = data.height;
					
			}
			
		}
	}
}