package com.ludens.utilities
{
	import flash.geom.Point;
	
	
	public class PointUtil
	{
		/**
		 * translates normalized points to absolute points
		 */
		public static function denormalizePoints( normPoints:Array, scaleRatio:Number ):Array {
			
			// translate normalized points to absolute points
			var absPoints:Array = new Array();
			
			for each( var normPoint:Point in normPoints ) {	
				absPoints.push( new Point( normPoint.x * scaleRatio, normPoint.y * scaleRatio )  );
			}
			
			return absPoints;
		}
		
		/**
		 * translates absolute points to normalized points
		 */
		public static function normalizePoints( absPoints:Array, scaleRatio:Number ):Array {
			
			var normPoints:Array = new Array();
			
			for each( var absPoint:Point in absPoints ) {				
				normPoints.push( new Point( absPoint.x / scaleRatio, absPoint.y / scaleRatio )  );
			}
			
			return normPoints;
		}
	}
}