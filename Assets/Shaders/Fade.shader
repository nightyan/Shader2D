// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'   replaced 'mul(UNITY_MATRIX_MV,*)' with 'UnityObjectToViewPos(*)'

Shader "Custom/Fade" {
    Properties {
        _MainTex ("Texture", 2D) = "white" { }
        _FadeDistanceNear ("Near fadeout dist (View Space)", float) = 35    
        _FadeDistanceFar ("Far fadeout dist (View Space)", float) = 40
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
            float _FadeDistanceNear;
            float _FadeDistanceFar;
            float4 _MainTex_ST;
            
            struct v2f {
                float4  pos : SV_POSITION;
                float2  uv : TEXCOORD0;
                float fade:TEXCOORD1;
            } ;
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                //相机坐标系的物体坐标
                float3 posView = UnityObjectToViewPos(v.vertex).xyz;
                //计算与相机距离
                float dis = length(posView);
                //计算fade
                o.fade = 1 - saturate((dis - _FadeDistanceNear)/(_FadeDistanceFar - _FadeDistanceNear));
                return o;
            }
            
            
            float4 frag (v2f i) : COLOR
            {
                float4 texCol = tex2D(_MainTex,i.uv);
                float4 outp = texCol;
                //fade作为alpha
                return float4(outp.rgb, i.fade);
            }
            ENDCG
        }
    }
}
