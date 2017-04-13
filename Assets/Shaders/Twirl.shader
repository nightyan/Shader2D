// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Twirl" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _TexSize ("Texture Size", vector) = (256, 256, 0, 0)
        _Center ("Center Point", vector) = (0.5, 0.5, 0, 0)
        _Radius ("Twirl Radius", Range(0,256)) = 0.5
        _Angle  ("Twirl Angel", Range(-90, 90)) = 90.0
    }

    SubShader {
        Pass {
            ZTest Always Cull Off ZWrite Off
            Fog { Mode off }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            sampler2D _MainTex;
            float4 _TexSize;
            float4 _Center;
            float _Radius;
            float _Angle;
            
            struct v2f {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            } ;
            
            v2f vert(appdata_img v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos (v.vertex);
                o.uv = v.texcoord;
                return o;
            }
            
            float4 frag (v2f i) : COLOR
            {
                float2 offset = i.uv - _Center.xy;
                float2 coord = float2(offset.x * _TexSize.x, offset.y * _TexSize.y);
                float dist2 = coord.x * coord.x + coord.y * coord.y;
                float radius2 = _Radius * _Radius;
                
                float2 outuv;
                if (dist2 > radius2)
                {
                    outuv = i.uv;
                }
                else
                {
                    float dist = sqrt(dist2);
                    float radian = _Angle * 3.141593f / 180.0f;
                    float a = atan2(coord.y, coord.x); // 本来的弧度
                    a += radian * (_Radius - dist) / _Radius; // 加上旋转的弧度，越靠外旋转越小
                    outuv.x = _Center.x + dist * cos(a) / _TexSize.x;
                    outuv.y = _Center.y + dist * sin(a) / _TexSize.y;
                }
                return tex2D(_MainTex, outuv);
            }
            ENDCG
        }
    }

    Fallback off
}