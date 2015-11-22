package com.ludens.redesigntool.view.components.editor.drawingitem
{
	import com.ludens.redesigntool.events.ModelUpdateEvent;
	import com.ludens.redesigntool.events.PropertyUpdateEvent;
	import com.ludens.redesigntool.model.om.DrawingItem;
	import com.ludens.redesigntool.model.om.DrawingSettings;
	import com.ludens.redesigntool.view.components.editor.SketchItemBaseView;
	import com.ludens.redesigntool.view.skins.SkinUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.registerClassAlias;
	
	import mx.events.FlexEvent;
	import mx.utils.ObjectUtil;
	
	import org.hasseg.externalMouseWheel.ExternalMouseWheelSupport;
	
	/**
	 * 
	 * 
	 * Model equivalent: DrawingItem
	 * 
	 * @author ludens
	 */
	
	public class DrawingItemView extends SketchItemBaseView
	{
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public Properties
	  	//
		//--------------------------------------------------------------------------
		
		/**
		 * data object
		 */
		override public function set data(value:Object):void {
			
			super.data = value;
			
			// if no data points, the line still has to be drawn,
			// and thus set _drawing to TRUE
			var dataPointsEmpty:Boolean = data.dataPoints.length == 0;
			if( dataPointsEmpty ) {
				_drawing = true;
			}
			else if( !_drawing ) {
				_selectionLine.dataPoints = value.dataPoints;
			}
		}
		
		override public function get data():Object {	
			return _data;
		}
		
		/**
		 * selected flag
		 */
		override public function set selected(value:Boolean):void {
			
			super.selected = value;
			
			_selectionLine.visible = value;
		}
		
		/**
		 * drawing settings
		 */
		public function set drawingSettings(value:DrawingSettings):void {
			_drawingUtil.drawingSettings = value;
			_selectionLine.invalidateDisplayList();
		}
		
		public function get drawingSettings():DrawingSettings {
			return _drawingUtil.drawingSettings;
		}
		
		//--------------------------------------------------------------------------
		//
		// 	Private Properties
		//
		//--------------------------------------------------------------------------
		
		// selection line
		private var _selectionLine:SelectionLineView;
				
		// flag indicating whether line is being drawn (i.e. receiving new data points)
		private var _drawing			:Boolean;
		
		protected var _oldMousePos		:Point;
		
		protected var _drawingUtil		:DrawingUtil;
		
		private var _scrollWheelSupport	:ExternalMouseWheelSupport;
		
		
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------
	    
	    public function DrawingItemView(  )
		{
			super();
			
			_drawingUtil = new DrawingUtil();
			
			// register drawing item class to make sure the casting of the copying works
			registerClassAlias("com.ludens.redesigntool.model.om.DrawingItem",DrawingItem);
			
			_skinType = SkinUtil.DRAWING_TYPE;
			
			addEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			
			// scroll wheel support for selection range
			
			ExternalMouseWheelSupport.registerAutomatically = false;
			_scrollWheelSupport = ExternalMouseWheelSupport.instance;
			_scrollWheelSupport.registerObject( this );
			addEventListener( MouseEvent.MOUSE_WHEEL, mouseWheelHandler );
			
		}
		
		
		//--------------------------------------------------------------------------
	    //
	   	//  UIComponent methods
	  	//
		//--------------------------------------------------------------------------

		override protected function createChildren():void {
			
			_selectionLine = new SelectionLineView( _drawingUtil );
			_selectionLine.closed = false;
			addChild(_selectionLine);
			
			super.createChildren();
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}

		//--------------------------------------------------------------------------
	    //
	   	//  Public  methods
	  	//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
	    //
	   	//  Private methods
	  	//
		//--------------------------------------------------------------------------
		
		private function creationCompleteHandler(event:FlexEvent):void {
			
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, doEdit );
			stage.addEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );	
		}
		
		protected function mouseDownHandler(event:MouseEvent):void {
			
			//super.mouseDownHandler(event);
			
			_oldMousePos = new Point( mouseX, mouseY );
 	    	
        	stage.addEventListener( MouseEvent.MOUSE_MOVE, doEdit );
        	stage.addEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
		}
		
		private function mouseUpHandler(event:MouseEvent):void {
			
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, doEdit );
        	stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
			
			if( _drawing ) {
				checkForClosingAfterDrawing();
				if( _data.dataPoints.length == 0 )
					_data.dataPoints = [ new Point(0,0), new Point(0,0) ];
				// stop drawing
				_drawing = false;
			}
		
			
			// relativate the data
			relativateData( );
			// create a copy to be send to the event
			var relativatedData:DrawingItem = ObjectUtil.copy( data ) as DrawingItem;
			
			// send event for update of model
			var updateEvent:ModelUpdateEvent = new ModelUpdateEvent( ModelUpdateEvent.UPDATE_MODEL, relativatedData );
			dispatchEvent( updateEvent );
		}
		
		private function mouseWheelHandler( event:MouseEvent ):void {
			
			var evt:PropertyUpdateEvent = new PropertyUpdateEvent( PropertyUpdateEvent.UPDATE );
			evt.propertyName = "selectionRange";
			evt.newValue = event.delta;
			
			dispatchEvent(evt);
		}
		
		private function doEdit( event:MouseEvent ):void {
			
			// if drawing...
			if( _drawing ) {
				// ...add new mouse location to dataPoints
				_data.dataPoints.push( new Point( mouseX, mouseY ) );
				_data.dataPoints = _drawingUtil.smartSmoothPoints( data.dataPoints, data.closed, 
																   data.dataPoints.length-1, false );
				data = _data;
			}
			else {
				var newMousePos:Point = new Point( mouseX, mouseY );				
				var newDataPoints:Array = _drawingUtil.dragPoints( data.dataPoints, data.closed, 
															   _oldMousePos, newMousePos, 
															   _selectionLine.selectedIndex );
				_data.dataPoints = newDataPoints;
				data = _data;
				
				_oldMousePos = newMousePos;
			}
			
			spreadDataPoints();
			checkForClosingAfterDrawing();
			
		}

		private function checkForClosingAfterDrawing():void {
			
			var closingDistance 	:Number = 15;
			var minPointsForCheck 	:Number = 5;
			
			/* TEMP HACK ?? */
			if( _data.dataPoints.length > minPointsForCheck ) {
			
				var distanceBetweenEndPoints:Number = 
					Point.distance( _data.dataPoints[0], _data.dataPoints[ _data.dataPoints.length-1 ] );
					
				if( distanceBetweenEndPoints < closingDistance ) {
					_data.closed = true;
					data = _data;
					_selectionLine.closed = true;
				}
				else {
					_data.closed = false;
					data = _data;
					_selectionLine.closed = false;
				}
			}
		}

		/**
		 * loops through the data points and creates a new data object,
		 * with a tight bounding box around the data points and a new x and y
		 */
		private function relativateData( ):void {
			
			var newData:DrawingItem = ObjectUtil.copy( data ) as DrawingItem;
			
			// min and max gets us the bounding box of the current
			// set of data points
			if( _data && _data.dataPoints && _data.dataPoints[0] ) {
				var minX:Number = _data.dataPoints[0].x;
				var minY:Number = _data.dataPoints[0].y;
				var maxX:Number = _data.dataPoints[0].x;
				var maxY:Number = _data.dataPoints[0].y;
			}

			// get the min and max values by looping through all the
			// data points and saving the lowest and highest values
			for each( var oldDataPoint:Point in _data.dataPoints ) {
				
				if( oldDataPoint.x < minX ) minX = oldDataPoint.x;
				if( oldDataPoint.y < minY ) minY = oldDataPoint.y;
				if( oldDataPoint.x > maxX ) maxX = oldDataPoint.x;
				if( oldDataPoint.y > maxY ) maxY = oldDataPoint.y;
			}
			
			// update x, y, width and height
			newData.x 		= _data.x + minX;
			newData.y 		= _data.y + minY;
			newData.width 	= maxX - minX;
			newData.height 	= maxY - minY;
			
			var deltaX:Number = newData.x - _data.x;
			var deltaY:Number = newData.y - _data.y;   
			
			// update the datapoints based on new x and y
			newData.dataPoints = [];
			for each( var oldDataPoint2:Point in _data.dataPoints ) {
				
				newData.dataPoints.push( new Point( oldDataPoint2.x - deltaX,
													oldDataPoint2.y - deltaY ) );
			}
			
			// update data
			data = newData;
		}
		
		/**
		 * function that spreads that data points of the line.
		 * It adds and/or removes points between others, depending on whether
		 * their distances are larger or smaller than the limits
		 */
		private function spreadDataPoints(  ):void {
        	
        	var lowerLimit:Number = 4;
        	var upperLimit:Number = 8;
        	
        	var tempDataPoints:Array = ObjectUtil.copy(data.dataPoints) as Array;
        	
        	if( tempDataPoints.length < 4 )
        		return;
        	
        	// variables used in this function
        	var distanceBetweenPoints:Number;
        	var dataPoints1:Array;
        	var dataPoints2:Array;
        	
        	// remove any points that are too close to their next neighbor
        	for(var i:uint = 0; i < tempDataPoints.length-1; i++) {
        		
        		distanceBetweenPoints = Point.distance( tempDataPoints[i], tempDataPoints[i+1] );
        		
        		if( distanceBetweenPoints < lowerLimit) {
        			
        			dataPoints1 = tempDataPoints.slice(0, i+1);
        			dataPoints2 = tempDataPoints.slice(i+2, tempDataPoints.length);
        			
        			for(var j:uint = 0; j < dataPoints2.length; j++) {
        				dataPoints1.push( dataPoints2[j] );
        			}
        			
        			if(i < _selectionLine.selectedIndex)
        				_selectionLine.selectedIndex--;
        			
        			tempDataPoints = dataPoints1;
        		}
        	}
 
        	
        	// add a point in between any two points that are too far away from one another
        	for(var k:uint = 0; k < tempDataPoints.length-1; k++) {
        		
        		distanceBetweenPoints = Point.distance( tempDataPoints[k], tempDataPoints[k+1] );
        		
        		if( distanceBetweenPoints > upperLimit ) {
        			
        			var newPoint:Point = Point.interpolate( tempDataPoints[k], tempDataPoints[k+1], 0.5);	
        			dataPoints1 = tempDataPoints.slice(0, k+1);
        			dataPoints2 = tempDataPoints.slice(k+1, tempDataPoints.length);
        			
        			dataPoints1.push(newPoint)
        			for(var l:uint = 0; l < dataPoints2.length; l++) {
        				dataPoints1.push( dataPoints2[l] );
        			}
        			
        			if(k < _selectionLine.selectedIndex)
        				_selectionLine.selectedIndex++;
        			
        			tempDataPoints = dataPoints1;
        		}
        	}
        	
        	if( data.closed ) {
        	
	        	// remove non-selected endpoint if distance between end point is too small
	        	var distanceBetweenEndPoints:Number = 
	        			Point.distance( tempDataPoints[0], tempDataPoints[tempDataPoints.length-1] );
	        	
	        	if(	distanceBetweenEndPoints < lowerLimit ) {
	      			if( _selectionLine.selectedIndex == 0)
	      				tempDataPoints.pop();
	      			else
	      				tempDataPoints.unshift();  
	        	}
	        	
	        	// add a point in between the two end points if they are too far away from one another
	        	distanceBetweenEndPoints = 
	        			Point.distance( tempDataPoints[0], tempDataPoints[tempDataPoints.length-1] );
	        	
	        	if(	distanceBetweenEndPoints > upperLimit ) {
	      			var newPoint2:Point = Point.interpolate( tempDataPoints[0], 
	      													tempDataPoints[tempDataPoints.length-1], 
	      													 0.5);
	      			tempDataPoints.push(newPoint2);
	      		}
	      	}
	      	
	      	data.dataPoints = tempDataPoints;
	      	data = _data;		
        }
	}
}