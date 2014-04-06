////////////////////////////////////////////////////////////////////////////////
// Filename: refractionshaderclass.cpp
////////////////////////////////////////////////////////////////////////////////
#include "refractionshaderclass.h"


RefractionShaderClass::RefractionShaderClass()
{
	m_vertexShader = 0;
	m_pixelShader = 0;
	m_layout = 0;
	m_sampleState = 0;
	m_matrixBuffer = 0;
	m_lightBuffer = 0;
	m_clipPlaneBuffer = 0;
}


RefractionShaderClass::RefractionShaderClass(const RefractionShaderClass& other)
{
}


RefractionShaderClass::~RefractionShaderClass()
{
}


bool RefractionShaderClass::Initialize(ID3D11Device* device, HWND hwnd)
{
	bool result;

	// Initialize the vertex and pixel shaders.
	result = InitializeShader(device, hwnd, L"../Engine/refractionvs.hlsl", L"../Engine/refractionps.hlsl");
	if (!result)
	{
		return false;
	}

	return true;
}

void RefractionShaderClass::Shutdown()
{
	// Shutdown the vertex and pixel shaders as well as the related objects.
	ShutdownShader();

	return;
}

bool RefractionShaderClass::Render(ID3D11DeviceContext* deviceContext, int indexCount, D3DXMATRIX worldMatrix,
	D3DXMATRIX viewMatrix, D3DXMATRIX projectionMatrix, ID3D11ShaderResourceView* texture,
	D3DXVECTOR3 lightDirection, D3DXVECTOR4 ambientColor, D3DXVECTOR4 diffuseColor,
	D3DXVECTOR4 clipPlane)
{
	bool result;


	// Set the shader parameters that it will use for rendering.
	result = SetShaderParameters(deviceContext, worldMatrix, viewMatrix, projectionMatrix, texture, lightDirection, ambientColor,
		diffuseColor, clipPlane);
	if (!result)
	{
		return false;
	}

	// Now render the prepared buffers with the shader.
	RenderShader(deviceContext, indexCount);

	return true;
}