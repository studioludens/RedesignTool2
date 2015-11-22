package com.ludens.redesigntool.view.skins.drawing
{
	import com.ludens.redesigntool.view.skins.ISkin;
	
	import mx.containers.Canvas;
	
	public class DrawingItemSkinBase extends Canvas implements ISkin
	{
		//--------------------------------------------------------------------------
	    //
	   	//  Public Properties
	  	//
		//--------------------------------------------------------------------------
		
		override public function set data(value:Object):void {
			
			_data = value;
			
			//trace("set data");
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		override public function get data():Object {
			return _data;
		}
		
		
		//--------------------------------------------------------------------------
		//
		// 	Private Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _data			:Object;
		
		[Bindable]
		protected var _width		:Number;	// width of the drawing area	
		[Bindable]
		protected var _height		:Number;	// height of the drawing area
		
		[Bindable]
		protected var _dataPoints	:Array;		// array of points that describe the line
		[Bindable]
		protected var _dataString	:String;
		[Bindable]
		protected var _closed		:Boolean;	// indicates whether line is closed
		[Bindable]
		protected var _lineColor	:int;		// color of the line
		[Bindable]
		protected var _fillColor	:int;		// fill color of the line (ALSO IF NOT CLOSED?)

		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------

		public function DrawingItemSkinBase()
		{
			super();
			
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy   = "off";
			this.clipContent = false;
			
			_dataString = "M 0,0";
		}
		
		
		//--------------------------------------------------------------------------
	    //
	   	//  Private methods
	  	//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
	    //
	   	//  UIComponent override methods
	  	//
		//--------------------------------------------------------------------------
		
		override protected function commitProperties():void {
			
			_dataPoints = _data.dataPoints;
			_closed		= _data.closed;
			_lineColor	= _data.lineColor;
			_fillColor	= _data.fillColor;
			
			// generate new data string for Path (or Polyline) object
			
			var newDataString:String = "M 0,0";
			
			if( _dataPoints.length > 1 ) {
				if( _dataPoints[0] )
					newDataString = " M " + _dataPoints[0].x + "," + _dataPoints[0].y;
				
				for(var i:int = 1; i < _dataPoints.length; i++) {
					newDataString += " L " + _dataPoints[i].x + "," + _dataPoints[i].y;
				}
			}
			
			_dataString = newDataString;
		}
		
	}
}