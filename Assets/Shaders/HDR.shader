// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/HDR"
{
    Properties
    {
        _MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
        _BlowTex ("Blow Texture", 2D) = "black" {}
        _Param ("Parameter", Range(1, 3)) = 1
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
            sampler2D _BlowTex;
            float _Param;
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
            
            // 调整亮度，让亮的地方更亮  公式: y = x * [(2-4k)*x + 4k-1]
            float4 hdr(float4 col, float gray, float k)
            {
                float b = 4*k - 1;
                float a = 1 - b;
                float f = gray * ( a * gray + b);
                return f * col;
            }
            
            fixed4 frag (v2f IN) : COLOR
            {
                float4 col = tex2D(_MainTex, IN.uv);
                float4 blurCol = tex2D(_BlowTex, IN.uv);// 高斯模糊后的纹理，让过渡更柔和、平滑
                float gray = 0.3 * blurCol.r + 0.59 * blurCol.g + 0.11 * blurCol.b;
                return hdr(col, gray, _Param);
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