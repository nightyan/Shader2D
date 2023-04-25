Shader "Custom/OldTV"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Cull Off 
        ZWrite Off 
        ZTest Always

        Tags { "Queue" = "Transparent"}

        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float3 mod289(float3 x) {
                return x - floor(x * (1.0 / 289.0)) * 289.0;
            }

            float2 mod289(float2 x) {
              return x - floor(x * (1.0 / 289.0)) * 289.0;
            }

            float3 permute(float3 x) {
              return mod289(((x*34.0)+1.0)*x);
            }

            float snoise(float2 v)
            {
              const float4 C = float4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);

              float2 i  = floor(v + dot(v, C.yy));
              float2 x0 = v - i + dot(i, C.xx);

              float2 i1;
              i1 = (x0.x > x0.y) ? float2(1.0, 0.0) : float2(0.0, 1.0);
              float4 x12 = x0.xyxy + C.xxzz;
              x12.xy -= i1;

              i = mod289(i);
              float3 p = permute(permute( i.y + float3(0.0, i1.y, 1.0 )) + i.x + float3(0.0, i1.x, 1.0 ));
              float3 m = max(0.5 - float3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
              m = m*m ;
              m = m*m ;

              float3 x = 2.0 * frac(p * C.www) - 1.0;
              float3 h = abs(x) - 0.5;
              float3 ox = floor(x + 0.5);
              float3 a0 = x - ox;

              m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

              float3 g;
              g.x  = a0.x  * x0.x  + h.x  * x0.y;
              g.yz = a0.yz * x12.xz + h.yz * x12.yw;
              return 130.0 * dot(m, g);
            }

            float rand(float2 co)
            {
              return frac(sin(dot(co.xy,float2(12.9898,78.233))) * 43758.5453);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv; 
                float time = _Time.y;
    
                float noise = max(0.0, snoise(float2(time, uv.y * 0.3)) - 0.3) * (1.0 / 0.7);    
                noise = noise + (snoise(float2(time*10.0, uv.y * 2.4)) - 0.5) * 0.15;    
                float xpos = uv.x - noise * noise * 0.25;
                fixed4 col = tex2D(_MainTex, float2(xpos, uv.y));
    
                float tmpvalue= rand(uv.y * time);
                col.rgb *= lerp(col.rgb, float3(tmpvalue,tmpvalue,tmpvalue), noise * 0.3).rgb;
    
                if (floor(fmod(i.uv.y * 0.25, 2.0)) == 0.0)
                {
                    col.rgb *= 1.0 - (0.15 * noise);
                }
    
                col.g = lerp(col.r, tex2D(_MainTex, float2(xpos + noise * 0.05, uv.y)).g, 0.25);
                col.b = lerp(col.r, tex2D(_MainTex, float2(xpos - noise * 0.05, uv.y)).b, 0.25);

                return col;
            }
            ENDCG
        }
    }
}