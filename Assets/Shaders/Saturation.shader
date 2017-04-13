// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Saturation" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _SatIncrement ("Saturation Increment", Range(-1,1)) = 0.2
    }
    
    SubShader
    {
         Tags{"Queue"="Transparent"}
     
        pass
        {
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"
            sampler2D _MainTex;
            float _SatIncrement;
            float4 _MainTex_ST;
           
            struct v2f
            {
                float4  pos : SV_POSITION;
                float2  uv : TEXCOORD0;
            };
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv =  TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            float4 frag (v2f i) : COLOR
            {
                float4 col = tex2D(_MainTex, i.uv);
                float rgbmax = max(col.r, max(col.g, col.b));
                float rgbmin = min(col.r, min(col.g, col.b));
                float delta = rgbmax - rgbmin;
                if (delta == 0)
                    return col;
                
                float value = (rgbmax + rgbmin);
                float light = value / 2;
                float cmp = step(light, 0.5);
                float sat = lerp(delta/(2-value), delta/value, cmp);
                if (_SatIncrement >= 0)
                {
                    cmp = step(1, _SatIncrement + sat);
                    float a = lerp(1-_SatIncrement, sat, cmp);
                    a = 1/a - 1;
                    col.r = col.r + (col.r - light) * a;
                    col.g = col.g + (col.g - light) * a;
                    col.b = col.b + (col.b - light) * a;
                }
                else
                {
                    float a = _SatIncrement;
                    col.r = light + (col.r - light) * (1+a);
                    col.g = light + (col.g - light) * (1+a);
                    col.b = light + (col.b - light) * (1+a);
                }
                return col;
            }
            ENDCG
        }
    }
}
