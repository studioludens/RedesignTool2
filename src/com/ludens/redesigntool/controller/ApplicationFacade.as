package com.ludens.redesigntool.controller
{
	import com.ludens.redesigntool.controller.commands.*;
	import com.ludens.redesigntool.controller.commands.startup.*;
	import com.ludens.redesigntool.model.DrawingSettingsProxy;
	import com.ludens.redesigntool.model.RedesignProxy;
	import com.ludens.redesigntool.model.SelectionProxy;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade implements IFacade
	{
		
		public var shiftKey:Boolean = false;
		
		
		
		public static function getInstance():ApplicationFacade {

			if (instance == null) instance = new ApplicationFacade();

			return instance as ApplicationFacade;
		}

		

		// Register commands with the controller

		override protected function initializeController():void {

			super.initializeController();
			
			registerCommand(Notifications.CHANGE_SCALE_RATIO, ChangeScaleRatioCommand);
			
			registerCommand(Notifications.STARTUP, StartupCommand);
			registerCommand(Notifications.SHUTDOWN, ShutdownCommand);
			
			registerCommand(Notifications.SAVE, SaveCommand);
			registerCommand(Notifications.LOAD, LoadCommand);
			
			registerCommand(Notifications.ADD_ITEM, AddItemCommand);
			registerCommand(Notifications.DELETE_ITEMS, DeleteItemsCommand);
			
			registerCommand(Notifications.EDIT_ITEMS, EditSketchItemsCommand);
			registerCommand(Notifications.EDIT_ITEM, EditSketchItemCommand);
			
			
			registerCommand(Notifications.EDIT_SELECTION, EditSelectionCommand);
			
			registerCommand(Notifications.CHANGE_DRAWING_SETTINGS, ChangeDrawingSettingsCommand);
			

		}
		
		/**
		 * get the RedesignProxy for use
		 */
		public function get redesignProxy():RedesignProxy {
			
			return RedesignProxy( ApplicationFacade.getInstance().retrieveProxy( RedesignProxy.NAME ) );
		}
		
		/**
		 * get the SelectionProxy for use
		 */
		public function get selectionProxy():SelectionProxy {
			
			return SelectionProxy( ApplicationFacade.getInstance().retrieveProxy( SelectionProxy.NAME ) );
		}
		
		/**
		 * get the DrawingSettingsProxy for use
		 */
		public function get drawingSettingsProxy():DrawingSettingsProxy {
			
			return DrawingSettingsProxy( ApplicationFacade.getInstance().retrieveProxy( DrawingSettingsProxy.NAME ) );
		}
		
		
		
	}
}