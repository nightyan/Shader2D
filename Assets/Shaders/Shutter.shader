// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Shutter" {
    Properties {
        _MainTex ("Old Texture", 2D) = "white" {}
        _NewTex ("New Texture", 2D) = "white" {}
        _TexSize ("Texture Size", vector) = (256, 256, 0, 0)
        _FenceWidth ("Fence Width", Range(10, 50)) = 30.0
        _AnimTime("Animation Time", Range(0.01, 5)) = 1
        _DelayTime("delay time", Range(0, 10)) = 0.2
        _LoopInterval("Interval time", Range(1, 10)) = 2
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
            sampler2D _NewTex;
            float4 _TexSize;
            float _FenceWidth;
            float _AnimTime;
            float _DelayTime;
            float _LoopInterval;
            
            struct v2f {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            v2f vert(appdata_img v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos (v.vertex);
                o.uv = v.texcoord;
                return o;
            }
            
            float4 frag (v2f i) : COLOR
            {
                float curtime = _Time.y; //当前时间
                int looptimes = floor(curtime / _LoopInterval);
                
                float starttime = looptimes * _LoopInterval; // 本次动画开始时间
                float passtime = curtime - starttime;//本次动画流逝时间
                if (passtime <= _DelayTime)
                {
                    if (fmod(looptimes, 2) == 0)
                        return tex2D(_MainTex, i.uv);
                    else
                        return tex2D(_NewTex, i.uv);
                }
                
                float progress = (passtime - _DelayTime) / _AnimTime; //底部右边界
                float fence_rate = fmod(i.uv.x * _TexSize.x, _FenceWidth) / _FenceWidth;
                if (progress < fence_rate)
                    return tex2D(_MainTex, i.uv);
                else
                    return tex2D(_NewTex, i.uv);
            }
            ENDCG
        }
    }

    Fallback off
}