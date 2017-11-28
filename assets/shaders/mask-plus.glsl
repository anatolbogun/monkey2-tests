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

#if MX2_RENDERPASS==0

	vec2 coord = v_TexCoord0 - m_Offset / m_Resolution;
	// vec4 maskColor = texture2D( m_MaskTexture, v_TexCoord0 ); // original
	vec4 maskColor = texture2D( m_MaskTexture, coord );
	// gl_FragColor = texture2D( m_ImageTexture0, v_TexCoord0 ) * v_Color * maskColor; // original
	gl_FragColor = texture2D( m_ImageTexture0, v_TexCoord0 ) * v_Color * maskColor * m_HighlightColor; // with uniform m_HighlightColor
	// gl_FragColor = v_Color * maskColor * m_HighlightColor;
	gl_FragColor.a = 0.0;

#else

	// What's that stuff for?
	// float alpha = texture2D( m_ImageTexture0, v_TexCoord0 ).a * v_Color.a;
	// gl_FragColor = vec4( 0.0, 1.0, 0.0, alpha );

#endif

}
