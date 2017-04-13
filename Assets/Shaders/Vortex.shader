// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Vortex" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _TexSize ("Texture Size", vector) = (256, 256, 0, 0)
        _Angle  ("Vortex Angel", Range(-45, 45)) = 45.0
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
                float radius = floor(max(_TexSize.x, _TexSize.y) / 2);
                float2 center = float2((_TexSize.x+1)/2, (_TexSize.y+1)/2);
                float2 offset = float2(i.uv.x * _TexSize.x - center.x, i.uv.y * _TexSize.y - center.y);
                float dist = sqrt(offset.x * offset.x + offset.y * offset.y);
                float a = atan2(offset.y, offset.x); // 本来的弧度
                a += dist / _Angle; // 距离越远，旋转越多
                float2 outuv = center + float2(dist*cos(a), dist*sin(a));
                outuv.x /= _TexSize.x;
                outuv.y /= _TexSize.y;
                return tex2D(_MainTex, outuv);
            }
            ENDCG
        }
    }

    Fallback off
}