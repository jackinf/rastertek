////////////////////////////////////////////////////////////////////////////////
// Filename: water.ps
////////////////////////////////////////////////////////////////////////////////


/////////////
// GLOBALS //
/////////////
SamplerState SampleType;
Texture2D reflectionTexture;
Texture2D refractionTexture;
Texture2D normalTexture;

cbuffer WaterBuffer
{
	float waterTranslation;
	float reflectRefractScale;
	float2 padding;
};

//////////////
// TYPEDEFS //
//////////////
struct PixelInputType
{
	float4 position : SV_POSITION;
	float2 tex : TEXCOORD0;
	float4 reflectionPosition : TEXCOORD1;
	float4 refractionPosition : TEXCOORD2;
};

////////////////////////////////////////////////////////////////////////////////
// Pixel Shader
////////////////////////////////////////////////////////////////////////////////
float4 WaterPixelShader(PixelInputType input) : SV_TARGET
{
	float2 reflectTexCoord;
	float3 refractTexCoord;
	float4 normalMap;
	float3 normal;
	float4 reflectionColor;
	float4 refractionColor;
	float4 color;

	input.tex.y = waterTranslation;

	reflectTexCoord.x = input.reflectionPosition.x / input.reflectionPosition.w / 2.0f + 0.5f;
	reflectTexCoord.y = -input.reflectionPosition.y / input.reflectionPosition.w / 2.0f + 0.5f;

	refractTexCoord.x = input.refractionPosition.x / input.refractionPosition.w / 2.0f + 0.5f;
	refractTexCoord.y = -input.refractionPosition.y / input.refractionPosition.w / 2.0f + 0.5f;

	normalMap = normalTexture.Sample(SampleType, input.tex);

	normal = (normalMap.xyz * 2.0f) - 1.0f;

	reflectionColor = reflectionColor + (normal.xy * reflectRefractScale);
	refractionColor = refractionColor + (normal.xy * reflectRefractScale);

	reflectionColor = reflectionTexture.Sample(SampleType, reflectTexCoord);
	refractionColor = refractionTexture.Sample(SampleType, refractTexCoord);

	color = lerp(reflectionColor, refractionColor, 0.6f);

	return color;
