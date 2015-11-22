package com.ludens.redesigntool.view.skins.drawing
{
	import flash.filters.BevelFilter;
	
	public class SimpleDrawingItemSkin extends DrawingItemSkinBase
	{
		public function SimpleDrawingItemSkin()
		{
			super();
			
			var bevelFilter:BevelFilter = new BevelFilter();
			bevelFilter.quality = 3;
			bevelFilter.distance = 4;
			bevelFilter.blurX = 6;
			bevelFilter.blurY = 6;
			bevelFilter.shadowAlpha = 0.5;
			bevelFilter.highlightAlpha = 0.5;
			
			this.filters = [ bevelFilter ];
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			this.graphics.clear();
			
			if( _dataPoints && _dataPoints.length > 1 ) {
			
				// set line style
				this.graphics.lineStyle( 2, _lineColor );
				// start fill if line is closed
				if( _closed ) this.graphics.beginFill( _fillColor, 1 );
			
				// move to first point
				this.graphics.moveTo( _dataPoints[0].x, _dataPoints[0].y );
				
				// draw line for each point
				for( var i:int = 1; i < _dataPoints.length; i++ ) {
					this.graphics.lineTo( _dataPoints[i].x, _dataPoints[i].y );
				}
				
				// end fill if filled 
				if( _closed ) this.graphics.endFill();
			}
		}
		
	}
}