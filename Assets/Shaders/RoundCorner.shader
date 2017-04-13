// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/RoundCorner"
{
	Properties
	{
		_MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
		_percent("_percent", Range(-5, 5)) = 1
		_corner("corner",Range(0,0.25)) = 0.08
	}
	
	SubShader
	{
		LOD 200

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
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			fixed _percent;
			fixed _corner;
			float4 _MainTex_ST;
	
			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
	
			struct v2f
			{
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
	
			v2f o;

			v2f vert (appdata_t v)
			{
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				o.color = v.color;
				return o;
			}
				
			fixed4 frag (v2f IN) : COLOR
			{
				fixed4 col = tex2D(_MainTex, IN.texcoord) * IN.color;
				
				// 计算圆角，巧妙的算法
				float2 uv = IN.texcoord.xy - float2(0.5,0.5);
				float centerDist = 0.5 - _corner;
				float rx = fmod(uv.x, centerDist);
				float ry = fmod(uv.y, centerDist);
				
				float mx = step(centerDist, abs(uv.x));
				float my = step(centerDist, abs(uv.y));
				float alpha = 1 - mx*my*step(_corner, length(half2(rx,ry)));
				
				// 高亮效果
				/*
				fixed2x2 rotMat = fixed2x2(0.866, 0.5, -0.5 , 0.866);
				uv = IN.texcoord - fixed2(0.5, 0.5);
				uv = (IN.texcoord + fixed2(_percent, _percent)) * 2;
				uv = mul(rotMat, uv);
				
				fixed v = saturate(lerp(fixed(1), fixed(0), abs(uv.y)))*0.3;
				col += fixed4(v,v,v,v);*/
				
				col.a *= alpha;
				return col;
			}
			ENDCG
		}
	}

	SubShader
	{
		LOD 100

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
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMaterial AmbientAndDiffuse
			
			SetTexture [_MainTex]
			{
				Combine Texture * Primary
			}
		}
	}
}
