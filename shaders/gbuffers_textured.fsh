#version 120
//#define Opaque

uniform sampler2D texture;
uniform sampler2D lightmap;

uniform vec4 entityColor;
uniform float blindness;
uniform int isEyeInWater;
uniform float frameTimeCounter;

varying vec4 color;
varying vec3 world;
varying vec2 coord0;
varying vec2 coord1;

void main()
{
    vec3 light = (1.-blindness) * texture2D(lightmap,coord1).rgb;
    vec4 col = color * vec4(light,1) * texture2D(texture,coord0);
    col.rgb = mix(col.rgb,entityColor.rgb,entityColor.a);

    float fog = (isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.);

    col.rgb = mix(col.rgb, gl_Fog.color.rgb, fog);

    float alpha = mod(dot(floor(world),vec3(1)),2.);
    #ifndef Opaque
	if (alpha<1.) discard;
	#endif
    gl_FragData[0] = col*vec4(alpha,alpha,alpha,1);
}
