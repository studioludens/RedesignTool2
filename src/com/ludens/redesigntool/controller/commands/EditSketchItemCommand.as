package com.ludens.redesigntool.controller.commands
{
	import com.ludens.redesigntool.model.RedesignProxy;
	import com.ludens.redesigntool.model.om.SketchItem;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	/**
	 * EditSketchItemCommand edits the sketch item model with the specified ID.
	 * If the property string is set to "data", the whole targeted model is replaced
	 * by the <CODE>_newValue</CODE> value (N.B. being the <CODE>data</CODE> object of a mediator).
	 * Otherwise, the specified property on the model object is set to the <CODE>_newValue</CODE>
	 * value.
	 * 
	 * EditSketchItemCommand is a undo- & redo-able command, implementing the IRedoCommand interface.
	 */
	public class EditSketchItemCommand extends UndoableCommandBase implements ICommand
	{

		public function EditSketchItemCommand( )
		{
			super();
		}
		
		/**
		 * execute the EditSketchItem Command
		 * 
		 * <p>For now, just display a status message</p>
		 * 
		 */
		override public function execute(notification:INotification):void
		{
			super.execute( notification );
			registerUndoCommand( EditSketchItemCommand );
		}
		
		/**
		 * execute the EditSketchItemsCommand Command
		 * 
		 * <p>call the RedesignProxy to add a new Sketch Item with the class
		 * specified in the body of the notification.</p>
		 * 
		 */
		override public function executeCommand():void {
			
			trace(">> edit sketchItem >>");
			
			// get the content of the notification body
			var editedItem:SketchItem = getNote().getBody() as SketchItem;
			
			// get redesign proxy
			var redesignProxy:RedesignProxy = facade.retrieveProxy( RedesignProxy.NAME ) as RedesignProxy;	
			
			
			// ask the RedesignProxy to update the model with the new properties
			redesignProxy.setSketchItem(editedItem.id, editedItem);
			
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