Shader "canturker/ProximityDissolveShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _HoleCenter("Hole Center", Vector) = (0, 0, 0, 0)
        _HoleRadius("Hole Radius", Range(0, 5)) = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        
        Cull Off

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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float3 normalDir : NORMAL;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float4 _HoleCenter;
            float _HoleRadius;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                float dist = distance(_HoleCenter, i.worldPos);
                clip(dist - _HoleRadius);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float diff = max(dot(i.normalDir, lightDir), 0);
                half4 texCol = tex2D(_MainTex, i.uv);
                half4 col = half4(_Color.rgb * texCol.rgb * diff + _Color.rgb * texCol.rgb * UNITY_LIGHTMODEL_AMBIENT.rgb, _Color.a * texCol.a);

                return col;
            }
            ENDCG
        }
    }
}
