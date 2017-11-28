#Import "<std>"
#Import "<mojo>"
#Import "<pyro-framework>"
#Import "<pyro-scenegraph>"

#Import "../../assets/"

Using std..
Using mojo..
Using pyro.framework..
Using pyro.scenegraph..

Global VirtualResolution := New Vec2i


Function Main()
	
	New AppInstance
 	
	VirtualResolution.x = 1280
	VirtualResolution.y = 720
	
	New MyDemoApp( "My Demo", VirtualResolution.x, VirtualResolution.y )
	
	App.Run()
End


Class MyDemoApp Extends Window
	
	Field Scene:Scene
	Field Camera:Camera
	
	Method New( name:String, width:Int, height:Int, flags:WindowFlags = WindowFlags.Resizable )
		Super.New( name, width, height, flags )
		
		ClearColor = Color.Black
		Layout = "letterbox"
		
		Scene = New Scene( Self )
		Camera = New Camera( Scene )
		
		Local layer := New Layer( Scene )
	End
	
	Method OnRender:Void( canvas:Canvas ) Override
		App.RequestRender()
		Scene.Update()
		Scene.Draw( canvas )
	End
	
	Method OnMeasure:Vec2i() Override
		Return VirtualResolution
	End
	
End