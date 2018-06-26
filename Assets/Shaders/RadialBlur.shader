// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'   replaced 'mul(UNITY_MATRIX_MV,*)' with 'UnityObjectToViewPos(*)'

Shader "Custom/RadialBlur" {
    Properties {
        _MainTex ("Texture", 2D) = "white" { }
        _SampleDistance ("Sample Distance", float) = 1
        _SampleStrength ("Sample Strength", float) = 2
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent"}
        ZWrite On
        Blend SrcAlpha OneMinusSrcAlpha
        pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            sampler2D _MainTex;
            float _SampleDistance;
            float _SampleStrength;
            float4 _MainTex_ST;
            
            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD;
            } ;
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }
            
            
            float4 frag (v2f i) : COLOR
            {
                // 计算距离
                float2 dir = float2(0.5, 0.5) - i.uv;  
                float dist = length(dir);
                
                // 采样
                dir /= dist;
                float2 sampleDir = dir * _SampleDistance;
                float4 sum = tex2D(_MainTex, i.uv - sampleDir*0.01);
                sum += tex2D(_MainTex, i.uv - sampleDir*0.02);
                sum += tex2D(_MainTex, i.uv - sampleDir*0.03);
                sum += tex2D(_MainTex, i.uv - sampleDir*0.05);
                sum += tex2D(_MainTex, i.uv - sampleDir*0.08);
                sum += tex2D(_MainTex, i.uv + sampleDir*0.01);
                sum += tex2D(_MainTex, i.uv + sampleDir*0.02);
                sum += tex2D(_MainTex, i.uv + sampleDir*0.03);
                sum += tex2D(_MainTex, i.uv + sampleDir*0.05);
                sum += tex2D(_MainTex, i.uv + sampleDir*0.08);
                sum *= 0.1;

                float4 col = tex2D(_MainTex, i.uv);
                float t = saturate(dist * _SampleStrength);
                return lerp(col, sum, t);
            }
            ENDCG
        }
    }
}
