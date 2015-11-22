package com.ludens.redesigntool.view.components.editor.drawingitem
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.effects.AnimateProperty;
	
	public class SelectionLineView extends UIComponent
	{
		//--------------------------------------------------------------------------
	    //
	    //  Class constants
	    //
	    //--------------------------------------------------------------------------
	    
	    //--------------------------------------------------------------------------
	    //
	   	//  Public Properties
	  	//
		//--------------------------------------------------------------------------
		
		public function set dataPoints( value:Array ):void {
			_dataPoints = value;
			invalidateDisplayList();
		}
		
		public function get dataPoints():Array {
			return _dataPoints;
		}
		
		override public function set visible(value:Boolean):void {
			
			super.visible = value;
			
			if( visible ) {
				stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				startShowSelectionEffect();
			}
			else {
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				startHideSelectionEffect();
			}
		}
        
        /**
		 * drawing util
		 */
		public function set drawingUtil( value:DrawingUtil ):void {
            
			_drawingUtil = value;
        }
        
        public function get drawingUtil( ):DrawingUtil {
            return _drawingUtil;
        }
        
        
        /**
		 * sets the current (maximum) thickness of the selection
		 */
        public function set currentSelectionThickness( value:Number ):void {
            _currentSelectionThickness = value;
            
            invalidateDisplayList( );
        }
        
        public function get currentSelectionThickness( ):Number {
            return _currentSelectionThickness;
        }
        
        /**
		 * flag indicating whether the line is closed or not
		 */
		public function set closed( value:Boolean ):void {
			_closed = value;
		}
		
		public function get closed():Boolean {
			return _closed;
		}
		
		/**
		 * get the selected index
		 */	
		public function set selectedIndex(value:uint):void {
			_selectedIndex = value;
		} 
		 
		public function get selectedIndex():uint {
			return _selectedIndex;
		}
        
		//--------------------------------------------------------------------------
		//
		// 	Private Properties
		//
		//--------------------------------------------------------------------------
		
		/* drawing sprites */
		protected var _selectionSprite			:Sprite;
		
		protected var _dataPoints				:Array;
		protected var _closed					:Boolean = false;
		
		/* selection properties */
		protected var _selectionColor			:Number				= 0x156684;	
		protected var _currentSelectionThickness:Number;	
		protected var _selectedIndex			:uint;	
		
		protected var _drawingUtil				:DrawingUtil;
		
		/* effects */
		protected var _selectionToggleEffect	:AnimateProperty;
		
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------
	    
	    public function SelectionLineView( drawingUtil:DrawingUtil  ):void {
	    	
	    	super();
	    	
	    	_drawingUtil = drawingUtil;
	    	
	    	_selectionToggleEffect = new AnimateProperty( );
	    	//configureSelectionEffect();  
	    	
	    	var bevelFilter:BevelFilter = new BevelFilter();
	    	bevelFilter.blurX = 5;
	    	bevelFilter.blurY = 5;
	    	bevelFilter.quality = 3;
	    	bevelFilter.highlightAlpha = 0.6;
	    	bevelFilter.shadowAlpha = 0.6;
	    	this.filters = [ bevelFilter ];
	    }
	    
	    //--------------------------------------------------------------------------
	    //
	   	//  UIComponent override methods
	  	//
		//--------------------------------------------------------------------------
		
		override protected function createChildren():void {
			super.createChildren();
			
			_selectionSprite = new Sprite( );
			addChild( _selectionSprite );  		
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
		}
			
		override protected function measure():void {
			super.measure();
		}	
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			clearSelectionLine();
			drawSelectionLine();
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

		/**
		 * draws selection graphics
		 */        
        private function drawSelectionLine( ):void {   	
        	
        	if( _dataPoints && _dataPoints.length > 1 ) {
        		
	        	var point:Point = _dataPoints[0];
	        	
	        	_selectionSprite.graphics.moveTo( point.x, point.y );
					        	        	
	        	for( var i:uint = 1; i < _dataPoints.length; i++ ) {
	        		
	        		var selectionThickness:Number = getSelectionThicknessFromIndex( i );
	        		
	        		_selectionSprite.graphics.lineStyle( selectionThickness, _selectionColor );
	        		_selectionSprite.graphics.lineTo( _dataPoints[i].x, _dataPoints[i].y );
	        	}
	        	
	        	if( _closed )
	        		_selectionSprite.graphics.lineTo(_dataPoints[0].x, _dataPoints[0].y);
	        }
        } 
        
        /**
		 * clears the selection
		 */
        private function clearSelectionLine():void {

        	// clear selection sprite
        	_selectionSprite.graphics.clear();
        }
        
        private function getSelectionThicknessFromIndex( index:uint ):Number {

        	var normalizedRatio	:Number = 
        		_drawingUtil.getSelectionRatioByIndex(  index, 
        												_selectedIndex, 
        												_dataPoints.length, _closed);	
        									 
        	var newThickness	:Number = normalizedRatio * _currentSelectionThickness;
	       	return newThickness; 		
        }
        
        /**
         * recalculates the selected index and updates the line
         */ 
        protected function mouseMoveHandler( e:MouseEvent ):void {
        	
        	if( !e.buttonDown ) calculateSelectedIndex();
        	
        	invalidateDisplayList();
        }
        
        /**
         * calculate selected index based on mouse pos
         */ 
        protected function calculateSelectedIndex():void {

			var mousePoint:Point = new Point( mouseX, mouseY );
        	var maxDistanceToPoint:Number = 1000000000;
        	
        	for(var i:uint = 0; i < _dataPoints.length; i++) {
        		
        		var distanceToPoint:Number = Point.distance(_dataPoints[i], mousePoint);
        		
        		if(distanceToPoint < maxDistanceToPoint) {
        			maxDistanceToPoint 	= distanceToPoint;
        			_selectedIndex = i;
        		}
        	}
        }

		/* EFFECTS */        
        
        /**
		 * configures the properties of the selection effect
		 * this method is e.g. called when the _maxSelectionThickness is changed
		 */
		/*
		private function configureSelectionEffect( ):void {
        	
        	if( !_drawingSettings )
        		return;
        	
        	_selectionToggleEffect.property  = 'currentSelectionThickness';
        	_selectionToggleEffect.fromValue = 0;
        	_selectionToggleEffect.toValue   = _drawingSettings.maxSelectionThickness;
        	_selectionToggleEffect.duration  = 200;
        	_selectionToggleEffect.easingFunction = Sine.easeOut;
        	
        	_selectionToggleEffect.target = this;
        }
        */
        
        
        // effects are currently not animations but just a "hard" change
        
        /**
		 * show line by running selection line effect
		 */
        private function startShowSelectionEffect( ):void {

			this.currentSelectionThickness = 20;
			/*
        	_selectionToggleEffect.duration = 200;        	
        	
        	if( _selectionToggleEffect.isPlaying )
	        	_selectionToggleEffect.reverse( );
	        else
	        	_selectionToggleEffect.play( [this], false );
	        */     	
        }
        
        /**
		 * hide line by running selection line effect backwards
		 */
        private function startHideSelectionEffect( ):void {
        	
        	this.currentSelectionThickness = 0;
        	/*
        	_selectionToggleEffect.duration = 200;
        	
        	if( _selectionToggleEffect.isPlaying )
	        	_selectionToggleEffect.reverse( );
	        else
        		_selectionToggleEffect.play( [this], true );  	
        	*/
        }
	}
}