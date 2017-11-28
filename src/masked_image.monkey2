Class MaskedImage Extends Image
	
	Field Shader:Shader
	
	Function Create:MaskedImage ( pixmap:Pixmap, maskPath:String, shaderId:String, textureFlags:TextureFlags = TextureFlags.FilterMipmap )
		If Not shaderId Then shaderId = "mask"
		Local shader := mojo.graphics.Shader.GetShader( shaderId )
		Local image := New MaskedImage( pixmap, textureFlags, shader )
		Local texture := mojo.graphics.Texture.Load( maskPath, textureFlags )
		
		image._Mask = texture
		image.MaskEnabled = True
		
		Return image
	End
	
	Function Create:MaskedImage ( imagePath:String, maskPath:String, shaderId:String, textureFlags:TextureFlags = TextureFlags.FilterMipmap )
		If Not shaderId Then shaderId = "mask"
		Local pixmap := Pixmap.Load( imagePath, Null, True )
		Local shader := mojo.graphics.Shader.GetShader( shaderId )
		Local image := New MaskedImage( pixmap, textureFlags, shader )
		Local texture := mojo.graphics.Texture.Load( maskPath, textureFlags )
		
		image._Mask = texture
		image.MaskEnabled = True
		
		Return image
	End
	
	' you can override any (all) constructor of Image class
	Method New ( pixmap:Pixmap, textureFlags:TextureFlags = TextureFlags.FilterMipmap, shader:Shader = Null )
		Super.New( pixmap, textureFlags, shader )
		Shader = shader
	End
	
	Property Mask:Texture ()
		Return _Mask
		
	Setter( value:Texture )
		_Mask = value
		
		If _Mask
			Shader = Shader.GetShader( "mask" )
			Material.SetTexture( "MaskTexture", _Mask )
		Else
			Shader = Shader.GetShader( "sprite" )
		Endif
	End
	
	Property MaskEnabled:Bool ()
		Return _MaskEnabled
		
	Setter( value:Bool )
		_MaskEnabled = value
		If _MaskEnabled And _Mask
			Shader = Shader.GetShader( "mask" )
			Material.SetTexture( "MaskTexture", _Mask )
		Else
			Shader = Shader.GetShader( "sprite" )
		Endif
	End
	
	Private
	
	Field _Mask:Texture
	Field _MaskEnabled:Bool
End


Class CanvasLayer Extends Canvas
	Field Mask:Image
	
	Function Create:CanvasLayer ( maskImageKey:String, width:Float, height:Float, shaderId:String = "mask" )
		Local pixmap := New Pixmap( width, height, PixelFormat.RGBA8 )
		Local mask := MaskedImage.Create( pixmap, maskImageKey, shaderId, TextureFlags.Dynamic )
		Return New CanvasLayer( mask )
	End

	Method New ( image:Image )
		Super.New( image )
		Mask = image
	End
	
End