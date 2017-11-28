#Import "<std>"
#Import "<mojo>"
#Import "<pyro-framework>"
#Import "<pyro-scenegraph>"

#Import "../../src/masked_image"

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
	
	New GlslMaskDemoApp( "GLSL Mask Demo", VirtualResolution.x, VirtualResolution.y )
	
	App.Run()
End

' TO DO
' - Scene.Draw( canvas ) can also draw to CanvasLayer here; let's see if it's possible to
'   Scene.Draw( CanvasLayers[ 0 ] ) and then Scene.Draw( CanvasLayers[ 1 ] ) so we can
'   keep working with Pyro 2


Class GlslMaskDemoApp Extends Window
	Field Scene:Scene
	Field Camera:Camera
	Field CanvasLayer:CanvasLayer
	
	Method New( name:String, width:Int, height:Int, flags:WindowFlags = WindowFlags.Resizable )
		Super.New( name, width, height, flags )
		
		ClearColor = New Color( 0.0, 0.0, 1.0 )
		Layout = "letterbox"
		
		Scene = New Scene( Self )
		Camera = New Camera( Scene )
		
		Local layer := New Layer( Scene )
		
		CanvasLayer = CanvasLayer.Create( "asset::mask.png", width, height )
		CanvasLayer.Mask.Material.SetColor( "HighlightColor", New Color( 1.0, 0.0, 0.0, 1.0 ) )
	End
	
	Method OnRender:Void( canvas:Canvas ) Override
		App.RequestRender()
		
		CanvasLayer.Clear( Color.None )
		CanvasLayer.Color = Color.White
		
		Local x := 0
		Local y := 0
		Local thickness := 150
		CanvasLayer.DrawRect( x, y + App.MouseLocation.y - thickness / 2, VirtualResolution.X, thickness )
		CanvasLayer.DrawRect( x + App.MouseLocation.x - thickness / 2, y, thickness, VirtualResolution.Y )
		CanvasLayer.Flush()
		
		canvas.DrawImage( CanvasLayer.Mask, 0, 0 )
		
		Scene.Update()
		Scene.Draw( canvas )
	End
	
	Method OnMeasure:Vec2i() Override
		Return VirtualResolution
	End
	
End
