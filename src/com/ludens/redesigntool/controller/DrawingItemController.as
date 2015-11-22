package com.spruit.controller
{
	import com.spruit.event.EditorSettingsEvent;
	
	import flash.events.EventDispatcher;
	
	public class DrawingItemController extends EventDispatcher
	{
		//--------------------------------------------------------------------------
	    //
	    //  Class constants
	    //
	    //--------------------------------------------------------------------------
	    
	    public static const MOVE_EDIT	:String = "moveedit";
	    public static const DRAG_EDIT	:String = "dragedit";
	    public static const SMOOTH_EDIT	:String = "smoothedit";
	    
	    public static const BELL_SELECTION  :String = "bellselection";
	    public static const BLOCK_SELECTION :String = "blockselection";
	    public static const LINEAR_SELECTION :String = "linearselection";
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public Properties
	  	//
		//--------------------------------------------------------------------------
				  
		//The public static method that gains acces to the instance
		public static function get instance():DrawingItemController {
			if(DrawingItemController._instance == null) {
				DrawingItemController._instance = new DrawingItemController(new SingletonEnforcer() );
			}
			
			return DrawingItemController._instance;
		}
		
		/**
		 * selection range
		 *   - bell curve: 1 standard deviation
		 *   - block curve & linear curve: from top to 0
		 */
		public function set selectionRange( value:Number ):void {
			_selectionRange = value;
			_maxRatio		   = getSelectionRatioByIndex(0,0,1,false);
			
			//trace("maxRatio: " + _maxRatio);
			
			var event:EditorSettingsEvent = 
					new EditorSettingsEvent(EditorSettingsEvent.NEW_SELECTION_VARIANCE);
			dispatchEvent(event);
		}
		
		public function get selectionRange( ):Number {
			return _selectionRange;
		}
		
		/**
		 * mode of editing
		 */
		public function set editMode( value:String ):void {
			_editMode = value;
		}
		
		public function get editMode( ):String {
			return _editMode;
		}
		
		/**
		 * mode of selection
		 */
		public function set selectionMode( value:String ):void {		
			_selectionMode = value;
			_maxRatio	   = getSelectionRatioByIndex(0,0,1,false);
		}
		
		public function get selectionMode( ):String {
			return _selectionMode;
		}
		
		
		public function get maxRatio( ):Number {
			return _maxRatio;
		}
		
		// arbitrary value at the moment
		public var smoothStrength:Number = 0.1;
		
		//--------------------------------------------------------------------------
		//
		// 	Private Properties
		//
		//--------------------------------------------------------------------------
		
		//The private static property that holds the instance
		private static var _instance	:DrawingItemController;
		
		private var _selectionRange		:Number;
		private var _maxRatio			:Number;
		private var _editMode			:String;
		private var _selectionMode		:String;
		 
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------
		 
		/**
		 * The constructor (that needs an SingletonEnforcer instance as an parameter)
		 */
		public function DrawingItemController( enforcer:SingletonEnforcer ) {
			_editMode = "smoothedit";
			_selectionMode = "blockselection";
			selectionRange = 5;
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public  methods
	  	//
		//--------------------------------------------------------------------------
		
		public function getSelectionRatioByIndex( currentIndex:uint, selectedIndex:uint, numberOfPoints:Number, closedLine:Boolean ) {

			var ratio:Number = 0;

        	switch(_selectionMode) {
        		
        		case DrawingItemController.BELL_SELECTION:
        	
		        	var distanceToSelectedIndex	:uint = Math.abs( selectedIndex - currentIndex );
		    		
		    		ratio = getProbability( currentIndex,
		    							    selectedIndex,
		    							    _selectionRange);		
		    		if( closedLine ) {
		    			var closedRatio:Number = 0;
		    			if( currentIndex < selectedIndex )
		    				closedRatio = getProbability( currentIndex + numberOfPoints,
		    											  selectedIndex,
		    											  _selectionRange);
		    			else
		    				closedRatio = getProbability( currentIndex - numberOfPoints,
		    											  selectedIndex,
		    											  _selectionRange);
		    			ratio = Math.max( ratio, closedRatio );
		    		}
		    		
		    		break;
		    		
		    	case DrawingItemController.BLOCK_SELECTION:
		    	
		    		if( Math.abs(currentIndex - selectedIndex) < _selectionRange ) {
		    			
		    			ratio = (_maxRatio) ? _maxRatio
		    								: 1;
			    	
				    	if( closedLine ) {
				    		var closedRatio:Number = 0;
			    			if( currentIndex < selectedIndex )
			    				closedRatio = getProbability( currentIndex + numberOfPoints,
			    											  selectedIndex,
			    											  _selectionRange);
			    			else
			    				closedRatio = getProbability( currentIndex - numberOfPoints,
			    											  selectedIndex,
			    											  _selectionRange);								  							  

			    			ratio = Math.max( ratio, closedRatio );
			    		}		
			    	} 
		    		
		    		break; 
		    		
		    	case DrawingItemController.LINEAR_SELECTION:
		    	
		    		var distanceToSelectedIndex	:uint = Math.abs( selectedIndex - currentIndex );
		    		
		    		ratio = Math.max( 0, (_selectionRange - distanceToSelectedIndex ) / _selectionRange );
		    				
		    		if( closedLine ) {
		    			var closedRatio:Number = 0;
		    			closedRatio = Math.max( 0, 
		    							(_selectionRange - Math.abs( distanceToSelectedIndex - numberOfPoints ) ) 
		    								/ _selectionRange );
		    			ratio = Math.max( ratio, closedRatio );
		    		}
		    		
		    		break;
        	}
    		
	       	return ratio;	
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  Private methods
	  	//
		//--------------------------------------------------------------------------
		
		private function getProbability(value:Number, mean, variance):Number {
        	
        	var eExp		:Number = -0.5 * ( ( value - mean ) / variance ) *
											 ( ( value - mean ) / variance );
        	var propability	:Number = ( 1 / ( variance * Math.sqrt(2*Math.PI) ) ) * Math.exp(eExp); 
        	
        	return propability;
        }
	}
}

//The private class
class SingletonEnforcer {};