//@renderpasses 0,1,2

varying vec2 v_TexCoord0;
varying vec4 v_Color;

//@vertex

attribute vec4 a_Position;
attribute vec2 a_TexCoord0;
attribute vec4 a_Color;

uniform mat4 r_ModelViewProjectionMatrix;

uniform vec4 m_ImageColor;


void main(){
	v_TexCoord0 = a_TexCoord0;
	v_Color = m_ImageColor * a_Color;
	gl_Position = r_ModelViewProjectionMatrix * a_Position;
}

//@fragment

uniform vec2 m_Resolution;
uniform sampler2D m_ImageTexture0;
uniform sampler2D m_MaskTexture;
uniform vec4 m_HighlightColor;
uniform vec2 m_Offset;

void main(){
	// const float PI = 3.1415926535897932384626433832795;

#if MX2_RENDERPASS==0
	vec2 maskCoord = v_TexCoord0 - m_Offset / m_Resolution;
	vec4 maskColor = texture2D( m_MaskTexture, maskCoord );
	vec4 imageColor = texture2D( m_ImageTexture0, v_TexCoord0 );
	gl_FragColor.rgba = imageColor.rgba * m_HighlightColor.rgba;
	gl_FragColor.rgba *= ( maskColor.r + maskColor.g + maskColor.b ) / 3.0;
	// float circle = floor( clamp(pow(sin( v_TexCoord0.x * PI) * sin( v_TexCoord0.y * PI) * 0.5 + 0.5 ,2),0.49,0.5) + 0.5 );
	// gl_FragColor.rgba = vec4(circle);
	
#endif

}
