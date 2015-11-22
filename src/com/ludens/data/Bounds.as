package com.ludens.data
{
	public class Bounds
	{
		public var top:Number;
		public var left:Number;
		
		//public var width:Number;
		//public var height:Number;
		
		/**
		 * or should we do right and bottom?
		 */
		 
		public var right:Number;
		public var bottom:Number;
		
		public function Bounds(left:Number = 0, top:Number = 0, right:Number = 0, bottom:Number = 0)
		{
			if(top) this.top = top;
			if(left) this.left = left;
			
			//if(width) this.width = width;
			//if(height) this.height = height;
			
			if(right) this.right = right;
			if(bottom) this.bottom = bottom;
			
			
		}
		
		public function get width():Number {
			return right - left;
		}
		
		public function get height():Number {
			return bottom - top;
			
		}
		
		public function get horizontalMiddle():Number {
			return (right + left) /2;
			
		}
		
		public function get verticalMiddle():Number {
			return (bottom + top) /2;
			
		}

	}
}