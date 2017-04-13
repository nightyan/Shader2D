// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/SectorWarp"
{
	Properties 
	{
		_MainTex ("纹理", 2D) = "white" {}
        _TexSize ("纹理宽高", vector) = (256, 256, 0, 0)
        _InnerRadius ("内圈半径", Range(0, 512)) = 256
        _OutterRadius ("外圈半径", Range(0, 512)) = 384
        _Center ("中心", vector) = (0.5, 1, 0, 0)
        _StartAngle ("初始角度", Range(0, 180)) = 0
        _SpreadAngle ("扩散角度", Range(0, 360)) = 180
	}
    
	SubShader 
	{
        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }
		Pass 
		{
            Cull Off
            Lighting Off
            ZWrite Off
            Fog { Mode Off }
            Offset -1, -1
            ColorMask RGB
            //AlphaTest Greater .01
            Blend SrcAlpha OneMinusSrcAlpha
            ColorMaterial AmbientAndDiffuse
            
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			sampler2D _MainTex;
			float4 _MainTex_ST;
            float2 _TexSize;
            float _InnerRadius;
            float _OutterRadius;
            float2 _Center;
            float _StartAngle;
            float _SpreadAngle;

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
                float distance = sqrt(dx * dx + dy * dy);
                
                float radian = _StartAngle * 3.141593f / 180.0f;
                float theta = atan2(dy, dx) + radian;
                theta = fmod(theta, 6.283185307);
                
                radian = _SpreadAngle * 3.141593f / 180.0f;
                float x = 1 - theta / (radian + 0.00001);// 加0.00001防止除数为0
                float y = (distance - _InnerRadius)/(_OutterRadius - _InnerRadius + 0.00001);
                float2 uv = float2(x, y);
                float4 col = tex2D(_MainTex, uv);
                //if (distance > _OutterRadius || distance < _InnerRadius)
                //    col.a = 0;
                float cmp = step(distance, _OutterRadius) * step(_InnerRadius, distance);
                col.a *= cmp;
                return col;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
