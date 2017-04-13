// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/WaterColor"
{
    Properties
    {
        _MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
        _NoiseTex ("Noise Texture", 2D) = "black" {}
        _QuantBit ("Quant Bit", Range(1, 7)) = 2
        _WaterPower ("Water Power", Range(5, 50)) = 10
        _TexSize ("Texture Size", Vector) = (256,256,0,0)
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
            sampler2D _NoiseTex;
            float _QuantBit;
            float _WaterPower;
            float2 _TexSize;
            float4 _MainTex_ST;
            
            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };
            
            struct v2f
            {
                float4 vertex : SV_POSITION;
                half2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };
            
            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }
            
            // 对颜色的几个分量进行量化
            float4 quant(float4 col, float k)
            {
                col.r = int(col.r * 255 / k) * k / 255;
                col.g = int(col.g * 255 / k) * k / 255;
                col.b = int(col.b * 255 / k) * k / 255;
                return col;
            }
            
            fixed4 frag (v2f IN) : COLOR
            {
                // 从噪声纹理中取随机数，对纹理坐标扰动，从而形成扩散效果
                float4 noiseCol = _WaterPower * tex2D(_NoiseTex, IN.uv);
                float2 newUV = float2(IN.uv.x + noiseCol.x/_TexSize.x, IN.uv.y + noiseCol.y/_TexSize.y);
                float4 col = tex2D(_MainTex, newUV);
                return quant(col, 255/pow(2, _QuantBit)); // 量化图像的颜色值，形成色块
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