package com.ludens.redesigntool.view.components.editor.drawingitem
{
	import com.ludens.redesigntool.model.DrawingSelectionTypes;
	import com.ludens.redesigntool.model.om.DrawingSettings;
	
	import flash.geom.Point;
	
	public class DrawingUtil
	{	
	    //--------------------------------------------------------------------------
	    //
	   	//  Public Properties
	  	//
		//--------------------------------------------------------------------------
		
		/**
		 * drawing settings
		 */
		public function set drawingSettings( value:DrawingSettings ):void {
            
			_drawingSettings = value;
        }
        
        public function get drawingSettings( ):DrawingSettings {
            return _drawingSettings;
        }
        
        //--------------------------------------------------------------------------
		//
		// 	Private Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _drawingSettings			:DrawingSettings;
		
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------
	    
		public function DrawingUtil()
		{
			_drawingSettings = new DrawingSettings();
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public  methods
	  	//
		//--------------------------------------------------------------------------
		
		public function getMaxRatio():Number {
			
			return this.getProbability(0,0, _drawingSettings.selectionRange);
		}
		
		public function getSelectionRatioByIndex( currentIndex:uint, selectedIndex:uint, numberOfPoints:Number, closedLine:Boolean ):Number {

			var ratio:Number = 0;
			
			var maxRatio:Number = getMaxRatio();
			var closedRatio:Number = 0;
			
			var distanceToSelectedIndex	:uint;
			
        	switch( _drawingSettings.selectionType ) {
        		
        		case DrawingSelectionTypes.BELL_SELECTION:
        			
		        	distanceToSelectedIndex = Math.abs( selectedIndex - currentIndex );
		    		
		    		ratio = getProbability( currentIndex,
		    							    selectedIndex,
		    							    _drawingSettings.selectionRange) / maxRatio;

		    		if( closedLine ) {
		    			closedRatio = 0;
		    			if( currentIndex < selectedIndex )
		    				closedRatio = getProbability( currentIndex + numberOfPoints,
		    											  selectedIndex,
		    											  _drawingSettings.selectionRange) / maxRatio;
		    			else
		    				closedRatio = getProbability( currentIndex - numberOfPoints,
		    											  selectedIndex,
		    											  _drawingSettings.selectionRange) / maxRatio;
		    			ratio = Math.max( ratio, closedRatio );
		    		}
		    		
		    		break;
		    		
		    	case DrawingSelectionTypes.BLOCK_SELECTION:
		    		
			    	if( Math.abs(currentIndex - selectedIndex) < _drawingSettings.selectionRange ) {
		    			ratio = 1;
			    	}
			    	else if( closedLine ) {
						if( currentIndex < selectedIndex &&
							Math.abs(currentIndex + numberOfPoints - selectedIndex) < _drawingSettings.selectionRange)
							ratio = 1;
						else if( currentIndex > selectedIndex &&
							Math.abs(currentIndex - selectedIndex + numberOfPoints) < _drawingSettings.selectionRange)
							ratio = 1;	
			    	}
		    		
		    		break; 
		    		
		    	case DrawingSelectionTypes.LINEAR_SELECTION:
		    	
		    		distanceToSelectedIndex = Math.abs( selectedIndex - currentIndex );
		    		
		    		ratio = Math.max( 0, ( _drawingSettings.selectionRange - distanceToSelectedIndex ) / _drawingSettings.selectionRange );
		    				
		    		if( closedLine ) {
		    			closedRatio = 0;
		    			closedRatio = Math.max( 0, 
		    							( _drawingSettings.selectionRange - Math.abs( distanceToSelectedIndex - numberOfPoints ) ) 
		    								/ _drawingSettings.selectionRange );
		    			ratio = Math.max( ratio, closedRatio );
		    		}
		    		
		    		break;
        	}
    		
	       	return ratio;	
		}
		
		/**
		 * drag function
		 */
		public function dragPoints( data:Array, closedLine:Boolean, 
									normOldMousePos:Point, normNewMousePos:Point, 
									selectedIndex:uint ):Array {
			
			var newDataPoints	:Array			= new Array();	
			
			var mouseXDisplacement:Number = normOldMousePos.x - normNewMousePos.x;
        	var mouseYDisplacement:Number = normOldMousePos.y - normNewMousePos.y;
        	
        	var maxPropability:Number = getProbability(0,0, _drawingSettings.selectionRange);
        	
        	for(var i:int = 0; i < data.length; i++) {
        			
        		if(data[i]) {
        			
        			var ratio:Number = 
        					getSelectionRatioByIndex( i,
        										  	  selectedIndex,
        										  	  data.length,
        										  	  closedLine );    					  	     										  	 
        					
	        		var newX:Number = data[i].x - mouseXDisplacement * ratio;
	        		var newY:Number = data[i].y - mouseYDisplacement * ratio;
	        		
        			newDataPoints[i] = new Point(newX, newY);
        		}
        	}
        	
        	return newDataPoints;
  		}
  		
  		
  		/**
  		 * smart smooth
  		 */
  		public function smartSmoothPoints( data:Array, closedLine:Boolean, 
										   selectedIndex:uint, overallSmooth:Boolean):Array {						   	 	  						   	 	  	
			
			// if there are fewer than 5 data points, there is no "point" in smoothing
			if(data.length < 5)
				return data;
											   	 	
			var newDataPoints		:Array			= new Array();									   	 	
			
			var maxPropability		:Number = getMaxRatio();
			
			var previousPointAngle	:Number;
			var currentPointAngle	:Number;
			var nextPointAngle		:Number;
        	
        	for(var i:uint = 0; i < data.length; i++) {
        		
        		// get angles of lines
        		
        		var minus2Point		:Point = null;
        		var minus1Point		:Point = null;
        		var zeroPoint		:Point = null;
        		var plus1Point		:Point = null;
        		var plus2Point		:Point = null;
        		
        		var minus21Angle	:Number;
        		var minus10Angle	:Number;
        		var plus01Angle		:Number;
        		var plus12Angle		:Number;
        		
        		var firstSmooth		:Boolean = false;	
        		
        		if( i == 0 && closedLine) {
        			minus2Point = data[data.length-2];
        			minus1Point = data[data.length-1];
        			zeroPoint   = data[0];
        			plus1Point  = data[1];
        			plus2Point  = data[2];
        			firstSmooth = true;
        		}
        		else if( i == 1 && closedLine ) {
        			minus2Point = data[data.length-1];
        			minus1Point = data[0];
        			zeroPoint   = data[1];
        			plus1Point  = data[2];
        			plus2Point  = data[3];
        		}
        		else if( i == 2 && !closedLine ) {
        			minus2Point = data[0];
        			minus1Point = data[1];
        			zeroPoint   = data[2];
        			plus1Point  = data[3];
        			plus2Point  = data[4];
        			firstSmooth = true;
        		}
        		else if( i > 2 && data[i+2] ) {
        			minus2Point = data[i-2];
        			minus1Point = data[i-1];
        			zeroPoint   = data[i];
        			plus1Point  = data[i+1];
        			plus2Point  = data[i+2];
        		}
        		else if( i == data.length-2 && closedLine ) {
        			minus2Point = data[i-2];
        			minus1Point = data[i-1];
        			zeroPoint   = data[i];
        			plus1Point  = data[i+1];
        			plus2Point  = data[0];
        		}
        		else if( i == data.length-1 && closedLine ) {
        			minus2Point = data[i-2];
        			minus1Point = data[i-1];
        			zeroPoint   = data[i];
        			plus1Point  = data[0];
        			plus2Point  = data[1];
        		}
        		else {
        			newDataPoints[i] = data[i];
        		}
        		
        		if(plus1Point) {
        		
	        		if(minus2Point && minus1Point)
	        			minus21Angle = getAngleOfLine( minus2Point, minus1Point );
	        		if(minus1Point && zeroPoint)
	        			minus10Angle = getAngleOfLine( minus2Point, zeroPoint );
	        		if(zeroPoint   && plus1Point)
	        			plus01Angle = getAngleOfLine( zeroPoint, plus1Point );
	        		if(plus1Point  && plus2Point)
	        			plus12Angle = getAngleOfLine( plus1Point, plus2Point );
	        			
	        		
	        		// get angles of points (absolute angle between the two lines touching the point)
	        		
	        		if(minus21Angle && minus10Angle && plus01Angle) {
	        			previousPointAngle = getDifferenceBetweenAngles( minus21Angle, minus10Angle, true );
	        			currentPointAngle = getDifferenceBetweenAngles( minus10Angle, plus01Angle, true );
	        		}
	        		else {
	        			// previous "current point angle" is now "previous point angle"
		    			previousPointAngle = currentPointAngle;
		    			// previous "next point angle" is now "current point angle"
		    			currentPointAngle = nextPointAngle;
	        		}
	        		
	        		if(plus01Angle && plus12Angle) {
		    			nextPointAngle = getDifferenceBetweenAngles( plus01Angle, plus12Angle );
	        		}
	        		
	        		// determine ratio
	        		var ratio:Number;
	    			if( overallSmooth ) {
	    				ratio = 0.5;
	    			} else {
	    				var curPropability:Number = 
	    					getSelectionRatioByIndex( i, selectedIndex,
	    										  	  data.length, closedLine );     
	    				//trace( _drawingSettings.smoothStrength );  										  	 				
	    				ratio = curPropability * _drawingSettings.smoothStrength;
	    			}
	    			
	    			// determine smoothing for current point
	        		
	        		// bump _/\_ compensation
	        		
	        		var differenceBetweenPreviousAndNext:Number = Math.abs( minus21Angle - plus12Angle );
	    			
	    			var bumpStrength	:Number = 0.95;
	    			var bumpRatio		:Number = ratio * Math.max(1 - bumpStrength * Math.pow(differenceBetweenPreviousAndNext, 0.1 ), 0);
	    			var maxNewPoint		:Point  = Point.interpolate( minus1Point, plus1Point, 0.5 );
	        		var unbumpedPoint	:Point  = Point.interpolate( maxNewPoint, zeroPoint, bumpRatio  );
	        		 
	        		ratio = Math.max(0, ratio - ( getDifferenceBetweenAngles( minus10Angle, plus01Angle ) ) ) ;
	        		
	        		newDataPoints[i] 	= Point.interpolate( maxNewPoint, unbumpedPoint, ratio  );	
	        		
	        		
	        		
	        		// smooth curves (but not corners)
	        		
	        		var currentPointAngle180:Number;
	        		
	        		currentPointAngle180 = (currentPointAngle > 180) ? currentPointAngle - 180
	        														 : currentPointAngle;
	        	}
        	}
        	
        	return newDataPoints;						   	 	  	
		}
  		
  		
		
		//--------------------------------------------------------------------------
	    //
	   	//  Private methods
	  	//
		//--------------------------------------------------------------------------
		
		/**
         * used by getSelectionRatioByIndex() to get selection value of 1 point
         */ 		
		private function getProbability(value:Number, mean:Number, variance:Number):Number {
        	
        	var eExp		:Number = -0.5 * ( ( value - mean ) / variance ) *
											 ( ( value - mean ) / variance );
        	var propability	:Number = ( 1 / ( variance * Math.sqrt(2*Math.PI) ) ) * Math.exp(eExp); 
        	
        	return propability;
        }
        
        /**
         * get angle of a line segment
         */
        private static function getAngleOfLine(p1:Point, p2:Point):Number {
			
			return Math.atan2( p2.y - p1.y, p2.x - p1.x );
		}
		
		/**
		 * get smallest difference between two angles.
		 * strictOrder set to true will force the angle to be calculated from angle 1 clockwise to angle 2
		 */
		private static function getDifferenceBetweenAngles(angle1:Number, angle2:Number, strictOrder:Boolean = false):Number {
			
			var angleDifference:Number;
			
			// normalize angles
			angle1 = angle1 % ( 2 * Math.PI );
			angle2 = angle2 % ( 2 * Math.PI );
			
			// make sure it's between 0 and 360
			if( angle1 < 0 )
				angle1 += 2 * Math.PI;
			if( angle2 < 0 )
				angle2 += 2 * Math.PI;	
			
			// calc difference
			angleDifference = Math.abs( angle1 - angle2 );
			
			// check whether the angle is smaller "over the 2PI border"	
			if( angle1 < angle2 ) {
				angle2 =- 2 * Math.PI;			
			}
			else if( angle1 > angle2 && strictOrder ) {
				angle2 =+ 2 * Math.PI;
			}
			
			var newAngleDifference:Number = Math.abs( angle1 - angle2 );
			if (newAngleDifference < angleDifference)
				angleDifference = newAngleDifference;
				
			return angleDifference;
		}
	}
}