package com.ludens.redesigntool.model.om
{
	/**
	 * The OM class implementation of a Drawing Item object 
	 * 
	 * <p>A DrawingItem is the representation of a line drawn by the user. </p>
	 *  
	 * @author ludens
	 * 
	 */	
	public class DrawingItem extends SketchItem
	{
		
		public var dataPoints:Array;
		public var closed:Boolean;
		public var lineColor:uint;
		public var fillColor:uint;
		
		
		
		
		public function DrawingItem()
		{
			//TODO: implement function
			super();
			
			dataPoints = new Array();
		}
		
	}
}