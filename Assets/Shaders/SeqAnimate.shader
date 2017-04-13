Shader "Custom/SeqAnimate" {
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Rows ("rows", Float) = 3
        _Cols ("cols", Float) = 4
        _FrameCount ("frame count", Float) = 12
        _Speed ("speed", Float) = 100
    }

    SubShader
    {
        Tags { "RenderType"="Opaque"}
        LOD 200

        CGPROGRAM
        #pragma surface surf NoLighting alpha

        sampler2D _MainTex;
        fixed4 _Color;

        uniform fixed _Rows;
        uniform fixed _Cols;
        uniform int _FrameCount;
        uniform fixed _Speed;

        struct Input
        {
            float2 uv_MainTex;
        };
        
        fixed4 LightingNoLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            fixed4 c;
            c.rgb = s.Albedo;
            c.a = s.Alpha;
            return c;
        }
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            uint index = floor(_Time.x * _Speed);
            index = index % _FrameCount;
            int indexY = index / _Cols;
            int indexX = index - indexY * _Cols;
            
            float2 uv = float2(IN.uv_MainTex.x /_Cols, IN.uv_MainTex.y /_Rows);
            uv.x += indexX / _Cols;
            uv.y += indexY / _Rows;
            
            //o.Albedo = float3(floor(_Time .x * _Speed) , 1, 1);
            fixed4 c = tex2D(_MainTex, uv) * _Color;
            //o.Albedo = c.rgb;
            o.Emission = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }

    Fallback "Transparent/VertexLit"
}
