// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/RoundRect"
{
    Properties
    {
        _MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
        _RoundRadius("Radius", Range (0,0.5)) = 0.1  
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
            float4 _MainTex_ST;
            fixed _RoundRadius;
    
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
                //return tex2D(_MainTex, IN.texcoord) * IN.color;
                fixed4 col = tex2D(_MainTex, IN.texcoord) * IN.color;
                
                half x = IN.texcoord.x;
                half y = IN.texcoord.y;
                fixed cx = 0;
                fixed cy = 0;
                
                if (x < _RoundRadius)
                {
                    cx = _RoundRadius;
                    if (y < _RoundRadius)
                        cy = _RoundRadius;
                    else if (y > 1-_RoundRadius)
                        cy = 1-_RoundRadius;
                }
                else if (x > 1-_RoundRadius)
                {
                    cx = 1 - _RoundRadius;
                    if (y < _RoundRadius)
                        cy = _RoundRadius;
                    else if (y > 1-_RoundRadius)
                        cy = 1-_RoundRadius;
                }
                
                if (cx != 0 && cy != 0)
                {
                    float dist = sqrt(pow((x-cx),2) + pow((y-cy),2));
                    //if (dist > _RoundRadius)
                    //    col.a = 0;
                    float d = dist - _RoundRadius;
                    float t = smoothstep(0, _RoundRadius*0.01, d);
                    col.a = 1 - t;
                }
                return col;
            }
            ENDCG
        }
    }
}
