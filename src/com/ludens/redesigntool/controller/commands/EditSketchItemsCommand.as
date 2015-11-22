package com.ludens.redesigntool.controller.commands
{
	import com.ludens.redesigntool.model.RedesignProxy;
	import com.ludens.redesigntool.model.SelectionProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	public class EditSketchItemsCommand extends UndoableCommandBase implements ICommand
	{
		public function EditSketchItemsCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			super.execute( notification );
			registerUndoCommand( EditSketchItemsCommand );
		}
		
		/**
		 * execute the EditSketchItemsCommand Command
		 * 
		 * <p>call the RedesignProxy to add a new Sketch Item with the class
		 * specified in the body of the notification.</p>
		 * 
		 */
		override public function executeCommand():void {
			
			trace(">> edit sketchItems >>");
			
			// get the content of the notification body
			var newItemProperties:Object = getNote().getBody() as Object;
			
			// get redesign proxy
			var redesignProxy:RedesignProxy = facade.retrieveProxy( RedesignProxy.NAME ) as RedesignProxy;	
			
			// get the SelectionProxy
			var selectionProxy:SelectionProxy = facade.retrieveProxy( SelectionProxy.NAME ) as SelectionProxy;	
			
			
			var selectedItemIDs:Array = selectionProxy.selectedItems;
			
			// ask the RedesignProxy to update the model with the new properties
			redesignProxy.updateSketchItemsById(selectedItemIDs, newItemProperties);
			
		}
		
		
		/**
		 * undo the command if it is currently NOT set to "undone"
		 */
		override public function undo():void {
			
		}
		
		/**
		 * Redo command is command is currently set to "undone"
		 */
		override public function redo():void {
			
		}
		
		override public function getCommandName():String {
			
			return "Edit Items";
		}
	}
}