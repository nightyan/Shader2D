Shader "Custom/SeqAnimateMulti" {
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Rows ("rows", Float) = 3
        _Cols ("cols", Float) = 4
        _FrameCount ("frame count", Float) = 12
        _Speed ("speed", Float) = 100
        
        // 添加随机种子属性，用于区分不同实例
        _RandomSeed ("Random Seed", Float) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 200
        
        // 启用GPU Instancing
        CGINCLUDE
        #pragma multi_compile_instancing
        ENDCG

        CGPROGRAM
        #pragma surface surf NoLighting alpha
        #pragma instancing_options assumeuniformscaling
        
        // Enable the required extension for integer modulus
        #pragma target 3.0

        sampler2D _MainTex;
        fixed4 _Color;

        uniform fixed _Rows;
        uniform fixed _Cols;
        uniform int _FrameCount;
        uniform fixed _Speed;

        // 添加实例化数据
        UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_DEFINE_INSTANCED_PROP(float, _RandomSeed)
        UNITY_INSTANCING_BUFFER_END(Props)

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
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
            // 获取实例特定的随机种子
            float randomSeed = UNITY_ACCESS_INSTANCED_PROP(Props, _RandomSeed);
            
            // 使用世界坐标和随机种子创建唯一的时间偏移
            float uniqueTime = _Time.x + randomSeed;
            
            // 计算帧索引
            float index = floor(uniqueTime * _Speed);
            index = fmod(index, _FrameCount);
            
            float indexY = floor(index / _Cols);
            float indexX = index - indexY * _Cols;
            
            float2 uv = float2(IN.uv_MainTex.x / _Cols, IN.uv_MainTex.y / _Rows);
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