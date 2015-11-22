package com.ludens.redesigntool.controller.commands.startup
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	import com.ludens.redesigntool.controller.commands.startup.*;
	
	/**
	 * 
	 * @author rulkens
	 * 
	 */
	public class StartupCommand extends MacroCommand implements ICommand
	{
		
		/**
		 * execute the Startup Command
		 * 
		 * <p>For now, just display a status message</p>
		 * 
		 */
		override protected function initializeMacroCommand():void {
			
			addSubCommand( StartupModelCommand );
			addSubCommand( StartupViewCommand );
		}
	}
}