// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/WaterRipple"
{
	Properties 
	{
		_MainTex ("纹理", 2D) = "white" {}
        _TexSize ("纹理宽高", vector) = (256, 256, 0, 0)
        _Amplitude ("振幅", Range(1, 64)) = 16
        _WaveLength ("波长", Range(1, 256)) = 64
        _Center ("中心", vector) = (0.5, 0.5, 0, 0)
        _Radius ("半径", Range(1, 512)) = 128
        _Phase ("相位", Range(0, 6.283185307)) = 0
        _Speed ("扩散速度", Range(0, 10)) = 5
	}
    
	SubShader 
	{
		Tags { "LightMode" = "ForwardBase" }
		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			sampler2D _MainTex;
            float2 _TexSize;
            float _Amplitude;
            float _WaveLength;
            float2 _Center;
            float _Radius;
            float _Phase;
            float _Speed;
			float4 _MainTex_ST;

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0; 
			};

			v2f vert(appdata_full  v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}


			fixed4 frag(v2f i) : COLOR
			{
                float dx = (i.uv.x - _Center.x) * _TexSize.x;
                float dy = (i.uv.y - _Center.y) * _TexSize.y;
                float distance2 = dx * dx + dy * dy;
                float radius2 = _Radius * _Radius;
                
                if (distance2 > radius2)
                {
                    float4 col = tex2D(_MainTex, i.uv);
                    return col;
                }
                else
                {
                    float distance = sqrt(distance2);
                    float amount = _Amplitude * sin(distance / _WaveLength * 6.283185307 - _Phase - _Speed * _Time.y);
                    amount *= (_Radius - distance) / _Radius;
                    if (distance != 0)
                    {
                        amount *= _WaveLength / distance;
                    }
                    float2 uv = float2(i.uv.x + dx * amount / _TexSize.x, i.uv.y + dy * amount / _TexSize.y);
                    float4 col = tex2D(_MainTex, uv);
                    return col;
                }
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
