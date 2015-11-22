package com.ludens.redesigntool.model
{
	import com.ludens.redesigntool.controller.Notifications;
	import com.ludens.redesigntool.model.om.DrawingSettings;
	
	import flash.net.registerClassAlias;
	
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class DrawingSettingsProxy extends Proxy implements IProxy
	{
		//--------------------------------------------------------------------------
	    //
	    //  Class constants
	    //
	    //--------------------------------------------------------------------------
		
		// the proxy name for use in PureMVC
		public static const NAME:String = "DrawingSettingsProxy";	
		
		
		//--------------------------------------------------------------------------
	    //
	    //  public properties
	    //
	    //--------------------------------------------------------------------------
		
		public function get drawingSettings():DrawingSettings {
			updateData();
			registerClassAlias("com.ludens.redesigntool.model.om.DrawingSettings",DrawingSettings);
			var dataCopy:DrawingSettings = ObjectUtil.copy(_data) as DrawingSettings;
			return dataCopy;
		}
		
		/**
		 * selection range
		 *   - bell curve: 1 standard deviation
		 *   - block curve & linear curve: from top to 0
		 */
		public function set selectionRange( value:Number ):void {
			
			_selectionRange = Math.max(value, 1);
			
			updateDataAndNotify();
		}
		
		public function get selectionRange( ):Number {
			return _selectionRange;
		}
		
		/**
		 * mode of editing
		 */
		public function set editMode( value:String ):void {
			_editMode = value;
			
			updateDataAndNotify();
		}
		
		public function get editMode( ):String {
			return _editMode;
		}
		
		/**
		 * mode of selection
		 */
		public function set maxSelectionThickness( value:Number ):void {		
			_maxSelectionThickness = value;
			
			updateDataAndNotify();
		}
		
		public function get maxSelectionThickness( ):Number {
			return _maxSelectionThickness;
		}
		
		/**
		 * mode of selection
		 */
		public function set selectionType( value:String ):void {		
			_selectionType = value;
			
			updateData();
		}
		
		public function get selectionType( ):String {
			return _selectionType;
		}
		
		
		/**
		 * mode of selection
		 */
		public function set smoothStrength( value:Number ):void {		
			_smoothStrength = value;
			
			updateData();
		}
		
		public function get smoothStrength( ):Number {
			return _smoothStrength;
		}
		
		//--------------------------------------------------------------------------
		//
		// 	Private Properties
		//
		//--------------------------------------------------------------------------
		
		private var _data				:DrawingSettings;
		
		private var _selectionRange			:Number;
		private var _maxSelectionThickness	:Number;
		private var _editMode				:String;
		private var _selectionType			:String;
		private var _smoothStrength			:Number;
		
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------
		
		public function DrawingSettingsProxy()
		{
			super( NAME );
			
			_data = new DrawingSettings();
			
			_maxSelectionThickness = 10;
			_selectionRange = 50;
			_smoothStrength = 0.4;
			_selectionType = DrawingSelectionTypes.BELL_SELECTION;	
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
		
		private function updateData():void {
			
			_data.maxSelectionThickness = _maxSelectionThickness;
			_data.selectionRange = _selectionRange;
			_data.selectionType = _selectionType;
			_data.smoothStrength = _smoothStrength;
		}
		
		private function updateDataAndNotify():void {
			
			updateData();
			sendNotification( Notifications.DRAWING_SETTINGS_CHANGED, _data );
		}
	}
}