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
	
	New GlslColorMaskDemoApp( "GLSL Mask Demo", VirtualResolution.x, VirtualResolution.y )
	
	App.Run()
End


Class GlslColorMaskDemoApp Extends Window
	Field Scene:Scene
	Field Camera:Camera
	Field CanvasLayers:CanvasLayer[]
	Field Rotations:Float[]
	
	Method New( name:String, width:Int, height:Int, flags:WindowFlags = WindowFlags.Resizable )
		Super.New( name, width, height, flags )
		
		ClearColor = New Color( 0.0, 0.0, 1.0 )
		Layout = "letterbox"
		
		Scene = New Scene( Self )
		Camera = New Camera( Scene )
		
		Local layer := New Layer( Scene )
		
		Rotations = Rotations.Resize( Rotations.Length + 1 )
		Rotations[ 0 ] = 0.0
		
		CanvasLayers = CanvasLayers.Resize( CanvasLayers.Length + 1 )
		CanvasLayers[ 0 ] = CanvasLayers[ 0 ].Create( "asset::mask.png", width, height, "color-mask" )
		CanvasLayers[ 0 ].Mask.Material.SetColor( "HighlightColor", New Color( 1.0, 0.0, 0.0, 1.0 ) )
		CanvasLayers[ 0 ].Mask.Material.SetColor( "AmbientColor", New Color( 0.0, 0.0, 0.0, 1.0 ) )
		CanvasLayers[ 0 ].Mask.Material.SetVec2f( "Resolution", New Vec2f( width, height ) )
		
		Rotations = Rotations.Resize( Rotations.Length + 1 )
		Rotations[ 1 ] = 0.0
		
		CanvasLayers = CanvasLayers.Resize( CanvasLayers.Length + 1 )
		CanvasLayers[ 1 ] = CanvasLayers[ 1 ].Create( "asset::mask.png", width, height, "color-mask" )
		CanvasLayers[ 1 ].Mask.Material.SetColor( "HighlightColor", New Color( 1.0, 1.0, 0.0, 1.0 ) )
		CanvasLayers[ 1 ].Mask.Material.SetColor( "AmbientColor", New Color( 1.0, 0.0, 1.0, 1.0 ) )
		CanvasLayers[ 1 ].Mask.Material.SetVec2f( "Resolution", New Vec2f( width, height ) )
	End
	
	Method OnRender:Void( canvas:Canvas ) Override
		App.RequestRender()
		
		' CanvasLayers[ 0 ]
		
		CanvasLayers[ 0 ].Clear( Color.None )
		CanvasLayers[ 0 ].Color = Color.White
		
		Local thickness := 150
		CanvasLayers[ 0 ].PushMatrix()
		CanvasLayers[ 0 ].Translate( VirtualResolution.X / 2, VirtualResolution.Y / 2 )
		Rotations[ 0 ] += 0.01
		CanvasLayers[ 0 ].Rotate( Rotations[ 0 ] )
		CanvasLayers[ 0 ].DrawRect( -VirtualResolution.X / 2, -thickness / 2, VirtualResolution.X, thickness )
		CanvasLayers[ 0 ].DrawRect( -thickness / 2, -VirtualResolution.X / 2, thickness, VirtualResolution.X )
		CanvasLayers[ 0 ].PopMatrix()
		CanvasLayers[ 0 ].Flush()
		
		CanvasLayers[ 0 ].Mask.Material.SetVec2f( "Offset", New Vec2f( App.MouseLocation.x - VirtualResolution.X / 2, App.MouseLocation.y - VirtualResolution.Y / 2 ) )

		canvas.DrawImage( CanvasLayers[ 0 ].Mask, 0, 0 )

		' CanvasLayers[ 1 ]
		
		CanvasLayers[ 1 ].Clear( Color.None )
		CanvasLayers[ 1 ].Color = Color.White
		
		CanvasLayers[ 1 ].PushMatrix()
		CanvasLayers[ 1 ].Translate( VirtualResolution.X / 2, VirtualResolution.Y / 2 )
		Rotations[ 1 ] -= 0.01
		CanvasLayers[ 1 ].Rotate( Rotations[ 1 ] )
		CanvasLayers[ 1 ].DrawRect( -VirtualResolution.X / 2, -thickness / 2, VirtualResolution.X, thickness )
		CanvasLayers[ 1 ].DrawRect( -thickness / 2, -VirtualResolution.X / 2, thickness, VirtualResolution.X )
		CanvasLayers[ 1 ].PopMatrix()
		CanvasLayers[ 1 ].Flush()
		
		CanvasLayers[ 1 ].Mask.Material.SetVec2f( "Offset", New Vec2f( App.MouseLocation.x * 0.9 - VirtualResolution.X / 2, App.MouseLocation.y * 0.9 - VirtualResolution.Y / 2 ) )

		canvas.DrawImage( CanvasLayers[ 1 ].Mask, 0, 0 )
		
		' CanvasLayers end
		
		Scene.Update()
		Scene.Draw( CanvasLayers[ 0 ] )
		Scene.Draw( CanvasLayers[ 1 ] )
	End
	
	Method OnMeasure:Vec2i() Override
		Return VirtualResolution
	End
	
End
