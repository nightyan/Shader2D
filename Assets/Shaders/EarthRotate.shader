// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/EarthRotate"
{
    Properties
    {
        _MainTex ("Earth", 2D) = "white" {}
        _CloudTex ("Cloud", 2D) = "white" {}
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
            //Cull Off
            //Lighting Off
            //ZWrite Off
            //Fog { Mode Off }
            //Offset -1, -1
            //Blend SrcAlpha OneMinusSrcAlpha
            Cull Back
            ZWrite On
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag            
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _CloudTex;
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
            };
    
            v2f o;

            v2f vert (appdata_t v)
            {
                o.vertex = UnityObjectToClipPos (v.vertex);
                o.texcoord = TRANSFORM_TEX (v.texcoord, _MainTex);
                return o;
            }
            
            fixed4 frag (v2f IN) : SV_Target
            {
                //return tex2D(_MainTex, IN.texcoord) * IN.color;
                
                float u = IN.texcoord.x + -0.1*_Time;
                float2 uv = float2(u, IN.texcoord.y);
                half4 texcol = tex2D(_MainTex, uv);
                
                u = IN.texcoord.x + -0.2*_Time;
                uv = float2(u, IN.texcoord.y);
                half4 cloudtex = tex2D (_CloudTex, uv);
                cloudtex = float4(1,1,1,0) * (cloudtex.x);
                
                return lerp(texcol, cloudtex, 0.5f);
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
            
            SetTexture [_EarthTex]
            {
                Combine Texture * Primary
            }
        }
    }
}
